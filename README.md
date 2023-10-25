# Veeam Tape Media Pool Monitoring Script

A PowerShell script to monitor tape numbers in a Veeam tape media pool and generate Nagios-compatible status messages based on user-defined warning and critical thresholds.

## Author

Diego Pastore stufo76@gmail.com

## License

This script is licensed under the GNU General Public License (GPL) version 3.0.

## Prerequisites

Before using this script, make sure you have the following prerequisites:

- Veeam PowerShell Module
- Nagios Monitoring System
- NCPA Agent on target host

## Parameters

You can customize the behavior of the script using the following parameters:

- -poolName (string): Name of the Veeam tape media pool to monitor.
- -warningThreshold (int): Warning threshold for the number of tapes in the pool. If the count falls below this threshold, a WARNING status is generated.
- -criticalThreshold (int): Critical threshold for the number of tapes in the pool. If the count falls below this threshold, a CRITICAL status is generated.

## Usage

This script can be integrated into Nagios for monitoring and alerting purposes. You can use it with the Nagios Cross-Platform Agent (NCPA) for active checks. Follow these steps to set up the script with NCPA:

### Integrating with Nagios using NCPA

1. Install and Configure NCPA on the Target Host:

   Ensure that NCPA is correctly installed and configured on the server where the script is located.

2. Upload veeam_media_pool.ps1 in Plugin NCPA folder (usually `%PROGRAMFILES(X86)%\Nagios\NCPA\plugins`)
   
3. Configure NCPA on the Target Host:

    Make sure that the NCPA agent on the target server is set up to execute powershell script and has the necessary permissions.

4. Define the Nagios Service Check:
   
   In your Nagios configuration (e.g., services.cfg), define a service check that uses the NCPA plugin to run the script.

   Here's an example configuration:

    ```
    define service {
        use generic-service
        host_name your_target_host
        service_description Veeam Media Pool
        check_command check_ncpa!-M 'plugins/veeam_media_pool.ps1' -a '-poolName "YourPoolName" -warningThreshold 10 -criticalThreshold 5'
    }
    ```

    - your_target_host: Replace this with the hostname of the server where the NCPA agent is running.
    - -M 'plugins/veeam_media_pool.ps1': Specifies the NCPA plugin to run the script.
    - -a: Pass the script's arguments (poolName, warningThreshold, criticalThreshold).

6. Restart Nagios:

    After defining the service check, restart Nagios to apply the changes.

7. Run the Script:

    The NCPA agent on the target host will execute the script as defined in the service check.

8. View the Results in Nagios:

    Nagios will process the results from the NCPA agent and display the status of the Veeam Media Pool check in the Nagios web interface.

Ensure that the NCPA agent is correctly configured on the target host and has access to the script and necessary permissions. The script will be executed by NCPA, and Nagios will report the results based on the script's output.
