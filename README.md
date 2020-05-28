# Dockerize the TripMealApp

Dockerizing the TripMealApp application (https://github.com/DanielAndreasen/TripMeal) is the process of converting this particular app to run within a Docker container.

## Description of the TripMealApp

For this project, I chose to package the **TripMeal** application developed by Daniel Andreasen (https://github.com/DanielAndreasen). This application is a **python web app** developed under Flask which is a lightweight WSGI web application framework. In addition, the application uses an **SQL database** to store user data and the content they can generate on the web app.

In a few words, the application is a **recipe sharing platform** with an authentication system. Thus, each user with an account can log in and post recipes or consult those of others. You can get an overview of the application deployed via the Heroku platform by visiting this link : https://tripmeal.herokuapp.com/.

## Description of the project

As mentioned before, the application uses a Flask server and a SQL database to run. It is therefore naturally split into two independent services. So I created a subdirectory for each service, containing everything needed to run that service (as well as the Dockerfile).

![docker architecture](images/docker_architecture.png)

### Database image

The goal is to create a docker image on top of the **mysql** (https://hub.docker.com/_/mysql) one that already contains the necessary scheme for the app.
To do this, the Dockerfile starts from a parent image.
```
FROM mysql
```
Then, on top of that, we have to execute the `db/init-db.sql` script to create the desired database if it doesn't already exist. When a container is started for the first time, it will execute files with extensions `.sh`, `.sql` and `.sql.gz` that are found in `/docker-entrypoint-initdb.d`, hence the second command that adds the script file `db/init-db.sql` to the `/docker-entrypoint-initdb.d` folder.
```
ADD init-db.sql /docker-entrypoint-initdb.d
``` 

### Web image

The TripMeal application relies on version 2 of python. Moreover, to install the `MYSQL-python` library present in the `requirements.txt` file, it is necessary to have a linux distribution. Thus, the parent image on which the Dockerfile is built is `python:2.7-alpine`

```
FROM python:2.7-alpine
```

Then, the following commands allow respectively to define the working directory of the container and to copy the `requirements.txt` file in this directory. The following RUN command allows to install all the libraries indicated in the `requirements.txt` file. 

```
WORKDIR app

COPY requirements.txt .

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
            gcc \
            make \
            libc-dev \
            musl-dev \
            linux-headers \
            pcre-dev \
            python-dev \
    && apk add --no-cache mariadb-dev \
    && sed '/st_mysql_options options;/a unsigned int reconnect;' /usr/include/mysql/mysql.h -i.bkp \
    && pip install -r requirements.txt \
    && runDeps="$( \
            scanelf --needed --nobanner --recursive /venv \
                    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                    | sort -u \
                    | xargs -r apk info --installed \
                    | sort -u \
    )" \
    && apk add --virtual .python-rundeps $runDeps \
    && apk del .build-deps
```

After having installed all the necessary dependencies, copy the entire web folder into the working directory. Copying the files is done in two steps to avoid having to download all the libraries again if someone makes a change to the python code using the docker cache system.

```
COPY . .
```

Finally, the ENTRYPOINT command allows you to start the server at container startup by specifying the appropriate python command.

```
ENTRYPOINT ["python","app.py"]
```

## Instruction

### Docker compose file

Since the application consists of several images, I created a `docker-compose-.yml` file to define the services that make up the application so that they can be run together in an isolated environment. In this file, we find both the `db` and `web` services. In addition, the top-level `networks` key lets you specify networks to be created.

In the web service, we notice that it depends on the `db` service thanks to the indication `depends_on` which expresses dependency between services. Moreover, we map ports in the HOST:CONTAINER format, and add this service to the `banana` network.
On the other hand in the `db` service, which is also added to the `banana` network, the 3306 port is exposed (through the key word `expose`) without publishing it to the host machine - it will only be accessible to linked services (e.g the web service). Finally, the `db` service uses a named volume called `db-data` that is listed under the top-level `volumes` key. This volume keeps the `tripmealdb` database data, initially created by the `db/Dockerfile`. Therefore, each time the container is restarted, the database already exists and the data previously entered persists.

### Retrieve images

Either you can pull the images from the DockerHub registry by executing the following commands in a terminal :
```
docker pull grosclara/trip-meal-web
docker pull grosclara/trip-meal-db
```
... Or you can directly build the two images locally by placing yourself in the root folder and executing the following command :
```
docker-compose build
```

### Run images

To run the application correctly once both images are pulled either from the Dockerhub registry or either locally, simply create an `.env` file in the root folder to initialize the environment variables and run the command to run containers according to the instructions in the `docker-compose.yml` file.
``` 
docker-compose up 
```

Le fichier `.env`doit contenir les variables suivantes. Lorsque vous créez ce fichier, libre à vous de choisir la valeur de ces variables d'environnement.
```
MYSQL_DATABASE=tripmealdb
MYSQL_USER=user
MYSQL_PASSWORD=my-secret-pw
TRIPMEAL_KEY='my-secret-key'
SERVER_PORT=5000
```


