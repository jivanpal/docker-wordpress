# WordPress in a Docker container!

## Summary

This set-up deploys a WordPress single-site instance on your local machine using a collection of Docker containers, operating together with the aid of `docker-compose`.

The Docker images used are:

- `nginx:latest` — Latest version of Nginx, a popular lightweight web server.
- `mariadb:latest` — Latest version of MariaDB, an open-source alternative to MySQL.
- `wordpress:fpm` — Latest version of WordPress coupled with PHP-FPM.

HTTP and HTTPS requests are handled by Nginx, forwarded to PHP-FPM if necessary, which in turn will interact with MariaDB to update/retrieve the necessary data.

SSL certificates for serving HTTPS requests are solicited from Let's Encrypt with the aid of Certbot. These are solicited by passing the DNS-01 challenge with the aid of the `dns-digitalocean` plugin in order to create and destroy temporary TXT records for the chosen domain in a completely automated fashion.

## So... how do I use it?

Due to the current nature of this set-up's design, it cannot be easily used on Windows (yet; unless you have Git-Bash or another UNIX shell-like interface that will allow you to run Bash scripts). I might create some PowerShell or DOS/command-prompt scripts in future, but don't bet on it.

You'll need [Docker](https://docs.docker.com/v17.12/docker-for-mac/install/) and [Docker Compose](https://docs.docker.com/compose/install/) installed on your machine, and thus be able to run `docker` and `docker-compose` from the terminal. Now that that's out of the way, here are the setup steps:

1. Clone this Git repository.

2. Edit the `.env` file, setting the following variables as appropriate:

   1. `CONTAINER_PREFIX` — This is the string that all the Docker containers used in this set-up will start with, e.g. if you set `CONTAINER_PREFIX=mywebsite`, then your containers will be named `mywebsite_webserver`, `mywebsite_database`, and `mywebsite_wordpress`. This is useful if you want to create multiple such set-ups for different websites using this repo, though you may still currently only have one such website running at any one time.

   2. `DOMAIN_NAME` — This is the domain name that Nginx will use when serving your content. If you don't want to use a domain name, just set this to `localhost`. If you do want to use a domain name, this needn't be a domain name you currently have control over; just edit your `/etc/hosts` file as appropriate so that the chosen domain resolves to localhost. However, if you want to serve content over HTTPS, then this must be a domain you have control over, and also be one whose DNS zone is managed via DigitalOcean, since we will attempt to pass Let's Encrypt's DNS-01 challenge automatically for the chosen domain using Certbot's `dns-digitalocean` plugin.

   3. `HTTPS` — Set this to `enabled` if you want to serve content over HTTPS; otherwise leave it set to `disabled`. If enabled, you will need to be able to pass the the DNS-01 challenge as described previously.
   
3. If you enabled HTTPS, put a DigitalOcean API key in the file `nginx-config-template/https_enabled/digitalocean.ini`. This API key should be able to create and destroy DNS records for the DNS zone of the domain specified by `DOMAIN_NAME` in `.env`.

4. Run `setup.sh` direcly from this directory, e.g.

   ```
   my-computer:Desktop john$ cd path/to/docker-wordpress
   my-computer:docker-wordpress john$ ./setup.sh
   ```

   The scripts provided will not work as expected unless the working directory is the directory they are in, e.g. doing the following won't work:

    ```
    my-computer:Desktop john$ path/to/docker-wordpress/setup.sh
    ```

    The setup script will not require any user input whilst it is running. If you enabled HTTPS, it will automatically:
   
    1. generate 2048-bit Diffie–Hellman parameters, which may take a few minutes; and
    2. solicit a new SSL certificate for the domain name specified in `.env` using Certbot.

    The script should then process the files in `nginx-config-template`, copy the processed files to `nginx-config`, and then exit cleanly.

5. Run `docker-compose up` to create the Docker containers and start them. the terminal will display console messages from each of the containers. Once MariaDB has initialised the database and WordPress has successfully connected to it, you should see the message `NOTICE: ready to handle connections`, at which point you will be able to access your locally hosted website. For now, though, stop the containers with `CTRL-C`.

Now that you're all set up, starting up the containers in the background is simply a matter of running `docker-compose up -d` from the main directory, and stopping them can be done with `docker-compose stop`.

## Things that I might add in future

- Documentation for the `reset.sh` script
- A script to easily import a database backup; useful if, e.g. using this set-up to host a local development version of a website that already has a production version live on the internet.
