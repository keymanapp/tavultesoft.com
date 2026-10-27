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
readonly PORT_TAVULTESOFT_COM=8063

source _common/keyman-local-ports.inc.sh
source _common/docker.inc.sh
source ./test.inc.sh

################################ Main script ################################

builder_describe \
  "Setup r.keymanweb.com site to run via Docker." \
  configure \
  clean \
  build \
  start \
  stop \
  test \
  "--no-unit-test" \
  "--no-lint" \
  "--no-link-check"

builder_parse "$@"

function do_test() {
  # note: no unit tests at this time, and phpunit not installed on this site
  # test_docker_container $TAVULTESOFT_CONTAINER_DESC $PORT_TAVULTESOFT_COM "/_test"
  test_keyman_htaccess
  test_keyman_support_htaccess
  test_keyman_documentation_htaccess
  test_forums
  test_prog_70_downloadkeyboards
  test_prog_80_downloadkeyboards
  test_prog_90_downloadkeyboards
  test_prog_macosx_10_downloadkeyboards
  test_root
}

builder_run_action configure  bootstrap_configure
builder_run_action clean      clean_docker_container $TAVULTESOFT_IMAGE_NAME $TAVULTESOFT_CONTAINER_NAME
builder_run_action stop       stop_docker_container  $TAVULTESOFT_IMAGE_NAME $TAVULTESOFT_CONTAINER_NAME
builder_run_action build      build_docker_container $TAVULTESOFT_IMAGE_NAME $TAVULTESOFT_CONTAINER_NAME $BUILDER_CONFIGURATION
builder_run_action start      start_docker_container $TAVULTESOFT_IMAGE_NAME $TAVULTESOFT_CONTAINER_NAME $TAVULTESOFT_CONTAINER_DESC $HOST_TAVULTESOFT_COM $PORT_TAVULTESOFT_COM $BUILDER_CONFIGURATION

builder_run_action test       do_test
