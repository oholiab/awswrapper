load test_helpers

it="are_all_regions"

all_valid_regions="us-east-1 us-west-1 us-west-2 eu-west-1 ap-southeast-1 ap-southeast-2 ap-northeast-1 sa-east-1"
some_valid_regions="us-east-1 narnia-east-1"
invalid_regions="narnia-east-1"

@test "$it parses all valid regions" {
  run are_all_regions $all_valid_regions
  echo $output
  [ $status -eq 0 ]
}

@test "$it doesn't parse invalid regions" {
  run are_all_regions $invalid_regions
  echo $output
  [ $status -eq 1 ]
}

@test "$it won't parse an invalid region amongst valid regions" {
  run are_all_regions $some_valid_regions
  echo $output
  [ $output = "narnia-east-1 is not a valid region" ]
  [ $status -eq 1 ]
}
