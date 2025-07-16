
This repo does the following tasks
1. Creates EKS cluster
2. Deploy ingress controller, loki,grafana, prometheus for monitoring
3. Deploys hello world application

I havent created ci/cd workflows for this repo. This needs to done in future. Once ci/cd flow is create we can build the docker image and push to ecr through CI pipeline. As of now it is manual.


We have 3 below directories here
1. terrafrom-eks : This folder contains terraform code to provision eks cluster from scratch from vpc,subnets to eks cluster and deploying ingress controller, grafana, loki, prometheus for monitoring and helloworld application using helm provider
2. deploy - This folder contains helm chart for deploying hello world application
3. src -  This folder contains python code for out hello world application

Execution instructions:

1. setup aws cli using aws configure 

aws configure

2. Build the docker image and push to ECR registry. We assume ECR is already created. 

docker build -t devops/helloworld:latest -t 123456789012.dkr.ecr.us-east-1.amazonaws.com/devops/helloworld:latest .

docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/devops/helloworld:latest

3. Update image url in deploy/helloworld/values.yaml
  repository: 123456789012.dkr.ecr.us-east-1.amazonaws.com/devops/helloworld

4. Follow the steps defined in certificate_commands.txt to generate certificate files. Here i am generating self signed certificate. If you alredy have trusted CA. You can just create server key and generate csr file. which you can get is signed by your trusted CA.

5. once you have certificate file. you can do bease64 encoding using below commands 

cat server.crt | base64 -w 0
cat server.key |  base64 -w 0 

then you can add the encoded text in deploy/helloworld/templates/secrets.yaml in tls.crt and tls.key sections

tls.crt: <your base64 encoded cert text>
tls.key: <your base64 encoded key text>

6. got to terraform-eks folder and run below terrafrom commands. 

cd terrafrom-eks

terraform init

terraform plan 

terraform apply

once completed this will provision vpc,subnets,routing tables,security groups,eks etc in aws. 
And deploys nginx ingress controller, loki,grafana, prometheus for monitoring. And deploys helloworld application and exposes it through ingress resources

7. once deployed you can verify the application with below curl command. I dont have registered domain. So i have got the load balancer ip and doing dns resolution in command here

curl --cacert server.crt https://demo.challenge.local/hello --resolve demo.challenge.local:443:52.205.128.58

For accessing the application through browser as i dont have registered domain. i need to get loadbalancer ip and add entry to /etc/hosts (windows: C:\Windows\System32\drivers\etc\hosts ) file for that domain

18.210.36.9 demo.challenge.local grafana.demo.challenge.local

If you have registered domain. You can add entry in route53 to transfer requests from that domain name to elb url.

8. You can access grafana through 
https://grafana.demo.challenge.local