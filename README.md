# Nextcloud development environment

This docker configuration is *only* intended to be used for development of nextcloud apps.
To do so, the `xdebug` extension of PHP is installed additionally.

## TL;DR

Just build the image with `docker-compose build --pull` and start the stack by `docker-compose up -d`.
The debug instance will listen on `localhost:8000` with user `admin` and passwort `admin_pwd`.

## Content

- [Setup](#setup)
    - [Building the image](#building-the-image)
    - [Initializing the databases](#initializing-the-database)
    - [Create mounting folders](#create-mounting-folders)
    - [Configuring the nextcloud timezone](#configuring-the-nextcloud-timezone)
    - [Install the basic nextcloud container](#installing-the-basic-nextcloud-container)
    - [Open the page in the browser](#open-the-page-in-the-browser)
- [Usage](#usage)

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

TODO
