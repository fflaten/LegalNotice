function Set-LegalNotice {
    [CmdletBinding(DefaultParameterSetName='Online')]
    param (
        # Caption/Title for the legal notice
        [Parameter(Mandatory)]
        [string]
        $Caption,
        # Text for the legal notice
        [Parameter(Mandatory)]
        [string]
        $Text,
        # Computers to apply legal otice on
        [Parameter(ParameterSetName='Online')]
        [string[]]
        $ComputerName = @($env:COMPUTERNAME),
        # Desired path for legal notice reg-file for offline usage
        [Parameter(ParameterSetName='File')]
        [string]
        $Path = ".\LegalNotice.reg"
    )

    begin {
        if ($psCmdlet.ParameterSetName -eq 'File') {
            $hexText = "hex(1):$(([System.Text.Encoding]::Unicode.GetBytes($Text) | % { "{0:X2}" -f $_ }) -join ','),00,00"
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
"LegalNoticeText"=$hex
"@
            Set-Content -Path $Path -Value $content
            if($?) {
                Write-Host "Legal notice registry-file saved to: $(Resolve-Path -Path $Path | Select-Object -ExpandProperty Path)"
            }
        }

    }

    end {
    }
}