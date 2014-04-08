load test_helpers

FOO_AWS_ACCESS_KEY='foo'
FOO_AWS_SECRET_KEY='bar'

@test "returns 1 when the command returns 1" {
  run run_command "false"
  [ "$status" -eq 1 ]
}

@test "returns 0 when the command returns 0" {
  run run_command "true"
  [ "$status" -eq 0 ]
}

@test "prints correct stdout" {
  run run_command "echo stuff"
  echo $output
  [ "$output" = "stuff" ]
}

@test "prints correct stderr" {
  run run_command "echo stuff >&2"
  echo $output
  [ "$output" = "stuff" ]
}
