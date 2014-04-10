function usage {
  cat << EOF
  awsw: Wrapper for repeating AWS operations in named accounts and regions
  USAGE: awsw -a ACCOUNT [ACCOUNT2 ...] -c "COMMAND"
  ARGUMENTS:
    -a  Named account, case insensitive. Must have an equivalent pair of
        environment variables (\$ACCOUNT_AWS_ACCESS_KEY and
        \$ACCOUNT_AWS_SECRET_KEY) set.

    -c  Command to run. Ideally should be quoted as otherwise flags will be
        treated as options for awsw rather than the command on first round
        parsing. Any escaped variables (i.e. \\\$AWS_ACCESS_KEY) will be
        expanded in the subshell.

    -r  NOT YET IMPLEMENTED. Will loop through given regions.

    -h  Display this message

EOF
}


function get_creds {
  if [ -z "$1" -o -z "$2" ]; then 
    echo "2 arguments expected" >&2
    return 1
  fi
  local acc_name=$(echo $1 | tr 'a-z' 'A-Z')
  local key_type=$(echo $2 | tr 'a-z' 'A-Z')

  if [ "$key_type" != 'ACCESS' -a "$key_type" != 'SECRET' ]; then
    echo "Key type should be either 'SECRET' or 'ACCESS'; was '$key_type'" >&2
    return 1
  fi

  local varname="${acc_name}_AWS_${key_type}_KEY"

  local key=$(eval echo \$${varname})
  if [ -z $key ]; then
    echo "Environment variable ${varname} is empty" >&2
    return 1
  fi
  echo $key
  return 0
}

function run_command {
  local command=$1
  export AWS_ACCESS_KEY=$2
  export AWS_ACCESS_KEY_ID=$2
  export AWS_SECRET_KEY=$3
  export AWS_SECRET_ACCESS_KEY=$3
  eval "$command"
  return $?
}

function are_all_regions {
  local all_valid_regions="us-east-1 us-west-1 us-west-2 eu-west-1 ap-southeast-1 ap-southeast-2 ap-northeast-1 sa-east-1"
  for i in $*; do
    [[ ! $all_valid_regions =~ $i ]] && echo "$i is not a valid region" >&2 &&return 1
  done
  return 0
}

function read_args {
  local args=()
  while (($#)) && [[ $1 != "-"* ]]; do
    args+=("$1")
    shift
  done
  echo "${args[@]}"
  return 0
}

function main {
  while (($#)); do
    case $1 in
      -r) local regions=$(read_args "${@:2}") 
        echo "Regions feature not yet implemented" && return 1
        ;;
      -a) local accounts=$(read_args "${@:2}") ;;
      -c) local command=$(read_args "${@:2}");;
      -h) usage; return 0;;
      -*) echo "$1 is not a supported flag" >&2 && return 1 ;;
      *) ;;
    esac
    shift
  done
  #if [ -z "${regions[@]}" ]; then
  #  echo "No regions were given and could not source from ${region_env}" >&2
  #  return 1
  #fi

  are_all_regions $regions
  local status=$?
  if [ $status -ne 0 ]; then return 1; fi
  local exit_code=0
  for account in $accounts; do
    local access_key=$(get_creds $account "access")
    local secret_key=$(get_creds $account "secret")
    if [ -z $access_key -o -z $secret_key ]; then
      exit_code=1
      continue
    fi
    run_command "${command}" "${access_key}" "${secret_key}"
    if [ $? -eq 1 ]; then exit_code=1; fi
  done
  return $exit_code
}
