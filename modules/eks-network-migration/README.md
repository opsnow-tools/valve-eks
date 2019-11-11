# EKS network module

* EKS 로 이관할때 새로운 클러스터(Green set)의 network 자원들을 생성합니다.

* 

* 현재는 ALB, ACM, Route53 을 정의하고 있으며, 추후 NLB 추가를 고려하고 있습니다.

## Resource

* resource "aws_acm_certificate" "default"

* resource "aws_route53_record" "validation"

* resource "aws_acm_certificate_validation" "default"

* resource "aws_lb" "main"

* resource "aws_security_group" "alb" 

* resource "aws_lb_target_group" "tg_http"

* resource "aws_lb_listener" "frontend_http"

* resource "aws_lb_listener" "frontend_https"

* resource "aws_lb_listener_certificate" "https_listener_no_logs" 

* resource "aws_route53_record" "address"

## Data

* data "aws_route53_zone" "selected" {
  
* data "aws_security_group" "worker_sg_id" {