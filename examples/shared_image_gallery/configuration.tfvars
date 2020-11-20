global_settings = {
  default_region = "region1"
  regions = {
    region1 = "southeastasia"
  }
}

resource_groups = {
  sig = {
    name = "sig"
  }
  packer_vm = {
    name = "packer_vm"
  }
}

shared_image_gallery = {
  galleries = {
    gallery1 = {
      name               = "test1"
      resource_group_key = "sig"
      description        = " "
    }
  }

  image_definition = {
    image1 = {
      name               = "image1"
      gallery_key        = "gallery1"
      resource_group_key = "sig"
      os_type            = "Linux"
      publisher          = "MyCompany"
      offer              = "WebServer"
      sku                = "2020.1"
    }
  }
}

keyvaults = {
  packer_client = {
    name                   = "packer"
    resource_group_key     = "sig"
    sku_name               = "standard"
    soft_delete_enabled    = true
    enabled_for_deployment = true
    creation_policies = {
      logged_in_user = {
        certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge", "Recover"]
        secret_permissions      = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }
  }
}

#####################################################################################
# Use the following Blocks to Authenticate Packer using a Azure AD Service Principal
# Ref : https://www.packer.io/docs/builders/azure#azure-active-directory-service-principal



keyvault_access_policies_azuread_apps = {
  packer_client = {
    packer_client = {
      #
      azuread_app_key    = "packer_client"
      secret_permissions = ["Set", "Get", "List", "Delete"]
    }
  }
}

azuread_apps = {
  packer_client = {
    useprefix                    = true
    application_name             = "packer-client"
    password_expire_in_days      = 1
    app_role_assignment_required = true
    keyvaults = {
      packer_client = {
        secret_prefix = "packer-client"
      }
    }
    # Store the ${secret_prefix}-client-id, ${secret_prefix}-client-secret...
    # Set the policy during the creation process of the launchpad
  }
}

azuread_roles = {
  packer_client = {
    roles = [
      "Contributor"
    ]
  }
}

role_mapping = {
  built_in_role_mapping = {
    subscriptions = {
      logged_in_subscription = {
        "Contributor" = {
          azuread_apps = {
            keys = ["packer_client"]
          }
        }
      }
    }
  }
}

########################################################################################

packer = {
  build1 = {
    packer_template_filepath      = "./shared_image_gallery/packer/packer_template.json"
    packer_configuration_filepath = "./shared_image_gallery/packer/packer_config.json"
    image_destroy_script_filepath = "./shared_image_gallery/packer/destroy_image.sh"
    azuread_apps_key              = "packer_client"
    secret_prefix                 = "packer-client"
    keyvault_key                  = "packer_client"
    managed_image_name            = "myImage"
    resource_group_key            = "sig" #for managed_image_resource_group_name
    os_type                       = "Linux"
    image_publisher               = "Canonical"
    image_offer                   = "UbuntuServer"
    image_sku                     = "16.04-LTS"
    location                      = "southeastasia"
    vm_size                       = "Standard_A2_v2"
    ansible_playbook_path         = "./shared_image_gallery/packer/ansible-ping.yml"
    shared_image_gallery_destination = {
      gallery_key         = "gallery1"
      image_key           = "image1"
      image_version       = "1.0.0"
      resource_group_key  = "sig"
      replication_regions = "southeastasia"
    }
  }
}

