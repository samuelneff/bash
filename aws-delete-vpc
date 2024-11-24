#!/bin/bash

set -e

VPC_ID=$1

if [[ "$VPC_ID" == "" ]]; then
  echo "Provide the VPC ID to delete as the first parameter."
  exit 1
fi

aws ec2 describe-route-tables \
  --filters Name=vpc-id,Values=$VPC_ID \
  --query "RouteTables[].RouteTableId" \
  --output json \
  | jq -r '.[]' \
  | while read routetable; do

  aws ec2 describe-route-tables \
    --route-table-id $routetable \
    --query "RouteTables[].Routes[?DestinationCidrBlock && GatewayId != 'local'].DestinationCidrBlock" \
    --output json \
    | jq -r '.[][]' \
    | while read ipv4cidr; do

      if [ -n "$ipv4cidr" ]; then
          echo "Deleting IPv4 route: $ipv4cidr"
          aws ec2 delete-route --route-table-id $routetable --destination-cidr-block $ipv4cidr
      fi
  done

  aws ec2 describe-route-tables \
    --route-table-id $routetable \
    --query "RouteTables[].Routes[?DestinationIpv6CidrBlock && GatewayId != 'local'].DestinationIpv6CidrBlock" \
    --output json \
    | jq -r '.[][]' \
    | while read ipv6cidr; do

      if [ -n "$ipv6cidr" ]; then
          echo "Deleting IPv6 route: $ipv6cidr"
          aws ec2 delete-route --route-table-id $routetable --destination-ipv6-cidr-block $ipv6cidr
      fi
  done

done


aws ec2 describe-vpc-endpoints \
  --filters Name=vpc-id,Values=$VPC_ID \
  --query "VpcEndpoints[].VpcEndpointId" \
  --output json \
  | jq -r '.[]' \
  | while read endpoint; do
    echo "Deleting VPC Endpoint $endpoint"
    aws ec2 delete-vpc-endpoints --vpc-endpoint-ids $endpoint
done

aws ec2 describe-subnets \
  --filters Name=vpc-id,Values=$VPC_ID \
  --query "Subnets[].SubnetId" \
  --output json \
  | jq -r '.[]' \
  | while read subnet; do

  aws ec2 describe-nat-gateways \
    --filter Name=subnet-id,Values=$subnet \
    --query "NatGateways[].NatGatewayId" \
    --output json \
    | jq -r '.[]' \
    | while read natgw; do

    echo "Deleting NAT gateway $natgw"
    aws ec2 delete-nat-gateway --nat-gateway-id $natgw

  done

  aws ec2 describe-network-interfaces \
    --filters Name=subnet-id,Values=$subnet \
    --query "NetworkInterfaces[].NetworkInterfaceId" \
    --output json \
    | jq -r '.[]' \
    | while read eni; do

    echo "Deleting network interface $eni"
    aws ec2 delete-network-interface --network-interface-id $eni

  done

  echo "Deleting subnet $subnet"
  aws ec2 delete-subnet --subnet-id $subnet

done

aws ec2 describe-internet-gateways \
  --filters Name=attachment.vpc-id,Values=$VPC_ID \
  --query "InternetGateways[].InternetGatewayId" \
  --output json \
  | jq -r '.[]' \
  | while read igw; do

    echo "Deleting internet gateway $igw"
    aws ec2 detach-internet-gateway --internet-gateway-id $igw --vpc-id $VPC_ID
    aws ec2 delete-internet-gateway --internet-gateway-id $igw
done

aws ec2 describe-nat-gateways \
  --filter Name=vpc-id,Values=$VPC_ID \
  --query "NatGateways[].NatGatewayId" \
  --output json \
  | jq -r '.[]' \
  | while read natgw; do

    echo "Deleting NAT Gateway $natgw"
    aws ec2 delete-nat-gateway --nat-gateway-id $natgw

done

aws ec2 describe-security-groups \
  --filters Name=vpc-id,Values=$VPC_ID \
  --query "SecurityGroups[?GroupName != 'default'].GroupId" \
  --output json \
  | jq -r '.[]' \
  | while read secgrp; do

  aws ec2 describe-security-group-rules \
    --filters Name=group-id,Values=$secgrp \
    --query 'SecurityGroupRules[?IsEgress==`false`].SecurityGroupRuleId' \
    --output json \
    | jq -r '.[]' \
    | while read ruleid; do
      if [ -n "$ruleid" ]; then
          echo "Deleting Security Group Ingress rule: $ruleid"
          aws ec2 revoke-security-group-ingress --group-id $secgrp --security-group-rule-ids $ruleid
      fi
  done

  aws ec2 describe-security-group-rules \
    --filters Name=group-id,Values=$secgrp \
    --query 'SecurityGroupRules[?IsEgress==`true`].SecurityGroupRuleId' \
    --output json \
    | jq -r '.[]' \
    | while read ruleid; do
      if [ -n "$ruleid" ]; then
          echo "Deleting Security Group Egress rule: $ruleid"
          aws ec2 revoke-security-group-egress --group-id $secgrp --security-group-rule-ids $ruleid
      fi
  done


  echo "Deleting Security Group $secgrp"
  aws ec2 delete-security-group --group-id $secgrp
done

echo "Deleting VPC $VPC_ID"
aws ec2 delete-vpc --vpc-id $VPC_ID
