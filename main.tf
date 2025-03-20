terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "=4.0.0"
        }
    }
}

provider "azurerm" {
    features {}
    subscription_id = "dc87fbc0-cc47-4a95-81fe-99d0baf3dabf"
}


resource "azurerm_resource_group" "balaji-rg"{
    name =  "balaji-rg"
    location = "Central India"
    tags = {
        environemt = "dev"
    }
}

resource "azurerm_virtual_network" "balaji-vn" {
    name = "balaji-vn"
    resource_group_name = azurerm_resource_group.balaji-rg.name
    location = azurerm_resource_group.balaji-rg.location 
    address_space = ["10.143.0.0/16"]
    tags = {
        evinronment = "dev"

    }
}

resource "azurerm_subnet" "balaji-subnet" {
    name = "balaji-subnet"
    resource_group_name = azurerm_resource_group.balaji-rg.name 
    virtual_network_name = azurerm_virtual_network.balaji-vn.name
    address_prefixes = ["10.143.166.0/24"]

}
resource "azurerm_network_security_group" "balaji-nsg" {
    name = "balaji-nsg"
    resource_group_name = azurerm_resource_group.balaji-rg.name 
    location = azurerm_resource_group.balaji-rg.location

}

resource "azurerm_network_security_rule" "balaji-nsgr" {
  name                        = "balaji-nsgr"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.balaji-rg.name
  network_security_group_name = azurerm_network_security_group.balaji-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "balaji-nsgs" {
    subnet_id = azurerm_subnet.balaji-subnet.id
    network_security_group_id = azurerm_network_security_group.balaji-nsg.id
}

resource "azurerm_public_ip" "balaji-pip" {
    name = "balaji-pip"
    location = azurerm_resource_group.balaji-rg.location 
    resource_group_name = azurerm_resource_group.balaji-rg.name
    allocation_method = "Dynamic"

}

resource "azurerm_network_interface" "balaji-nic" {
    name = "balaji_nic"
    location = azurerm_resource_group.balaji-rg.location
    resource_group_name = azurerm_resource_group.balaji-rg.name

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.balaji-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.balaji-pip.id
    }
}