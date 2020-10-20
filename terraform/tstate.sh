#!/bin/bash

RESOURCE_GROUP_NAME=tstate-rg
STORAGE_ACCOUNT_NAME=tstateidentity$RANDOM
CONTAINER_NAME=tstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location westeurope

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

