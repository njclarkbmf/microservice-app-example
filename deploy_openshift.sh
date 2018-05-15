#!/usr/bin/env bash
DEFAULT_OPENSHIFT_ENDPOINT="https://dev.rdu2c.fabric8.io:8443"
OPENSHIFT_ENDPOINT=${OPENSHIFT_ENDPOINT:-${DEFAULT_OPENSHIFT_ENDPOINT}}

DEFAULT_OPENSHIFT_PROJECT="production"
OPENSHIFT_PROJECT=${OPENSHIFT_PROJECT:-${DEFAULT_OPENSHIFT_PROJECT}}

DEFAULT_USE_VALID_TLS_CERTIFICATE="false"
USE_VALID_TLS_CERTIFICATE=${USE_VALID_TLS_CERTIFICATE:-${DEFAULT_USE_VALID_TLS_CERTIFICATE}}

DEFAULT_SETUP_CICD="false"
SETUP_CICD=${SETUP_CICD:-${DEFAULT_SETUP_CICD}}

echo -n "Logging using OpenShift endpoint \"${OPENSHIFT_ENDPOINT}\"..."
if [ -z "${OPENSHIFT_TOKEN+x}" ]; then
  echo "**ERROR**: OPENSHIFT_TOKEN is not provided. Aborting."
  exit 1
else
  oc login "${OPENSHIFT_ENDPOINT}" --token="${OPENSHIFT_TOKEN}"  > /dev/null
fi
echo "done!"

echo -n "Checking if project \"${OPENSHIFT_PROJECT}\" exists..."
if ! oc get project "${OPENSHIFT_PROJECT}" &> /dev/null; then
    echo -n "Creating \"${OPENSHIFT_PROJECT}\"..."
    oc new-project ${OPENSHIFT_PROJECT}
else
    echo "Project \"${OPENSHIFT_PROJECT}\" already exists. Please remove project before running this script."
    exit 1
fi

if [ "${SETUP_CICD}" == "true" ]; then
  echo "Deploying BuildConfig to setup CI/CD"
  oc apply -f openshift/openjdk-s2i-imagestream.yml
  oc apply -f openshift/is.yml
  oc apply -f openshift/whsecret.yml
  oc apply -f openshift/bc.yml
fi

# applying k8s resources
cd k8s

cd redis
oc apply -f deployment.yaml
oc apply -f service.yaml

cd ..
cd auth-api
oc apply -f deployment.yaml
oc apply -f service.yaml

cd ..
cd frontend
oc apply -f deployment.yaml
oc apply -f service.yaml


cd ..
cd users-api
if [ "${SETUP_CICD}" == "true" ]; then
  oc apply -f deployment-cicd.yaml
  oc apply -f service-cicd.yaml
else
  oc apply -f deployment.yaml
  oc apply -f service.yaml
fi

cd ..
cd todos-api
oc apply -f deployment.yaml
oc apply -f service.yaml

# exposing route 
oc expose svc/frontend

if [ "${USE_VALID_TLS_CERTIFICATE}" == "true" ]; then
  # LetsEncrypt certificate is provisioned by openshift-acme service, just need to annotate the route
  echo -n "Using valid TLS certificate"
  oc annotate route/frontend kubernetes.io/tls-acme=true
fi 

echo "Successufully deployed microservice app on OpenShift"
