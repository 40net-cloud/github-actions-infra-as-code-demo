#!/bin/bash

# John McDonough Fortinet
# @movinalot

FORTICARE_AUTH_URL="https://customerapiauth.fortinet.com/api/v1/oauth/token/"
FLEXVM_BASE_URL="https://support.fortinet.com/ES/api/flexvm/v1"

eval "$(jq -r '@sh "API_USERNAME=\(.apiUsername) API_PASSWORD=\(.apiPassword) PROGRAM_SERIAL=\(.programSerial) CONFIG_NAME=\(.configName) VM_SERIAL=\(.vmSerial) VM_OP=\(.vmOp)"')"

#API_USERNAME=${1}
#API_PASSWORD=${2}
#PROGRAM_SERIAL=${3} # FlexVM Program Serial number to use when listing/creating/updating a VM
#CONFIG_NAME=${4}    # FlexVM Configuration to use when listing/creating/updating a VM
#VM_SERIAL=${5}      # if not specified then create a new VM Token and generate a new Serial number
#VM_OP=${6}          # VM OP choices are STOP, REACTIVATE (aka start), and TOKEN (generate a new token)

flexvm_authenticate () {

  RESPONSE=$(curl -s -d '{"username": "'${API_USERNAME}'","password": "'${API_PASSWORD}'","client_id": "flexvm","grant_type": "password"}' -H 'Content-Type: application/json' ${FORTICARE_AUTH_URL})
  STATUS=$(echo ${RESPONSE} | jq -r '.["status"]')

  echo "Authentication Status: ${STATUS}" 1>&2
  if [ ${STATUS} == 'success' ];
  then
    ACCESS_TOKEN=$(echo ${RESPONSE} | jq -r '.["access_token"]')
  else
    exit
  fi
}

flexvm_configs_list () {

  AUTH_HEADER="Authorization: Bearer ${ACCESS_TOKEN}"
  RESPONSE=$(curl -s -d '{"programSerialNumber": "'${PROGRAM_SERIAL}'"}' -H 'Content-Type: application/json' -H "${AUTH_HEADER}" ${FLEXVM_BASE_URL}/configs/list)
  STATUS=$(echo ${RESPONSE} | jq -r '.["status"]')

  echo "Configs List Status: ${STATUS}" 1>&2
  CONFIG_ID="NOT_FOUND"
  if [ ${STATUS} -eq 0 ];
  then
    CONFIG_ID=$(echo ${RESPONSE} | jq -r --arg CONFIG_NAME ${CONFIG_NAME} '.configs[] | select(.name==$CONFIG_NAME) | .id')
    echo ${CONFIG_ID} 1>&2
  else
    exit
  fi
}

flexvm_vms_list () {

  AUTH_HEADER="Authorization: Bearer ${ACCESS_TOKEN}"
  RESPONSE=$(curl -s -d '{"configId": "'${CONFIG_ID}'"}' -H 'Content-Type: application/json' -H "${AUTH_HEADER}" ${FLEXVM_BASE_URL}/vms/list)
  STATUS=$(echo ${RESPONSE} | jq -r '.["status"]')

  echo "VMs List Status: ${STATUS}" 1>&2

  if [ ${STATUS} -eq 0 ];
  then
    VM_FOUND=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .serialNumber')
    VM_STATUS=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .status')
    VM_TOKEN=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .token')
    VM_TOKEN_STATUS=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .tokenStatus')
    echo ${VM_FOUND} ${VM_STATUS} ${VM_TOKEN} ${VM_TOKEN_STATUS} 1>&2
  else
    exit
  fi
}

flexvm_vms_create () {

  AUTH_HEADER="Authorization: Bearer ${ACCESS_TOKEN}"
  RESPONSE=$(curl -s -d '{"configId": "'${CONFIG_ID}'", "count": "1", "description": "created by automation", "endDate": null}' -H 'Content-Type: application/json' -H "${AUTH_HEADER}" ${FLEXVM_BASE_URL}/vms/create)
  STATUS=$(echo ${RESPONSE} | jq -r '.["status"]')

  echo "VMs Create Status: ${STATUS}" 1>&2

  if [ ${STATUS} -eq 0 ];
  then
    VM_FOUND=$(echo ${RESPONSE} | jq -r '.vms[] | .serialNumber')
    VM_STATUS=$(echo ${RESPONSE} | jq -r '.vms[] | .status')
    VM_TOKEN=$(echo ${RESPONSE} | jq -r '.vms[] | .token')
    VM_TOKEN_STATUS=$(echo ${RESPONSE} | jq -r '.vms[] | .tokenStatus')
    echo ${VM_FOUND} ${VM_STATUS} ${VM_TOKEN} ${VM_TOKEN_STATUS} 1>&2
  else
    exit
  fi
}

