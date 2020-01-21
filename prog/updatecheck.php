<?php
  $NoPageView = true;
  define('KeymanVersion', '6.2.183.0');
  define('KeymanCIMUVersion', '6.1.166.0');
  define('KeymanDeveloperVersion', '6.2.183.0');
  
  header('Content-Type: application/xml');
  
  echo '<?xml version="1.0" encoding="ISO-8859-1"?>';
  echo "<updatecheck>";

  if(!isset($_REQUEST['Application']) || !isset($_REQUEST['Version']))
  {
    echo "<error>Invalid Parameters - expected Application and Version.</error>";
    echo "</updatecheck>";
    return false;
  }

  $Application = $_REQUEST['Application'];
  $Version = $_REQUEST['Version'];
  
  if(CheckVersion($Title, $NewVersion, $DownloadURL))
  { //NewVersion now not used to disable auto update check for v6 
    echo "<application name=\"$Application\" title=\"$Title\" version=\"$Version\" newversion=\"$Version\" downloadurl=\"$DownloadURL\" />";
  }
  
  echo "</updatecheck>";
  
  function CheckVersion(&$Title, &$NewVersion, &$DownloadURL)
  {
    global $Application, $Version;
  
    switch(strtolower($Application))
    {
      case 'keyman':
        $NewVersion = KeymanVersion;
        $Title = "Keyman";
        $DownloadURL = 'http://www.tavultesoft.com/keyman/downloads/';
        break;
      case 'keymandeveloper':
        $NewVersion = KeymanDeveloperVersion;
        $Title = "Keyman Developer";
        $DownloadURL = 'http://www.tavultesoft.com/keymandev/downloads/';
        break;
      case 'keyman-cimu':
        $NewVersion = KeymanCIMUVersion;
        $Title = "Keyman for CIMU";
        $DownloadURL = 'http://www.cimu.gov.mt/htdocs/content.asp?c=498';
        break;
      default:
        echo "<error>Invalid Parameter Value for Application.</error>";
        return false;
    }
    return true;
  }
?>