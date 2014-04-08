load test_helpers

@test "everything after -c is run as a command" {
  run main "-c echo things"
  echo $output
  [ "$status" -eq 0 ]
  [ $output = "things" ]
}
