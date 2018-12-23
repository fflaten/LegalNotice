$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. ("$here\$sut" -replace '\\Tests\\', '\LegalNotice\')

Describe "Set-LegalNotice" {
    It "Function loaded" {
        Get-Command Set-LegalNotice | Should -Be $true
    }

    Context "ParamterSet 'File'" {
        $path = "TestDrive:\LegalNotice.reg"

        function clean {
            if(Test-Path -Path $path) { Remove-Item -Path $path }
        }

        clean

        It "Generate file with valid input and path" {
            {Set-LegalNotice -Caption "My Test Title" -Text "My Test Text" -Path $path } | Should -Not -Throw
        }
    }

    Context "ParamterSet 'Online'" {
        It "Throws NotImplemented-error on usage" {
            { Set-LegalNotice -Caption "My Test Title" -Text "My Test Text" -ErrorAction Stop } | Should -Throw
        }
    }
}
