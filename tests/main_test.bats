load test_helpers

it="main"

FOO_AWS_ACCESS_KEY="blah"
FOO_AWS_SECRET_KEY="blah"

@test "$it everything after -c is run as a command" {
  read -a some_args <<<"-a foo -c echo things"
  run main ${some_args[@]}
  echo $output
  [ $status -eq 0 ]
  [ $output = "things" ]
}

@test "$it fails when invalid region arguments are given" {
  run main "-r narnia-east-1"
  echo $output
  [ $status -eq 1 ]
}

@test "$it fails when an unrecognised argument is given" {
  read -a some_args <<<"-a foo  -d bananas"
  run main ${some_args[@]}
  echo $output
  [ $status -eq 1 ]
  [ $output = "-d is not a supported flag" ]
}
