# Description

This repo is the ipmgmt module, which can be used to:

- Given a VNET range break it down to number of subnets based on a subnet size
- Given a list of IP ranges in use and  number of IP addresses needed find out a free slot for a VNET

In general it is a part of the project I run to show the process of creation Enterprise-focused PowerShell module, or set of modules for managing hybrid infrastructures in On-prem<->Azure environments.

## Installation

The module can be installed from the [PowerShell gallery](https://www.powershellgallery.com/packages/ipmgmt)

```powershell
Install-Module -Name ipmgmt
```

## More details

VLSM breakdown of a VNET, based on number of IPs. Size is simply number of IPs you expect to have in the sunet

```powershell
$subnets =
@{type = "GTWSUBNET"; size = 30},
@{type = "DMZSUBNET"; size = 62},
@{type = "EDGSUBNET"; size = 55},
@{type = "APPSUBNET"; size = 62},
@{type = "CRESUBNET"; size = 62}

Get-VLSMBreakdown -Network 10.10.0.0/16 -SubnetSize $subnets | ft
```

VLSM breakdown of a VNET, based on a a lenght of a prefix

```powershell
$subnets =
@{type = "GTWSUBNET"; cidr = 26},
@{type = "DMZSUBNET"; cidr = 21},
@{type = "EDGSUBNET"; cidr = 26},
@{type = "APPSUBNET"; cidr = 24},
@{type = "CRESUBNET"; cidr = 22}

Get-VLSMBreakdown -Network 10.10.0.0/16 -SubnetSizeCidr $subnets | ft
```
