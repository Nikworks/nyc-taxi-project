variable "credentials" {
  description = "Path to the GCP service account key file"
  default     = "~/.config/gcloud/terraform-key.json"
}

variable "project" {
  description = "Your GCP Project ID"
  default     = "terraform-gcp-project-457818"  # Replace with your actual project ID
}

variable "region" {
  description = "Region for GCP resources"
  default     = "us-central1"
}

variable "location" {
  description = "Location for GCP resources"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "BigQuery Dataset name"
  default     = "demo_dataset_1"
}

variable "gcs_bucket_name" {
  description = "Storage bucket name - must be globally unique"
  default     = "nyc-taxi-project-terraform-bucket"  
}

variable "gcs_storage_class" {
  description = "Storage class for your bucket"
  default     = "STANDARD"
}