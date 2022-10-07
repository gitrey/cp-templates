## Access token needs delete rights which is not included in the base repo rights
export INSTANCE_GIT_REPO_TOKEN=
export INSTANCE_GIT_REPO_OWNER=cgrant

## Delete Trigger
TRIGGER_NAME=${APP_NAME}-webhook-trigger
gcloud alpha builds triggers delete ${TRIGGER_NAME} -q


## Delte Secret 
SECRET_NAME=${APP_NAME}-webhook-trigger-secret
gcloud secrets delete ${SECRET_NAME} -q

## Delete Repo
export GIT_TOKEN=${INSTANCE_GIT_REPO_TOKEN}
export GIT_USERNAME=${INSTANCE_GIT_REPO_OWNER}
export BASE_DIR=${PWD}
export GIT_CMD=${BASE_DIR}/util/git/gh.sh
export GIT_ASKPASS=${BASE_DIR}/util/git/git-ask-pass.sh
${GIT_CMD} delete ${APP_NAME} 

