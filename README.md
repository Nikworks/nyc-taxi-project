# NYC Taxi Data Pipeline

This project implements a complete data engineering pipeline for NYC taxi data using Docker, PostgreSQL, Google Cloud Platform, and Terraform. It provides an end-to-end solution for data ingestion, storage, and analytics.

## Architecture Overview

![Architecture Diagram](https://mermaid.ink/img/pako:eNptkU1vwjAMhv9KlBOgSU3KN1IO0zaNwybEYdLuJXFLRJO0SjLEEP99KWxM2ubiyO_jx5YzJqEixlnYaBXLElaoNc6ULHZCvUOJBtHbGnEHqYCQQsgF-OoNMo2mwCWYwtRNz_G9hYAz-2Q-v-rO0SdCKUCq10JoCP3_W-8HOnN_SHCwCq-kFXDSavJIcAuIf0KqSQdnOlx7DWcGGkTJaqUr1MVXPG9lNPTWCGmr7fQa5YGVJ6X3OLNf_FGjMWrMBs4wKtFHtdTUaXKPURnuqLlmM1ZSE3LO6gq0xkNCG2HztcMyWXLOUj-JwzQNFl48Hwf-MIqSKIknybzoL31znZJtZm0DKlLGeTSIgjgK40UQxckkHobxcByP_YvlxTaD3l-f_nrL?type=png)

The pipeline consists of the following components:

1. **Docker & PostgreSQL**:
   - Containerized environment for initial data processing
   - PostgreSQL for data ingestion and transformation

2. **Google Cloud Platform**:
   - GCS buckets for data lake storage
   - BigQuery for data warehousing and analytics

3. **Terraform**:
   - Infrastructure as Code for GCP resource provisioning
   - Automated setup of cloud components

## Prerequisites

- Docker and Docker Compose
- Google Cloud SDK (gcloud CLI)
- Terraform 1.11.3 or later
- Python 3.9 or later

## Setup Instructions

### 1. GCP Project Configuration

```bash
# Set up your GCP project
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# Create a service account for Terraform
PROJECT_ID=$(gcloud config get-value project)
SA_NAME="terraform-admin"
SA_EMAIL="$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"

gcloud iam service-accounts create $SA_NAME \
    --description="Service account for Terraform automation" \
    --display-name="Terraform Admin"

# Grant necessary permissions
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/storage.objectAdmin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/bigquery.admin"

# Create and download service account key
mkdir -p ~/.config/gcloud
gcloud iam service-accounts keys create ~/.config/gcloud/terraform-key.json \
    --iam-account=$SA_EMAIL

# Set environment variable
export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/terraform-key.json
```

### 2. Terraform Infrastructure Deployment

```bash
# Navigate to Terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply infrastructure
terraform apply
```

### 3. Docker Environment Setup

```bash
# Navigate to Docker directory
cd ../docker_sql

# Start PostgreSQL and pgAdmin
docker-compose up -d

# Ingest data
docker build -t taxi_ingest:latest .
docker run -it \
  --network=pg-network \
  taxi_ingest:latest \
  --user=root \
  --password=root \
  --host=pg-database \
  --port=5432 \
  --db=ny_taxi \
  --table_name=yellow_taxi_trips \
  --url=<DATA_URL>
```

## Data Pipeline Flow

1. **Data Ingestion**: NYC taxi data is downloaded and ingested into PostgreSQL using the ingest_data.py script.
2. **Data Processing**: Initial data cleaning and transformations occur in PostgreSQL.
3. **Data Export**: Processed data is exported to Google Cloud Storage.
4. **Data Warehousing**: Data is loaded from GCS to BigQuery for analytics.

## GCP Resources Created

- **GCS Bucket**: `<your-unique-bucket-name>` - Used for data lake storage
- **BigQuery Dataset**: `demo_dataset` - Used for data warehousing

## Repository Structure

```
nyc-taxi-pipeline/
├── terraform/
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Variable definitions
│   └── terraform_with_variables/  # Alternative config with variables
├── docker_sql/
│   ├── Dockerfile            # Docker image for data ingestion
│   ├── docker-compose.yaml   # Docker Compose configuration
│   ├── ingest_data.py        # Data ingestion script
│   └── data-loading-parquet.py  # Parquet data loader
└── README.md                 # This file
```

## Maintenance and Cleanup

To avoid incurring charges, destroy resources when not in use:

```bash
# Delete GCP resources with Terraform
terraform destroy

# Stop and remove Docker containers
docker-compose down -v
```

## Troubleshooting

- **GCS Bucket Creation Failures**: Ensure bucket names are globally unique.
- **Permission Errors**: Verify service account has appropriate roles.
- **Docker Networking Issues**: Check network configuration in docker-compose.yaml.

## Next Steps

1. Implement data quality checks
2. Add CI/CD pipeline for automation
3. Create data visualization layer with Looker or Data Studio
4. Implement incremental data loading