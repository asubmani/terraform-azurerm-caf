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