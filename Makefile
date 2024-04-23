.PHONY: prepare-codespace run destroy

prepare-codespace:
	# @sudo apt-get update
	# @sudo apt-get install -y apt-transport-https ca-certificates curl gnupg software-properties-common
	@sudo mkdir -p -m 755 /etc/apt/keyrings
	@curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | \
	sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
	@sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
	@echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
	https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | \
	sudo tee /etc/apt/sources.list.d/kubernetes.list
	@sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
	@wget -O- https://apt.releases.hashicorp.com/gpg | \
	gpg --dearmor | \
	sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
	@gpg --no-default-keyring \
	--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
	--fingerprint
	@echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
	https://apt.releases.hashicorp.com $(shell lsb_release -cs) main" | \
	sudo tee /etc/apt/sources.list.d/hashicorp.list

	@sudo apt-get update
	@sudo apt-get install -y terraform kubectl
	([ "$(shell uname -m)" = "x86_64" ] && curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.22.0/kind-$(shell uname)-amd64") || true
	([ "$(shell uname -m)" = "aarch64" ] && curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.22.0/kind-$(shell uname)-arm64") || true
	chmod +x ./kind
	sudo mv ./kind /usr/local/bin/kind

run:
	@terraform -chdir=$(CURDIR)/terraform init
	@terraform -chdir=$(CURDIR)/terraform apply -auto-approve

destroy:
	@kind delete cluster -n demo-local
	@rm -rf $(CURDIR)/terraform/.terraform
	@rm -f $(CURDIR)/terraform/*tfstate*
