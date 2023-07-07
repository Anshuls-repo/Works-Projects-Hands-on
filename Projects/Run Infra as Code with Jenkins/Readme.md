# Run Infra as a Code with Jenkins
![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-000.png)

## Let us distribute this process into two parts.

- Part-1: We are going to install Jenkins on EC2 with one click. Then we are going to install plugins in Jenkins. Finally we will run a cloudformation from github in Jenkins.
- Part-2: We are going to install AWS CLI into jenkins, then learn about Jenkinsfile and then create a pipeline to deploy cloudformation from GIT.

## Part:1

Search for ‘Jenkins’ in AWS Marketplace products. Choose an AMi according to the OS you want. I chose one with Ubuntu in it.
![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.002.jpeg)

Now quickly choose the required settings and instance configuration that you need and launch it. We chose t2.micro as it is free.
![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.003.jpeg)

Our EC2 instance has started to spin up. Rename it to avoid confusion.
![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.004.jpeg)

SSH into this instance. To get password to login into jenkins: cat /var/lib/jenkins/secrets/initialAdminPassword
![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.005.jpeg)

Copy the public ip of instance.
![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.006.jpeg)

And paste it on the browser following the 8080 port. That is ip\_address:8080. 
Enter the password here that you got after using the cat command in the above steps.
![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.007.jpeg) 

Later you will be prompted to install the plugins page. We will install default plugins for now and install the plugins we need later.
After the plugins are installed. Enter username password and other details.
![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.008.jpeg)

Now you will be prompted to this page.
![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.009.jpeg)

To install the plugin that we need.
Click on Manage Jenkins>>Manage Plugins>> Available and then search for ‘Cloudformation’.Install this plugin.
![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.010.jpeg)

Now let us run cloud formation from github into jenkins.
For this we have created a file in json format. Let us look into it first.

```
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Resources": {
    "S3Bucket": {
      "Type": "AWS::S3::Bucket"
  }
},
  "Outputs": {
    "BucketName": {
      "Value": {
        "Ref": "S3Bucket"
      },
      "Description": "Name of the sample Amazon S3 bucket."
    }
  }
}
```

Here's what the different parts of the template do:

- "AWSTemplateFormatVersion": This specifies the version of the CloudFormation template format being used. In this case, it's the 2010-09-09 version.
- "Resources": This section contains a list of resources that will be created when the CloudFormation stack is deployed. In this template, there is only one resource, an S3 bucket.
- "S3 Bucket": This is the logical ID of the S3 bucket resource. The "Type" attribute specifies the type of AWS resource to create, in this case, an S3 bucket.
- "Outputs": This section contains a list of output values that can be retrieved from the CloudFormation stack after it has been created.
- "BucketName": This is the logical ID of the output value. The "Value" attribute is set to the "Ref" function, which retrieves the value of the S3 bucket's logical ID. This means that the output will contain the name of the S3 bucket that was created by this CloudFormation stack. The "Description" attribute provides a description of the output value.

**Overall, this CloudFormation template creates an S3 bucket resource and outputs the name of the bucket. When the CloudFormation stack is created from this template, the S3 bucket will be provisioned and the bucket name will be available as an output value.**

Let us get back to jenkins and create a freestyle project using this json file.

Click on create job>>Freestyle Project and name your project.

![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.011.jpeg)

Now, it has to get code from github repo.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.012.jpeg)

Choose ‘Git’ in ‘Source Code Management’ for this to happen. Copy paste this repo URL.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.013.jpeg)

In credentials add your github credentials.

Now in ‘Build Environment’ choose ‘Create AWS Cloud Formation Stack’. **This option is up ![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.014.jpeg)there because of the plugin that we installed before**.

Fill the details accordingly.

In ‘Cloud Formation recipe file/S3 URL. (.json)’ section give your json file name from github repo.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.015.jpeg)

Here you need to enter Access Key and Secret Key.

The need for these keys for Jenkins is to call Cloudformation API. Let us head towards AWS to get Access Key and Secret Key.

Goto IAM>>Users>>Add user from AWS Console.

