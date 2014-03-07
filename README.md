# Cap3 standalone deploy tool

#### Why?

1. I want to keep it separately. Keep deploy tool in rails app it's not best idea
2. I want to have independent deploy tool for many rails apps
3. I want to restrict access to deploy tool in team. Juniors shouldn't touch it.
4. It's should be easy to maintain and improve
5. It's should be base for branches: **cap3node**, **cap3django**, **cap3php** etc.

#### How to use?

1. Clone cap3rails
2. Copy config file
```
cp settings/production.yml.example settings/production.yml
```
3. Puts your settings in config file
4. ```cap production deploy```
5. Include App nginx config into your main nginx config
```
include /var/www/USER/data/www/MY_APP/shared/web_server/nginx/config;
```
6. restart nginx ```cap production nginx:restart```
7. Profit!!!

#### Who in the box?

1. **Settingslogic** for config files
2. **Nginx**, **Unicorn** config templates
3. Only **production** stage
4. Ready for small projects, but not for giants

#### Status of repo

It's a draft. It's need a lot of work, but it'a alive! You can try it.

#### Plans

1. To improve Unicorn configs
2. To add **Monit** configs
3. To add **Puma** templates
3. To drink tea with piece of chocolate
4. To take over the world

# Workflow

#### Access to server

Check acceess to server

```ssh root@my-mega-project.com```

```ssh deployer@my-mega-project.com```

#### Generate your public key

[How to](https://help.github.com/articles/generating-ssh-keys)

#### Authorize your key on server

```sh
cat ~/.ssh/id_rsa.pub | ssh deployer@my-mega-project.com 'cat >> ~/.ssh/authorized_keys'
```

#### Let's play!

```sh
cap ENV_NAME TASK_NAME
```

For example:

```sh
cap production info:image_magick
```

```sh
cap production info:gemset
```

#### Deploy your App

```sh
cap production deploy
```

#### Extend your nginx config with:

```
include /var/www/USER/data/www/MY_APP/shared/web_server/nginx/config;
```

#### Nginx restart

```sh
cap production nginx:restart
```

#### Destroy App

Is it ugly? Just destroy it!

Stop Unicorn and destroy.

```sh
cap production destroy:soft
```

or destroy file structure right now!

```sh
cap production destroy:hard
```

# Caps

### Apocalypse is here!

```
cap production deploy:rollback
```

### WebServer commands

```sh
cap production -vT | grep web_server

cap web_server:force
cap web_server:force-stop
cap web_server:restart
cap web_server:start
cap web_server:stop
```

it's mean that you should to execute:

```sh
cap production web_server:restart
```

### Nginx commands

```sh
cap -vT | grep nginx
```

### Info commands

```sh
cap -vT | grep info
```

### The MIT License (MIT)

Copyright (c) [2013] [Ilya N. Zykin, github/the-teacher]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.