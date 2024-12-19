output "instance_ips" {
  value = {
    for name, instance in google_compute_instance.vm_instances :
    name => {
      internal_ip = instance.network_interface[0].network_ip
      external_ip = instance.network_interface[0].access_config[0].nat_ip
    }
  }
} 