# Security Group module

* AWS 에서 Security Group 을 생성하는 module 입니다.

## Graph

> CMD : terraform graph | dot -Tsvg > graph.svg

## Resource

* resource "aws_security_group" "this"

* resource "aws_security_group_rule" "self"

* resource "aws_security_group_rule" "sg_ids"

* resource "aws_security_group_rule" "sg_cidrs"

## Data
