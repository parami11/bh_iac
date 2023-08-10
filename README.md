# Introduction
This repository contains Iac deployment for a simple landing zone consist of a frontend, backend and a database. Frontend and backend are containerized deployments which will be hosted in an Azure Container Registry. Azure Web Apps will reference that when running the apps. Database will be a Cosmos DB instance that uses SQL API to connect.

# Execution
This sample was tested on a Windows PC. You need to have following prerequisites to test this on a Command Prompt. 
- Azure CLI Tools
- Login to an Active Azure Subscription on Command Prompt
