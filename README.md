# TODO 
- Update instructions for generics
- Add startup instructions for building from a blank box
- Build docs (possibly in MKDocs)



Installation Profile Instructions
=================================
###### **Updated:** _2016-05-26_


## Requirements

The basic tools needed to install this box are:

* **Vagrant** - [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)
* **VirtualBox** - [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
* **Ansible** - [https://valdhaus.co/writings/ansible-mac-osx](https://valdhaus.co/writings/ansible-mac-osx)
* **Drush** - [http://docs.drush.org/en/master/install-alternative](http://docs.drush.org/en/master/install-alternative)
* A recent copy of the **%project_name% Production Database**
* A copy of your **Public SSH Key**


## Installation instructions

1. Create a fork in the [%project_name% Repo](%project_upstream_repo%) and clone the site to your ~/Sites folder: `git clone %project_origin_repo% ~/Sites/%production_url%`

2. CD into your site folder: `cd ~/Sites/%production_url%`

3. Copy the example.local.config.yml and save as local.config.yml: `cp dvm/example.local.config.yml dvm/local.config.yml`

4. Edit the local.config.yml and update your **ssh_username** (If your local isn't installed at ~/Sites/%production_url%, you will need to update these references as well.): `vi dvm/local.config.yml`

5. Install the following Vagrant plugins: 
```bash
vagrant plugin install vagrant-auto_network
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vbguest
```

6. Place your %project_name% database backup in the `dvm/backups` folder and it will update during the post-provision process. 
For instruction on how to get a recent copy of %project_name%'s database, see the section on **Database Updating** below.

7. **Skip this step pending further testing** ~~Put a copy of your public key in the `/dvm/keys/public` folder: `cp ~/.ssh/id_rsa.pub ~/Sites/%production_url%/dvm/keys/public/`~~

8. Bring up Vagrant (This might take a while!): `vagrant up` 

8. Install your public key: `cat ~/.ssh/id_rsa.pub | ssh vagrant@%vagrant_ip% 'cat >> .ssh/authorized_keys'` The default password for user "vagrant" is "vagrant."

9. Once complete, open the dashboard at: [http://dashboard.%vagrant_hostname%](http://dashboard.%vagrant_hostname%). Your site should now be available at [https://%vagrant_hostname%](https://%vagrant_hostname%)

### Troubleshooting: 

If vagrant throws an error on `vagrant up`: 

* Try updating your Vagrant box: `vagrant box update` and run `vagrant up --provision`.
* Run `vagrant box list` to see if the "%vagrant_box%" exists. If it does, remove it with `vagrant box remove %vagrant_box%` then run `vagrant up` again.

If you get an "**ECDSA host key**" error, check your "known_host" file `sudo vi ~/.ssh/known_hosts` for instances of "%vagrant_hostname%" - most likely at the bottom of the file. Remove the line and save the file. Then, run `vagrant up` again.


## Initial Database and File updates

### Drush Aliases

The site install should have added Drush aliases for the available %project_name% environments. They are as follows: 

* **@%project_name%.local** - For your local VM, [https://%vagrant_hostname%](https://%vagrant_hostname%)
* **@%project_name%.dev** - For the development site set up at [https://%dev.alias_uri%](https://%dev.alias_uri%)
* **@%project_name%.stage** - For the staging site at [https://%stage.alias_uri%](https://%stage.alias_uri%)
* **@%project_name%.prod** -  For the production site at [https://%production_url%](https://%production_url%). While this alias is set to work with the prod site, the alias is not currently usable as proxy access is not currently available for this server.

To use these, cd into the (core Drupal file): `cd %drupal_core_path%` (or from anywhere if Drush is installed globally on your machine.) 
and run your Drush commands, e.g., `drush @%project_name%.local status` .

### Image and file syncing

Images and other files are updated automatically on your local through the [Stage File Proxy module](https://www.drupal.org/project/stage_file_proxy).

### Database updating

A recent version of the %project_name% DB is include within the current vagrant box at "%custom_vagrant_box%." If your site launches without a database, run `vagrant reload --provision` to update your local repo to the most recent version.

To update your data to what is currently available on Production, download a recent backup by logging into the %project_name% Prod site and go to [Backup and Migrate](https://%production_url%/admin/config/system/backup_migrate).
From here, you can either generate a new backup or download a recent file from the "Saved backups" tab. (You will need Admin access to %project_name% in order to do this.)

With the downloaded file, do one of the following tasks:

* Go to [Backup and Migrate](https://%vagrant_hostname%/admin/config/system/backup_migrate) on your local site and restore the database with your backup file.
* Using Drush, sync from the SQL dump file with: `drush @%project_name%.local sql-cli < %vagrant_local_path%/%project_name%*.mysql.gz`
* Import the backup through other third party software (e.g.: Sequel Pro) using the SQL settings found on the [dashboard](http://dashboard.%vagrant_hostname%).


## More on Drupal VM

More documentation on the [Drupal VM project](http://www.drupalvm.com) can be found at [http://docs.drupalvm.com/en/latest](http://docs.drupalvm.com/en/latest)
