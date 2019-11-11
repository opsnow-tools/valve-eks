# Security Group module

* node.CLUSTER 생성을 담당합니다.

## Draw

![](./img-draw-valve-eks-4steps.svg)

## Detail

* region = 생성 region
* city   = 공통
* stage  = 공통
* name   = 공통
* suffix = 공통

* vpc_id = 생성할 vpc 를 지정합니다.

* sg_name = 이름을 지정합니다. sg_name.CLUSTER
* sg_desc = Security Group 의 description 입니다.

* source_sg_cidrs = ingress 로 등록될 cidrs 를 list 형식으로 입력합니다. 자세한 예제는 example.tfvars.pub 를 참조하세요.