flexvm_vms_stop () {

  AUTH_HEADER="Authorization: Bearer ${ACCESS_TOKEN}"
  RESPONSE=$(curl -s -d '{"serialNumber": "'${VM_FOUND}'"}' -H 'Content-Type: application/json' -H "${AUTH_HEADER}" ${FLEXVM_BASE_URL}/vms/stop)
  STATUS=$(echo ${RESPONSE} | jq -r '.["status"]')

  echo "VMs List Status: ${STATUS}" 1>&2

  if [ ${STATUS} -eq 0 ];
  then
    VM_FOUND=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .serialNumber')
    VM_STATUS=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .status')
    VM_TOKEN=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .token')
    VM_TOKEN_STATUS=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .tokenStatus')
    echo ${VM_FOUND} ${VM_STATUS} ${VM_TOKEN} ${VM_TOKEN_STATUS} 1>&2
  else
    exit
  fi
}

flexvm_vms_reactivate () {

  AUTH_HEADER="Authorization: Bearer ${ACCESS_TOKEN}"
  RESPONSE=$(curl -s -d '{"serialNumber": "'${VM_FOUND}'"}' -H 'Content-Type: application/json' -H "${AUTH_HEADER}" ${FLEXVM_BASE_URL}/vms/reactivate)
  STATUS=$(echo ${RESPONSE} | jq -r '.["status"]')

  echo "VMs List Status: ${STATUS}" 1>&2

  if [ ${STATUS} -eq 0 ];
  then
    VM_FOUND=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .serialNumber')
    VM_STATUS=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .status')
    VM_TOKEN=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .token')
    VM_TOKEN_STATUS=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .tokenStatus')
    echo ${VM_FOUND} ${VM_STATUS} ${VM_TOKEN} ${VM_TOKEN_STATUS} 1>&2
  else
    exit
  fi
}

flexvm_vms_token () {

  AUTH_HEADER="Authorization: Bearer ${ACCESS_TOKEN}"
  RESPONSE=$(curl -s -d '{"serialNumber": "'${VM_FOUND}'"}' -H 'Content-Type: application/json' -H "${AUTH_HEADER}" ${FLEXVM_BASE_URL}/vms/token)
  STATUS=$(echo ${RESPONSE} | jq -r '.["status"]')

  echo "VMs List Status: ${STATUS}" 1>&2

  if [ ${STATUS} -eq 0 ];
  then
    VM_FOUND=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .serialNumber')
    VM_STATUS=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .status')
    VM_TOKEN=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .token')
    VM_TOKEN_STATUS=$(echo ${RESPONSE} | jq -r --arg VM_SERIAL ${VM_SERIAL} '.vms[] | select(.serialNumber==$VM_SERIAL) | .tokenStatus')
    echo ${VM_FOUND} ${VM_STATUS} ${VM_TOKEN} ${VM_TOKEN_STATUS} 1>&2
  else
    exit
  fi
}

flexvm_output () {
  jq -n \
    --arg vm_serial "$VM_FOUND" \
    --arg vm_status "$VM_STATUS" \
    --arg vm_token "$VM_TOKEN" \
    --arg vm_token_status "$VM_TOKEN_STATUS" \
    '{"vmSerial":$vm_serial,"vmStatus":$vm_status,"vmToken":$vm_token,"vmTokenStatus":$vm_token_status}'
}

flexvm_authenticate
flexvm_configs_list

if [ -z ${VM_SERIAL} ]
then
  flexvm_vms_create
  exit
else
  flexvm_vms_list
  if [ ! -z ${VM_OP} ]
  then
    if [ ${VM_OP} == 'STOP' ] && [ ${VM_STATUS} != 'STOPPED' ]
    then
      flexvm_vms_stop
    fi

    if [ ${VM_OP} == 'REACTIVATE' ] && [ ${VM_STATUS} != 'ACTIVE' ]
    then
      flexvm_vms_reactivate
    fi

    if [ ${VM_OP} == 'TOKEN' ]
    then
      if [ ${VM_STATUS} != 'ACTIVE' ]
      then
        flexvm_vms_reactivate
      fi

      flexvm_vms_token

      flexvm_output
    fi
  fi
fi
