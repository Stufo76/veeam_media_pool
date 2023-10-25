<#
.SYNOPSIS
A PowerShell script to monitor tape numbers in a Veeam tape media pool and generate Nagios-compatible status messages based on user-defined warning and critical thresholds.

.DESCRIPTION
This script checks the number of all tapes within the specified Veeam tape media pool and generates appropriate status messages. It can be integrated into Nagios for monitoring and alerting purposes.

.PARAMETER poolName
    Name of the Veeam tape media pool to monitor.

.PARAMETER warningThreshold
    Warning threshold for the number of tapes in the pool. If the count falls below this threshold, a WARNING status is generated.

.PARAMETER criticalThreshold
    Critical threshold for the number of tapes in the pool. If the count falls below this threshold, a CRITICAL status is generated.

.NOTES
    File Name      : veeam_media_pool.ps1
    Script Version : 1.0
    Prerequisite   : Veeam PowerShell Module must be installed
    Author: Diego Pastore
    Email: stufo76@gmail.com
    GitHub Profile: [GitHub Profile](https://github.com/Stufo76)
    License        : [GNU General Public License (GPL) version 3.0](https://www.gnu.org/licenses/gpl-3.0.html)
#>

param (
    [string]$poolName,               # Name of the Veeam tape media pool to monitor
    [int]$warningThreshold,         # Warning threshold for the number of tapes in the pool
    [int]$criticalThreshold         # Critical threshold for the number of tapes in the pool
)

$poolName = $poolName.Trim('"')  # Remove extra double quotes if present

# Check if required parameters are missing or not properly specified
if (-not $poolName -or -not $warningThreshold -or -not $criticalThreshold) {
    Write-Host "UNKNOWN: Missing or improperly specified parameters."
    Write-Host "Usage: .\veeam_media_pool.ps1 -poolName ""PoolName"" -warningThreshold [WarningThreshold] -criticalThreshold [CriticalThreshold]"
    exit 3
}

# Check if the critical threshold is greater than the warning threshold
if ($criticalThreshold -gt $warningThreshold) {
    Write-Host "UNKNOWN: Critical threshold must be less or equal than the warning threshold."
    Write-Host "Usage: .\veeam_media_pool.ps1 -poolName ""PoolName"" -warningThreshold [WarningThreshold] -criticalThreshold [CriticalThreshold]"
    exit 3
}

# Function to check the status of all tapes in the pool and generate appropriate status messages
function CheckTapeStatus {
    try {
        $poolInfo = Get-VBRTapeMediaPool | Where-Object { $_.Name -eq $poolName }
        if ($poolInfo -eq $null) {
            Write-Host "UNKNOWN: The pool ""$poolName"" does not exist."
            exit 3
        }

        $tapeCount = $poolInfo.Medium.Count

        if ($tapeCount -lt $criticalThreshold) {
            Write-Host ("CRITICAL: Number of tapes in the pool """ + $poolName + """: " + $tapeCount + " is less than the critical threshold: " + $criticalThreshold + " | tape_count=" + $tapeCount)
            exit 2
        } elseif ($tapeCount -lt $warningThreshold) {
            Write-Host ("WARNING: Number of tapes in the pool """ + $poolName + """: " + $tapeCount + " is less than the warning threshold: " + $warningThreshold + " | tape_count=" + $tapeCount)
            exit 1
        } else {
            Write-Host ("OK: Number of tapes in the pool """ + $poolName + """: " + $tapeCount + " | tape_count=" + $tapeCount)
            exit 0
        }
    } catch {
        Write-Host ("CRITICAL: Unable to retrieve information about the ""$poolName"" pool - Error: $_")
        exit 2
    }
}

# Call the monitoring function
CheckTapeStatus
