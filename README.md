## DOCKER
This is a docker project so the configuration only works when the containers are running.
This can be done by executing docker-compose up -d in the directory where the docker-compose.yml file is located.

## PROJECTS DIRECTORY
In this directory you can place your projects. All projects are in docker mounted under /var/www/html/

## WEBROOT
Every project should have a directory called: webroot. The apache virtualhost configuration will 
look automatically for that location. 

## URL
The url to reach your project should be as following: 
http://[projectname]:[portnr] The default port nummer in this configuration is 8001 so in that
case you only have to think about the projectname in the url:
http://[projectname]:8001

It can be that you have to add the hostname to your host systems /etc/hosts file. Together
with the ip of your container. In case of mac or windows that ip will not be the ip of your container
but of the virtual machine (like docker-machine on virtualbox) where your docker
environment is running in.

## PATH
So when entering http://[projectname]:8001 it will look in the docker web container for:
/var/www/html/[projectname]/webroot.

## EXAMPLE
The setup is included with a default project called 'web' so:
- startup the containers with docker-compose up in the location of docker-compose.yml
- add to your /etc/hosts file the line: 192.168.99.100 web
- go to http://web:8001 and you will see the site

## MAC OSX DOCKER-MACHINE
This docker setup is written on OSX on a mac. Because mac and windows don't run on the
linux kernel they need an extra layer for virtualisation. The setup should also work
on other environments then docker-machine but it might be that you need to make an adjustment
to your environment like configuring port forwarding.

When working with docker machine:
- First install docker toolbox which includes docker-machine: https://docs.docker.com/toolbox/overview
- Then create a virtual machine. This can be done with: docker-machine create default (where default is the name of the environment)
- Start your new environment: docker-machine start default
- Make your shell aware of your new enviornment: eval $(docker-machine env default)


## START THE CONTAINERS
- cd into this project to the same level as docker-compose.yml
- run: docker-compose up -d
- to find the name of the running container run: docker ps
- to login into a running container run: docker exec -it container_name /bin/bash

## CHANGING VHOST SETTINGS
The file dockerconfig/virtualhosts.conf is mounted into the docker system. So here you can
change the virtualhost configuration just by editing it on your host system.

Once modified, you have to login to the docker container and run:
service apache2 reload
Mind that if you do apache2 restart, your container will be shutdown and you have to
get it up again.

Other mounted files like virtualhosts.conf can be found in the docker-compose.yml file under volumes.
In the format: 
- /path/to/file/in/host/system:/path/to/file/in/container
So you can edit the file on your host system as specified left from the colon. And then
it is also changed in the location right from the colon.

## SSH
In general you should not use ssh to access the shell in your container. The
adviced way to acces that shell is:
docker exec -it exercises_web_1 /bin/bash

But when for some reason you want ssh acces to your container than you first
have to enabled it by running:
- /usr/sbin/sshd
in the container.

The username for ssh is configured in your dockerfile. In the default configuration it is:
username: root
password: develop

## XDEBUG SETTINGS PHP STORM
In phpstorm settings under languages -> php  add en interpreter.
In the newer phpstorm versions (at least 2017.02) you can select 'Docker Compose' for the remote connection to the
interpreter.

Server: Docker
Configuration file(s): /path/to/docker-compose.yml
Container: web

PHP Executable: /usr/local/bin/php

Debugger extension: /usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so

 
Under languages -> php -> debug. I've chosen port 9001. This is configured in:
dockerconfig/docker_php.ini which is mounted as the default php.ini file. (see the docker-compose)

Further xdebug settings can be found in the file: dockerconfig/20-xdebug.ini

For further informatioin about xdebug and phpstorm I can advise these urls:
https://www.youtube.com/watch?v=jDbF3UmV8jQ&list=PL7cMNPx-nzyiKmGE2A08S2PF5MKfBJF3n
https://serversforhackers.com/c/getting-xdebug-working

## XDEBUG PHPSTORM ADDING DEBUG CONFIGURATIONS
To debug we need a connection between docker and our browser or php interpreter.
Go to: Run -> Edit Configurations
We have to do this per project because each project have it's own url.

I advise to add a configuration of the type: PHP Web application. With this debug configuration you can start a debug 
session from docker. When you have created the configuration you can select it and press on the bug symbol.
Then docker automatically opens the browser and returns to PHPStorm as soon as it hits a breakpoint.

How to setup the debug configuration is explained here:
https://serversforhackers.com/c/getting-xdebug-working
and here: 
https://www.youtube.com/watch?v=OlcsQ8TCU3A&list=PL7cMNPx-nzyiKmGE2A08S2PF5MKfBJF3n&index=2

Two other options then 'PHP Web application' are:
* PHP Script: this one connect directly to the php interpreter without opening the browser. It sounds like a very nice
solution but in my setup it wanted to restart docker every time when running this debug configuration. The setup
and more explanations about this form can be found here:
https://www.youtube.com/watch?v=OlcsQ8TCU3A&list=PL7cMNPx-nzyiKmGE2A08S2PF5MKfBJF3n&index=2
* PHP Remote Debug: This one just listen to your browser. It's explained here:
https://serversforhackers.com/c/getting-xdebug-working


## PHP Code sniffer
For use from the container PHP Codesniffer is installed in the web container.
Login to the containers shell: docker exec -it exercises_web_1 /bin/bash
Run php sniffer for PSR2: phpcs --standard=PSR2 path/to/filename

To get PHP Codesniffer working on PHP Storm I didn't used the docker implementation
but installed it on my Mac and used it as a local resource for PHP Storm.

Therefore you have to set it up in two places in PHPStorm:
Under: Languages & Frameworks > PHP > Code Sniffer
And enable it under: Editor > Inspections > PHP > PHP Code Sniffer validation

### .gitignore.
Everything in the project directory is ignored. So you can have a seperate repository for
your project and for this docker configuration. 

The other way around: This docker project is designed as a seperate docker development
environment and is not specific for one project.

### PHPStorm included settings.
I didn' tested it fully but I have included some of the settings in the .idea directory
of this repository so it might be that things like the docker or the xdebug configuration
already work for you or can be imported to work.