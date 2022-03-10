# A Terraform module to create a subset of cloud components
# Copyright (C) 2022 IQ3 CLOUD Skaylink GmbH

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version. 

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# For questions and contributions please contact info@iq3cloud.com
# https://github.com/iq3cloud-dev/terraform-azurerm-iq3-windows-vm

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "random_password" "cspadmin_password" {
  length           = 24
  special          = true
  override_special = "_%@"
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                = var.vm_name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  size                = var.vm_size
  admin_username      = "cspadmin"
  admin_password      = random_password.cspadmin_password.result
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }

  tags {
    deploymentType = "terraform"
  }
}

########################
# Backup Configuration #
########################

resource "azurerm_backup_protected_vm" "backup_configuration" {
  resource_group_name = "iq3-basemanagement"
  recovery_vault_name = var.vm_recovery_vault
  source_vm_id        = azurerm_windows_virtual_machine.virtual_machine.id
  backup_policy_id    = data.azurerm_backup_policy_vm.backup_policy.id
}

#################
# VM Extensions #
#################

resource "azurerm_virtual_machine_extension" "diskencryption" {
  count = var.vm_enable_disk_encryption ? 1 : 0

  name                 = "DiskEncryptionWindows"
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryption"
  type_handler_version = "2.2"
  settings             = <<SETTINGS
    {
        "EncryptionOperation": "EnableEncryption",
        "KeyVaultURL": "${data.azurerm_key_vault.kv.vault_uri}",
        "KeyVaultResourceId": "${data.azurerm_key_vault.kv.id}",					
        "KeyEncryptionKeyURL": "${data.azurerm_key_vault_key.encryption_key.id}",
        "KekVaultResourceId": "${data.azurerm_key_vault.kv.id}",					
        "KeyEncryptionAlgorithm": "RSA-OAEP",
        "VolumeType": "ALL"
    }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "monitoringWindows" {
  name                       = "iq3-Management-Monitoring"
  virtual_machine_id         = azurerm_windows_virtual_machine.virtual_machine.id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
        {
          "workspaceId": "${data.azurerm_log_analytics_workspace.workspace.workspace_id}"
        }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
          "workspaceKey": "${data.azurerm_log_analytics_workspace.workspace.primary_shared_key}"
        }
PROTECTED_SETTINGS
}

resource "azurerm_virtual_machine_extension" "antimalware" {
  name                 = "${var.vm_name}-MSIaaSAntimaleware"
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.5"

  settings = <<SETTINGS
  {
    "AntimalwareEnabled": true,
    "RealtimeProtectionEnabled": "true",
    "ScheduledScanSettings": {
      "isEnabled": "true",
      "day": "6",
      "time": "200",
      "scanType": "Quick"
    }
  }
  SETTINGS
}

resource "azurerm_virtual_machine_extension" "iaas_diagnostics" {
  name                       = "${var.vm_name}-IaaSDiagnostics"
  virtual_machine_id         = azurerm_windows_virtual_machine.virtual_machine.id
  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "IaaSDiagnostics"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true
  settings                   = data.template_file.iaas_diagnostics_extension_settings.rendered
  protected_settings         = data.template_file.iaas_diagnostics_extension_protected_settings.rendered
}

resource "azurerm_virtual_machine_extension" "domain_Join" {
  lifecycle {
    prevent_destroy = true
  }
  count = var.domain_join_settings == null ? 0 : 1

  name                 = "ADDomainJoin"
  virtual_machine_id   = azurerm_windows_virtual_machine.virtual_machine.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings           = <<SETTINGS
{
  "Name" : "${var.domain_join_settings.domain_name}",
  "User" : "henkelgroup.net\\${data.azurerm_key_vault_secret.domainjoin_user[0].value}",
  "OUPath" : "${var.domain_join_settings.ou_path}",
  "Restart" : "true",
  "Options" : 3
}
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
{
  "Password" : "${data.azurerm_key_vault_secret.domainjoin_password[0].value}"
}
PROTECTED_SETTINGS
}

resource "azurerm_network_interface_application_security_group_association" "pbicloud_rdp_asg" {
  for_each                      = toset(var.application_security_groups)
  network_interface_id          = azurerm_network_interface.nic.id
  application_security_group_id = each.key
}