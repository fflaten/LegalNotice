<#
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

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding(DefaultParameterSetName='Online')]
    param (
        #Caption/Title for the legal notice
        [Parameter(Mandatory)]
        [string]
        $Caption,
        #Text for the legal notice
        [Parameter(Mandatory)]
        [string]
        $Text,
        #Computers to apply legal otice on
        [Parameter(ParameterSetName='Online')]
        [string[]]
        $ComputerName = @($env:COMPUTERNAME),
        #Desired path for legal notice reg-file for offline usage
        [Parameter(ParameterSetName='File')]
        [string]
        $Path = ".\LegalNotice.reg"
    )

    begin {
        if ($psCmdlet.ParameterSetName -eq 'File') {
            $hexText = "hex(1):$(([System.Text.Encoding]::Unicode.GetBytes($Text) | Foreach-Object { "{0:X2}" -f $_ }) -join ','),00,00"
        } else {
            Write-Error "Online-functionality not yet implemented. Use Path-parameter to generate registry-file for import." -Category NotImplemented
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
            Set-Content -Path $Path -Value $content
            if($?) {
                Write-Verbose "Legal notice registry-file saved to: $(Resolve-Path -Path $Path | Select-Object -ExpandProperty Path)"
            }
        }

    }

    end {
    }
}