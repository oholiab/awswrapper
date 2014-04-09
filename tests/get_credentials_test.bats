load test_helpers

it="get_creds"

FOO_AWS_ACCESS_KEY='foo'
FOO_AWS_SECRET_KEY='bar'

@test "$it grabs the correct credentials with type 'access'" {
  access_key=$(get_creds foo access)
  [ "$access_key" = 'foo' ]
}

@test "$it grabs the correct credentials with type 'secret'" {
  secret_key=$(get_creds foo secret)
  [ "$secret_key" = 'bar' ]
}

@test "$it fails when type is incorrect" {
  run get_creds foo bar
  echo $output
  [ "$status" -eq 1 ]
  [ "$output" = "Key type should be either 'SECRET' or 'ACCESS'; was 'BAR'" ]
}

@test "$it fails when environment variable is not set" {
  run get_creds lemon access
  echo $output
  [ "$status" -eq 1 ]
  [ "$output" = "Environment variable LEMON_AWS_ACCESS_KEY is empty" ]
}
