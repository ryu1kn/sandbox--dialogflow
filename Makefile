parent_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

config_path := $(abspath config.json)

get-config = $(shell jq -r '$1' $(config_path))

export TF_VAR_access_token := $(shell gcloud auth print-access-token)

.PHONY: enable-billing
enable-billing:
	gcloud alpha billing projects link $$TF_VAR_project_id --billing-account $$GCP_BILLING_ACCOUNT_ID

.PHONY: tf-foundation/%
tf-foundation/%: $(config_path)
	cd infra/foundation && terraform init 1>&2 \
	&& terraform $* \
		$(if $(filter apply deploy,$*),-auto-approve -var-file $<) \
		$(if $(filter output,$*),-json)

.PHONY: tf-system/%
tf-system/%: $(config_path) $(abspath __function.zip)
	@cd infra/system && terraform init 1>&2 \
	&& terraform $* \
		$(if $(filter apply destroy,$*),\
			-auto-approve \
			-var-file "$<" \
			-var "packaged_function_path=$(word 2,$^)") \
		$(if $(filter output,$*),-json)

$(abspath __function.zip): $(wildcard app/*)
	cd app && ./build.sh

.PHONY: agent/deploy
agent/deploy: export GOOGLE_APPLICATION_CREDENTIALS = $(abspath __dialogflow-agent-maker-key.json)
agent/deploy:
	export WEBHOOK_URL=$$($(MAKE) tf-system/output | jq -r '.function_endpoint.value // ""') \
	&& cd agent && yarn && node create-agent

.PHONY: encrypt
encrypt:
	@[[ -n "$$PLAINTEXT_AUTH_KEY" ]]
	@printf "$$PLAINTEXT_AUTH_KEY" \
	| gcloud kms encrypt \
		--keyring $(call get-config,.kms_key_ring) --key $(call get-config,.kms_key_name) \
		--plaintext-file - \
		--ciphertext-file - \
		--location $(call get-config,.region) \
	| base64
