# Dropbox Server Backup

Guide to backup your server's sensitive data to Dropbox, using AndreaFabrizi's Dropbox Uploader script

## Steps

### Choose directory

In this example we're running everything as `root` and placing all the scripts in `/root/backups/`. Preferably run as any other user.

    mkdir backups
    cd backups

### Install Dropbox Uploader
Dropbox uploader uses different configuration files per user. It will have to be installed for any user you may need it for.

    # download
    curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh

    # make executable
    chmod 744 dropbox_uploader.sh

    # run
    ./dropbox_uploader.sh

    # follow on screen steps to finish installation

### Test
After installing the application you can upload a test file and checking in your Dropbox account if it has successfully uploaded.

    touch test.txt
    ./dropbox_uploader.sh upload test.txt test--received.txt

### Setup a backup script
- Here are two very similar scripts that will backup your MySQL database or directories.
- Grab the script you'd like to use and update all the brackets with your own information
- Notice that there's a `CONFIG_FILE` variable. This is the `.dropbox_uploader` file generated by Dropbox Uploader upon installation. It is placed in the user's home folder. For root this would be `/root/.dropbox_uploader`.
- Make executable
- Run to check if it's working

### Log backups to a database
This latest version incorporates backups to be logged into a database with the following structure:

    +---------------+--------------+------+-----+-------------------+----------------+
    | Field         | Type         | Null | Key | Default           | Extra          |
    +---------------+--------------+------+-----+-------------------+----------------+
    | id            | int(11)      | NO   | PRI | NULL              | auto_increment |
    | backup_date   | timestamp    | NO   |     | CURRENT_TIMESTAMP |                |
    | backup_name   | varchar(64)  | NO   |     | NULL              |                |
    | backup_status | varchar(64)  | NO   |     | NULL              |                |
    +---------------+--------------+------+-----+-------------------+----------------+

To create it, run:

    CREATE TABLE my_table (
        id int NOT NULL AUTO_INCREMENT,
        backup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        backup_name varchar(64) NOT NULL,
        backup_status varchar(64) NOT NULL,
        PRIMARY KEY (id)
    );

This will be particularly useful for scripts that have been added to cron jobs. The database entry will be updated as the script progresses, thus resulting in entries that are either "Failed" or "Done". This data can then be displayed in a custom page for easy access.

### Add to cronjob
- [How Do I Setup a Cron Job (in the Command Line)](http://askubuntu.com/questions/2368/how-do-i-set-up-a-cron-job)
- [Using Webmin](http://www.htpcbeginner.com/create-cron-job-with-webmin/)

## Resources
- [Dropbox Uploader](http://github.com/andreafabrizi/Dropbox-Uploader)
- [Simple Linux Backup to Dropbox](http://www.howopensource.com/2014/09/simple-linux-backup-to-dropbox/)
- [Handling Errors and Exceptions in Bash](http://linuxcommand.org/wss0150.php)
- [How to Check Exit Status of Pipe Command](http://scratching.psybermonkey.net/2011/01/bash-how-to-check-exit-status-of-pipe.html)
