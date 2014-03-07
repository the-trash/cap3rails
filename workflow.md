### Deploy tool config

Copy config file and change it

```sh
cp settings/production.yml.example settings/settings/production.yml
```

### Switch off capistrano/rvm hook

gem **capistrano/rvm** execute task **rvm:hook** before any capistrano task.

If RVM not installed on your server it can be problem for some tasks which not are required RVM.

Use following ENV variable to switch off **rvm:hook**.

```
RVM_HOOK=false
```

### Check for Disk Usage

check for ```.rvm``` and ```fetch(:deploy_to)``` folders and disk usage

```sh
RVM_HOOK=false cap production info:disk_usage
```

This task should to show size of user's folder with RVM and size of project's folder.

```sh
ERROR DIR NOT FOUND /var/www/megasite_owner/data/my-megasite.com
DEBUG [2f416e1f]  121M  .rvm
```

### RVM install for user

You can install RVM, RUBY and create project's GEMSET with following task.

```sh
RVM_HOOK=false cap production rvm:install:env
```

task based on following section in ```settings/production.yml```

```yml
configs:
  rvm:
    ruby:   ruby-2.0.0-p247
    gemset: cap3
```

### Copy ssh keys

Use following task to copy your public key to server

```sh
RVM_HOOK=false cap staging configs:keys
```

you will see following:

```sh
cat ~/.ssh/id_rsa.pub | ssh megasite_owner@my-megasite.com 'cat >> ~/.ssh/authorized_keys'
PASSWORD: MeGaSECretPassword1
```

just copy pass to command line prompt.

### ForwardAgent yes

```sh
vi ~/.ssh/config
```

```sh
ForwardAgent yes
```

```sh
ssh-add ~/.ssh/id_rsa
```

```sh
ssh-add -L
```

### Your DB should be exists

For successful deployment your database should be created. 

### Let's rock!

```sh
cap production deploy
```

### Nginx include for project

Nginx config for project will be copy into project's folder

Now you should include this config into NGINX.

Following task will help you

```sh
cap production nginx:config:include
```

you will see something like this

```sh
 INFO ******************************
 INFO NGINX INCLUDE
 WARN include /var/www/megasite_owner/data/my-megasite.com/shared/web_server/nginx/config;
 INFO ******************************
 WARN SUDO required
 INFO insert Nginx include into one of following files:
 INFO 1) into file: /etc/nginx/sites-available/USER_NAME.conf
 INFO 2) into file: /etc/nginx/nginx.conf
 INFO ******************************
 WARN DON'T FORGET TO RESTART NGINX!
```

### Nginx restart

If sudo params defined in ```settings/production.yml```

```sh
  defaults:
    ssh: &ssh_defaults
      password:
      auth_methods:
        - publickey
        - password
      forward_agent: true

    sudo:
      address: <%= domain %>
      ssh:
        <<: *ssh_defaults
        user: root
        password: MegaPaSSword123
```

you can restart NGINX with following task:

```sh
ROLES=sudo cap production nginx:configtest

ROLES=sudo cap production nginx:restart
```

### Remote rake and migrations

Do you need to run migration? No problems!

```sh
cap production remote_rake:task
```

**Please enter rake_task: |routes|**

```sh
db:migrate
```

use this task to execute any rake tasks on server