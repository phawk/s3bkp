## Installation
Open up server\_backup.sh and edit the configuration information.

### Automate the backup process
It goes without saying that this process is pretty useless without being able to have your server automate it for you. This task is one for crontab, the example crontab below will run this script at 3am everyday.

```bash
crontab -e
* 3 * * * /home/phawk/s3bkp/server_backup.sh
```