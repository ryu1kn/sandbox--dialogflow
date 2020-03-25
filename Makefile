export TF_VAR_access_token := $(shell gcloud auth print-access-token)
export TF_VAR_project_id := $(shell gcloud config get-value project)
export TF_VAR_region := australia-southeast1

.PHONY: enable-billing
enable-billing:
	gcloud alpha billing projects link $$TF_VAR_project_id --billing-account $$GCP_BILLING_ACCOUNT_ID

.PHONY: tf.%
tf.%: __functions.zip
	cd infra && terraform init && terraform $* -auto-approve

__functions.zip: $(wildcard app/*)
	cd app && ./build.sh
