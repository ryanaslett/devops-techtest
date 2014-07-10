Devops Test
===========

To verify that this is working:

add `127.0.0.1 devops.dev` to your /etc/hosts  
(I explored the possibility of automatically editing the local users host file with the https://github.com/cogitatio/vagrant-hostsupdater plugin, but that seemed overkill) 

vagrant up
point browser at http://devops.dev:8081 and login as admin/pass


## 1. Get something working immediately.
Started with most obvious command (vagrant up)  - It didnt work, so I fixed vagrantfile, commited fix.
Connect to bare VM. Cool. Now I can iterate.

## 2. Configure environment to work on Vagrantfiles and puppetfiles.
###Development environment setup:
* Installed textmate bundle and imported into phpstorm so I can have syntax highlighting in Vagrantfiles (http://confluence.jetbrains.com/display/PhpStorm/TextMate+Bundles+in+PhpStorm)
_Syntax highlighting was not working in my editor, so, using some Dtrace scripts, I figure out the expected location of the mappable color schemes, hack my IDE to expect them in the IDE’s applications folder, and open a ticket with the IDE vendor (http://youtrack.jetbrains.com/issue/WI-23914#)_  
  
  
* Debug all the things:  
`puppet.options = '--verbose --debug'`    
`export VAGRANT_LOG=debug`
  
  
* Manifest code quality
puppet-lint gem for checking code formatting.

## 3. Look at other projects for project structure, layout. Familiarize myself with what all the parts are - manifests, modules, hiera, Vagrantfiles, provisioners, providers etc.

Investigated other similar projects to explore their methodologies

Looked at these:

* https://www.drupal.org/project/undine
* https://www.drupal.org/project/drupal-up
* https://www.drupal.org/project/aegir_up
* http://www.kalamuna.com/news/introducing-kalabox

And already had these installed:

* https://puphpet.com/
* https://github.com/boxen

And found several other github projects, looking for best practices patterns from well followed repos, with many stars etc.

## 4. Determine which modules to reuse from puppetforge from the choices available:

_Which puppet modules to use?:_

__Apache:__
Dug around to sort out whether or not I want puppetlabs or example42’s apache module
Decided on puppetlabs apache module. As I didnt jive with example42’s dependencies on puppi, and it seemed like puphpet

__MySql:__
Obvious choice was obvious puppetlabs-mysql

__PHP:__
https://github.com/thias/puppet-php

__Drupal:__
Sort out whether or not I wanted to use binford2k-drupal - seemed to be the most robust.

__Drush:__
included in the binford2k-drupal module.

## 5. Add and configure the various modules enough to get drupal running

* Investigated how the providers and types were configured for drupal modules
* Set up  dependencies
* Tested configuraiton: while ($notworking == true) { google_problem(); apply_fix(); }
* Set up the Vagrantfile for some port mapping
* Added an ascii art graphic which revealed that Vagrant chops output into 16k segments. Sometimes even the fun becomes enlightening.

## 5. Future things I'd like to fix to improve

### Implement a better module strategies for including modules: 
Since puppet has a lot of modules available that have already solved the issues of CM for typical stuff like apache/php/mysql and even drupal, I wanted to leverage those modules.
Theres a couple of ways this could be accomplished - either keeping a copy of the module in the repo, or using a tool like puppet librarian, r10k, or even a shell provisioner that calls ‘puppet module’ and having a particular version of a module fetched and installed. 

Ideally it locks the version  such that every time vagrant up is run, you end up with identical module versions and do not have to worry about something breaking due to an upgrade.

I would probably lean towards rebuild it to use r10K for the puppetforge modules

Read the following blogs for info on r10k vs. puppet-librarian vs. git submodule strategies for more info on the most modern best practices regarding module management.

* http://somethingsinistral.net/blog/how-dynamic-environments-came-to-be/
* http://somethingsinistral.net/blog/scaling-puppet-environment-deployment/
* http://somethingsinistral.net/blog/rethinking-puppet-deployment/
* http://somethingsinistral.net/blog/git-submodules-are-probably-not-the-answer/

### Separating the code from the data:

Defintely would like to clean up the manifest files and get more of the data *out* of the manifest files and into hiera yaml. Functioning first, Elegance next.

* http://www.devco.net/archives/2013/12/09/the-problem-with-params-pp.php
* http://www.devco.net/archives/2013/12/08/better-puppet-modules-using-hiera-data.php
* http://garylarizza.com/blog/2013/12/08/when-to-hiera/
* http://ttboj.wordpress.com/2014/06/04/hiera-data-in-modules-and-os-independent-puppet/

### Improve the actual server configuration

Mysql/php/apache are not configured to be ideal for anything right now. Setting all the configuration variables to have a tuned, humming system would be nice, also be able to have different commandline args passed to vagrant to allow for a 'dev' state or production state machine with different configs (ie. which node to 'up')  Also do things like determine whether or not mysql database and files directory should be something that is persisted on the host system between installs.  

Also might want to look into splitting the configuration files up with the roles and profile methodology especially if this might work for more than type of server (http://www.craigdunn.org/2012/05/239/)


### Write tests to validate configuration

Finally, add rspec/cucumber tests to verify that this would work once there are options available (apc on or off, xhprof on or off)
