# EKS-Network module

* EKS-Network 생성을 담당합니다.

## Draw

![](./img-draw-valve-eks-4steps.svg)

## Detail

* region = 생성 region
* city   = 공통
* stage  = 공통
* name   = 공통
* suffix = 공통

* vpc_id = 생성할 vpc 를 지정합니다.

* root_domain = 호스팅영역의 Domain 이름을 입력합니다. (eg. opsnow.io)

* public_subnet_ids = public subnet id 들을 입력합니다.

* weighted_routing = 가중치 기반 라우팅으로 셋팅됩니다. default 100
