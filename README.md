# aws-ecs-tf

This is an example project showcasing the provisioning of a Replicated Redis cluster AKA [ElastiCache](https://aws.amazon.com/elasticache/), and the associated resources that are required to make it publicly accessible, on AWS, using Terraform.

## Table of Contents
1. [Prerequesites](#prerequesites)
2. [Usage](#usage)
3. [Testing](#testing)
4. [License](#license)


## Prerequesites <a name="prerequesites"></a>

1. Install the necessary tools:

    - [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

        ```bash
        brew install terraform
        ```

    - [Redis](https://redis.io/docs/install/install-redis/)

        ```bash
        brew install redis
        ```

2. Create a free AWS account:
    Head to https://aws.amazon.com/free on your browser and click "Create a Free Account". Follow the steps until the account setup is complete.

3. Configure AWS credentials:

    - On the AWS console, head over to the IAM service.

    - Click "Users" > "Create User" and give it a name, such as "Terraform" and click "Next".

    - On the "Permissions options", click "Attach policies directly", then "Next", followed by "Create user".

    - Click the user that was just created, then click "Create access key". Follow through the steps and copy the Access Key ID and Value.

4. Generate an SSH key pair:

    - Open a terminal window and run `$ssh-keygen -b 4096 -t rsa`.

    - You will be prompted to enter a filename. By default, your keys will be saved as `id_rsa` and `id_rsa.pub`. Simply press Enter to confirm the default.

    - When prompted, enter an optional passphrase. This will created a hidden directory called .ssh that contains both your public (`id_rsa.pub`) and private (`id_rsa`) key files. 

## Usage <a name="usage"></a>

After making sure that your AWS credentials have been configured and the prerequesites have been installed, we are a couple of terraform commands away from creating our cluster. Before doing that though, take a look at the configuration parameters this module accepts as shown below, and feel free to customize them to your needs. These values are set in the `terraform.tfvaras` file.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Define additional tags to be added to the resources. | `map` | <pre>{<br>  "Provisioner": "Terraform"<br>}</pre> | no |
| <a name="input_ami_override"></a> [ami\_override](#input\_ami\_override) | Override the AMI for the SSH host. | `any` | `null` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. | `bool` | `true` | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | The CIDR blocks for creating subnets. | `list` | <pre>[<br>  "10.1.1.0/24",<br>  "10.1.2.0/24"<br>]</pre> | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Replication group identifier. | `string` | `"redis-cluster"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to use for the instance. | `string` | `"t2.nano"` | no |
| <a name="input_monitoring_enabled"></a> [monitoring\_enabled](#input\_monitoring\_enabled) | If true, the launched EC2 instance will have detailed monitoring enabled. | `bool` | `false` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Number of node groups (shards) for this Redis replication group. | `number` | `3` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance class to be used. | `string` | `"cache.t2.micro"` | no |
| <a name="input_port"></a> [port](#input\_port) | Port number on which each of the cache nodes will accept connections. | `number` | `6379` | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to public key for ssh access. | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The IPv4 CIDR block for the VPC. | `string` | `"10.1.0.0/16"` | no |

In order to proceed, first set the AWS credentials that you copied earlier as environment variables:

```bash
export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_ACCESS_KEY_VALUE>
```

Initialize terraform with `$terraform init`. Then plan the changes with `$terraform plan`. Apply the changes with `$terraform apply` while making sure that the output looks as expected. When prompted, type "yes" and hit enter. While you wait, terraform will be provisioning the resources shown below.

| Name | Description |
|------|-------------|
| [aws_elasticache_replication_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.25.0/docs/resources/elasticache_replication_group) | The replicated Redis cluster. |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.25.0/docs/resources/elasticache_subnet_group) | The cluster's subnet group. |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/5.25.0/docs/resources/instance) | An EC2 instance acting as a bastion host. |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/5.25.0/docs/resources/internet_gateway) | Enables resources to connect to the internet. |
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/5.25.0/docs/resources/key_pair) | Public/private key pair for connecting to the EC2 instance. |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/5.25.0/docs/resources/route) | Grant the VPC internet access on its main route table. |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/5.25.0/docs/resources/security_group) | Controls the inbound/outbound traffic resources. |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/5.25.0/docs/resources/subnet) | A range of IP addresses in the VPC. |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/5.25.0/docs/resources/vpc) | A VPC lets you launch AWS resources in a logically isolated virtual network. |

After the resources have been provisoned, terraform will print the outputs shown below.

| Name | Description |
|------|-------------|
| <a name="output_configuration_endpoint"></a> [configuration\_endpoint](#output\_configuration\_endpoint) | Address of the replication group configuration endpoint. |
| <a name="output_redis_arn"></a> [redis\_arn](#output\_redis\_arn) | ARN of the created Redis cluster. |
| <a name="output_redis_cmd"></a> [redis\_cmd](#output\_redis\_cmd) | Command for connecting to the created Redis cluster. |
| <a name="output_ssh_cmd"></a> [ssh\_cmd](#output\_ssh\_cmd) | Command for connecting to the SSH host. |
| <a name="output_ssh_host"></a> [ssh\_host](#output\_ssh\_host) | Public IP address assigned to the instance. |

## Testing <a name="testing"></a>

In order to test out our Redis cluster, we first have to connect to the host via SSH. The command for doing this can be found in the outputs of the apply command.

E.g.

```bash
ssh ubuntu@12.345.678.901
```

Once you get a shell in the host, run the `redis-cli` command from the terraform output in order to connect to the cluster. 

E.g.

```bash
redis-cli -h redis-cluster.abcdef.clustercfg.use1.cache.amazonaws.com -p 6379
```

Once you are connected, run `$CLUSTER NODES` to get a list of the running nodes. You can connect to any one of them by running `$redis-cli -h <NODE_IP_ADDRESS> -p 6379`. After getting a shell in a node, you can set a key-value pair with `$SET <KEY> <VALUE>`, and get a value with `$GET <KEY>`. In order to get more info run `$INFO`.

## License <a name="license"></a>

The project is licensed under the [MIT License](LICENSE).