# Run Infra as a Code with Jenkins
![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-000.png)

## Let us distribute this process into two parts.

- **Part-1**: We are going to install Jenkins on EC2 with one click. Then we are going to install plugins in Jenkins. Finally we will run a cloudformation from github in Jenkins.
- **[Part-2](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Readme.md#part2)** : We are going to install AWS CLI into jenkins, then learn about Jenkinsfile and then create a pipeline to deploy cloudformation from GIT.

## Part:1

Search for ‘Jenkins’ in AWS Marketplace products. Choose an AMi according to the OS you want. I chose one with Ubuntu in it.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-001.png)

Now quickly choose the required settings and instance configuration that you need and launch it. We chose t2.micro as it is free.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-003.png)

Our EC2 instance has started to spin up. Rename it to avoid confusion.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-004.png)

SSH into this instance. To get password to login into jenkins: cat /var/lib/jenkins/secrets/initialAdminPassword

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-006.png)

Copy the public ip of instance.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-007.png)

And paste it on the browser following the 8080 port. That is ip\_address:8080. 
Enter the password here that you got after using the cat command in the above steps.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-008.png) 

Later you will be prompted to install the plugins page. We will install default plugins for now and install the plugins we need later.
After the plugins are installed. Enter username password and other details.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-010.png)

Now you will be prompted to this page.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-011.png)

To install the plugin that we need.
Click on Manage Jenkins>>Manage Plugins>> Available and then search for ‘Cloudformation’.Install this plugin.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-013.png)

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

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-016.png)
![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-017.png)

Now, it has to get code from github repo.
Choose ‘Git’ in ‘Source Code Management’ for this to happen. 
Copy paste this repo URL.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-018.png)

In credentials add your github credentials.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-020.png)

Now in ‘Build Environment’ choose ‘Create AWS Cloud Formation Stack’. **This option is up there because of the plugin that we installed before**.
Fill the details accordingly.
In ‘Cloud Formation recipe file/S3 URL. (.json)’ section give your json file name from github repo.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-021.png)

Here you need to enter Access Key and Secret Key.
The need for these keys for Jenkins is to call Cloudformation API. Let us head towards AWS to get Access Key and Secret Key.
Goto IAM>>Users>>Add user from AWS Console.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-023.png)

Name the user.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-024.png)
Now, attach a policy to the user.
You need to attach ‘CloudFormation FullAccess’ and ‘S3 bucket FullAccess’ policies to it.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-025.png)
Check the policies attached and Create User.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-027.png)
Open the user that you just created and create an Access Key.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-028.png)
Copy the Access Key and Secret Key.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-030.png)

And paste the Access Key and Secret Access Key here.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-031.png)
Now save the project. Then select ‘Build Now’ to build the project.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-032.png)
You can see logs and the project has been built.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-034.png)
Also in AWS console CloudFormation>>Stack you can see the Stack has been created.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-035.png)

## Part:2

Now, we need to install AWS CLI. We can do it in multiple ways like SSH into instance and install or we can also use AWS SSM Session Manager to install without keys. We will be just SSHing into it and then download using commands.

First SSH into it. Then update using: sudo apt-get update.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-037.png)

Then install awscli using: sudo apt-get install awscli

**We will be using following jenkins file to pass on command on CLI:**
```
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

```

This is a Jenkins pipeline script that uses the AWS CLI to create an AWS CloudFormation stack from a template file. The pipeline has one stage called "Submit Stack" that consists of a single step.

Here's what the different parts of the pipeline script do:
- "pipeline": This is the top-level block of the Jenkins pipeline script that defines the entire pipeline.
- "agent any": This specifies that the pipeline can run on any available agent. In other words, it allows the Jenkins master to allocate an executor on any available Jenkins node to run this pipeline.
- "stages": This section contains a list of stages that the pipeline will execute. In this case, there is only one stage called "Submit Stack".
- "stage('Submit Stack')": This defines a stage in the pipeline called "Submit Stack". "steps": This section contains a list of steps that the pipeline will execute as part of the "Submit Stack" stage.
- "sh": This is a Jenkins step that allows running shell commands. In this case, it runs the AWS CLI command to create a CloudFormation stack with the name "s3bucket" using the "infraasacodewithjenkins.json" template file in the "us-east-1" region.

**Overall, this pipeline script automates the creation of an AWS CloudFormation stack using the AWS CLI. When executed, the pipeline will create the stack named "s3bucket" in the "us-east-1" region using the "infraasacodewithjenkins.json" template file.**

Unlike the previous part, here we will use IAM Role.
Let us create and attach an IAM role to EC2 with full S3 and CloudFormation Access. Select the EC2 instance and go to:
Actions Drop Down Menu>>Security>>Modify IAM Role

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-039.png)

Create an IAM ROle with following policies attached.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-041.png)

Attach that IAM role to EC2 instance

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-042.png)

Now let us create a Jenkins Pipeline Job.
First name your job and choose pipeline as type of job.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-044.png)

Straight away go to change ‘Pipeline Configuration’. Here choose ‘pipeline script from SCM’. Then choose GIT. Fill the details accordingly. We will be using this repo with Jenkins file and CloudFormation File.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-045.png)

Details has been filled according to the resources in GIT.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-047.png)

Then choose “Build now’ to build the job.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-048.png)
In logs you can see the job has been built successfully. AlsoThe command in ‘CLI-Jenkins’ file is being executed.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-050.png)

The s3 Bucket has been created which was our end goal.

![](https://github.com/Anshuls-repo/Works-Projects-Hands-on/blob/main/Projects/Run%20Infra%20as%20Code%20with%20Jenkins/Images/image-051.png)

## Conclusion: 
**You can deploy any infrastructure by just changing the Code in “infraasacodewith jenkins.json” with respective code for the infrastructure that you want in github. The pipeline will do the job for you.**

