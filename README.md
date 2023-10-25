# Veeam Tape Media Pool Monitoring Script

A PowerShell script to monitor tape numbers in a Veeam tape media pool and generate Nagios-compatible status messages based on user-defined warning and critical thresholds.

## Usage

```powershell
.\veeam_media_pool.ps1 -poolName "PoolName" -warningThreshold [WarningThreshold] -criticalThreshold [CriticalThreshold]

## Prerequisites
Veeam PowerShell Module must be installed.

## Author
Author: Diego Pastore
Email: stufo76@gmail.com

## License
This script is licensed under the GNU General Public License (GPL) version 3.0.

## Notes
File Name: veeam_media_pool.ps1
Script Version: 1.0
