# TODO: enable secret manager: secretmanager.googleapis.com


## REQUIRED VARS
# PROJECT_ID
# APP_NAME

# INSTANCE_GIT_REPO_TOKEN
# INSTANCE_GIT_REPO_OWNER
# INSTANCE_GIT_REPO_NAME

# API_KEY


# subdir of template # TODO refactor
APP_LANG=sample

## CONSTRUCTED VARS
export GIT_TOKEN=${GIT_TOKEN}
export GIT_USER=${GIT_USER}
export GIT_USERNAME=${GIT_USER}
export API_KEY_VALUE=${API_KEY}


export WORK_DIR=${PWD}
export GIT_CMD=${WORK_DIR}/cp-templates/cicd-pipeline/util/git/gh.sh
export GIT_BASE_URL=https://${GIT_USER}@github.com/${GIT_USER}

export APP_INSTANCE_REPO_LOCATION=https://github.com/${GIT_USERNAME}/${APP_NAME}

export IMAGE_REPO=gcr.io/${PROJECT_ID}
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

export SECRET_NAME=${APP_NAME}-webhook-trigger-secret

#TODO - Fix value # this didn't work in cloud build run
#SECRET_VALUE=$(sed "s/[^a-zA-Z0-9]//g" <<< $(openssl rand -base64 15))
SECRET_VALUE=foobar

SECRET_PATH=projects/${PROJECT_NUMBER}/secrets/${SECRET_NAME}/versions/1
printf ${SECRET_VALUE} | gcloud secrets create ${SECRET_NAME} --data-file=-

gcloud secrets add-iam-policy-binding ${SECRET_NAME} \
    --member=serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-cloudbuild.iam.gserviceaccount.com \
    --role='roles/secretmanager.secretAccessor'

## Create CloudBuild Webhook Endpoint
echo Create CloudBuild Webhook Endpoint
TRIGGER_NAME=${APP_NAME}-webhook-trigger
BUILD_YAML_PATH=$WORK_DIR/cp-templates/cicd-pipeline/app-templates/${APP_LANG}/build/cloudbuild.yaml

## Setup Trigger & Webhook
gcloud alpha builds triggers create webhook \
    --name=${TRIGGER_NAME} \
    --inline-config=$BUILD_YAML_PATH \
    --secret=${SECRET_PATH} --substitutions='_APP_NAME=${APP_NAME},_APP_REPO=$(body.repository.git_url),_REF=$(body.ref)'

## Retrieve the URL 
WEBHOOK_URL="https://cloudbuild.googleapis.com/v1/projects/${PROJECT_ID}/triggers/${TRIGGER_NAME}:webhook?key=${API_KEY_VALUE}&secret=${SECRET_VALUE}"
echo WEBHOOK_URL=${WEBHOOK_URL}

## Configure Github Repo Webhook
echo Configure Github Repo Webhook
${GIT_CMD} create_webhook ${APP_NAME} $WEBHOOK_URL

