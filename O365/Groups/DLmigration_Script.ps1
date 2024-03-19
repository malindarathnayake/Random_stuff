# Connect to Exchange Online
Connect-ExchangeOnline -Credential (Get-Credential)

# Retrieve and create groups from onprem Exchange
$groups = Get-DistributionGroup -Filter "EmailAddresses -like '*@olshanlaw.com'"
foreach ($group in $groups) {
    $members = Get-DistributionGroupMember -Identity $group.Identity
    $memberEmails = $members | Select -ExpandProperty PrimarySmtpAddress

    # Create the group in Office 365
    $newGroup = New-UnifiedGroup -DisplayName $group.DisplayName -Alias $group.Alias -PrimarySmtpAddress $group.PrimarySmtpAddress

    # Add members to the new group
    foreach ($memberEmail in $memberEmails) {
        Add-UnifiedGroupLinks -Identity $newGroup.Identity -LinkType Members -Links $memberEmail
    }
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline
