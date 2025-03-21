terraform{
    required_providers{
        azurerm={
            source="azurerm/hashicorp"
            version"4.0.0"
        }
    }
}

provider "azurerm" {
    features{}
}

resource "azurerm_resoure_group" "balaji-rg" {
    name="balaji-rg"
    location="Central India"

}

resource "azurerm_virtual_network" "balaji-vn" {
    name: "balaji-vn"
    address_space=["10.143.165.0/24"]
    resource_group_name=azurerm_resource_group.balaji-rg.name
    location=azurerm_resource_group.balaji-rg.location 
}
resource "azurerm_subnet" "balaji-subnet"{
    name:"balaji-subnet"
    address_prefixes=["10.143.165.0/28"]
    resource_group_name=azurerm_resource_group.balaji-rg.name  
    virtual_network_name=azurerm_resource_group.balaji-rg.name
}

resource "azure_network_interface" "balaji-nic"{
    name:"balaji-nic"
    resource_group_name=azurerm_resource_group.balaji-rg.name  
    location=azurerm_resoures_group.balaji-rg.location
    ip_configuration{
        name="balaji"
        subnet_id=azurerm_subnet.internal.id
        private_ip_address_allocation="Dynamic"

    }
}
resource "azurerm_virtual_machine" "balaji-vm" {
    name="balaji-vm"
    resource_group_name=azurerm_resource_group.balaji-rg.name 
    location=azurerm_resoures_group.balaji-rg.location
    network_interfaces_ids=azurerm_network_interface.balaji-nic.id
    vm_size=""

    storage_image_reference{
        sku=

    }
    storage_os_disk{
        name=
    }
}