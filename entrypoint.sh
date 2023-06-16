#!/bin/sh

echo "Welcome! You're logging as $(whoami)"
httpd -D FOREGROUND
