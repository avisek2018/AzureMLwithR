# Create AzureML Pipeline with R Scripts as Steps
As a data scientist, I often face clients who have the challenge to take their existing machine learning models to the cloud platform, Microsoft Azure, where they can automate the entire process using the pipelines. It is more of an MLOps problem though than a real data science task. The task becomes much harder if the exiting model is written in R than Python. Clients who have the working scripts/processes in R are usually reluctant to reinvent the wheel in Python and which makes complete sense. 
There are numerous use cases, tutorials, and blogs that talk about creating and maintaining Azure ML pipelines in python but there are hardly any for R. Here I am trying to create a quick reference guide on how you can create an Azure ML pipeline inside Azure Machine Learning Studio using R scripts as your pipeline steps. 
I have used the famous penguin data set as an example here. I assume you have the basic knowledge of creating Azure resources, storage account, and Azure ML workspace. The steps involved here are - 
1.	Create a custom environment from your docker file and register with the Azure ML container registry.
2.	Create your own Azure compute instance.
3.	Register the Dataset.
4.	Create/Use your R scripts for pipeline steps
5.	Create the Python wrapper to define the pipeline and kick off the execution
6.	Execute and monitor your Azure ML pipeline.

## Create Custom Environment:
I created a custom docker file and used that to create a custom environment inside AzureML space.

![Custom Environment](Images/create_env1.jpg?raw=true)

Once you create the environment it will take several minutes to build and register. Once succeeded you can notice the container registry inside it.

![Custom Environment](Images/create_env2.jpg?raw=true)

 ## Create Compute Instance: 
We need to create a compute instance in the Azure ML space. You can choose the Standard_DS11_v2 or any virtual machine you want.

![Create Compute](Images/create_compute1.jpg?raw=true)

## Register the Dataset:
I used the famous Penguin dataset [https://www.kaggle.com/code/parulpandey/penguin-dataset-the-new-iris/data] as an example here. You can download the dataset and register it in the Azure ML.

![Create Dataset](Images/create_dataset1.jpg?raw=true)
