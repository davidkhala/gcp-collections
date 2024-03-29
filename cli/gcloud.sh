setup() {
  gcloud init
}
loginWebUser() {
  gcloud auth login --brief
}
setupADC() {
  # Application Default Credentials (ADC) used in calling Google APIs.
  # used for local dev environment to use lanuage specific gcp sdk
  # no projectId if auth standalone, you can use `gcloud init` to add projectId into context
  gcloud auth application-default login
}
setupServer() {
  gcloud init --no-browser
}

loginServiceAccount() {
  # gcloud auth activate-service-account serves the same function as gcloud auth login but uses a service account rather than Google user credentials.
  # same as `gcloud auth login --cred-file=$1`
  gcloud auth activate-service-account --key-file=$1
}
logout() {
  gcloud auth revoke
  gcloud auth application-default revoke
}
list() {
  gcloud auth list # not showing application-default credential

  gcloud auth application-default print-access-token
}
update() {
  gcloud components update -q
}
$@
