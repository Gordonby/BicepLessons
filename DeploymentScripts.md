# Deployment Script errors

## Application Gateway

As encountered when developing [this script](https://github.com/Azure/bicep-registry-modules/pull/84).

## CanceledAndSupersededDueToAnotherOperation

Exception Details: (CanceledAndSupersededDueToAnotherOperation)
Operation PutApplicationGatewayOperation (026ca89f-6c2e-463d-bbff-cf0472368217) was canceled and superseded by operation PutApplicationGatewayOperation (5e5009ef-0b59-44c0-a9ae-65177a835750).

## DeploymentScriptContainerInstancesServiceLoginFailure

The deployment script was unable to log into Azure Resource Manager via the specified Managed Identity due to multiple errors. 
First error: MSI endpoint is not responding. Please make sure MSI is configured correctly.

## Other

> "message": "The provided script failed with multiple errors. First error:\r\nBusyBox v1.33.1 () multi-call binary.. Please refer to https://aka.ms/DeploymentScriptsTroubleshoot for more deployment script information."