Name the user.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.016.jpeg)![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.017.jpeg)

Now, attach a policy to the user.

You need to attach ‘CloudFormation FullAccess’ and ‘S3 bucket FullAccess’ policies to it.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.018.jpeg)

Check the policies attached and Create User.

![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.019.jpeg)

Open the user that you just created and create an Access Key.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.020.jpeg)

Copy the Access Key and Secret Key.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.021.jpeg)

And paste the Access Key and Secret Access Key here.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.022.jpeg)

Now save the project. Then select ‘Build Now’ to build the project.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.023.jpeg)

You can see logs and the project has been built.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.024.jpeg)

Also in AWS console CloudFormation>>Stack you can see the Stack has been created.

![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.025.jpeg)

**Part:2**

Now, we need to install AWS CLI. We can do it in multiple ways like SSH into instance and install or we can also use AWS SSM Session Manager to install without keys. We will be just SSHing into it and then download using commands.

First SSH into it. Then update using: sudo apt-get update![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.026.jpeg)

Then install awscli using: sudo apt-get install awscli

**We will be using following jenkins file to pass on command on CLI:**

pipeline {

agent any

stages {

stage('Submit Stack') {

steps {

sh "aws cloudformation create-stack --stack-name s3bucket --template-body file://infraasacodewithjenkins.json --region 'us-east-1'"

}

}

}

}

This is a Jenkins pipeline script that uses the AWS CLI to create an AWS CloudFormation stack from a template file. The pipeline has one stage called "Submit Stack" that consists of a single step.

Here's what the different parts of the pipeline script do:

"pipeline": This is the top-level block of the Jenkins pipeline script that defines the entire pipeline.

"agent any": This specifies that the pipeline can run on any available agent. In other words, it allows the Jenkins master to allocate an executor on any available Jenkins node to run this pipeline.

"stages": This section contains a list of stages that the pipeline will execute. In this case, there is only one stage called "Submit Stack".

"stage('Submit Stack')": This defines a stage in the pipeline called "Submit Stack". "steps": This section contains a list of steps that the pipeline will execute as part of the "Submit Stack" stage.

"sh": This is a Jenkins step that allows running shell commands. In this case, it runs the AWS CLI command to create a CloudFormation stack with the name "s3bucket" using the "infraasacodewithjenkins.json" template file in the "us-east-1" region.

**Overall, this pipeline script automates the creation of an AWS CloudFormation stack using the AWS CLI. When executed, the pipeline will create the stack named "s3bucket" in the "us-east-1" region using the "infraasacodewithjenkins.json" template file.**

Unlike the previous part, here we will use IAM Role.

Let us create and attach an IAM role to EC2 with full S3 and CloudFormation Access. Select the EC2 instance and go to:

Actions Drop Down Menu>>Security>>Modify IAM Roles![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.027.jpeg)

Create an IAM ROle with following policies attached.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.028.jpeg)

Attach that IAM role to EC2 instance![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.029.jpeg)

Now let us create a Jenkins Pipeline Job.

First name your job and choose pipeline as type of job.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.030.jpeg)

Straight away go to change ‘Pipeline Configuration’. Here choose ‘pipeline script from SCM’. Then choose GIT. Fill the details accordingly. We will be using this repo with Jenkins file and CloudFormation File.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.031.jpeg)

Details has been filled according to the resources in GIT.

![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.032.jpeg)

Then choose “Build now’ to build the job.

![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.033.jpeg)In logs you can see the job has been built successfully. AlsoThe command in ‘CLI-Jenkins’ file is being executed.![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.034.jpeg)

The s3 Bucket has been created which was our end goal.

![](Aspose.Words.8c6231e7-1686-4e35-99fa-a45aa915df3f.035.jpeg)

Conclusion: You can deploy any infrastructure by just changing the Code in [“infraasacodewith jenkins.json](https://github.com/Anshuls-repo/IAAC-Jenkins/blob/main/infraasacodewithjenkins.json)” with respective code for the infrastructure that you want in github. The pipeline will do the job for you.

