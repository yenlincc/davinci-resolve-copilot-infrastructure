# Makefile for Terraform project

# Variables
TF_CMD = terraform
TF_PLAN = plan.out
# ENVIRONMENTS = $(shell ls -d environments/*/ | xargs -n 1 basename)
ENVIRONMENTS = staging
# Default target
.PHONY: all
all: init validate plan

# Initialize Terraform for all environments
.PHONY: init
init:
	@for env in $(ENVIRONMENTS); do \
		echo "Initializing environment $$env"; \
		$(TF_CMD) -chdir=environments/$$env init; \
	done

# Validate Terraform configuration for all environments
.PHONY: validate
validate:
	@for env in $(ENVIRONMENTS); do \
		echo "Validating environment $$env"; \
		$(TF_CMD) -chdir=environments/$$env validate; \
	done

# Format Terraform files
.PHONY: fmt
fmt:
	$(TF_CMD) fmt -recursive

# Generate and show an execution plan for all environments
.PHONY: plan
plan:
	@for env in $(ENVIRONMENTS); do \
		echo "Planning environment $$env"; \
		$(TF_CMD) -chdir=environments/$$env plan -out=$(TF_PLAN); \
	done

# Destroy Terraform-managed infrastructure for staging
.PHONY: destroy
destroy:
	echo "Destroying environment staging";
	$(TF_CMD) -chdir=environments/staging destroy;

# Clean up generated files
.PHONY: clean
clean:
	@for env in $(ENVIRONMENTS); do \
		echo "Cleaning up environment $$env"; \
		rm -f environments/$$env/$(TF_PLAN); \
	done

# Bootstrap infrastructure to enable CD from GitHub Actions
.PHONY: bootstrap
bootstrap:
	@for env in $(ENVIRONMENTS); do \
		echo "Bootstrapping environment $$env"; \
		echo "Running init, environment $$env"; \
		$(TF_CMD) -chdir=environments/$$env/bootstrap init || exit; \
		echo "Running validate, environment $$env"; \
		$(TF_CMD) -chdir=environments/$$env/bootstrap validate || exit; \
		echo "Running plan, environment $$env"; \
		$(TF_CMD) -chdir=environments/$$env/bootstrap plan || exit; \
		echo "Running apply, environment $$env"; \
		$(TF_CMD) -chdir=environments/$$env/bootstrap apply || exit; \
	done