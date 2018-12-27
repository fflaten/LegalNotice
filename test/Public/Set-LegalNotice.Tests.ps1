. $PSScriptRoot\..\Shared.ps1

Describe "Set-LegalNotice" {

    $FilePath = "TestDrive:\LegalNotice.reg"

    function clean {
        if(Test-Path -Path $FilePath) { Remove-Item -Path $FilePath }
    }

    Context "Common tests" {
        It "Function is available after import" {
            Get-Command Set-LegalNotice | Should -Be $true
        }

        It "Throws error when caption contains linebreak" {
            clean

            $caption = @"
Line1
Line2
"@
            $text = "My Test Text"
            { Set-LegalNotice -Caption $caption -Text $text -FilePath $FilePath -ErrorAction Stop } | Should -Throw
        }

    }

    Context "ParamterSet 'File'" {

        It "Generates file with valid input and path" {
            clean

            $caption = "My Test Title"
            $text = "My Test Text"
            $expected = @'
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
"LegalNoticeCaption"="My Test Title"
"LegalNoticeText"=hex(1):4D,00,79,00,20,00,54,00,65,00,73,00,74,00,20,00,54,00,65,00,78,00,74,00,00,00

'@

            { Set-LegalNotice -Caption $caption -Text $text -FilePath $FilePath -ErrorAction Stop } | Should -Not -Throw
            Get-Content -Path $FilePath -Raw | Should -BeExactly $expected
        }

    }

    Context "ParamterSet 'Online'" {

        BeforeAll {
            #Set up testkey
            $regpath = "HKCU:\SOFTWARE\PSLegalNotice-test"
            New-Item -Path $regpath -ItemType Key
        }

        #Had to use -ModuleName to make it call Invoke-Command. Why?
        Mock -CommandName Invoke-Command -ModuleName PSLegalNotice {
            $regpath = "HKCU:\SOFTWARE\PSLegalNotice-test"
            Set-ItemProperty -Path $regpath -Name "$($ComputerName)-LegalNoticeCaption" -Value $Caption
            Set-ItemProperty -Path $regpath -Name "$($ComputerName)-LegalNoticeText" -Value $Text
        }

        $env:COMPUTERNAME, "localhost" | Foreach-Object {
            It "Works when called multiple times - '$_'" {
                $caption = "My Test Title"
                $text = "My Test Text"

                { Set-LegalNotice -Caption $caption -Text $text -ComputerName $_ -ErrorAction Stop } | Should -Not -Throw

                $t = Get-ItemProperty -Path $regpath
                $t."$($_)-LegalNoticeCaption" | Should -BeExactly $caption
                $t."$($_)-LegalNoticeText" | Should -BeExactly $Text

                Assert-MockCalled -CommandName Invoke-Command -ModuleName PSLegalNotice -Times 1 -ParameterFilter { $ComputerName -eq $_ }
            }
        }

        It "Works using array as vale for -ComputerName" {
            $computers = @($env:COMPUTERNAME, "localhost")
            $caption = "My Test Title"
            $text = "My Test Text"
            Set-LegalNotice -Caption $caption -Text $text -ComputerName $computers -ErrorAction Stop
            Assert-MockCalled -CommandName Invoke-Command -ModuleName PSLegalNotice -Times 2 -ParameterFilter { $ComputerName -in $computers }
        }

        AfterEach {
            Remove-ItemProperty $regpath -Name "*-LegalNoticeCaption"
            Remove-ItemProperty $regpath -Name "*-LegalNoticeText"
        }

        AfterAll {
            Remove-Item -Path $regpath -Recurse
        }

    }
}