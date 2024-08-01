.PHONY: imagine/aws/vpc/describe-subnets
imagine/aws/vpc/describe-subnets:
	@aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-099940443fbe6b12c" --query "Subnets[*].[SubnetId, Tags[?Key=='Name'].Value | [0], AvailableIpAddressCount, AvailabilityZone, AvailabilityZoneId, RouteTableId]" --output table