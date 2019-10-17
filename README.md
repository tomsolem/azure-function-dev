# Azure Function app Development
I had a hard time getting a good flow for a short azure function demo. It require dotnet core 2.1 (not 2.2) and also node js version 8 or 10. I had different version installed on my computer.


So I ended up create a custom ubuntu image to use for azure function development. This docker image can be used to create new azure function (only tested with node js). After the function is created you can test and develop against it in the docker image. 


When your happy use the azure cli to create a new azure function and publish the code from inside the same docker image. 


The docker image is intended to be used for development only. You can fork this repo and start development of your azure function app. 

# Getting started
Clone or fork this repo to your local computer. 

I assume that you already installed docker. The commands below are tested on macos. 

I guess the `$PWD` variable will differ on other os. 
___
Build the docker image
```
docker build . -t azure-func-dev
```
Start docker image
```
docker run -it --rm --name azure-func-dev -v $PWD/app/:/home/app/ -p 8080:7071 azure-func-dev
```
You are now working from inside the docker image. 

The folder /app/ is mounted into the docker in the path /home/app/.
```
cd /home/app
```
Start with init a new azure function
```
func init
```
* Choose `option 2` (node). 
* Select language: 1 (javascript)


![alt text](https://raw.githubusercontent.com/tomsolem/azure-function-dev/master/img/func-init.png "func init")


Create a new azure function
```
func new 
```

* Select template: 8 (HTTP trigger)
* Give the function a name: "TestTrigger"


![alt text](https://raw.githubusercontent.com/tomsolem/azure-function-dev/master/img/func-new.png "func new")

Start the new function app
```
func start
```
Open postman outside the docker image. 
```
http://localhost:8080/api/TestTrigger?name=HelloWorld
```
Note: we mapped the port 8080 to the 7071 inside the container. 


![alt text](https://raw.githubusercontent.com/tomsolem/azure-function-dev/master/img/postman.png "postman")

# Publish the azure function app
### Login with azure cli
```
az login
```
You'll get a url to past into the browser and fill inn token key.


After login you should set the correct subscription on the account:
```
az account set -s <subscription-id>
```
To publish the azure function. 
### Create a new azure function 

First we need to find what location we can create the function in:
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
### Publish azure function app
At last we can publish our new function app
```
func azure functionapp publish demo-function-app-001
```

![alt text](https://raw.githubusercontent.com/tomsolem/azure-function-dev/master/img/publish.png "func publish")


