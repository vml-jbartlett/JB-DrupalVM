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
* A recent copy of the **Passport Production Database**
* A copy of your **Public SSH Key**


## Installation instructions

1. Create a fork in the [Passport Stash Repo](https://stash.vmlapps.com/projects/VML/repos/passport.vml.com/browse) and clone the site to your ~/Sites folder: `git clone ssh://git@stash.vmlapps.com/~STASH_USERNAME/passport.vml.com.git ~/Sites/passport.vml.com`

2. CD into your site folder: `cd ~/Sites/passport.vml.com`

3. Copy the example.local.config.yml and save as local.config.yml: `cp dvm/example.local.config.yml dvm/local.config.yml`

4. Edit the local.config.yml and update your **vml_username** (If your local isn't installed at ~/Sites/passport.vml.com, you will need to update these references as well.): `vi dvm/local.config.yml`

5. Install the following Vagrant plugins: 
```bash
vagrant plugin install vagrant-auto_network
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vbguest
```

6. Place your Passport database backup in the `dvm/backups` folder and it will update during the post-provision process. 
For instruction on how to get a recent copy of Passport's database, see the section on **Database Updating** below.

7. **Skip this step pending further testing** ~~Put a copy of your public key in the `/dvm/keys/public` folder: `cp ~/.ssh/id_rsa.pub ~/Sites/passport.vml.com/dvm/keys/public/`~~

8. Bring up Vagrant (This might take a while!): `vagrant up` 

8. Install your public key: `cat ~/.ssh/id_rsa.pub | ssh vagrant@10.20.10.10 'cat >> .ssh/authorized_keys'` The default password for user "vagrant" is "vagrant."

9. Once complete, open the dashboard at: [http://dashboard.local.passport.vml.com](http://dashboard.local.passport.vml.com). Your site should now be available at [https://local.passport.vml.com](https://local.passport.vml.com)

### Troubleshooting: 

If vagrant throws an error on `vagrant up`: 

* Try updating your Vagrant box: `vagrant box update` and run `vagrant up --provision`.
* Run `vagrant box list` to see if the "JoeBartlett/passport" exists. If it does, remove it with `vagrant box remove JoeBartlett/passport` then run `vagrant up` again.

If you get an "**ECDSA host key**" error, check your "known_host" file `sudo vi ~/.ssh/known_hosts` for instances of "local.passport.vml.com" - most likely at the bottom of the file. Remove the line and save the file. Then, run `vagrant up` again.


## Initial Database and File updates

### Drush Aliases

The site install should have added Drush aliases for the available Passport environments. They are as follows: 

* **@passport.local** - For your local VM, [https://local.passport.vml.com](https://local.passport.vml.com)
* **@passport.dev** - For the development site set up at [https://neoport.vmldev.com](https://neoport.vmldev.com)
* **@passport.stage** - For the staging site at [https://neoport.vmlstage.com](https://neoport.vmlstage.com)
* **@passport.prod** -  For the production site at [https://passport.vml.com](https://passport.vml.com). While this alias is set to work with the prod site, the alias is not currently usable as proxy access is not currently available for this server.

To use these, cd into the /htdocs folder (core Drupal file): `cd ~/Sites/passport.vml.com/htdocs` (or from anywhere if Drush is installed globally on your machine.) 
and run your Drush commands, e.g., `drush @passport.local status` .

It should noted that the proxies for dev/stage/prod are only available on the VML internal network and won't be accessible from outside without VPN access.

### Image and file syncing

Images and other files are updated automatically on your local through the [Stage File Proxy module](https://www.drupal.org/project/stage_file_proxy).

### Database updating

A recent version of the Passport DB is include within the current vagrant box at "JoeBartlett/passport." If your site launches without a database, run `vagrant reload --provision` to update your local repo to the most recent version.

To update your data to what is currently available on Production, download a recent backup by logging into the Passport Prod site and go to [Backup and Migrate](https://passport.vml.com/admin/config/system/backup_migrate).
From here, you can either generate a new backup or download a recent file from the "Saved backups" tab. (You will need Admin access to passport in order to do this.)

With the downloaded file, do one of the following tasks:

* Go to [Backup and Migrate](https://local.passport.vml.com/admin/config/system/backup_migrate) on your local site and restore the database with yourbackup file.
* Using Drush, sync from the SQL dump file with: `drush @passport.local sql-cli < ~/{Path-To_Backup}/Passport*.mysql.gz`
* Import the backup through other third party software (e.g.: Sequel Pro) using the SQL settings found on the [dashboard](http://dashboard.local.passport.vml.com).


## More on Drupal VM

More documentation on the [Drupal VM project](http://www.drupalvm.com) can be found at [http://docs.drupalvm.com/en/latest](http://docs.drupalvm.com/en/latest)
