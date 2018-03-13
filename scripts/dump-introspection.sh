#!/bin/sh

DATA_DIRECTORY=/home/stack/introspection_data

mkdir -p ${DATA_DIRECTORY} 2>/dev/null

source ~/stackrc

for NODE in $(openstack baremetal node list -f value -c Name)
do
  openstack baremetal introspection data save ${NODE} | jq . >${DATA_DIRECTORY}/${NODE}.introspection
done

