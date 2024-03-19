# Initialize a list to store group data
$groupData = New-Object System.Collections.Generic.List[Object]

try {
    # Retrieve groups with email addresses matching 'olshanlaw.com'
    $groups = Get-DistributionGroup -Filter "EmailAddresses -like '*@olshanlaw.com'"

    foreach ($group in $groups) {
        $members = Get-DistributionGroupMember -Identity $group.Identity
        foreach ($member in $members) {
            # Create a custom object for each member
            $memberData = [PSCustomObject]@{
                'GroupDisplayName' = $group.DisplayName
                'GroupAlias' = $group.Alias
                'GroupPrimarySmtpAddress' = $group.PrimarySmtpAddress
                'MemberEmail' = $member.PrimarySmtpAddress
            }
            # Add the custom object to the list
            $groupData.Add($memberData)
        }
    }

    # Define the path for the CSV file
    $csvPath = "C:\Path\To\Directory\GroupMembers.csv"
    # Check if the directory exists, if not, create it
    $directory = Split-Path -Path $csvPath -Parent
    if (-not (Test-Path -Path $directory)) {
        New-Item -ItemType Directory -Path $directory
    }

    # Export the data to CSV
    $groupData | Export-Csv -Path $csvPath -NoTypeInformation
}
catch {
    Write-Error "An error occurred: $_"
}

