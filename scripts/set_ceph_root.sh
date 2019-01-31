#!/bin/bash

ARGS=("$@")

INTROSPECTION_DATA=~stack/introspection_data

if [[ $# < 2 ]]
then
  echo "Usage: $0 <drive> <node_name> [node_name] [node_name]..."
  exit 0
fi

if [[ -d ${INTROSPECTION_DATA} ]]
then
  if [[ -z "$(ls ${INTROSPECTION_DATA}/*.introspection)" ]]
  then
    echo "ERROR: Introspection data not found in this location: ${INTROSPECTION_DATA}"
    exit 1
  fi
else
  echo "ERROR: Introspection data directory not found: ${INTROSPECTION_DATA}"
fi

source ~stack/stackrc

ROOT_DISK=${ARGS[0]}

for ((NDX=1; NDX<$#; NDX++))
{
  NODE_NAME=${ARGS[$NDX]}
  if [[ ! -r ${INTROSPECTION_DATA}/${NODE_NAME}.introspection ]]
  then
    echo "ERROR: Unable to find introspeciton data for node ${NODE_NAME}:  ${INTROSPECTION_DATA}/${NODE_NAME}.introspection"
  else
    DATA_FILE=${INTROSPECTION_DATA}/${NODE_NAME}.introspection
    if [[ -z "$(grep ${ROOT_DISK} ${DATA_FILE})" ]]
    then
      echo "ERROR: Unable to find root disk in ${DATA_FILE}"
    else
      WWN=$(egrep -A10 ${ROOT_DISK} ${DATA_FILE} | grep '"wwn":' | head -1 | awk '{print $NF}' | sed 's/,//g;s/"//g')
      if [[ -z "${WWN}" ]]
      then
        WWN=$(egrep -B10 ${ROOT_DISK} ${DATA_FILE} | grep '"wwn":' | tail -1 | awk '{print $NF}' | sed 's/,//g;s/"//g')
      fi
      SERIAL=$(egrep -A10 ${ROOT_DISK} ${DATA_FILE} | grep '"serial":' | head -1 | awk '{print $NF}' | sed 's/,//g;s/"//g')
      if [[ -z "${SERIAL}" ]]
      then
        SERIAL=$(egrep -B10 ${ROOT_DISK} ${DATA_FILE} | grep '"serial":' | tail -1 | awk '{print $NF}' | sed 's/,//g;s/"//g')
      fi
      echo "Configuring ${ROOT_DISK} as root disk device for node '${NODE_NAME}' using serial '${SERIAL}'"
      openstack baremetal node set --property root_device="{'serial': '${SERIAL}'}" ${NODE_NAME}
    fi
  fi
}
