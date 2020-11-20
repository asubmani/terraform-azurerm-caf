vnets = {
  packer_vm = {
    resource_group_key = "packer_vm"
    vnet = {
      name          = "packer_vm"
      address_space = ["10.100.100.0/24"]
    }
    specialsubnets = {}
    subnets = {
      servers = {
        name    = "packer_subnet"
        cidr    = ["10.100.100.128/25"]
        nsg_key = "packer"
      }
    }

  }
}

network_security_group_definition = {

  packer = {

    nsg = [
      {
        name                       = "ssh",
        priority                   = "200"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "http",
        priority                   = "201"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "https",
        priority                   = "210"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "VirtualNetwork"
      },
    ]
  }

}