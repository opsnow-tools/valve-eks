# EKS network-migration module

* EKS Network Migration module 생성을 담당합니다.

* Terraform apply 순서
  1. EKS-Network-Migration apply
      * Blue set Blue.domain 100
      * Green set Blue.domain 0
      * Green.domain 100
  1. Green set 에 어플리케이션 이관 (Green.domain 으로 테스트)
  1. EKS-Network-Migration update -> apply
      * Blue set Blue.domain 100
      * Green set Blue.domain 100
      * Green.domain 100
  1. EKS-Network update -> apply
      * Blue set Blue.domain 0
      * Green set Blue.domain 100
      * Green.domain 100
  1. Green set 에 어플리케이션 테스트 (Blue.domain 으로 테스트)
  1. EKS-Network destroy
      * Blue set Blue.domain 사라짐
      * Green set Blue.domain 100
      * Green.domain 100

## Draw

<span style="display:block;text-align:center">![](./img/img-draw-valve-eks-4steps-migration.svg)</span>
<span style="display:block;text-align:center">valve eks 이관</span>

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

* name_represent = 이관 대상이 되는 이전에 생성했던 name 을 입력합니다.

* weighted_routing_represent = Blue domain 의 가중치를 부여합니다. Default 0
* weighted_routing_new = Green domain 의 가중치를 부여합니다. Default 100
