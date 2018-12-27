<<<<<<< HEAD
﻿<#
.SYNOPSIS
    Configure pre-logon message in Windows using the legal notice screen
.DESCRIPTION
    Configures the legal notice to display a pre-logon message that requires the user to press OK to continue.

    This function can be used to enable the message directly or generate a reg-file to be deployed using ex. Group Policy.
.EXAMPLE
    PS C:\> Set-LegalNotice -Caption "Important Title" -Text "Do you really need this computer?" -Path .\MyLegalNotice.reg

    Generates a reg-file that can be deployed to present the message and title specified before the user sees the logon screen.
.NOTES
    Author: Frode Flaten
    Date created: 26.12.2018
    Version: 0.1.0
#>
function Set-LegalNotice {

=======
function Set-LegalNotice {
>>>>>>> 2d37057... Renamed Path-parameter in Set-LegalNotice and added Caption-validation
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding(DefaultParameterSetName='Online')]
    param (
        #Caption/Title for the legal notice
        [Parameter(Mandatory)]
        [ValidateScript({
            if($_ -notmatch '\n|\r') {
                $true
            } else {
                throw "Caption cannot contain linebreaks."
            }
        })]
        [string]
        $Caption,
        #Text for the legal notice
        [Parameter(Mandatory)]
        [string]
        $Text,
        # Computers to apply legal notice on
        [Parameter(ParameterSetName='Online')]
        [string[]]
        $ComputerName = @($env:COMPUTERNAME),
        #Desired path for legal notice reg-file for offline usage
        [Parameter(ParameterSetName='File')]
        [string]
        $FilePath = ".\LegalNotice.reg"
    )

    begin {
        if ($psCmdlet.ParameterSetName -eq 'File') {
            $hexText = "hex(1):$(([System.Text.Encoding]::Unicode.GetBytes($Text) | Foreach-Object { "{0:X2}" -f $_ }) -join ','),00,00"
        }
    }

    process {
        if ($psCmdlet.ParameterSetName -eq 'File') {
            $content = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
"LegalNoticeCaption"="$($Caption.Trim())"
"LegalNoticeText"=$hexText
"@
            Set-Content -Path $FilePath -Value $content
            if($?) {
                Write-Verbose "Legal notice registry-file saved to: $(Resolve-Path -Path $FilePath | Select-Object -ExpandProperty Path)"
            }
        } else {
            #Online
            foreach ($c in $ComputerName) {
                Write-Verbose "Applying legal notice to '$c'"
                if($c -ne $env:COMPUTERNAME -and $c -ne 'localhost') {
                    #Remote machine
                    Invoke-Command -ComputerName $c -ScriptBlock {
                        $regpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
                        Set-ItemProperty -Path $regpath -Name LegalNoticeCaption -Value $Using:Caption
                        Set-ItemProperty -Path $regpath -Name LegalNoticeText -Value $Using:Text
                    }
                } else {
                    #Local machine
                    Invoke-Command -ScriptBlock {
                        $regpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
                        Set-ItemProperty -Path $regpath -Name LegalNoticeCaption -Value $Caption -WhatIf
                        Set-ItemProperty -Path $regpath -Name LegalNoticeText -Value $Text -WhatIf
                    }
                }
            }
        }
    }

    end {
    }
}