# node-js-getting-started

A barebones Node.js app using [Express 4](http://expressjs.com/).

This application supports the [Getting Started on Heroku with Node.js](https://devcenter.heroku.com/articles/getting-started-with-nodejs) article - check it out.

## Running Locally

Make sure you have [Node.js](http://nodejs.org/) and the [Heroku CLI](https://cli.heroku.com/) installed.

```sh
$ git clone https://github.com/heroku/node-js-getting-started.git # or clone your own fork
$ cd node-js-getting-started
$ npm install
$ npm start
```

Your app should now be running on [localhost:5000](http://localhost:5000/).

## Deploying to Heroku

```
$ heroku create
$ git push heroku main
$ heroku open
```
or

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Documentation

For more information about using Node.js on Heroku, see these Dev Center articles:

- [Getting Started on Heroku with Node.js](https://devcenter.heroku.com/articles/getting-started-with-nodejs)
- [Heroku Node.js Support](https://devcenter.heroku.com/articles/nodejs-support)
- [Node.js on Heroku](https://devcenter.heroku.com/categories/nodejs)
- [Best Practices for Node.js Development](https://devcenter.heroku.com/articles/node-best-practices)
- [Using WebSockets on Heroku with Node.js](https://devcenter.heroku.com/articles/node-websockets)


## Steps to deploy

1. Use Cloud Native BuildPacks (https://buildpacks.io/) to create Docker image for Heroku app: 

    ````bash
    pack build node-js-getting-started --builder heroku/buildpacks:20
    ```

1. Create ECR repo with Service Catalog:

    ````bash
    cd infrastructure-live/stage/ecr-repos
    terragrunt apply
    ```

1. Push Docker image to ECR repo:

    ```bash
    aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 087285199408.dkr.ecr.eu-west-1.amazonaws.com/node_js_getting_started
    docker tag node-js-getting-started 087285199408.dkr.ecr.eu-west-1.amazonaws.com/node_js_getting_started:v1
    docker push 087285199408.dkr.ecr.eu-west-1.amazonaws.com/node_js_getting_started:v1
    ```

1. Deploy VPC:

    ```bash
    cd infrastructure-live/stage/vpc
    terragrunt apply
    ```

1. Deploy ALB:

    ```bash
    cd infrastructure-live/stage/alb
    terragrunt apply
    ```

1. Deploy Fargate ECS Cluster:

    ```bash
    cd infrastructure-live/stage/ecs-cluster
    terragrunt apply
    ```

1. Deploy Docker image:

    ```bash
    cd infrastructure-live/stage/node-js-getting-started
    terragrunt apply
    ```




