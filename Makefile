export TF_VAR_access_token := $(shell gcloud auth print-access-token)
export TF_VAR_project_id := $(shell gcloud config get-value project)
export TF_VAR_region := australia-southeast1

parent_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: enable-billing
enable-billing:
	gcloud alpha billing projects link $$TF_VAR_project_id --billing-account $$GCP_BILLING_ACCOUNT_ID

.PHONY: tf-foundation.%
tf-foundation.%: $(abspath config.json)
	cd infra/foundation && terraform init && terraform $* -var-file $< -auto-approve

.PHONY: tf.%
tf.%: $(abspath config.json) $(abspath secrets/encrypted-auth-key.txt) $(abspath __function.zip)
	cd infra/system && terraform init && \
		terraform $* -var-file "$<" \
			-var "encrypted_auth_key=$$(< $(word 2,$^))" -auto-approve \
			-var "packaged_function_path=$(word 3,$^)"

$(abspath __function.zip): $(wildcard app/*)
	cd app && ./build.sh
