# Dialogflow Sandbox

Dialogflow is not yet integrated...

It deploys an app that extract data from Google Sheet on Cloud Function.

## Prerequisites

* terraform
* Environment variable `GCP_BILLING_ACCOUNT_ID` is set
* `gcloud` is authenticated: `gcloud auth login`
* `gcloud` is configured to the correct project: `gcloud config set project <your-project>`

## Usage

```sh
make tf.apply
```

For more information, start from [Makefile](./Makefile).
