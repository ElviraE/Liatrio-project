# Flask Rest Api

# setup
flask
- Installing python
- create virtual enviroment
- Install dependancies
- create flask app


## Features
- Flask Based App - Api Endpoint


## Primary Goals
 - To Write a rest api endpoint that is return a message and timestamp as json. 


## Table of Contents

1. [Getting Started With Flask App](#getting-started)
1. [Dependancies](#Dependancies)
1. [Project Structure](#ProjectStructure)




## Getting Started With Flask App

clone the project

```bash
$ git clone flask-docker-kubernetes.git flask-api
$ cd flask-api
```

create virtual environment using python3 and activate it (keep it outside our project directory)

```bash
$ python3 -m venv /path/to/your/virtual/environment
$ source <path/to/venv>/bin/activate
```

install dependencies in virtualenv

```bash
$ pip install -r requirements.txt
```

setup `flask` command for our app

```bash
$ export FLASK_APP=app.py
$ export FLASK_ENV=development
```

5) start test server at `localhost:5000`

```bash
$ flask run
```



## Dependancies

- asgiref==3.5.1
- certifi==2021.10.8
- charset-normalizer==2.0.12
- click==8.1.3
- colorama==0.4.4
- Flask==2.0.2
- idna==3.3
- itsdangerous==2.1.2
- Jinja2==3.1.2
- MarkupSafe==2.1.1
- urllib3==1.26.9
- Werkzeug==2.1.2
- python-dotenv==0.20.0



## Project Structure

src
├── app.py
├── .env
├── .env.prod
├── Dockerfile
├── .dockerignore
├── kubernetes-manifest.yaml
├── README.md
├── .gitignore
├── requirements.txt

