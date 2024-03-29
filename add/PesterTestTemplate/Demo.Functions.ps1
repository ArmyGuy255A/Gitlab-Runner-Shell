function ConvertTo-TitleCase {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $String
    )

    $textInfo = (Get-Culture).TextInfo
    $titleString = $textInfo.ToTitleCase($String)
    if ([string]::IsNullOrEmpty($titleString)) {
        return $null
    }
    return $titleString
}