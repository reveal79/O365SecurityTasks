# O365SecurityTasks
A PowerShell script for Azure AD account management, capable of resetting user passwords, disabling accounts, and revoking sessions. Ideal for IT admins dealing with compromised accounts or needing to manage account access swiftly.

It resets the password twice to mitigate the pass-the-hash type of attacks and to kill the sessions and blocks sign in so when it prompts to login they can't because the password was invalidated twice.
