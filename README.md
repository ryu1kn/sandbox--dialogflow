# Dialogflow Sandbox

Setup Dialogflow chatbot that asks a webhook to provide response.

The webhook runs as a Cloud Function.

## Contents

This repository has following directory:

* **agent**: Spins up a new Dialogflow agent with intents already imported
* **app**: Webhook code that Dialogflow consults how it should respond to end users
* **infra**: Infra code (except Dialogflow agent, that is looked after by the contents under **agent** directory)
* **conversation-history**: Code to parse conversation history for later analysis

## Prerequisites

* terraform
* Environment variable `GCP_BILLING_ACCOUNT_ID` is set
* `gcloud` is authenticated: `gcloud auth login`
* `gcloud` is configured to the correct project: `gcloud config set project <your-project>`
* `jq`
* `yarn`
* Node.js v10+

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

1. Update config with the encrypted webhook auth key (with key `encrypted_webhook_auth_key`)

    ```sh
    $ make encrypt PLAINTEXT_AUTH_KEY='plaintext-auth-key'
    ```

1. Deploy webhook

    ```sh
    make tf-system/apply
    ```

1. Deploy Dialogflow agent. You need a service account key that has Dialogflow Admin & KMS Decrypter role.

    ```sh
    make agent/deploy
    ```

1. Now use Dialogflow, see your bot knows whose hobby is what!

For more information, start from [Makefile](./Makefile).

## TODOs

* Reduce manual setup steps
* Convert config to YAML to allow comments in config
* Give config file path to terraform to avoid [this upcoming change][2],
  or introduce [Terragrunt][3].

[1]: https://github.com/terraform-providers/terraform-provider-google/issues/4276
[2]: https://github.com/hashicorp/terraform/issues/22004
[3]: https://terragrunt.gruntwork.io/
