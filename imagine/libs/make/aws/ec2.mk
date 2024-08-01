.PHONY: imagine/aws/ec2/describe-images
imagine/aws/ec2/describe-images:
	@aws ec2 describe-images --owners self --query "Images[*].[ImageId, Name]" --output table

.PHONY: imagine/aws/ec2/deregister-image
imagine/aws/ec2/deregister-image:
	@aws ec2 deregister-image --image-id $(IMAGE_ID)
