#!/usr/bin/env bash
set -e

AWS_CLI="/usr/local/bin/aws"

# fail if INPUT_SUBCOMMAND is not set
if [ -z "${INPUT_SUBCOMMAND}" ]; then
  echo "Required variable \`subcommand\` is missing"
  exit 1
fi

# switch directory
cd "${INPUT_WORKINGDIRECTORY:-.}"

if [ -z "${c}" ]; then
  INPUT_ROLESESSIONNAME="aws-cli-github-action"
fi

# assume role if exists
if [ -n "${INPUT_ASSUMEROLE}" ]; then
  echo "::debug:: Executing command: aws sts assume-role --role-arn "${INPUT_ASSUMEROLE}" --role-session-name "${INPUT_ROLESESSIONNAME}"
  ROLE_CREDS=$(aws sts assume-role --role-arn "${INPUT_ASSUMEROLE}" --role-session-name "${INPUT_ROLESESSIONNAME}")

  export AWS_ACCESS_KEY_ID=$(echo "$ROLE_CREDS" | jq -r .Credentials.AccessKeyId)
  export AWS_SECRET_ACCESS_KEY=$(echo "$ROLE_CREDS" | jq -r .Credentials.SecretAccessKey)
  export AWS_SESSION_TOKEN=$(echo "$ROLE_CREDS" | jq -r .Credentials.SessionToken)
fi

# execute packer build
echo "::debug:: Executing command: ${OPERATION} ${INPUT_SUBCOMMAND}"

# shellcheck disable=SC2086
`${AWS_CLI} "${INPUT_SUBCOMMAND}"`