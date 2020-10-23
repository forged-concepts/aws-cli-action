# AWS CLI GitHub Action

The Github action is used to run aws-cli commands, but also includes jq for parsing json files. This action also supports assuming a role

## Table Of Contents

- [AWS CLI GitHub Action](#aws-cli-github-action)
  - [Table Of Contents](#table-of-contents)
  - [Usage](#usage)
    - [Inputs](#inputs)
      - [`workingdirectory`](#workingdirectory)
      - [`subcommand`](#subcommand)
      - [`assumerole`](#assumerole)
      - [`rolesessionname`](#rolesessionname)
    - [Debugging](#debugging)

## Usage

Add the Action to your [GitHub Workflow](https://help.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow#creating-a-workflow-file) like so:

```yaml
---

name: AWS CLI example

on:
  push:

jobs:
  packer:
    runs-on: ubuntu-latest
    name: aws-cli

    steps:
      - name: Update SSM Parameter
        uses: forged-concepts/aws-cli-action
        with:
          workingdirectory: "."
          subcommand: |
            ssm put-parameter \
            --type SecureString \
            --name /test/application/ami \
            --overwrite \
            --value `jq -r '.builds[0].artifact_id' test.app.packer.processed.json | awk -F: '{print $$2}'` | tee -a
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.TEST_AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.TEST_AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: ${{ secrets.TEST_AWS_REGION }}

```

### Inputs

| Name               | Description                                                 | Required | Default               |
| ------------------ | ----------------------------------------------------------- | -------- | --------------------- |
| `workingdirectory` | used to change the working directory of where to run packer | false    | `.`                   |
| `subcommand`       | the the argument to use when running aws cli command        | true     |                       |
| `assumerole`       | a role to assume for cross role needs                       | false    |                       |
| `rolesessionname`  | a session name to use with assume role                      | false    | aws-cli-github-action |


workingdirectory:
    description: "a directory where the packer template lives"
    required: false
    default: "."
  subcommand:
    description: "the the argument to use when running aws cli command"
    required: true
  assumerole:
    description: "a role to assume for cross role needs"
    required: false
  rolesessionname:
    description: "a session name if using assume role"
    required: false

#### `workingdirectory`

`workingdirectory` is a string to change directory before running packer build.

```yaml
  workingdirectory: './packer'
```

#### `subcommand`

`subcommand` is a string with the subcommand and remaining parameters to run with aws-cli. Do not include `aws`

```yaml
    subcommand: s3 ls
```

#### `assumerole`

`assumerole` is an iam role to assume when using cross role credentials

```yaml
  assumerole: arn:aws:iam::123456789000:role/test-deployment-role
```

#### `rolesessionname`

`rolesessionname` is a role name to use when assuming a role

```yaml
  rolesessionname: aws-cli-github-action
```

### Debugging

To enable debug logging, create a secret named `ACTIONS_STEP_DEBUG` with the value `true`. See [here](https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-a-debug-message) for more information.
