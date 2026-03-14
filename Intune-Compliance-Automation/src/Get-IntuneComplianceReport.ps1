<#
    REAL INTUNE COMPLIANCE REPORT SCRIPT
    ------------------------------------
    This script connects to Microsoft Graph and retrieves REAL Intune devices.
    It then generates:
    - IntuneComplianceReport.csv - All devices with compliance details
    - StaleDevices.csv - Devices that haven't synced for 30+ days

    Requirements:
    - Microsoft Graph PowerShell SDK installed
    - Intune Administrator or equivalent permissions
    - Azure AD account with DeviceManagementManagedDevices
#>

# ========================================
# 1. CONNECT TO MICROSOFT GRAPH
# ========================================
# This opens a login window. You must sign is with an account
# that has Intune permissions (Intune Administrator).

Connect-MgGraph -Scopes "DeviceManagementManagedDevice.Read.All" #Scope is the permnission ticket to see the managed device#

# ===========================================
# 2. GET REAL INTUNE MANAGED DEVICES
# ===========================================
# This command pulls All devices enrolled in Intune. 
# Each device contain fields like:
# - Device Name
# - OperatingSystem
# - ComplianceState
# - LastSyncDateTime
# - UserPrincipalName
# - DeviceID
# ============================================

$devices = Get-MgDeviceManagementManagedDevice

# ============================================
# 3. EXPORT FULL COMPLIANCE REPORT
# ============================================
# We select only the important fields and save them to a CSV. 
# This CSV can be used for audits, reporting, or  security checks. 
$devices |
    Select-Object DeviceName,
                  OperatingSystem,
                  ComplianceState,
                  LastSyncDateTime,
                  UserPrincipalName |
    Export-Csv "../Output/IntuneComplianceReport.csv" -NoTypeInformation

# =============================================

# 4. IDETIFY STALE DEVICES (NO SYNC FOR 30+ DAYS)
# =============================================
# Devices that haven't synced for 30+ days may be:
# - Lost
# - Stolen
# - Not receiving updates
# - Out of compliance
# =============================================

$staleDevices = $devices | Where-Object {
    $_.LastSyncDateTime -lt (Get-Date).AddDays(-30)
}
# Export stale devices to a separate CSV
$staleDevices | 
    Select-Object DeviceName,
                  OperatingSystem,
                  ComplianceState,
                  LastSyncDateTime,
                  UserPrincipalName |
    Export-Csv "../output/Staledevices.csv" -NoTypeInformation
# ==============================================
# 5. SHOW SUCCESS MESSAGES
# ==============================================

Write-Host "Real Intune compliance report generated."
Write-Host "Reale stale device report generated"

