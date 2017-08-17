$IDracs = @"
webnode09-id
webnode11-id
webnode12-id
webnode14-id
webnode15-id
"@ -split "`r`n"

$IDracsWithBrokenRedfish = @"
webnode16-id
"@ -split "`r`n"

$IDracsThatAreOld = @"
webnode07-id
"@ -split "`r`n"

function Get-TervisIDRACCredential {
    Get-PasswordstateCredential -PasswordID 201
}

function Connect-TervisIDRAC {
    param (
        $ComputerName
    )
    $Credential = Get-TervisIDRACCredential
    Connect-iDRAC -iDRAC_IP $ComputerName -Credentials $Credential -trustCert
}

function New-TervisIDRACSession {
    foreach ($Idrac in $IDracs) { 
        New-iDRACSession -iDRAC_IP $Idrac -Credentials $(Get-PasswordstateCredential -PasswordID 201) -trustCert
    }
}

function Get-TervisIDRACEthernetInterface {
    $System = Get-iDRACSystemElement
    $EthernetInterfaces = $System.EthernetInterfaces | Get-iDRACodata
    $EthernetInterfaces.Members | Get-iDRACodata
}

function Copy-TervisIDRACSCP {
    param (
        $ComputerName,
        $ShareName      
    )
    $Credential = Get-Credential
    Copy-iDRACSCP -Credentials $Credential -Cifs_IP $ComputerName -Cifs_Sharename $ShareName -Filename $ComputerName.xml -waitcomplete
}