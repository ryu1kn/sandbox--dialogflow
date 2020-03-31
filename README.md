# Dialogflow Sandbox

Setup Dialogflow chatbot that asks a webhook to provide response.

The webhook runs as a Cloud Function.

## Prerequisites

* terraform
* Environment variable `GCP_BILLING_ACCOUNT_ID` is set
* `gcloud` is authenticated: `gcloud auth login`
* `gcloud` is configured to the correct project: `gcloud config set project <your-project>`
* `jq`
* `yarn`

## Setup

1. Create a google sheet and create people data like follows:

    | Name | Hobby  |
    | ---- | ------ |
    | Mike | Skiing |
    | Emma | Coding |
    | John | Biking |

   Take a memo of sheet id (in the URL) and range (probably `Sheet1!A2:B`),
   and put them in the [config](./config.json) as `people_sheet_id` and `people_sheet_range`, respectively.

1. Deploy foundational GCP resources

    ```sh
    make tf-foundation/apply
    ```

1. Create an encrypted webhook auth key

    ```sh
    make secrets/auth-key.enc.txt PLAINTEXT_AUTH_KEY='plaintext-auth-key'
    ```

1. Deploy webhook

    ```sh
    make tf-system/apply
    ```

    Memo `function_endpoint` URL in the output.

1. Deploy Dialogflow agent. You need a service account key that has Dialogflow Admin & KMS Decrypter role.

    ```sh
    make agent/deploy
    ```

1. Now use Dialogflow, see your bot knows whose hobby is what!

For more information, start from [Makefile](./Makefile).

## TODOs

* Reduce manual setup steps
* Provide intents
* Convert config to YAML to allow comments in config
* Give config file path to terraform to avoid [this upcoming change][2],
  or introduce [Terragrunt][3].

[1]: https://github.com/terraform-providers/terraform-provider-google/issues/4276
[2]: https://github.com/hashicorp/terraform/issues/22004
[3]: https://terragrunt.gruntwork.io/
