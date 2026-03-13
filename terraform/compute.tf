resource "google_compute_instance" "frontend_vm" {

  name         = "frontend-server"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {

    initialize_params {
      image = "debian-cloud/debian-11"
    }

  }

  network_interface {

    network = "default"

    access_config {
    }

  }

  metadata_startup_script = <<-EOF
    apt update
    apt install -y nginx

    cat <<HTML > /var/www/html/index.html
    <h1>Frontend Cloud Lab</h1>
    <p>Servidor funcionando</p>
    HTML

    systemctl restart nginx
  EOF

}
