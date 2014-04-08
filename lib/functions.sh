function get_credentials {
  if [ -z $1 -o -z $2 ]; then 
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
