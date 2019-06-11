#Insert your API key here

$api_key = 'INSERT_API_KEY_HERE'
    

function Failure {
$global:helpme = $body
$global:helpmoref = $moref
$global:result = $_.Exception.Response.GetResponseStream()
$global:reader = New-Object System.IO.StreamReader($global:result)
$global:responseBody = $global:reader.ReadToEnd();
Write-Host -BackgroundColor:Black -ForegroundColor:Red "Status: A system exception was caught."
Write-Host -BackgroundColor:Black -ForegroundColor:Red $global:responsebody
Write-Host -BackgroundColor:Black -ForegroundColor:Red "The request body has been saved to `$global:helpme"
return}

function Get-MerakiSwitches {

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $api.url = '/networks/INSERT_NETWORK_ID/devices'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiAPs {

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = '/networks/INSERT_NETWORK_ID/devices'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiAppliances {

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = '/networks/INSERT_NETWORK_ID/devices'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiVPN {

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = '/organizations/INSERT_ORGANIZATION_ID/thirdPartyVPNPeers'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiNetworks {

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = '/organizations/INSERT_ORGANIZATION_ID/networks'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiOrganizations {

    #Usage: Get-MerakiOrganizations

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = '/organizations'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-OrganizationAdmins([string]$OrgID) {


    #Usage: Get-OrganizationAdmins '12345678' 

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = '/organizations/' + $OrgID + '/admins'
    $uri = $api.endpoint + $api.url
    echo $uri
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Put-AddOrganizationAdmin([string]$OrgID, [string]$AdminName, [string]$AdminEmail, [string]$OrgAccess) {

    #Usage: Put-AddOrganizationAdmin '12345678' 'First Last' 'first.last@example.com' 'full'
    #options for $orgAccess 'full', 'read-only' possibly others.

    $api = @{

        "endpoint" = 'https://api.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $data = @{
        
  "name" = $AdminName
  "email" = $AdminEmail
  "orgAccess" = $OrgAccess
    
    } | ConvertTo-Json

    $api.url = '/organizations/' + $OrgID + '/admins'
    $uri = $api.endpoint + $api.url
    $request = Invoke-WebRequest -Method GET -Uri $uri -Headers $header -MaximumRedirection 0 -ErrorAction Ignore
    if($request.StatusCode  -ge 300 -and $request.StatusCode -lt 400)
    {
    $uri = $request.Headers.Location
    }
    try{ $request = Invoke-RestMethod -Method POST -Uri $uri -Headers $header -Body $data}
    catch{Failure}
    if($request.StatusCode  -ge 300 -and $request.StatusCode -lt 400) {return}
    return $request

}

function Get-MerakiAllOrgsAllAdmins {
    
    #Usage: Get-MerakiAllOrgsAllAdmins
    #All access is dependent on the api key, use the api key for a specific user to list all admins for organizations they have access to, or from a "master" account to list all admins for all organizations your company manages.

Get-MerakiOrganizations | ForEach-Object {echo "Organization: "$_.name"`r`n"; Get-OrganizationAdmins $_.id} *>&1 | Tee-Object -FilePath "$env:USERPROFILE\Desktop\MerakiAdmins.txt"
}

function Put-MerakiAllOrgsNewAdmin([string]$AdminName, [string]$AdminEmail, [string]$OrgAccess) {
    
    #Usage: Put-MerakiAllOrgsNewAdmin 'First Last' 'first.last@example.com' 'full'
    #options for $orgAccess 'full', 'read-only' possibly others.
    
    #all access is dependent on the api key, use the api key for a specific user to clone them, or from a "master" account to give access to all organizations your company manages.
    #On first run this will create an account and add 1-3 organizations, before failing for the remainder w/ error code below.
    
    #Status: A system exception was caught.
    #{"errors":["Email first.last@example.com is already registered with a Cisco Meraki Dashboard account. For security purposes, that user must verify his/her email address before administrator permissions can be granted here."]}
    #The request body has been saved to $global:helpme 

    #To resolve, verify the email address using one of the emails sent, then run the script again.
    #Any organizations already added will return the error below, but you can ignore it.
    
    #Organization: 
    #Your Meraki Org (YMO)


    #Status: A system exception was caught.
    #{"errors":["Email has already been taken"]}
    #The request body has been saved to $global:helpme 

    #After all organizations have been added, log in online and accept the organizations.
     

Get-MerakiOrganizations | ForEach-Object {echo "Organization: "$_.name"`r`n"; Put-AddOrganizationAdmin $_.id $AdminName $AdminEmail $OrgAccess} -ErrorAction Ignore *>&1 | Tee-Object -FilePath "$env:USERPROFILE\Desktop\MerakiNewAdmin.txt"
}

function Get-MerakiSwitchPorts {

    #Useage: Get-MerakiSwitchPorts "SW01"

    param (
    
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $switch_name
    
    )
    
    $switch = Get-MerakiSwitches | where {$_.name -eq $switch_name}

    if ($switch){

        $api = @{

            "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
        }

        $header = @{
        
            "X-Cisco-Meraki-API-Key" = $api_key
            "Content-Type" = 'application/json'
        
        }

        $api.url = "/devices/" + $switch.serial + "/switchPorts"
        $uri = $api.endpoint + $api.url
        $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
        return $request
    
    }
    else{

        Write-Host "Switch doesn't exist." -ForegroundColor Red
    
    }

}
