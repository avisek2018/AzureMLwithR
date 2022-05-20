# Create AzureML Pipeline with R Scripts as Steps
As a data scientist, I often face clients who have the challenge to take their existing machine learning models to the cloud platform, Microsoft Azure, where they can automate the entire process using the pipelines. It is more of an MLOps problem though than a real data science task. 

The task becomes much harder if the exiting model is written in R than Python. Clients who have the working scripts/processes in R are usually reluctant to reinvent the wheel in Python and which makes complete sense. R is useful, AML makes it hard, I have a solution.

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
I used the famous Penguin dataset [Penguin Dataset](https://www.kaggle.com/code/parulpandey/penguin-dataset-the-new-iris/data) as an example here. 

![Penguin Dataset](Images/Penguin.jpg?raw=true)

You can download the dataset and register it in the Azure ML.

![Create Dataset](Images/create_dataset1.jpg?raw=true)


## Create R Scripts: 
I have created 4 R scripts to process the data, prepare the data, train the model and score the model. This is a very simple dataset but I tried my best to demonstrate the typical lifecycle of a machine learning pipeline. I used a decision tree to solve this classification problem.

- [Process Data](RCodes/process_data.R)
- [Prepare Data](RCodes/prepare_data.R)
- [Train a Decision Tree Model](RCodes/train_model_dt.R)
- [Score the Model](RCodes/test_model_dt.R)

![Decision tree](Images/dt_chart.jpg?raw=true)

## Create the Python wrapper:
This notebook shows how to use the CommandStep with Azure Machine Learning Pipelines for running R scripts in a pipeline. I am just highlighting the key points here. For the full code please check the notebook file [Create and Execute Pipeline](commandstep_decision_tree.ipynb)
#### Setup and get the Dataset
```
#Get default Workspace
ws = Workspace.from_config()
#Get the Penguin data from registered Dataset
datastore = ws.get_default_datastore()
pg_dataset = Dataset.File.from_files(datastore.path('penguin_data'))
```
#### Get the Compute and Custom Env
```
#Get the Compute
compute_name = "avisekCompute"
compute_target = ws.compute_targets[compute_name]
#Get the Custom Env
env = Environment.get(ws,name='commandstepR-env')
```
#### Define and Trigger the Pipeline

Define the ScriptRunConfigs to represents configuration information for submitting a run in Azure Machine Learning.
```
#Define the Rscripts
process_data = ScriptRunConfig(source_directory=src_dir,
                            command=['Rscript process_data.R --penguin_data', pg_dataset.as_named_input(name="penguin_data").as_mount(), '--output_folder', validated_data],
                            compute_target=compute_target,
                            environment=env)

prepare_data = ScriptRunConfig(source_directory=src_dir,
                            command=['Rscript prepare_data.R --validated_data', validated_data, '--train_folder', train_data, '--test_folder', test_data],
                            compute_target=compute_target,
                            environment=env)

train = ScriptRunConfig(source_directory=src_dir,
                            command=['Rscript train_model_dt.R --train_data', train_data, '--model_folder', model],
                            compute_target=compute_target,
                            environment=env)

test = ScriptRunConfig(source_directory=src_dir,
                            command=['Rscript test_model_dt.R --test_data', test_data, '--model_folder', model],
                            compute_target=compute_target,
                            environment=env)
```
Define and build the pipeline
```
#Define Pipeline Steps
#Process Data step
process_data_step = CommandStep(name='process_data', 
                    outputs = [validated_data],
                    runconfig=process_data)
#Prepare/Feature Engg step
prepare_data_step = CommandStep(name='prepare_data', 
                    inputs = [validated_data],
                    outputs = [train_data, test_data],
                    runconfig=prepare_data)
#Train the Model
train_step = CommandStep(name='model_training', 
                    inputs = [train_data],
                    outputs = [model],
                    runconfig=train)
#Test the model
test_step = CommandStep(name='model_scoring', 
                    inputs = [test_data, model],
                    #outputs = [model],
                    runconfig=test)
                    
# Define Pipeline
poc_pipeline_R = [test_step]
# Build the pipeline
pipeline1 = Pipeline(workspace=ws, steps=[poc_pipeline_R])
```
Submit the pipeline
```
# Submit the pipeline to be run
pipeline_run1 = Experiment(ws, 'POC_PENGUIN_DATA_CMDSTEP').submit(pipeline1)
```
#### View Run Details
```
RunDetails(pipeline_run1).show()
```
Here is the screenshot from the Pipeline run.
![Pipeline Run](Images/pipeline_run.jpg?raw=true)
