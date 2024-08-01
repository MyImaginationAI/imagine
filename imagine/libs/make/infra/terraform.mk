# Makefile for managing Terraform infrastructure

# Phony targets
.PHONY: imagine/infra/terraform/init
imagine/infra/terraform/init:
	@cd $(IMAGINE_INFRA_TERRAFORM_DIR) && terraform init

.PHONY: imagine/infra/terraform/validate
imagine/infra/terraform/validate:
	@cd $(IMAGINE_INFRA_TERRAFORM_DIR) && terraform validate

.PHONY: imagine/infra/terraform/plan
imagine/infra/terraform/plan:
	@cd $(IMAGINE_INFRA_TERRAFORM_DIR) && terraform plan -out terraform.plan

.PHONY: imagine/infra/terraform/apply
imagine/infra/terraform/apply:
	@cd $(IMAGINE_INFRA_TERRAFORM_DIR) && terraform apply "terraform.plan"

.PHONY: imagine/infra/terraform/destroy
imagine/infra/terraform/destroy:
	@cd $(IMAGINE_INFRA_TERRAFORM_DIR) && terraform destroy -auto-approve

.PHONY: imagine/infra/terraform/output
imagine/infra/terraform/output:
	@cd $(IMAGINE_INFRA_TERRAFORM_DIR) && terraform output

.PHONY: imagine/infra/terraform/state
imagine/infra/terraform/state:
	@cd $(IMAGINE_INFRA_TERRAFORM_DIR) && terraform state list

.PHONY: imagine/infra/terraform/refresh
imagine/infra/terraform/refresh:
	@cd $(IMAGINE_INFRA_TERRAFORM_DIR) && terraform refresh

.PHONY: imagine/infra/terraform/taint
imagine/infra/terraform/taint:
	@cd $(IMAGINE_INFRA_TERRAFORM_DIR) && terraform taint $(resource_name)

.PHONY: imagine/infra/terraform/unlock
imagine/infra/terraform/unlock:
	@cd $(IMAGINE_INFRA_TERRAFORM_DIR) && terraform force-unlock $(lock_id)
