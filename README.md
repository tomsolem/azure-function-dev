# azure-function-dev
Azure function development

# Getting started

Clone this repo
Build docker image
```
docker build . -t azure-func-dev
```
Start docker image
```
docker run -it --rm --name azure-func-dev -v $PWD/app/:/home/app/ -p 8080:7071 azure-func-dev
```
You are now working from inside the docker image. The folder /app/ is 
mounted into the docker in the path /home/app/.
```
cd /home/app
```
Start with init a new azure function
```
func init
```
Choose option 2 (node)
Create a new azure function
```
func new 
```
* Select language: 1 (javascript)
* Select template: 8 (HTTP trigger)
* Function name: "TestTrigger"

Start the new function app
```
func start
```
Open postman outside the docker image. 
```
http://localhost:8080/api/TestTrigger?name=HelloWorld
```
Note: we mapped the port 8080 to the 7071 inside the container. 

# Publish the azure function app
Login with azure cli
```
az login
```
You'll get a url to past into the browser and fill inn token key.
After login you should set the correct subscription on the account:
```
az account set -s <subscription-id>
```
To publish the azure function. 
First we need to create a new azure function. First we need to find 
what location we can create the function in:
```
az account list-locations | grep name
```
I.e. we can use "westeurope".
First we must create a resource group
```
az group create -l westeurope -n demo-function-app
```
We then need to create a storage account to store the function app in
```
az storage account create -n demofunctionapp -g demo-function-app -l westeurope --sku Standard_LRS
```
Then we can create the azure function app
```
az functionapp create --consumption-plan-location westeurope --name demo-function-app-001 --os-type Linux --resource-group demo-function-app --runtime node --storage-account demofunctionapp
```
At last we can publish our new function app
```
func azure functionapp publish demo-function-app-001
```


