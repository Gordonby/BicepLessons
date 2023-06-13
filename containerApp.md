# Container Apps

## Adding a new active revision with zero weight

There is a documented issue with Container Apps, where you cannot easily add a new revision to an app with a weight of 0%. https://github.com/microsoft/azure-container-apps/issues/688

I've created a sample which shows how to do achieve this. In order for it to work it assumes the a single latest revision has weight of 100%. Where the weight is split over multiple active revisions, this method will not work.

It works by looking at the existing ContainerApp and pulling the revision with 100% weight, then using that as part of the new app config

### Deploy it!

```powershell
#Prereq: Deploy an app
az deployment group create -g innerloop -f .\bicep\containerapp\containerapp-dapr.bicep

#Create a 0% active revision
az deployment group create -g innerloop -f .\bicep\containerapp\containerapp-newrevision.bicep

```