function Clear-LegalNotice {
    [CmdletBinding()]
    param (
        # Computers to remove legal notice from
        [string[]]
        $ComputerName = @($env:COMPUTERNAME)
    )

    begin {
        $Scriptblock = {
            $regpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
            Set-ItemProperty -Path $regpath -Name "LegalNoticeCaption" -Value ""
            Set-ItemProperty -Path $regpath -Name "LegalNoticeText" -Value ""
        }
    }

    process {
        # Foreach computer - check registry-values
        foreach ($c in $ComputerName) {
            Write-Verbose "Clearing legal notice on '$c'"
            if($c -ne $env:COMPUTERNAME -and $c -ne 'localhost') {
                #Remote machine
                Invoke-Command -ComputerName $c -ScriptBlock $Scriptblock
            } else {
                #Local machine
                Invoke-Command -ScriptBlock $Scriptblock
            }
        }
    }

    end {
    }
}