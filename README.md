# Dockerize the TripMealApp

Dockerizing the TripMealApp application (https://github.com/DanielAndreasen/TripMeal) is the process of converting this particular app to run within a Docker container.

## Description of the TripMealApp

For this project, I chose to package the **TripMeal** application developed by Daniel Andreasen (https://github.com/DanielAndreasen). This application is a **python web app** developed under Flask which is a lightweight WSGI web application framework. In addition, the application uses an **SQL database** to store user data and the content they can generate on the web app.

In a few words, the application is a **recipe sharing platform** with an authentication system. Thus, each user with an account can log in and post recipes or consult those of others. You can get an overview of the application deployed via the Heroku platform by visiting this link : https://tripmeal.herokuapp.com/.

## Description of the project

As mentioned before, the application uses a Flask server and a SQL database to run. It is therefore naturally split into two independent services. So I created a subdirectory for each service, containing everything needed to run that service (as well as the Dockerfile).

SCHEME


### Database image

### Web image
The description of the Dockerfile, specifying the meaning of each instruction.

## Instruction

### Pull images from the Dockerhub registry

### Build images with the docker compose file

### Run images

To run the application correctly once both images are pulled either from the Dockerhub registry or either locally, simply create an `.env` file in the root folder to initialize the environment variables and run the docker-compose up command to rotate both the containers according to the instructions in the docker-compose file.

Le fichier `.env`doit contenir les variables suivantes. Lorsque vous créez ce fichier, libre à vous de choisir la valeur de ces variables d'environnement.
```
MYSQL_DATABASE=tripmealdb
MYSQL_PORT=3306
MYSQL_USER=user
MYSQL_PASSWORD=my-secret-pw
TRIPMEAL_KEY='my-secret-key'
SERVER_PORT=5000
```



Documentation for Trip Meal App

Description de l'app

File hierarchy

- Schéma architecture de l'app comme il a fait)
- Explication de l'app (db qui communique avec server qui tourne sur le localhost / architecture de la db : ce que j'ai fait)
- Description déclarative de comment déployer l'app (pptés)
- image sql fichier env avec variable de config, attendre ??, décrire dockerfile
- python : décrire dockerfile (version2 python + ordre des copy) 	


