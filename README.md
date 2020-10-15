# Nextcloud development environment

This docker configuration is *only* intended to be used for development of nextcloud apps.
To do so, the `xdebug` extension of PHP is installed additionally.

## TL;DR

Just build the image with `docker-compose build --pull` and start the stack by `docker-compose up -d`.
The debug instance will listen on `localhost:8000` with user `admin` and passwort `admin_pwd`.

## Content

- [Setup](#setup)
    - [Building the image](#building-the-image)
    - [Initializing the databases](#initializing-the-databases)
    - [Create mounting folders](#create-mounting-folders)
    - [Configuring the nextcloud timezone](#configuring-the-nextcloud-timezone)
    - [Install the basic nextcloud container](#install-the-basic-nextcloud-container)
    - [Open the page in the browser](#open-the-page-in-the-browser)
- [Usage](#usage)
    - [Command line programs](#command-line-programs)
    - [Installation of app to debug](#installation-of-app-to-debug)
    - [Functionality of the debugger](#functionality-of-the-debugger)
    - [Tracing and profiling](#tracing-and-profiling)
    - [Debugging a PHP script](#debugging-a-php-script)

## Setup

### Building the image

The first step is to build the docker image.
This is done using `docker-compose` command as it keeps thing neat and tidy.

Simply call the command
```
docker-compose build --pull
```
This will download a basic installation of nextcloud and tweak it for debugging.

### Initializing the databases

The database needs to be prepared.
This can take a few seconds until a few minutes.
To avoid issues with the installation of the nextcloud, the datbases should be started first:

```
docker-compose up -d db redis
```

Take a short break to wait until the databse file structure has been initialized.

### Create mounting folders

Create the following folder structure in the current folder:
```
volumes
├── apps
├── base
├── config
├── custom_apps
└── xdebug
    ├── profiles
    └── traces
```

To do so, just call
```
mkdir -p volumes/{apps,base,config,custom_apps,xdebug/{profiles,traces}}
```

### Configuring the nextcloud timezone

When running on Linux you might want to uncomment the following line (keep the indentation!):
```
- /etc/localtime:/etc/localtime:ro
```

For Windows installations, this should not be necessary.

### Install the basic nextcloud container

Now that you prepared all your structure, you can install the nextcloud instance.
This is done by creating and starting the corresponding container.
```
docker-compose up -d
```
The installation process might take a bit of time as well.
You can proceed with the next step as there will be no web page visible as long as the installation is running.

### Open the page in the browser

Navigate to the location `http://localhost:8000` in your browser.
If the installation is still running, an error might appear.
Reload then in regular intervals.

To log into you need to provide username and password.
These are `admin` and `admin_pwd` respective.


## Usage

### Command line programs

In the current folder there are the scripts `db.sh` and `occ.sh`.
These allow to open the database (even during a live deebugging session and to invoke the OCC console commands.

### Installation of app to debug

You can install any custom apps in `./volumes/custom_apps`.
How to install an app there you must reference to the official documentation and the documentation of the app.

You might need to allow the development user writable access to `./volumes/custom_apps`.
This can be done (assuming you are in group `developers`) by
```
sudo chgrp developers volumes/custom_apps
sudo chmod g+w volumes/custom_apps
```

For example to install the cookbook app from git, you would navigate to the `volumes/custom_apps` folder and checkout the app from git
```
git clone git@github.com:nextcloud/cookbook.git
```
In the case of the cookbook app you need to install some dependencies and build a vue application.
For this special app you need to run `npm install && make` to build the app but this depends on the app you want to debug.
Finally, you can enable the app using the occ interface by
```
./occ app:enable cookbook
```

Additionally, the configuration can be tweaked under `./volumes/config`.

You might wnat to enable debug mode in Nextcloud:
Go to `./volumes/config/config.php` and insert
```php
  'debug' => true,
```

### Functionality of the debugger

This image has a set of different functionalities:

- Debugging of running PHP processes
- Profiling of a PHP run (cheking the timing)
- Tracing of a PHP run (which functions are called in which order)

The profiler and tracer of xdebug is set up by default.
To make use of any functionality, you need to set a trigger.
This is a Cookie, a call parameter or a HTTP header.
This can be done using e.g. an extension to your browser.
See here for [Chrome](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc) and [Firefox](https://addons.mozilla.org/en-GB/firefox/addon/xdebug-helper-for-firefox/).

### Tracing and profiling

Both tracing and profiling generate a file per request.
The correesponding files will be located in `./volumes/xdebug/traces` and `./volumes/xdebug/profiles`.

To interpret these files, there are different programs availabe.
You need to use one suitable for your operating system.

### Debugging a PHP script

The debugging requires interaction with your IDE to allow e.g. singe-step debugging and the like.
I will describe the setting using the eclipse plattform as this is my personal favorite IDE for these types of setups.

I assume, you have the IDE already preinstalled and also the plugins for PHP and web development installed.

**Hint:** When the debugging port 9000 is used by another process, the debugging will silently fail to start.
You will not get any warning or message.
So make sure, the port is free for usage **before starting eclipse**.
You need a restart of eclipse if teh port has been in use.

#### Preparation of eclipse (one time only per workspace)

There are a few settings you need to set before you can start the session.

Go to Preferencees -> PHP -> Debug -> Debuggers and click on XDebug.
Click on configure to open a new dialog.
Set the setting *Allow remote session (JIT)* to **any**.

You might want to set under Preferences -> PHP -> Debug uncheck the box *Break at first line*.
Otherwise you will be thrown into the internals of the nextcloud core.

#### Creation of a project

**Linux only:**
Navigate to this repository and then to `volumes`.
Ensure that the directory `base` is owned by a group you are member of (`sudo chgrp developers base` if you are member of `developers`) and make the `base` directory writable for that group (`sudo chmod g+w base`).
That way you can create files in the nextcloud base directory.
Eclipse needs this in order to store some metadata.

Create a new PHP project with existing source location.
Set the location to `volumes/base` relative to this repository.
Click on *Next*.

On the next pane, the libraries and source folders are to be set up.
Leave it at its defaults and click on *Next*.

The next tab ist the configuration of the source folders and filters.
Click on *Link Source* to open a new dialog.
Select (using *Browse*) the location of the app within the `volumes/custom_apps` folder.
In the example from above that would be `volumes/custom_apps/cookbook`.
The (destination) folder name would be `custom_apps/cookbook`.
Set the option to *update the exclusion filters in the other source folder to solve nesting*.

If there are other apps in the `custom_apps` folder to be used, add these as well.

Verify that the project has a valid structure and the app to be debugged is visible in the `custom_apps` folder of the project.

#### Debugging

Now you have set up everything for debugging.
You might need to restart eclipse in order to save and use all settings.
When enabling the [debugging session in the browser](#functionality-of-the-debugger) and you reload the site, you should just get no special effect.
Especially, in eclipse you should not be asked about starting a debugging session or see a stopped script execution.
This will get tendious as all resources are going to trigger dozens of debugging sessions, so make sure, the debugger starts not at fist sight.

You can set breakpoints in your PHP code and as soon as that line is reached, the script will stop executing and you can look around in eclipse.
