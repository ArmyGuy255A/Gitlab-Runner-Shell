BeforeAll {
    . $PSScriptRoot/Demo.Functions.ps1
}

### Start Tests Here
Describe "ConvertTo-TitleCase" {
    Context "Capitalize Each Word And Letter" {
        It "Returns <expected> (<name>)" -TestCases @(
            @{ Name = ""; Expected = $null}
            @{ Name = "phillip"; Expected = 'Phillip'}
            @{ Name = "phillip dieppa"; Expected = 'Phillip Dieppa'}
            @{ Name = "phillip a dieppa"; Expected = 'Phillip A Dieppa'}
        ) {
            $value = ConvertTo-TitleCase -String $Name
            $value | Should -BeExactly $expected
        }
    }
}
    
Describe "Verify Registry" {
Context "Ensure Key is Present" {
    It "HKLM:SOFTWARE Should be present" -TestCases @(
        @{ Path = "HKLM:\SOFTWARE\"; Expected = $true},
        @{ Path = "HKLM:/SOFTWARE/"; Expected = $true},
        @{ Path = "HKLM:SOFTWARE"; Expected = $true}
        @{ Path = "HKLM\SOFTWARE"; Expected = $true}

    ) {
        $value = Test-Path $Path
        $value | Should -Be $expected
    }
}
}