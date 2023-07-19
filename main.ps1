$ServerName = "SQLServer"
$DatabaseName = "DatabaseName"
$TableName = "EmployeesTable"
$Username = "username"
$Password = "password"


$ExchangeServer = "ExchangeServer"
$DatabaseName = "MailboxDatabase01"
$OU = "OU=Employees,DC=your domain,DC=your domain name extension(com, ir, net, ...)"


$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server=$ServerName;Database=$DatabaseName;User ID=$Username;Password=$Password;"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = "SELECT Name, Password FROM $TableName"
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$SqlConnection.Close()


foreach ($Row in $DataSet.Tables[0].Rows) {
    $Name = $Row["Name"]
    $Password = $Row["Password"]

    $FirstName = $Name.Split(" ")[0]
    $LastName = $Name.Split(" ")[1]
    $Alias = $FirstName.ToLower() + "." + $LastName.ToLower()

    $UPN = "$Alias@domain name"
    $PrimarySMTPAddress = "$Alias@domain name"
    $DisplayName = $Name

    New-Mailbox -Name $Name -Alias $Alias -UserPrincipalName $UPN -OrganizationalUnit $OU -Database $DatabaseName -Password (ConvertTo-SecureString $Password -AsPlainText -Force) -ResetPasswordOnNextLogon $false -DisplayName $DisplayName -PrimarySmtpAddress $PrimarySMTPAddress -Server $ExchangeServer
}