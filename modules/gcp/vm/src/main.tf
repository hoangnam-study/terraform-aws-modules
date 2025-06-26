resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
      type  = var.disk_type
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  metadata = {
    ssh-keys = "root:${file(var.ssh_pubkey_path)}"
  }

  # tags = ["http-server"]
}
