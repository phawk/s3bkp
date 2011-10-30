## Dependencies
This script relies on the [s3sync library for ruby](http://s3.amazonaws.com/ServEdge_pub/s3sync/README.txt). Asides from that, you will need an AWS account with S3 enabled and a server backups bucket setup in your S3 account.

## Installation
1. Open up server\_backup.sh and edit the configuration information.
2. Run `./.server_backup.sh` to test that it works.
3. You can now follow the steps below to automate your backups.

### Automate the backup process
It goes without saying that this process is pretty useless without being able to have your server automate it for you. This task is one for crontab, the example crontab below will run this script at 3am everyday.

```bash
crontab -e
0 3 * * * /home/user/s3bkp/server_backup.sh
```