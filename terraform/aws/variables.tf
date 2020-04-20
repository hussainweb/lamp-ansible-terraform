variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-west-1"
}

variable "web_instance_type" {
  default = "t2.micro"
}
//
//variable "name_prefix" {
//  default = "dx-cms-webdev-"
//}
//variable "site_name" {}
//variable "environment" {}
//
//variable "files_dir" {
//  default = ""
//}
//
//variable "drupal_base_protocol" {
//  default = "http"
//}
//variable "drupal_base_domain_name" {}
//
//variable "drupal_acep_key" {}
//
//variable "drupal_api_proxy_lambda_zip" {
//  default = ""
//}
//
//locals {
//  drupal_base_url = "${var.drupal_base_protocol}://${var.drupal_base_domain_name}"
//  is_production = "${var.environment == "prod"}"
//}
