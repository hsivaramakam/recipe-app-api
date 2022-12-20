FROM python:3.9-alpine3.13
LABEL maintainer="harishiv"

# don't buffer the output
# print it directly to the console
ENV PYTHONUNUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
# create venv inside docker
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
   if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
   fi && \     
   rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# path env variable on linux operating system. 
ENV PATH="/py/bin:$PATH"

# switch from root to django-user
USER django-user
