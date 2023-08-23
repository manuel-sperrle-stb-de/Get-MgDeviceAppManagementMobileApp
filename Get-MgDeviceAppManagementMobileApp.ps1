param (

    $ODataType = @(
        '#microsoft.graph.winGetApp'
        '#microsoft.graph.win32LobApp'
    )

)

$ConnectMgGraphParams = @{
    Scopes = @(
        'DeviceManagementApps.Read.All'
    )
}

# Connect
Select-MgProfile -Name beta
Connect-MgGraph @ConnectMgGraphParams

$PSDefaultParameterValues['*:Encoding']='utf8'
$PSDefaultParameterValues['*:UseCulture']=$true
$PSDefaultParameterValues['*:NoTypeInformation']=$true
$PSDefaultParameterValues['Export*:Force']=$true
$PSDefaultParameterValues['Out-File:Force']=$true

# All
$MgDeviceAppManagementMobileApp = Get-MgDeviceAppManagementMobileApp -All -Property Assignments -ExpandProperty Assignments
$MgDeviceAppManagementMobileApp | ConvertTo-Json -Depth 4 | Out-File '.\MgDeviceAppManagementMobileApp.json'

# Filtered
$MgDeviceAppManagementMobileAppFiltered = $MgDeviceAppManagementMobileApp | Where-Object { $_.AdditionalProperties.'@odata.type' -in $ODataType }
$MgDeviceAppManagementMobileAppFiltered | ConvertTo-Json -Depth 4 | Out-File '.\MgDeviceAppManagementMobileApp.filtered.json'

# Filterered Flat
$SelectObjectParams = @{

    Property = @(

        'Id'
        'DisplayName'

        @{
            n = 'Assignments.Intent'
            e = { $_.Assignments.Intent }
        }

        @{
            n = 'AdditionalProperties.@odata.type'
            e = { $_.AdditionalProperties.'@odata.type' }
        }

        @{
            n = 'AdditionalProperties.packageIdentifier'
            e = { $_.AdditionalProperties.packageIdentifier }
        }
        @{
            n = 'AdditionalProperties.installExperience.runAsAccount'
            e = { $_.AdditionalProperties.installExperience.runAsAccount }
        }

    )

}

$MgDeviceAppManagementMobileAppFilteredFlat = $MgDeviceAppManagementMobileAppFiltered | Select-Object @SelectObjectParams
$MgDeviceAppManagementMobileAppFilteredFlat | Export-Csv '.\MgDeviceAppManagementMobileApp.filtered.csv'
$MgDeviceAppManagementMobileAppFilteredFlat | Where-Object { $_.'AdditionalProperties.@odata.type' -eq '#microsoft.graph.winGetApp' } | Export-Csv '.\MgDeviceAppManagementMobileApp.filtered.winGetApp.csv'
$MgDeviceAppManagementMobileAppFilteredFlat | Where-Object { $_.'AdditionalProperties.@odata.type' -eq '#microsoft.graph.win32LobApp' } | Export-Csv '.\MgDeviceAppManagementMobileApp.filtered.win32LobApp.csv'

$MgDeviceAppManagementMobileAppFilteredFlat | Where-Object { $_.'Assignments.Intent' -eq 'required' } | Export-Csv '.\MgDeviceAppManagementMobileApp.filtered.required.csv'
$MgDeviceAppManagementMobileAppFilteredFlat | Where-Object { $_.'Assignments.Intent' -eq 'required' -and $_.'AdditionalProperties.@odata.type' -eq '#microsoft.graph.winGetApp' } | Export-Csv '.\MgDeviceAppManagementMobileApp.filtered.required.winGetApp.csv'
$MgDeviceAppManagementMobileAppFilteredFlat | Where-Object { $_.'Assignments.Intent' -eq 'required' -and $_.'AdditionalProperties.@odata.type' -eq '#microsoft.graph.win32LobApp' } | Export-Csv '.\MgDeviceAppManagementMobileApp.filtered.required.win32LobApp.csv'
