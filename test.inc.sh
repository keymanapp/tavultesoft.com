set -eu

# testhost="https://tavultesoft.keyman-staging.com"
testhost="http://tavultesoft.com.localhost:8063"

function test_redirect() {
  local origin="$1"
  local expectedTarget="$2"
  local url="$testhost$origin"
  builder_echo grey "Testing $url"
  local result="$(curl --silent -f -I "$url")"
  # echo "$result"
  local actualTarget="$(echo "$result" | grep -i "Location:" | cut -d' ' -f2 -)"
  if [[ "$actualTarget" != "$expectedTarget" ]]; then
    builder_echo error "URL '$url' did not redirect to expected '$expectedTarget'"
    echo
    echo "$result"
    echo
    builder_die "Redirect test failed"
  fi
}

function test_keyman_htaccess() {
  test_redirect "/keyman/downloads/keyboards" "https://keyman.com/keyboards"
  test_redirect "/keyman/downloads/keyboards/something" "https://keyman.com/keyboards"
  test_redirect "/keyman/downloads" "https://keyman.com/desktop/download"
  test_redirect "/keyman/download.php" "https://keyman.com/desktop/download.php"
  test_redirect "/keyman/download/" "https://keyman.com/desktop/download.php"
  test_redirect "/keyman/downloadanything.php" "https://keyman.com/downloads/archive/"
  test_redirect "/keyman/faq.php" "https://help.keyman.com/products/desktop/9.0/docs/common.php"
  test_redirect "/keyman/unicode.php" "https://keyman.com/desktop/"
  test_redirect "/keyman/register.php" "$testhost/closed"
}

function test_keyman_support_htaccess() {
  test_redirect "/keyman/support/faq001.php" "https://help.keyman.com/knowledge-base/2"
  test_redirect "/keyman/support/faq002.php" "https://help.keyman.com/knowledge-base/3"
  test_redirect "/keyman/support/faq003.php" "https://help.keyman.com/knowledge-base/4"
  test_redirect "/keyman/support/faq004.php" "https://help.keyman.com/knowledge-base/5"
  test_redirect "/keyman/support/faq005.php" "https://help.keyman.com/knowledge-base/6"
  test_redirect "/keyman/support/faq006.php" "https://help.keyman.com/knowledge-base/7"
  test_redirect "/keyman/support/faq007.php" "https://help.keyman.com/knowledge-base/8"
  test_redirect "/keyman/support/faq008.php" "https://help.keyman.com/knowledge-base/9"
  test_redirect "/keyman/support/faq009.php" "https://help.keyman.com/knowledge-base/10"
  test_redirect "/keyman/support/faq010.php" "https://help.keyman.com/knowledge-base/11"
  test_redirect "/keyman/support/faq011.php" "https://help.keyman.com/knowledge-base/14"
  test_redirect "/keyman/support/faq012.php" "https://help.keyman.com/knowledge-base/15"
  test_redirect "/keyman/support/faq013.php" "https://help.keyman.com/knowledge-base/12"
  test_redirect "/keyman/support/faq014.php" "https://help.keyman.com/knowledge-base/13"
  test_redirect "/keyman/support/faq.php" "https://help.keyman.com/knowledge-base/"
  test_redirect "/keyman/support/sysreq.php" "http://help.keyman.com/products/desktop/9.0/docs/about_requirements.php"
  test_redirect "/keyman/support/index.php" "http://help.keyman.com/products/desktop/9.0/"
  test_redirect "/keyman/support/" "http://help.keyman.com/products/desktop/9.0/"
  test_redirect "/keyman/support/locale" "https://help.keyman.com/products/desktop/12.0/docs/advanced_locale_edit.php"
}

