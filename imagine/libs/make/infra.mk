# Makefile for managing Terraform infrastructure

# Phony targets
.PHONY: imagine/infra/init
imagine/infra/init:
	@cd $(IMAGINE_INFRA_DIR) && terraform init

.PHONY: imagine/infra/validate
imagine/infra/validate:
	@cd $(IMAGINE_INFRA_DIR) && terraform validate

.PHONY: imagine/infra/plan
imagine/infra/plan:
	@cd $(IMAGINE_INFRA_DIR) && terraform plan -out terraform.plan

.PHONY: imagine/infra/apply
imagine/infra/apply:
	@cd $(IMAGINE_INFRA_DIR) && terraform apply "terraform.plan"

.PHONY: imagine/infra/destroy
imagine/infra/destroy:
	@cd $(IMAGINE_INFRA_DIR) && terraform destroy -auto-approve

.PHONY: imagine/infra/output
imagine/infra/output:
	@cd $(IMAGINE_INFRA_DIR) && terraform output

.PHONY: imagine/infra/state
imagine/infra/state:
	@cd $(IMAGINE_INFRA_DIR) && terraform state list

.PHONY: imagine/infra/refresh
imagine/infra/refresh:
	@cd $(IMAGINE_INFRA_DIR) && terraform refresh

.PHONY: imagine/infra/taint
imagine/infra/taint:
	@cd $(IMAGINE_INFRA_DIR) && terraform taint $(resource_name)

.PHONY: imagine/infra/unlock
imagine/infra/unlock:
	@cd $(IMAGINE_INFRA_DIR) && terraform force-unlock $(lock_id)
