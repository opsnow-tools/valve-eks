# EKS module

* EKS-Compute 생성을 담당합니다.

## Draw

![](./img/img-draw-valve-eks-4steps.svg)

## Detail

* region = 생성 region
* city   = 공통
* stage  = 공통
* name   = 공통
* suffix = 공통

* vpc_id = 생성할 vpc 를 지정합니다.

* kubernetes_version = 생성할 node 의 ami 를 가져올때 사용합니다.

* subnet_ids = private subnet id 들을 입력합니다. 입력한 az 에만 node 가 생성됩니다.

* public_subnet_ids =  public subnet id 들을 입력합니다.

* instance_type = 기본으로 생성할 node type 을 지정합니다.

* mixed_instances = 기본 type 외에 다른 type 을 지정하면 기본 type 노드가 부족할때 지정된 다른 type 을 사용합니다.

* volume_size = EBS 사이즈 입니다. default 64

* min = Auto Scaler 에 초기 설정할 node 개수 입니다. default 1
* max = Auto Scaler 에 초기 설정할 node 개수 입니다. default 10

* on_demand_base = spot instance 를 쓰지 않고 기본으로 유지해야할 on demand 개수 입니다.
* on_demand_rate = spot instance, on demand 개수의 비율을 지정합니다. 0이면 모두 spot instance 를 사용하겠다는 의미입니다.

* key_name = worker node 에 직접 접근할때 사용할 key pair 입니다. (직접 접근할 일이 없어야 정상입니다.)

* map_users = 클러스터에 접근할 AWS user 를 지정합니다. aws_auth configmap 에 등록되어 클러스터 접근제어에 사용됩니다. 사용법은 example.tfvars.pub 를 참고하세요
