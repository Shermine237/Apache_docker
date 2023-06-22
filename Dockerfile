FROM alpine:3.18

LABEL version='2.0.3' arch='x86-64'
# Copy entrypoint.sh file to root image's folder (/)
COPY ./entrypoint.sh /
# Give exec permission to /entrypoint.sh
RUN chmod +x /entrypoint.sh
# Argument
ARG NAME=user
ARG PASSWORD=user
# Set environment variable
ENV USER_NAME=$NAME
ENV USER_PASSWORD=$PASSWORD
# Create user
RUN adduser -D $USER_NAME && echo $USER_NAME:$USER_PASSWORD | chpasswd; \
# Install doas
    apk add --no-cache doas && echo "permit $USER_NAME as root" > /etc/doas.d/doas.conf; \
# Permit user to run the folowing command as root without password
    echo "permit nopass $USER_NAME as root cmd httpd" >> /etc/doas.d/doas.conf; \
# Install apache
    apk add --no-cache apache2; \
# Configure apache2
    echo ServerName myodoo.local >> /etc/apache2/apache2.conf
# Set user
USER $USER_NAME
# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
# Open PORT
EXPOSE 80
