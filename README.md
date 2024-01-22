# Remove-RemoteRecycleBinItem

Powershell. Remove a single item from a remote users Recycle Bin

Connects to a remote machine and removes a specific item from the $Recyle.Bin contents

Uses file names that are not the original file names from the Recycle Bin, but the metadata names ($RZYZ72E etc

You'll need to use Get-RemoteRecycleBin to ascertain which file you are trying to delete

---

**Parameters**

_user_

The SamAccountName of the users recycle bin that you are trying to retrieve

_computer_

The host name of the computer that holds the recycele bin that you are trying to retrieve

_file_

The file name that you are trying to delete.  Don't provide the leading $

---

**Examples**

Remove-RemoteRecycleBinItem -user newman -computer apartment5E -file 'RZYZ72E.txt'
