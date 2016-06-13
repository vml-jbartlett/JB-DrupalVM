Installation Profile Instructions
=================================
###### **Updated:** _2016-06-13_


## Requirements

The basic tools needed to install this box are:

* **Vagrant** - [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)
* **VirtualBox** - [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
* **Ansible** - [https://valdhaus.co/writings/ansible-mac-osx](https://valdhaus.co/writings/ansible-mac-osx)
* **Drush** - [http://docs.drush.org/en/master/install-alternative](http://docs.drush.org/en/master/install-alternative)
* **Optional** - A recent copy of the [**%project_name% Production Database**] (See the section on "[Database Updating](#DB_Updates)" for more information.)


## Installation instructions

1. Create a fork in the [%project_name% Repo](%project_upstream_repo%) and clone the site to your ~/Sites folder: `git clone %project_origin_repo% ~/Sites/%production_url%`

2. CD into your site folder: `cd ~/Sites/%production_url%`

3. Copy the example.local.config.yml and save as local.config.yml: `cp dvm/example.local.config.yml dvm/local.config.yml`

4. Edit the local.config.yml and update your **ssh_username**: `vi/nano/your_pref_editor dvm/local.config.yml`

5. Install the following Vagrant plugins: `vagrant plugin install vagrant-auto_network vagrant-hostsupdater vagrant-share vagrant-vbguest vagrant-triggers`

6. If you have a recent database backup, place it in the `dvm/db_backups` folder and it will update during the post-provision process. For instruction on how to get a recent copy of the Production database, see the section on "[Database Updating](#DB_Updates)" below.

7. Bring up Vagrant (This might take a while!): `vagrant up` 

8. Install your public key: `cat ~/.ssh/id_rsa.pub | ssh vagrant@IP_SET_BY_VAGRANT 'cat >> .ssh/authorized_keys'` The default password for user "vagrant" is "vagrant."

9. Once complete, Vagrant will open the dashboard in your default browser - [http://dashboard.%vagrant_hostname%](http://dashboard.%vagrant_hostname%). Your site should now be available at [https://%vagrant_hostname%](https://%vagrant_hostname%)

### Troubleshooting: 

If vagrant throws an error on `vagrant up`: 

* Try updating your Vagrant box: `vagrant box update` and run `vagrant up --provision`.
* Run `vagrant box list` to see if the box "geerlingguy/ubuntu1404" exists. If it does, remove it with `vagrant box remove geerlingguy/ubuntu1404` then run `vagrant up` again.

If you get an "**ECDSA host key**" error, check your "known_host" file `sudo vi/nano/your_pref_editor ~/.ssh/known_hosts` for instances of "%vagrant_hostname%" - most likely at the bottom of the file. Remove the line and save the file. Then, run `vagrant up` again.


## Initial Database and File updates

### Drush Aliases

The site install should have added Drush aliases for the available environments. They are as follows: 

* **@%project_name%.local** - For your local VM, [https://%vagrant_hostname%](https://%vagrant_hostname%)
* **@%project_name%.stage** - For the staging site at [https://%stage.alias_uri%](https://%stage.alias_uri%)
* **@%project_name%.dev** - For the development site set up at [https://%dev.alias_uri%](https://%dev.alias_uri%)
* **@%project_name%.prod** -  For the production site at [https://%production_url%](https://%production_url%).

To use these, cd into the (core Drupal file): `cd %drupal_core_path%` (or from anywhere if Drush is installed globally on your machine.) and run your Drush commands, e.g., `drush @%project_name%.local status` .

### Image and file syncing

Images and other files are updated automatically on your local through the [Stage File Proxy module](https://www.drupal.org/project/stage_file_proxy).

### <a name="DB_Updates"></a> Database updating

Implementing a recent version of Production database is now a part of the initialization process of the Vagrant build. If your site launches without a database install or you wish to update your local with what is currently on production, follow the 

To update your data to what is currently available on Production, download a recent backup by logging into the %project_name% Prod site and go to [Backup and Migrate](https://%production_url%/admin/config/system/backup_migrate).
From here, you can either generate a new backup or download a recent file from the "Saved backups" tab. (You will need Admin access to %project_name% in order to do this.)

With the downloaded file, do one of the following tasks:

* Go to [Backup and Migrate](https://%vagrant_hostname%/admin/config/system/backup_migrate) on your local site and restore the database with your backup file.
* Using Drush, sync from the SQL dump file with: `drush @%project_name%.local sql-cli < %vagrant_local_path%/*.mysql.gz`
* Import the backup through other third party software (e.g.: Sequel Pro) using the SQL settings found on the [dashboard](http://dashboard.%vagrant_hostname%).


## More on Drupal VM

More documentation on the [Drupal VM project](http://www.drupalvm.com) can be found at [http://docs.drupalvm.com/en/latest](http://docs.drupalvm.com/en/latest)
