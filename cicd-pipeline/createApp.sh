
## Required Vars

# APP_NAME
# REGION

# INSTANCE_GIT_REPO_TOKEN
# INSTANCE_GIT_REPO_OWNER
# INSTANCE_GIT_REPO_NAME



## Constructed Vars
export GIT_USERNAME=${INSTANCE_GIT_REPO_OWNER}
export GIT_TOKEN=${INSTANCE_GIT_REPO_TOKEN}
export GIT_BASE_URL=https://${INSTANCE_GIT_REPO_OWNER}@github.com/${INSTANCE_GIT_REPO_OWNER}
export BASE_DIR=${PWD}
export GIT_CMD=${BASE_DIR}/cp-templates/cicd-pipeline/util/git/gh.sh
export GIT_ASKPASS=${BASE_DIR}/cp-templates/cicd-pipeline/util/git/git-ask-pass.sh


## Verify Vars
echo GIT_ASKPASS=${GIT_ASKPASS}
echo REGION=${REGION} 
echo APP_NAME=${APP_NAME} 
echo INSTANCE_GIT_REPO_OWNER=${INSTANCE_GIT_REPO_OWNER} 
echo GIT_USERNAME=${GIT_USERNAME}
echo INSTANCE_GIT_REPO_NAME=${INSTANCE_GIT_REPO_NAME} 
echo INSTANCE_GIT_REPO_TOKEN=${INSTANCE_GIT_REPO_TOKEN}
echo GIT_TOKEN=$GIT_TOKEN


git config --global user.email $(gcloud config get-value account)
git config --global user.name ${INSTANCE_GIT_REPO_OWNER}


git clone https://github.com/gitrey/cp-templates.git util



#source $GIT_ASKPASS

printf 'Creating application: %s \n' $APP_NAME

# # Create an instance of the template.
# Clone the template repo
#git clone https://github.com/GoogleCloudPlatform/software-delivery-workshop.git plat
#mv plat/delivery-platform/resources/repos/app-templates ./
#rm -rf plat
rm -rf app-templates/.git
cd ./cp-templates/cicd-pipeline/app-templates/sample

# Swap Variables
for template in $(find . -name '*.tmpl'); do envsubst < ${template} > ${template%.*}; done

# Create and push to new repo
git init
git checkout -b main
#git symbolic-ref HEAD refs/heads/main
echo create repo
${GIT_CMD} create ${APP_NAME}
git remote add origin $GIT_BASE_URL/${APP_NAME}
git add . && git commit -m "initial commit" 
git push origin main
# Auth fails intermittetly on the very first client call for some reason
#   Adding a retry to ensure the source is pushed. 
git push origin main


