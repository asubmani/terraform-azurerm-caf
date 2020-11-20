managed_identities = {
  packer = {
    name               = "packer-msi"
    resource_group_key = "packer"
  }
}

role_mapping = {
  built_in_role_mapping = {
    subscriptions = {
      logged_in_subscription = {
        "Contributor" = {
          managed_identities = {
            keys = ["packer"]
          }
        }
      }
    }
  }
}