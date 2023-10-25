# Veeam Tape Media Pool Monitoring Script

A PowerShell script to monitor tape numbers in a Veeam tape media pool and generate Nagios-compatible status messages based on user-defined warning and critical thresholds.

## Usage

```powershell
.\veeam_media_pool.ps1 -poolName "PoolName" -warningThreshold [WarningThreshold] -criticalThreshold [CriticalThreshold]
