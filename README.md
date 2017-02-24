# bootstrap.sh #

*Creates dev.* and staging.* vhost*

**PreRequisites:**
Apache2, a working DNS set up for the subdomain created. (Cloudflare)

__Expected Dir Structure:__
- _/etc/apache2/sites-available/*_
- _/etc/apache2/sites-enabled/*_
- _/var/www/*_
- _/var/log/apache2/*_

###Usage

`sudo sh bootstrap.sh 1234-example mydomain.com public`

(creates dev.1234-example.mydomain.com (with root at /var/www/1234-example/public) & staging.1234-example.mydomain.com (with root at /var/www/1234-example/public) 
