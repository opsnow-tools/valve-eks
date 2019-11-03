# Security Group module

* AWS Security Group 을 관리하기 위한 용도로 사용합니다. 변경사항을 plan 으로 추적할 수 있으려면 inline 방식으로 관리해야 합니다.

## Resource

* resource "aws_security_group" "this"