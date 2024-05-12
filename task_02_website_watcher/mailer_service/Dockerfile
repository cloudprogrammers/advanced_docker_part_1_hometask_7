# Use the juanluisbaptiste/postfix image as the base
FROM juanluisbaptiste/postfix

# Install curl to perform health checks on the Nginx server
RUN apk --no-cache add curl

# Define arguments that can be passed at build time
ARG SMTP_SERVER=smtp.sendgrid.net
ARG SMTP_PORT=587
ARG SMTP_USERNAME=
ARG SMTP_PASSWORD=
ARG OVERWRITE_FROM=office@cloudprogrammers.pl
ARG SERVER_HOSTNAME=cloudprogrammers.pl

# Set environment variables from build arguments
ENV SMTP_SERVER=$SMTP_SERVER \
    SMTP_PORT=$SMTP_PORT \
    SMTP_USERNAME=$SMTP_USERNAME \
    SMTP_PASSWORD=$SMTP_PASSWORD \
    OVERWRITE_FROM=$OVERWRITE_FROM \
    SERVER_HOSTNAME=$SERVER_HOSTNAME

COPY entrypoint.sh .
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN chmod +x /usr/local/bin/healthcheck.sh

EXPOSE 587
EXPOSE 25

CMD ["./entrypoint.sh"]