server {
  server_name rpavlov.com;
  listen [::]:443 ssl http2; 
  listen 443 ssl http2;

  error_log  /var/log/nginx/error.log;
  access_log /var/log/nginx/access.log;

  # Browser and robot always look for these. Turn off logging for them
  location = /favicon.ico { log_not_found off; access_log off; }
  location = /robots.txt  { log_not_found off; access_log off; }


  location / {
  	root /var/www/html;
  }
  
  ssl_certificate /etc/letsencrypt/live/rpavlov.com/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/rpavlov.com/privkey.pem; # managed by Certbot

}

server {
    server_name rpavlov.com;
    listen 80;
    listen [::]:80;
    include /etc/nginx/snippets/letsencrypt-acme-challenge.conf;

    return 301 https://$host$request_uri;
}
