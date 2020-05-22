# Dockerized Alpine LEMP

This is a Docker-based LEMP (Linux/NGINX/MySQL/PHP) stack for web development that delivers a quick, reliable, relatively small, alpine-based (ish) environment so you can start working in minutes.

### Main features

- NGINX 1.17 on Alpine with SSL support, independent logging per site and `gzip` enabled
- PHP FPM 7.4.6 on Alpine, with `MySQLi` and `PDO` extensions installed by default
- MariaDB's official image 10.4.13, with a mounted volume on `/db` for persistance
- Easily customizable scripts and config files, as they sit on mounted `/scripts` and `/conf` folders
- NGINX and PHP logs are avilable on the `/logs` folder, accessible from the host machine
- NGINX allows custom configurations on `/custom/conf` that will be added to the right server blocks. The names of the files must be `HOST`.`BASE_DOMAIN`.conf.
---

### Get started

1. Clone this repo
2. Create an `.env` file on the root folder with the necessary variables (see `.env.example`)
3. Create one or more folders on `/www` and include their names on `.env:HOSTS`
4. Run `docker-compose build` to generate the SSL certificates based on `BASE_DOMAIN` and `HOSTS`, update the NGINX config files, install the php extensions and build the final images
5. Don't forget to include a line on your `/etc/hosts` so you can access your sites
6. Run `docker-compose up -d` to start the stack

---

### Caveats

- Root folders for all sites sit on `/www/sitename/public` by default. You might want to change it depeneding on your needs, check `/conf/nginx.conf` and `/scripts/hosts.sh`
- Conditional building phases for PHP with GD, LDAP and Intl have been included as an example to the `.env` and the PHP Dockerfile. Feel free to add any more extensions
- Visiting any of your sites for the first time might trigger an SSL error, as the CA for your SSL certificates is not trusted. Just add the site's CA to the trusted list on your computer and you're all set.

---

### To do

- [ ] Automatic NGINX server config generation triggered by changes on `/www`
- [ ] Custom MariaDB docker based on Alpine, at the moment is based on the official image
- [ ] Better `.env` management
- [ ] Improve custom NGINX templates on a per-site basis.