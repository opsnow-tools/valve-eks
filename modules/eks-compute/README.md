# EKS compute module

* AWS EKS 모듈을 정의합니다. EKS cluster 와 그에 필요한 worker node 들을 auto scaler group (ASG) 을 통해 spot instance + ondemand 방식으로 띄울수 있습니다. 또한 필수 Security Group + IAM role 등을 정의하고 있습니다.

* template 내 정의된 파일들과 local-exec 를 통해 aws_auth, kube_config 파일을 생성 하고 aws_auth 라는 이름의 configmap 을 바로 injection 합니다. 이는 생성자 외에 추가로 EKS 클러스터에 접근권한을 부여할수 있는 방법입니다.

* 아래 그림에서 EKS-compute 를 가리킵니다.

## Draw

<span style="display:block;text-align:center">![](./img-draw-valve-eks-4steps.svg)</span>
<span style="display:block;text-align:center">valve eks 전체</span>

## Graph

> CMD : terraform graph | dot -Tsvg > graph.svg

## Resource

* resource "aws_eks_cluster" "cluster"

* resource "aws_iam_role" "cluster"

* resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy"

* resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy"

* resource "aws_security_group" "cluster"

* resource "aws_security_group_rule" "cluster-ingress-node-https"

* resource "aws_iam_role" "worker"

* resource "aws_iam_instance_profile" "worker"

* resource "aws_iam_role_policy_attachment" "worker-AmazonEKS_CNI_Policy"

* resource "aws_iam_role_policy_attachment" "worker-AmazonEKSWorkerNodePolicy"

* resource "aws_iam_role_policy_attachment" "worker-AmazonEC2ContainerRegistryReadOnly"

* resource "aws_iam_role_policy_attachment" "worker_autoscaling"

* resource "aws_iam_policy" "worker_autoscaling"

* resource "aws_key_pair" "worker"

* resource "aws_launch_template" "worker-mixed"

* resource "aws_autoscaling_group" "worker-mixed"

* resource "aws_security_group" "worker"

* resource "aws_security_group_rule" "worker-ingress-self"

* resource "aws_security_group_rule" "worker-ingress-cluster"

* resource "aws_security_group_rule" "worker-ingress-sg"

## Data

* data "aws_iam_policy_document" "worker_autoscaling"

* data "aws_security_group" "worker_sg_id"

* data "aws_caller_identity" "current"

* data "aws_ami" "worker"

* data "template_file" "kube_config"

* data "template_file" "aws_auth_map_roles"

* data "template_file" "aws_auth_map_users"

* data "template_file" "aws_auth"
