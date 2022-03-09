
BeforeAll {
    # enums
    . "$($Source.Path)\OrgMode\enum\OrgType.ps1"
    # classes
    . "$($Source.Path)\OrgMode\classes\OrgElement.ps1"
    . "$($Source.Path)\OrgMode\classes\OrgHeadline.ps1"
    # functions
    . "$($Source.Path)\OrgMode\public\Headline\Get-OrgHeadline.ps1"

}

Describe "Testing public Headline function Get-OrgHeadline" -Tags @('unit', 'OrgHeadline', 'Get' ) {
    Context "Basic functionality" {
        It "Should load without error" {
            {Get-Help Get-OrgHeadline -ErrorAction Stop} | Should -Not -Throw
        }
    }
}
