#01 Installing the Domain Controlled

1. Use 'sconfig' to:
    - Change the hostname
    - CHange the IP address to static
    - Change the DNS server to our own IP address

2. Install the Active DIrectory Windows Feature

```shell
Install-WindowsFeature AD-Domain-Services
-IncludeManagementTools
```


```
Get-NetIPAddress Set-DNSClientServer
```

# Joining the Workstation to the domain


```
Add-Computer -Domainname jpcodes.com -Credential jpcodies\Administrator -Force -Restart
````