# The Dockerfile is used to build our image, which contains a mini Linux Operating System with all the dependencies needed to run our project.# 

#alpine: light image of linux
FROM python:3.9-alpine3.13 
LABEL maintainer: "christianmataj"

ENV PYTHONUNBUFFERED 1

#copy files from our local directory to a directory in the image
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./scripts /scripts
COPY ./app /app

WORKDIR /app
#port
EXPOSE 8000

ARG DEV=false
    #create a new virtual enviroment that is used to store the dependencies
RUN python -m venv /py && \
    #specify full path of the virtual enviroment and update pip 
    /py/bin/pip install --upgrade pip && \
    # install the postgresql client
    apk add --update --no-cache postgresql-client jpeg-dev && \
    # 
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    #install de requirements list inside the docker image
    /py/bin/pip install -r /tmp/requirements.txt && \
    #
    if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    #remove the tmp directory to avoid the files we don't need and make a lighter docker image. 
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    #add user to aovid only the super user
    adduser \
        #the new user wont' nedd a password nor a home directory to keep the image light
        --disabled-password \
        --no-create-home \
        #name of the user
        django-user && \
    mkdir -p /vol/web/media && \
    mkdir -p /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol &&\
    chmod -R +x /scripts
#updates the enviroment variable PATH so we can avoid writing "py/bin" so every time we run a python command it runs directly from our virtual enviroment
ENV PATH="/scripts:/py/bin:$PATH"
#swith to the created user
USER django-user

CMD ["run.sh"]