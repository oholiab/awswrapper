load test_helpers
it=read_args

@test "$it gets the right arguments from a string" {
  args=$(read_args blah blah blah -b something else)
  echo "'$args'"
  [ "$args" = "blah blah blah" ]
}
