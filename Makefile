parent_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

config_path := $(abspath config.json)

get-config = $(shell jq -r '$1' $(config_path))

export TF_VAR_access_token := $(shell gcloud auth print-access-token)
export TF_VAR_project_id := $(shell gcloud config get-value project)

.PHONY: enable-billing
enable-billing:
	gcloud alpha billing projects link $$TF_VAR_project_id --billing-account $$GCP_BILLING_ACCOUNT_ID

.PHONY: tf-foundation/%
tf-foundation/%: $(config_path)
	cd infra/foundation && terraform init && terraform $* -var-file $< -auto-approve

.PHONY: tf-system/%
tf-system/%: $(config_path) $(abspath secrets/auth-key.enc.txt) $(abspath __function.zip)
	cd infra/system && terraform init && \
		terraform $* -var-file "$<" \
			-var "encrypted_auth_key=$$(< $(word 2,$^))" -auto-approve \
			-var "packaged_function_path=$(word 3,$^)"

$(abspath __function.zip): $(wildcard app/*)
	cd app && ./build.sh

.PHONY: deploy/agent
agent/deploy:
	cd agent && yarn && node create-agent

secrets/auth-key.enc.txt:
	[[ -n "$$PLAINTEXT_AUTH_KEY" ]]
	printf "$$PLAINTEXT_AUTH_KEY" \
	| gcloud kms encrypt \
		--keyring $(call get-config,.kms_key_ring) --key $(call get-config,.kms_key_name) \
		--plaintext-file - \
		--ciphertext-file - \
		--location $(TF_VAR_region) \
	| base64 \
	> $@
