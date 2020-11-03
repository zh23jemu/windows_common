$sourceFolder = "G:\source\"
$destinationFolder = "G:\destination\"

$files = Get-ChildItem $sourceFolder
foreach ($item in $files)
{
    $username = ($item.BaseName -split "@")[0]
    $fullpath = $destinationFolder + $username + "\"

    New-Item -Path $fullpath -ItemType Directory
    Copy-Item $item.FullName -Destination $fullpath

    $NewAcl = Get-Acl -Path $fullpath
    # Set properties
    $identity = "csisolar.com\" + $username
    $fileSystemRights = "Modify"
    $type = "Allow"
    # Create new rule
    $fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
    $fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
    # Apply new rule
    $NewAcl.SetAccessRule($fileSystemAccessRule)
    Set-Acl -Path $fullpath -AclObject $NewAcl

    $username + " completed on " + (Get-Date -Format "MM/dd hh:mm") >> ("g:\log.txt")
}



