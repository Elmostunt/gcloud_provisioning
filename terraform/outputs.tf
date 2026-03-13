output "frontend_ip" {

 value = google_compute_instance.frontend_vm.network_interface[0].access_config[0].nat_ip

}

output "backend_url" {

 value = google_cloud_run_service.backend.status[0].url

}
