# AWS CLI GitHub Action

The Github action is used to run aws-cli commands, but also includes jq for parsing json files

## Table Of Contents

- [AWS CLI GitHub Action](#aws-cli-github-action)
  - [Table Of Contents](#table-of-contents)
  - [Usage](#usage)
    - [Inputs](#inputs)
      - [`subcommand`](#subcommand)
      - [`workingdirectory`](#workingdirectory)
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

| Name               | Description                                                 | Required | Default |
| ------------------ | ----------------------------------------------------------- | -------- | ------- |
| `subcommand`       | the the argument to use when running aws cli command        | true     |         |
| `workingdirectory` | used to change the working directory of where to run packer | false    | `.`     |

#### `subcommand`

`subcommand` is a string with the subcommand and remaining parameters to run with aws-cli. Do not include `aws`

```yaml
    subcommand: s3 ls
```

#### `workingdirectory`

`workingdirectory` is a string to change directory before running packer build.

```yaml
  workingdirectory: './packer'
```

### Debugging

To enable debug logging, create a secret named `ACTIONS_STEP_DEBUG` with the value `true`. See [here](https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-a-debug-message) for more information.
