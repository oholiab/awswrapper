load test_helpers

FOO_AWS_ACCESS_KEY='foo'
FOO_AWS_SECRET_KEY='bar'

@test "grabs the correct credentials with type 'access'" {
  access_key=$(get_credentials foo access)
  [ "$access_key" = 'foo' ]
}

@test "grabs the correct credentials with type 'secret'" {
  secret_key=$(get_credentials foo secret)
  [ "$secret_key" = 'bar' ]
}

@test "fails when type is incorrect" {
  run get_credentials foo bar
  echo $output
  [ "$status" -eq 1 ]
  [ "$output" = "Key type should be either 'SECRET' or 'ACCESS'; was 'BAR'" ]
}

@test "fails when environment variable is not set" {
  run get_credentials lemon access
  echo $output
  [ "$status" -eq 1 ]
  [ "$output" = "Environment variable LEMON_AWS_ACCESS_KEY is empty" ]
}