function test_keyman_documentation_htaccess() {
  test_redirect "/keyman/documentation/" "http://help.keyman.com/products/desktop/"
  test_redirect "/keyman/documentation/index.php" "http://help.keyman.com/products/desktop/"
  test_redirect "/keyman/documentation/versionhistoryindex.php" "http://help.keyman.com/products/desktop/versionhistoryindex.php"
  test_redirect "/keyman/documentation/70/" "http://help.keyman.com/products/desktop/7.0/"
  test_redirect "/keyman/documentation/help/index.php" "http://help.keyman.com/products/desktop/6.0/index.php"
  test_redirect "/keyman/documentation/5.1/index.php" "http://help.keyman.com/products/desktop/5.0/5.1/specification.pdf"
  test_redirect "/keyman/documentation/km5/token" "http://help.keyman.com/products/desktop/5.0/token"
  test_redirect "/keyman/documentation/km4/token" "http://help.keyman.com/products/desktop/4.0/token"
}

function test_forums() {
  test_redirect "/forums/index.php" "$testhost/forums/"
  test_redirect "/forums/index.php?ParentForumCategoryID=3" "$testhost/forums/index.php@parentforumcategoryid=3.html"
  test_redirect "/forums/category.php?ForumCategoryID=45" "$testhost/forums/category.php@forumcategoryid=45.html"
  test_redirect "/forums/topic.php?ForumTopicID=238" "$testhost/forums/topic.php@forumtopicid=238.html"
}

function test_prog_70_downloadkeyboards() {
  test_redirect "/prog/70/downloadkeyboards/?token=foo" "https://keyman.com/keyboards?embed=windows&token=foo"
}

function test_prog_80_downloadkeyboards() {
  test_redirect "/prog/80/downloadkeyboards/?token=foo" "https://keyman.com/keyboards?embed=windows&token=foo"
}

function test_prog_90_downloadkeyboards() {
  test_redirect "/prog/90/downloadkeyboards/?token=foo" "https://keyman.com/keyboards?embed=windows&token=foo"
}

function test_prog_macosx_10_downloadkeyboards() {
  test_redirect "/prog/macosx/10/downloadkeyboards/?token=foo" "https://keyman.com/keyboards?embed=macos&token=foo"
}

