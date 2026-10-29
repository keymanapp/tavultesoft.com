#!/usr/bin/env bash
## START STANDARD SITE BUILD SCRIPT INCLUDE
readonly THIS_SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
readonly BOOTSTRAP="$(dirname "$THIS_SCRIPT")/resources/bootstrap.inc.sh"
BOOTSTRAP_VERSION="$(cat "$(dirname "THIS_SCRIPT")/resources/.bootstrap-required-version")" || exit 1
readonly BOOTSTRAP_VERSION
if ! [ -f "$BOOTSTRAP" ] || ! source "$BOOTSTRAP"; then
  curl -H "Cache-Control: no-cache" --fail --silent --show-error -w "curl: Finished attempt to download %{url}" "https://raw.githubusercontent.com/keymanapp/shared-sites/$BOOTSTRAP_VERSION/bootstrap.inc.sh" -o "$BOOTSTRAP.tmp" || exit 1
  source "$BOOTSTRAP.tmp"
  rm -f "$BOOTSTRAP.tmp"
fi
## END STANDARD SITE BUILD SCRIPT INCLUDE

readonly TAVULTESOFT_CONTAINER_NAME=tavultesoft-com-website
readonly TAVULTESOFT_CONTAINER_DESC=tavultesoft-com-app
readonly TAVULTESOFT_IMAGE_NAME=tavultesoft-com-website
readonly HOST_TAVULTESOFT_COM=tavultesoft.com.localhost

source _common/keyman-local-ports.inc.sh
source _common/docker.inc.sh
source ./test.inc.sh

################################ Main script ################################

builder_describe \
  "Setup tavultesoft.com site to run via Docker." \
  configure \
  clean \
  build \
  start \
  stop \
  test \
  verify_bootstrap_required_version \
  "--no-unit-test" \
  "--no-lint" \
  "--no-link-check" \
  "--no-redirect-check" \
  "--no-php-error-check"

# --no-unit-test not relevant for this script but kept for consistency
export DOCKER_NO_UNIT_TEST=1    # test_docker_container uses this

builder_parse "$@"

function do_test() {
  # tavultesoft.com-specific tests
  if ! builder_has_option --no-redirect-check; then
    test_all_redirects "$HOST_TAVULTESOFT_COM:$PORT_TAVULTESOFT_COM" # from test.inc.sh
  fi
  # shared standard tests
  test_docker_container $TAVULTESOFT_CONTAINER_DESC $PORT_TAVULTESOFT_COM "/forums"

  if ! builder_has_option --no-php-error-check; then
    docker_report_php_errors $TAVULTESOFT_CONTAINER_DESC
  fi
}

builder_run_action configure  bootstrap_configure
builder_run_action clean      clean_docker_container $TAVULTESOFT_IMAGE_NAME $TAVULTESOFT_CONTAINER_NAME
builder_run_action stop       stop_docker_container  $TAVULTESOFT_IMAGE_NAME $TAVULTESOFT_CONTAINER_NAME
builder_run_action build      build_docker_container $TAVULTESOFT_IMAGE_NAME $TAVULTESOFT_CONTAINER_NAME $BUILDER_CONFIGURATION
builder_run_action start      start_docker_container $TAVULTESOFT_IMAGE_NAME $TAVULTESOFT_CONTAINER_NAME $TAVULTESOFT_CONTAINER_DESC $HOST_TAVULTESOFT_COM $PORT_TAVULTESOFT_COM $BUILDER_CONFIGURATION

builder_run_action test       do_test
builder_run_action verify_bootstrap_required_version  docker_verify_bootstrap_required_version
