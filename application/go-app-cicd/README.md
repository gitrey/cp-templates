## TODO: Util directory should be in its own repo for reuse
## TODO: AppTemplate should be top level maybe

#Goto https://console.cloud.google.com/apis/credentials > 'Create Credentials' > 'API Key'


export PROJECT_ID=crg-workbench 
export _APP_NAME=foobar 


export _API_KEY=
export _INSTANCE_GIT_REPO_TOKEN=

export _INSTANCE_GIT_REPO_OWNER=cgrant
export _INSTANCE_GIT_REPO_NAME=${_APP_NAME} 
export _REGION=us_central1



gcloud builds submit --config cp-cloudbuild.json --substitutions=_APP_NAME=${_APP_NAME},_INSTANCE_GIT_REPO_TOKEN=${_INSTANCE_GIT_REPO_TOKEN},_INSTANCE_GIT_REPO_NAME=${_INSTANCE_GIT_REPO_NAME},_INSTANCE_GIT_REPO_OWNER=${_INSTANCE_GIT_REPO_OWNER},_API_KEY=${_API_KEY}

