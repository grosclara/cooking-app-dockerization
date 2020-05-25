CREATE DATABASE IF NOT EXISTS tripmealdb;
USE tripmealdb;

CREATE TABLE recipes(
   rid   mediumint (9)    NOT NULL AUTO_INCREMENT,
   title VARCHAR (255),
   location  VARCHAR (5) ,
   ingredients  VARCHAR (1000) ,
   favourites   VARCHAR (1000),
   user   VARCHAR (50),       
   recipe   MEDIUMTEXT,       
   rate   float ,      
   votes int(3) ,        
   PRIMARY KEY (rid)
);


CREATE TABLE users(
   uid   mediumint (9)    NOT NULL AUTO_INCREMENT,
   username VARCHAR (20),
   password  VARCHAR (100) ,
   email  VARCHAR (60) ,  
   favourites  VARCHAR (1000) ,            
   PRIMARY KEY (uid)
);

