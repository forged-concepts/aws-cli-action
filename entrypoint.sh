#!/usr/bin/env bash

set -e

# fail if INPUT_COMMAND is not set
if [ -z "${INPUT_SUBCOMMAND}" ]; then
  echo "Required variable \`subcommand\` is missing"
  exit 1
fi

# switch directory
cd "${INPUT_WORKINGDIRECTORY:-.}"

OPERATION="aws"

# execute packer build
echo "::debug:: Executing command: ${OPERATION} ${INPUT_SUBCOMMAND}"

# shellcheck disable=SC2086
${OPERATION} "${INPUT_SUBCOMMAND}"