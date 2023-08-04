# O365SecurityTasks
A PowerShell script for Azure AD account management, capable of resetting user passwords, disabling accounts, and revoking sessions. Ideal for IT admins dealing with compromised accounts or needing to manage account access swiftly.


This PowerShell script is designed to reset and disable user accounts in Azure Active Directory (Azure AD). Here's a rundown of its functionality:

Import AzureAD module: The script begins by importing the AzureAD module, which provides the cmdlets necessary to interact with Azure Active Directory.

Function Reset-AzureADUser: The main function of this script takes one mandatory parameter, the User Principal Name (UPN), and performs the following steps:

Checks if the specified user exists in Azure AD. If the user doesn't exist, the function exits.

Generates two random passwords. The script uses .NET's System.Web.Security.Membership class to create these passwords.

Tries to reset the user's password twice, waiting for 5 seconds between attempts. This dual reset could be a method of ensuring the password change is processed or to fulfill a security policy requirement. Errors in resetting the password will result in a message and function exit.

Tries to block the user's sign-in by disabling their account in Azure AD. If an error occurs, it outputs an error message and exits the function.

Attempts to revoke all the user's sessions by invalidating their refresh tokens. Any errors result in a message and function exit.

Connect to Azure AD: After defining the function, the script connects to Azure AD using the Connect-AzureAD cmdlet.

User reset loop: It then enters a loop where it asks for a user's email (UPN) to reset. After each user reset, it asks if the user wants to reset another user account. The loop continues until the user chooses not to reset another account.

Disconnect from Azure AD: Once the loop ends, the script disconnects from Azure AD using the Disconnect-AzureAD cmdlet.

This script could be useful for IT administrators who need to quickly reset, disable, and revoke sessions for Azure AD user accounts, such as when dealing with compromised accounts.
