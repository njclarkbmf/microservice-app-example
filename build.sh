#!/usr/bin/env bash

TAG=$(date +%s)
git pull

cd auth-api

docker build -t eivantsov/auth-api:${TAG} .
docker push eivantsov/auth-api:${TAG}
cd ..
cd frontend
docker build -t eivantsov/frontend:${TAG} .
docker push eivantsov/frontend:${TAG}
cd ..
cd todos-api
docker build -t eivantsov/todos-api:${TAG} .
docker push eivantsov/todos-api:${TAG}
cd ..
cd users-api
docker build -t eivantsov/users-api:${TAG} .
docker push eivantsov/users-api:${TAG}

# update k8s deployments


kubectl set image deployment/auth-api auth-api=eivantsov/auth-api:${TAG}
kubectl set image deployment/users-api users-api=eivantsov/users-api:${TAG}
kubectl set image deployment/todos-api todos-api=eivantsov/todos-api:${TAG}
kubectl set image deployment/frontend frontend=eivantsov/frontend:${TAG}