Vagrant PHP 7.1
=

A configured Vagrant machine for rapid development, perfect for starting work in your favourite IDE (like PHPStorm).

Features a working PHP 7.1 and Xdebug installation and an `http://app.local` virtual host right from the start. All you
need to do is `vagrant up`, then later on `vagrant ssh` and get customising.

Versions
-

- PHP 7.1 with Xdebug 2.5
- Apache 2.4
- Composer (latest)

Basic Usage
-

- Run `vagrant up`
- Type in your admin password when prompted so 
  [hostmanager plugin](https://github.com/devopsgroup-io/vagrant-hostmanager) can update your /etc/hosts file with
  "app.local"
- Go and make yourself a cup of tea
- Visit `http://app.local` when finished and view your `phpinfo()`

<img src="http://imgsharer.eu/uploads/450/screen_shot_201_1492540004.png" style="max-width: 600px;" />

*Here's what `http://app.local` looks like right after `vagrant up` finishes*

Xdebug Usage
-

This example uses PHPStorm, although it shouldn't be hard to replicate with any other IDE / whatever else you want.

Make sure you haven't changed the PHPStorm default xdebug settings if you want this to 'just work'.

<img src="http://imgsharer.eu/uploads/211/screen_shot_201_1492540422.png" style="max-width: 300px;" />

*Start listening for PHP Debug Connections by clicking the above icon in PHPStorm so it turns green*

<img src="http://imgsharer.eu/uploads/538/screen_shot_201_1492540545.png" style="max-width: 300px;" />

*Set a break point in `web/index.php`*

<img src="http://imgsharer.eu/uploads/98/screen_shot_201_1492540749.png" style="max-width: 300px;" />

*Finally, make sure your Xdebug helper browser extension has the ide key as "PHPSTORM". Note: the above image is from
the Xdebug Toggler Safari extension*

<img src="http://imgsharer.eu/uploads/428/screen_shot_201_1492540854.png" style="max-width: 300px;" />

*Refresh `http://app.local` and get developing*