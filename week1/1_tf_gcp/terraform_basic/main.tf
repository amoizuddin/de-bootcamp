terraform {
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "4.51.0"
        }
    }
}

provider "google" {
    project = "de-zoomcamp-471601"
    region = "us-central"
}

resource "google_storage_bucket" "data-lake-bucket" {
    name        ="de-zoomcampbucket"
    location    ="US"

    storage_class = "STANDARD"
    uniform_bucket_level_access = true

    versioning {
      enabled = true
    }

    lifecycle_rule {
      action {
        type = "Delete"
      }
      condition {
        age = 30 //days
      }
    }

    force_destroy = true
}

resource "google_bigquery_dataset" "dataset" {
    dataset_id = "my_first_dataset"
    project = "de-zoomcamp-471601"
    location = "US"
}

