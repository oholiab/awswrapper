load test_helpers

it="run_command"

a_key="foo"
s_key="bar"

@test "$it returns 1 when the command returns 1" {
  run run_command "false" $a_key $s_key
  [ "$status" -eq 1 ]
}

@test "$it returns 0 when the command returns 0" {
  run run_command "true" $a_key $s_key
  [ "$status" -eq 0 ]
}

@test "$it prints correct stdout" {
  command="echo stuff"
  run run_command "$command" $a_key $s_key
  echo $output
  [ "$output" = "stuff" ]
}

@test "$it prints correct stderr" {
  command="echo stuff >&2"
  run run_command "$command" $a_key $s_key
  echo $output
  [ "$output" = "stuff" ]
}

@test "$it receives the correct environment variables" {
  command="echo \$AWS_ACCESS_KEY \$AWS_SECRET_KEY \$AWS_ACCESS_KEY_ID \$AWS_SECRET_ACCESS_KEY"
  run run_command "$command" $a_key $s_key
  echo $output
  [ "$output" = "foo bar foo bar" ]
}