function test_root() {
  test_redirect "/keyman/downloads/keyman6-0-158.exe" "$testhost/tamil/"
  test_redirect "/beta/something" "https://keyman.com/beta/"
  test_redirect "/keymandev/regtest.dtd" "https://api.keyman.com/schemas/regtest/regtest.dtd"
  test_redirect "/70/anything" "https://keyman.com/desktop/"
  test_redirect "/burmese/anything" "https://keyman.com/burmese/"
  test_redirect "/ethiopic/anything" "https://keyman.com/amharic/"
  test_redirect "/eurolatin/anything" "https://keyman.com/eurolatin/"
  test_redirect "/greek/anything" "https://keyman.com/greek/"
  test_redirect "/ipa/anything" "https://keyman.com/ipa/"
  test_redirect "/isis/anything" "https://keyman.com/keyboards?q=isis"

  test_redirect "/keyboards/?id=khmer_angkor" "https://keyman.com/keyboards/khmer_angkor"
  test_redirect "/keyboards?ID=khmer_angkor" "https://keyman.com/keyboards/khmer_angkor"
  test_redirect "/keyboards/index.php?KeyboardID=khmer_angkor" "https://keyman.com/keyboards/khmer_angkor"
  test_redirect "/keyboards/?keyboardid=khmer_angkor" "https://keyman.com/keyboards/khmer_angkor"

  test_redirect "/keyboards/?Search=khmer" "https://keyman.com/keyboards/?q=khmer"
  test_redirect "/keyboards/?q=khmer" "https://keyman.com/keyboards/?q=khmer"

  test_redirect "/lswin" "https://laoscript.net/"

  test_redirect "/sinhala/anything" "https://keyman.com/sinhala/"
  test_redirect "/tamil/anything" "https://keyman.com/tamil/"
  test_redirect "/tibetan/anything" "https://keyman.com/tibetan/"

  test_redirect "/index.php" "https://keyman.com/"
  test_redirect "/products.php" "https://keyman.com/"
  test_redirect "/support.php" "https://help.keyman.com/"
  test_redirect "/testimonials.php" "https://keyman.com/testimonials"

  test_redirect "/keymandev/register" "$testhost/closed"
  test_redirect "/keymandev/documentation" "https://help.keyman.com/developer"
  test_redirect "/keymandev/support" "https://help.keyman.com/developer"
  test_redirect "/keymandev/anything.php" "https://keyman.com/developer/"
  test_redirect "/keymandev/download" "https://keyman.com/developer/download"
  test_redirect "/keymandev/quality/whitepaper-1.0.pdf" "https://help.keyman.com/developer/keyboards/whitepaper/whitepaper-1.0.pdf"
  test_redirect "/keymandev/visualkeyboard.dtd" "https://api.keyman.com/schemas/visualkeyboard/visualkeyboard.dtd"
  test_redirect "/keymanweb/bookmarklet.php" "https://keyman.com/bookmarklet/"
  test_redirect "/keymanweb/anything" "https://keyman.com/developer/keymanweb/"

  test_redirect "/buy/80/wizard.php" "https://keyman.com/downloads/archive/legacy-embed.php"
  test_redirect "/buy/90/wizard.php" "https://keyman.com/downloads/archive/legacy-embed.php"

  test_redirect "/buy/anything" "$testhost/closed"
  test_redirect "/ctc08" "$testhost/closed"
  test_redirect "/pay" "$testhost/closed"
  test_redirect "/search/anything" "$testhost/closed"
  test_redirect "/tsactsrv" "$testhost/closed"
  test_redirect "/video" "$testhost/closed"
  test_redirect "/account/" "$testhost/closed"

  # random subset of root pages
  test_redirect "/about.php" "$testhost/closed"
  test_redirect "/code.php" "$testhost/closed"
  test_redirect "/contact.php" "$testhost/closed"
  test_redirect "/services.php" "$testhost/closed"
  test_redirect "/terms.php" "$testhost/closed"

  test_redirect "/orderform.pdf" "$testhost/closed"

  # TODO: this is a rewrite, not a redirect
  # test_redirect "/prog/submitdiag.php" "https://api.keyman.com/desktop/10.0/submitdiag"

  test_redirect "/partners" "$testhost/closed"

  test_redirect "/prog/90/keepintouch" "https://keyman.com/desktop/keepintouch-100"
  test_redirect "/prog/70/downloadlocales/all.php" "$testhost/prog/100/downloadlocales/locale-global-download.kmp"
  test_redirect "/prog/100/downloadlocales/all.php" "$testhost/prog/100/downloadlocales/locale-global-download.kmp"

  test_redirect "/support/" "https://help.keyman.com/products/desktop/9.0/"
  test_redirect "/support/uninstall" "https://keyman.com/uninstall/"
  test_redirect "/support/exception.php?IssueID=123" "https://keyman.com/go/desktop/10.0/view-exception?id=123"

  # TODO: this is a rewrite, not a redirect
  #test_redirect "/prog/70/crash.php" "https://api.keyman.com/desktop/10.0/exception"

  test_redirect "/kb/browse.php" "https://help.keyman.com/knowledge-base"
  test_redirect "/kb/?id=11" "https://help.keyman.com/knowledge-base/11"
  test_redirect "/kb/index.php?ID=12" "https://help.keyman.com/knowledge-base/12"
  test_redirect "/kb/index.php?KnowledgeBaseID=13" "https://help.keyman.com/knowledge-base/13"

  test_redirect "/go/90/download.php?Keyboard=khmer_angkor" "https://keyman.com/keyboards/khmer_angkor"

  test_redirect "/download_direct/charident.exe"  "$testhost/closed"
  test_redirect "/download_direct/importkeyboard.exe"  "$testhost/closed"
  test_redirect "/download_direct/keymandesktop/anything"  "https://downloads.keyman.com/windows/stable/"
  test_redirect "/download_direct/keymandeveloper/anything"  "https://downloads.keyman.com/developer/stable/"
}