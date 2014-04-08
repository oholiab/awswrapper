function get_credentials {
  if [ -z "$1" -o -z "$2" ]; then 
    echo "2 arguments expected" >&2
    return 1
  fi
  acc_name=$(echo $1 | tr 'a-z' 'A-Z')
  key_type=$(echo $2 | tr 'a-z' 'A-Z')

  if [ "$key_type" != 'ACCESS' -a "$key_type" != 'SECRET' ]; then
    echo "Key type should be either 'SECRET' or 'ACCESS'; was '$key_type'" >&2
    return 1
  fi

  varname="${acc_name}_AWS_${key_type}_KEY"

  key=$(eval echo \$${varname})
  if [ -z $key ]; then
    echo "Environment variable ${varname} is empty" >&2
    return 1
  fi
  echo $key
  return 0
}

function run_command {
  if [ -z "$1" ]; then
    echo "1 argument expected" >&2
    return 1
  fi
  eval "$*"
  return $?
}

function are_all_regions {
  all_valid_regions="us-east-1 us-west-1 us-west-2 eu-west-1 ap-southeast-1 ap-southeast-2 ap-northeast-1 sa-east-1"
  for i in $*; do
    [[ ! $all_valid_regions =~ $i ]] && echo "$i is not a valid region" >&2 &&return 1
  done
  return 0
}

function main {
  while getopts ":rac:" opt; do
    case $opt in
      r) regions=$OPTARG ;;
      a) accounts=$OPTARG ;;
      c) command=$OPTARG ;;
    esac
  done
  run_command "${command}"
}
