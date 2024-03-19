# Connect to Exchange Online PowerShell
Connect-ExchangeOnline -Credential (Get-Credential)

# Import the CSV file
$csvPath = "C:\Path\To\GroupMembers.csv" # Update the path to your CSV file
$groupData = Import-Csv -Path $csvPath

# Loop through each row in the CSV and create Unified Groups and add members
foreach ($data in $groupData) {
    # Create Unified Group if it doesn't exist
    $group = Get-UnifiedGroup -Identity $data.GroupPrimarySmtpAddress -ErrorAction SilentlyContinue
    if (-not $group) {
        $group = New-UnifiedGroup -DisplayName $data.GroupDisplayName -Alias $data.GroupAlias -PrimarySmtpAddress $data.GroupPrimarySmtpAddress
    }

    # Add member to the Unified Group
    Add-UnifiedGroupLinks -Identity $data.GroupPrimarySmtpAddress -LinkType Members -Links $data.MemberEmail
}

# Disconnect from Exchange Online PowerShell
Disconnect-ExchangeOnline
