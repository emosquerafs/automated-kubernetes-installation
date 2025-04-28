#!/bin/awk -f
# Agrega las IP de los nodos al arhivo /etc/hosts
# de nuestro nodo ejecutando el comando
# awk -f node_hostname.awk <Inventory_file> |sudo tee -a /etc/hosts

$0~/ansible_host/ {
  split($2, ip, "=")
  print ip[2], $1
}
