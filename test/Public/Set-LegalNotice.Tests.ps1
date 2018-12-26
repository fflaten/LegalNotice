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

        function clean {
            if(Test-Path -Path $path) { Remove-Item -Path $path }
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
        It "Throws NotImplemented-error on usage" {
            $caption = "My Test Title"
            $text = "My Test Text"
            { Set-LegalNotice -Caption $caption -Text $text -ErrorAction Stop } | Should -Throw
        }
    }
}
