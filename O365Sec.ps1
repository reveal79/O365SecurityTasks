# Import necessary modules
Import-Module AzureAD

# Function to reset user
function Reset-AzureADUser {
    param(
        [Parameter(Mandatory=$true)]
        [string]$userPrincipalName
    )

    # Check if user exists
    try {
        $user = Get-AzureADUser -ObjectId $userPrincipalName
    }
    catch {
        Write-Host "User not found: $_"
        return
    }

    # Generate random password
    Add-Type -AssemblyName System.Web
    $randomPassword1 = [System.Web.Security.Membership]::GeneratePassword(10, 2)
    $randomPassword2 = [System.Web.Security.Membership]::GeneratePassword(10, 2)
    $newPassword1 = ConvertTo-SecureString $randomPassword1 -AsPlainText -Force
    $newPassword2 = ConvertTo-SecureString $randomPassword2 -AsPlainText -Force

    # Set first password
    try {
        Set-AzureADUserPassword -ObjectId $userPrincipalName -Password $newPassword1
        Write-Host "First password reset successful"
    }
    catch {
        Write-Host "Error resetting first password: $_"
        return
    }

    # Wait a moment before changing password again
    Start-Sleep -s 5

    # Set second password
    try {
        Set-AzureADUserPassword -ObjectId $userPrincipalName -Password $newPassword2
        Write-Host "Second password reset successful"
    }
    catch {
        Write-Host "Error resetting second password: $_"
        return
    }

    # Block sign-in
    try {
        Set-AzureADUser -ObjectId $userPrincipalName -AccountEnabled $false
        Write-Host "Sign-in block successful"
    }
    catch {
        Write-Host "Error blocking sign-in: $_"
        return
    }

    # Revoke all sessions
    try {
        Revoke-AzureADUserAllRefreshToken -ObjectId $userPrincipalName
        Write-Host "All sessions revoked successfully"
    }
    catch {
        Write-Host "Error revoking sessions: $_"
        return
    }
}

# Connect to Azure AD
Connect-AzureAD

# User reset loop
do {
    # User information
    $userPrincipalName = Read-Host -Prompt 'Input the email address of the user you want to reset'
    Reset-AzureADUser -userPrincipalName $userPrincipalName

    $resetAnother = Read-Host -Prompt 'Do you want to reset another user? (yes/no)'
} while ($resetAnother -eq 'yes')

# Disconnect from Azure AD
Disconnect-AzureAD
