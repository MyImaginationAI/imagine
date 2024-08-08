# Makefile for managing Packer builds

# Phony targets
.PHONY: imagine/infra/packer/init
imagine/infra/packer/init:
	@cd $(IMAGINE_INFRA_PACKER_DIR) && packer init .

.PHONY: imagine/infra/packer/build
imagine/infra/packer/build:
	@cd $(IMAGINE_INFRA_PACKER_DIR) && packer build webui.pkr.hcl

.PHONY: imagine/infra/packer/validate
imagine/infra/packer/validate:
	@cd $(IMAGINE_INFRA_PACKER_DIR) && packer validate webui.pkr.hcl

.PHONY: imagine/infra/packer/inspect
imagine/infra/packer/inspect:
	@cd $(IMAGINE_INFRA_PACKER_DIR) && packer inspect webui.pkr.hcl
    
.PHONY: imagine/infra/packer/clean
imagine/infra/packer/clean:
	@echo "Cleaning up old AMIs..."
	@aws ec2 describe-images --filters "Name=name,Values=ubuntu-22.04-*" --query 'Images[*].[ImageId]' --output text | xargs -r aws ec2 deregister-image --image-id

.PHONY: imagine/infra/packer/push
imagine/infra/packer/push:
	@echo "Pushing image to repository..."
	@cd $(IMAGINE_INFRA_PACKER_DIR) && packer push webui.pkr.hcl

.PHONY: imagine/infra/packer/help
imagine/infra/packer/help:
	@echo "Available targets:"
	@echo "  imagine/infra/packer/build     - Build the AMI"
	@echo "  packer/validate  - Validate the Packer template"
	@echo "  packer/inspect   - Inspect the Packer template"
	@echo "  packer/clean     - Clean up old AMIs"
	@echo "  packer/push      - Push the image to a repository"