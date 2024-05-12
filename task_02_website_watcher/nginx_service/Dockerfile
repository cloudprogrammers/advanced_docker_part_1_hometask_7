FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*  

#create directory for SSL cert (may be merged with below statement)
RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=PL/ST=pomorskie/L=Sopot/O=CloudProgrammers/CN=www.cloudprogrammers.pl"

# Copy custom Nginx config from host to container
COPY rootfs/ /etc/nginx/sites-available/

# Set the working directory to Nginx's web root
WORKDIR /var/www/html

#move the website file to nginx root directory, so that nginx can serve this website
COPY *.html .

# Inform Docker that the container listens on port 80 and 443
EXPOSE 80 443

# Use ENTRYPOINT to start Nginx in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]