resource "google_cloud_run_service" "backend" {

  name     = "cloud-backend"
  location = var.region

  template {

    spec {

      containers {

        image = "gcr.io/${var.project_id}/backend"

        resources {

          limits = {
            cpu    = "1"
            memory = "512Mi"
          }

        }

      }

    }

  }

  traffic {
    percent         = 100
    latest_revision = true
  }

}
