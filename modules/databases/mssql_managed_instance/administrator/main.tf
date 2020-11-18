terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }
  required_version = ">= 0.13"
}

locals {
  object_id    = coalesce(var.group_id, try(data.azuread_user.upn[0].id, null))
  display_name = var.group_id != null ? var.group_name : var.user_principal_name

  # arm_filename = "${path.module}/arm_mi_administrator.json"

  # # this is the format required by ARM templates
  # parameters_body = {
  #   managedInstanceName = {
  #     value = var.mi_name
  #   }
  #   login = {
  #     value = var.settings.login
  #   }
  #   sid = {
  #     value = coalesce(var.group_id, try(data.azuread_user.upn[0].id, null))
  #   }
  # }
}