#!/bin/bash

RESOURCE_GROUP_NAME=tstate-rg
STORAGE_ACCOUNT_NAME=tstateidentity$RANDOM
CONTAINER_NAME=tstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location westeurope

