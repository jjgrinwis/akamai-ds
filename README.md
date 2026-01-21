# Akamai DataStream Terraform Configuration

This Terraform configuration (root module) creates an Akamai DataStream resource that collects data from multiple properties and sends it to a destination using an HTTPS connector. This example uses Vector as the HTTPS endpoint, but DataStream supports multiple destination types.

## Features

- **DataStream Decoupling**: Creates a DataStream independently from the DataStream property behavior
- **Dynamic Property Lookup**: Automatically resolves property IDs from property names
- **Secure Credential Management**: Uses variables for sensitive data instead of hardcoding
- **HTTPS Connector**: Sends log data to an HTTPS endpoint (Vector example shown) with basic authentication
- **Flexible Destinations**: Configuration can be adapted for other DataStream targets

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Akamai Terraform Provider](https://registry.terraform.io/providers/akamai/akamai/latest) >= 9.2.0
- Akamai API credentials configured in `~/.edgerc`
- Access to Akamai properties within your group
- **DataStream Decoupling feature enabled on your Akamai contract** (required for DataStream-managed integration types)

## Configuration

### Required Variables

Set these variables in `terraform.tfvars` or via environment variables:

```terraform
# Akamai Control Center group name
group_name = "Your-Group-Name"

# List of property names to include in the datastream
property_names = ["property1.example.com", "property2.example.com"]

# DataStream name
stream_name = "vector"

# Notification emails
notification_emails = ["admin@example.com"]

# HTTPS connector credentials (use environment variables for production)
https_username = "your_username"
https_password = "your_password"
https_endpoint = "https://vector.example.com:8080"
```

### Using Environment Variables (Recommended for Production)

For better security, set credentials via environment variables:

```bash
export TF_VAR_https_username="your_username"
export TF_VAR_https_password="your_password"
export TF_VAR_https_endpoint="https://vector.example.com:8080"
export TF_VAR_group_name="Your-Group-Name"
export TF_VAR_property_names='["property1.example.com"]'
export TF_VAR_stream_name="vector"
export TF_VAR_notification_emails='["admin@example.com"]'
```

## Usage

### Initialize Terraform

```bash
terraform init
```

### Plan Changes

```bash
terraform plan
```

### Apply Configuration

```bash
terraform apply
```

### Destroy Resources

```bash
terraform destroy
```

## How It Works

1. **Contract Lookup**: The configuration looks up your Akamai contract and group IDs based on the group name
2. **Property ID Resolution**: Property names are resolved to numeric IDs using the `akamai_property` data source
3. **DataStream Creation**: A DataStream resource is created with:
   - JSON format delivery
   - 60-second delivery frequency
   - Specified dataset fields (1000, 1002, 1102, 1066)
   - HTTPS connector to Vector endpoint with basic authentication (example)

## Available DataStream Destinations

This configuration uses an **HTTPS connector** with Vector as an example endpoint. DataStream supports multiple destination types including:

- **HTTPS** - Send to any HTTPS endpoint (Vector, custom endpoints, etc.)
- **Amazon S3** - Store logs in S3 buckets
- **Azure Storage** - Send to Azure Blob Storage
- **Google Cloud Storage** - Store in GCS buckets
- **Splunk** - Direct integration with Splunk
- **Datadog** - Send to Datadog
- **Sumo Logic** - Stream to Sumo Logic
- **And more** - See the [DataStream API reference](https://techdocs.akamai.com/datastream2/v3/reference/post-stream-cdn) for all available connectors

To use a different destination, replace the `https_connector` block in [main.tf](main.tf) with the appropriate connector configuration.

## Dataset Fields

The following dataset fields are configured (see [Akamai documentation](https://techdocs.akamai.com/terraform/docs/set-up-datastream#choose-data-sets) for details):

- `1000` - Request timestamp
- `1002` - Client IP
- `1102` - HTTP status code
- `1066` - Request path

Modify these in [main.tf](main.tf) to customize the data collected.

## Security Notes

- Mark `https_username` and `https_password` as `sensitive = true` (already configured)
- Never commit `terraform.tfvars` with credentials to version control
- Add `terraform.tfvars` to `.gitignore`
- Use secret management tools (HashiCorp Vault, AWS Secrets Manager, etc.) for production

## Documentation

- [Akamai DataStream Documentation](https://techdocs.akamai.com/datastream2/v3/docs/integration-types)
- [Terraform Provider Documentation](https://techdocs.akamai.com/terraform/docs/overview)
- [DataStream API Reference](https://techdocs.akamai.com/datastream2/v3/reference/post-stream-cdn)

## Files

- `main.tf` - Main configuration with DataStream resource
- `variables.tf` - Variable declarations
- `providers.tf` - Akamai provider configuration
- `versions.tf` - Terraform and provider version constraints
- `outputs.tf` - Output values
- `terraform.tfvars` - Variable values (add to `.gitignore`)

## License

This configuration is provided as-is for demonstration purposes.
