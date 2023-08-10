# Introduction
This repository contains Iac deployment for a simple landing zone consist of a frontend, backend and a database. Frontend and backend are containerized deployments which will be hosted in an Azure Container Registry. Azure Web Apps will reference that when running the apps. Database will be a Cosmos DB instance that uses SQL API to connect.

# Execution
This sample was tested on a Windows PC. You need to have following prerequisites to test this on a Command Prompt. 
- Azure CLI Tools
- Login to an Active Azure Subscription on Command Prompt
- Co-Administrator access to the Azure Subscription (as we execute in subscription scope)

## Command
You can modify the default parameters (environmentType and applicationName) in the core.bicep file or pass the parameters via command prompt command when they are prompted.

```
az deployment sub create --location <location> --template-file core.bicep
```
