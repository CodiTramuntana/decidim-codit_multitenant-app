Initial Tenant Setup Guide
==========================

This guide will cover the steps to setup the domain and server to be able
to create a new tenant through the `Decidim::System` interface.

In the next steps replace {tenant} with the tenant name

Step 1 - Subdomain DNS
----------------------

Check that the {tenant}.decideix.com resolves to the host IP `46.101.117.21`,
probably is resolving as the DNS is configured with a `*` catch all rule.

Step 2 - Create Virtual Host Non SSL
-----------------------------------

Log into the remote server and create the vhost for the new tenant.

Get the [`vhost.example-no-ssl.conf`](https://gitlab.coditdev.net/decidim/decidim-codit-multitenant-app/blob/master/config/vhost-no-ssl.example.conf) template found in `/etc/apache2/sites-available/`, make a copy and rename the file:

```
sudo cp vhost.example-no-ssl.conf {tenant}-no-ssl.decideix.com.conf
```

Change the contents of the file by replacing `{change_me}` with the `{tenant}`, run:

```
sudo sed -i 's/{change_me}/{tenant}/g' {tenant}-no-ssl.decideix.com.conf
```

Enable Virtual Host File with the following command:

```
sudo a2ensite {tenant}-no-ssl.decideix.com.conf
```
Restart `Apache`:

```
sudo service apache2 restart
```

Step 3 - Create the SSL Certificate
-----------------------------------

Follow the steps from this guide [Certbot](https://certbot.eff.org/lets-encrypt/ubuntuxenial-apache)

> I'm using **Apache** on **Ubuntu 10.04 (xenial)**


Step 4 - Create Virtual Host with SSL
-------------------------------------

Get the [`vhost.example.conf`](https://gitlab.coditdev.net/decidim/decidim-codit-multitenant-app/blob/master/config/vhost.example.conf) template found in `/etc/apache2/sites-available/`, make a copy and rename the file:

```
sudo cp vhost.example.conf {tenant}.decideix.com.conf
```

Change the contents of the file by replacing `{change_me}` with the `{tenant}`, run (only replace the {tenant} string):

```
sudo sed -i 's/{change_me}/{tenant}/g' {tenant}.decideix.com.conf
```

Dissable the _Non SSL_ and enable the _SSL_ Virtual Host File with the following command:

```
sudo a2dissite {tenant}-no-ssl.decideix.com.conf && sudo a2ensite {tenant}.decideix.com.conf
```

Restart `Apache`:

```
sudo service apache2 restart
```

Step 5 - Create the tenant in Decidim's System
----------------------------------------------

Visit htpps://codit.decideix.com and create a new **Organization** pointing to `{tenant}.decideix.com`.


<!--
Not working as `decidim-codit-multitenant-app` is a private repo
```bash
sudo wget https://gitlab.coditdev.net/decidim/decidim-codit-multitenant-app/raw/master/config/vhost.example.conf -P /etc/apache2/sites-available/ --no-check-certificate
```
-->