param( [Parameter(Mandatory=$true)] $JSONFile)

function CreateADGroup(){
    param( [Parameter(Mandatory=$true)] $groupObject )

    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global
}

function CreateADUser() {
    param (
        [Parameter(Mandatory=$true)]
        $userObject
    )
    #Pull out name from JSON object
    $name = $userObject.name
    $password = $userObject.password

    # Generate a "first inital, last name" structure for username
    $firstname, $lastname = $name.Split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $samAccountName = $username
    $principalname = $username
    
    #Actually creates the AD user object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

    #adds users to appropriate group BUT does not validate/check to see if group exists...
    foreach($group_name in $userObject.groups) {

        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }
            catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
            {
            Write-Warning "Whooops User $name NOT added to group $group_name because object not found"
            }
    }
}



$json = (Get-Content $JSONFile | ConvertFrom-JSON)

$Global:Domain = $json.domain

foreach ( $group in $json.groups ){
    CreateADGroup $group
}

foreach ( $user in $json.users ){
    createADUser $user
}