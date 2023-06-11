FROM alpine:3.18

LABEL version='1.0.2' arch='x86-64'
# Copy entrypoint.sh file to root image's folder (/)
COPY ./entrypoint.sh /
# Give exec permission to /entrypoint.sh
RUN chmod +x /entrypoint.sh
# Argument
ARG USER
ARG PASSWORD
# Set environment variable
ENV USER_NAME $USER
ENV USER_PASSWORD $PASSWORD
# Create user
RUN adduser -D $USER_NAME && echo $USER_NAME:$USER_PASSWORD | chpasswd
# Install doas
RUN apk add --no-cache doas && echo "permit $USER_NAME as root" > /etc/doas.d/doas.conf
# Install apache
RUN apk add --no-cache apache2
# Set user
USER $USER_NAME
# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
# Open PORT
EXPOSE 80
