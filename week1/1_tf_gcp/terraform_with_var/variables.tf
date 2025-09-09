variable "credentials" {    
    description = "my credentials"
    default = "/Users/abdullah/Documents/de_zoomcamp/week1/de-zoomcamp-471601-b3fdb18067c4-SA-KEY.json"
}

variable "project" {
    description = "Project"
    default = "de-zoomcamp-471601" 
}

variable "region" {
    description = "Region"
    default = "us-central1"
}

variable "location" {
    description = "Location"
    default = "US"
}

variable "bq_dataset_name" {
    description = "my bigquery dataset name"
    default = "demo_dataset"
}

variable "gcs_bucket_name" {
    description = "google cloud storage bucket name"
    default = "tf-demo-terrabucket-amoiz1"
  
}

variable "gcs_storage_class" {
    description = "Bucket Storage class"
    default = "STANDARD"
}