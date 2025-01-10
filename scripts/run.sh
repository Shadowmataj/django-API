#!/bin/sh

set -e

python manage.py wait_for_db
#All the static files in the project are copied to the same directory and make them accessible by the engine x reverse proxy
python manage.py collectstatic --noinput
python manage.py migrate
#socket 9000
#workers -> cluster
#module -> entry point to the application
uwsgi --socket :9000 --workers 4 --master --enable-threads --module app.wsgi


python manage.py migrate
