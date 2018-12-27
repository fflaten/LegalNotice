function Get-LegalNotice {
    [CmdletBinding()]
    param (
        # Computers to check for legal notice
        [string[]]
        $ComputerName = @($env:COMPUTERNAME)
    )

    begin {
        $sb = {
            $regpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
            $prop = Get-ItemProperty -Path $regpath -Name "LegalNotice*"

            [pscustomobject]([ordered]@{
                Computer = $env:COMPUTERNAME
                LegalNoticeCaption = $prop.LegalNoticeCaption
                LegalNoticeText = $prop.LegalNoticeText
            })
        }
    }

    process {
        # Foreach computer - check registry-values
        foreach ($c in $ComputerName) {
            Write-Verbose "Getting legal notice to '$c'"

            if($c -ne $env:COMPUTERNAME -and $c -ne 'localhost') {
                #Remote machine
                Invoke-Command -ComputerName $c -ScriptBlock $sb
            } else {
                #Local machine
                Invoke-Command -ScriptBlock $sb
            }
        }
    }

    end {

    }
}