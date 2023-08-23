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

# All
$MgDeviceAppManagementMobileApp = Get-MgDeviceAppManagementMobileApp -All -Property Assignments -ExpandProperty Assignments
$MgDeviceAppManagementMobileApp | ConvertTo-Json -Depth 4 | Out-File '.\MgDeviceAppManagementMobileApp.json' -Force

# Filtered
$MgDeviceAppManagementMobileAppFiltered = $MgDeviceAppManagementMobileApp | Where-Object { $_.AdditionalProperties.'@odata.type' -in $ODataType }
$MgDeviceAppManagementMobileAppFiltered | ConvertTo-Json -Depth 4 | Out-File '.\MgDeviceAppManagementMobileApp.filtered.json' -Force

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
$MgDeviceAppManagementMobileAppFilteredFlat | Export-Csv '.\MgDeviceAppManagementMobileApp.filtered.csv' -UseCulture -Encoding utf8 -NoTypeInformation -Force
$MgDeviceAppManagementMobileAppFilteredFlat | Where-Object { $_.'Assignments.Intent' -eq 'required' } | Export-Csv '.\MgDeviceAppManagementMobileApp.filtered.required.csv' -UseCulture -Encoding utf8 -NoTypeInformation -Force
$MgDeviceAppManagementMobileAppFilteredFlat | Where-Object { $_.'Assignments.Intent' -eq 'required' -and $_.'AdditionalProperties.@odata.type' -eq '#microsoft.graph.winGetApp' } | Export-Csv '.\MgDeviceAppManagementMobileApp.filtered.required.winGetApp.csv' -UseCulture -Encoding utf8 -NoTypeInformation -Force
$MgDeviceAppManagementMobileAppFilteredFlat | Where-Object { $_.'Assignments.Intent' -eq 'required' -and $_.'AdditionalProperties.@odata.type' -eq '#microsoft.graph.win32LobApp' } | Export-Csv '.\MgDeviceAppManagementMobileApp.filtered.required.win32LobApp.csv' -UseCulture -Encoding utf8 -NoTypeInformation -Force
