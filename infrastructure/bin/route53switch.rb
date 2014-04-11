require 'pp'
require 'trollop'
require 'aws-sdk-core'

opts = Trollop::options do
  opt :subdomain, "The sub-domain that should be switched to point to the new address (just the subdomain. For example, for demo.stelligent.com, you'd punch in 'demo')", :type => String, :required => true
  opt :hostedzone, "The hosted zone name that should be switched to point to the new address (This is the domain. For example, for demo.stelligent.com, you'd punch in 'stelligent.com')", :type => String, :required => true
  opt :region, "The region that you're working in.", :type => String, :required => true
  opt :stackname, "The name of the CloudFormation stack that is intended to become the new production stack", :type => String, :required => true
end

#route 53 and opsworks only run in us-east-1
r53 = Aws::Route53.new(region: 'us-east-1')
ops = Aws::OpsWorks.new(region: "us-east-1")

# cfn needs to be in the same 
cfn = Aws::CloudFormation.new(region: opts[:region])

new_ip_address = get_new_ip_address cfn, opts[:stackname]
old_ip_address = get_old_ip_address r53, opts[:subdomain], opts[:hostedzone]

# Tell Route 53 to switch the new IP in for the old one
full_address = "#{opts[:subdomain]}.#{opts[:hostedzone]}"
r53.change_resource_record_sets hosted_zone_id: hosted_zone.id.split('/')[2], change_batch: 
{ 
  changes: 
  [
    {
      action: "DELETE", 
      resource_record_set: {
        name: full_address, 
        type: "A",
        ttl: 300,
        resource_records: [ { value: old_ip_address} ] }
    },
    {
      action: "CREATE", 
      resource_record_set: {
        name: full_address, 
        type: "A",
        ttl: 300,
        resource_records: [ { value: new_ip_address } ]
      } 
    }
  ] 
}


def get_old_ip_address r53, subdomain, hosted_zone_name
# Get the IP Address of the existing Production Instance from Route 53 itself.
  zone_id = r53.list_hosted_zones.hosted_zones.collect {|zone| if zone.name == "#{hosted_zone_name}." then zone.id.split('/').last end }.compact.first
  old_ip_address = r53.list_resource_record_sets(hosted_zone_id: zone_id).resource_record_sets.select {|record| record.name == "#{subdomain}.#{hosted_zone_name}."}.first.resource_records.first.value
end

def get_new_ip_address cfn, stack_name
  instance_id = get_opsworks_instance_id cfn, stack_name
  # Get the IP Address from the OpsWorks instance information
  new_ip_address = ops.describe_instances(instance_ids: [instance_id]).first.instances.first.public_ip
  return new_ip_address
end

def get_opsworks_instance_id cfn, stack_name
  # get the OpsWorks Instance ID from the CloudFormation stack
  instance_id = nil
  cfn.describe_stack_resources(stack_name: stack_name).stack_resources.each do |resource|
    if resource.resource_type == "AWS::OpsWorks::Instance"
      instance_id = cfn.describe_stack_resource(stack_name: stack_name, logical_resource_id: resource.logical_resource_id).stack_resource_detail.physical_resource_id
    end
  end
  return instance_id
end
