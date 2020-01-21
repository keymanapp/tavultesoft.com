<?php
  // Static updatecheck.php for Keyman versions 7-9

  $versions = [
    1  => [ "id" => 1, "version" => "7.1.273.0", "size" => 6033064, "url" => "https://downloads.keyman.com/windows/stable/7.1.273.0/keymandesktoppro-7.1.273.0.exe" ],
    8  => [ "id" => 8, "version" => "7.1.273.0", "size" => 5382072, "url" => "https://downloads.keyman.com/windows/stable/7.1.273.0/keymandesktoplight-7.1.273.0.exe" ],
    12 => [ "id" => 12, "version" => "8.0.361.0", "size" => 8244952, "url" => "https://downloads.keyman.com/windows/stable/8.0.361.0/keymandesktop-8.0.361.0.exe" ],
    20 => [ "id" => 20, "version" => "9.0.528.0", "size" => 16327624, "url" => "https://downloads.keyman.com/windows/stable/9.0.528.0/keymandesktop-9.0.528.0.exe" ],
    4  => [ "id" => 4, "version" => "7.1.269.0", "size" => 0, "url" => "https://keyman.com/downloads/archive" ],
    14 => [ "id" => 14, "version" => "8.0.360.0", "size" => 24971928, "url" => "https://downloads.keyman.com/developer/stable/8.0.360.0/keymandeveloper-8.0.360.0.exe" ],
    22 => [ "id" => 22, "version" => "9.0.526.0", "size" => 33876408, "url" => "https://downloads.keyman.com/developer/stable/9.0.526.0/keymandeveloper-9.0.526.0.exe" ],
  ];

  // NOTE: We no longer support updating keyboards for old versions of Keyman (9.0 and earlier)

  $update = '';
  $Error = '';
  $Message = '';

  if(isset($_REQUEST['Raw'])) $Raw = $_REQUEST['Raw']; else $Raw = 0;
  // Online update requests from Setup have Raw=1 set

  if(!$Raw) header('Content-Type: text/xml', true);
  else header('Content-Type: text/plain', true);

  if(!isset($_REQUEST['OnlineProductID']) || !isset($_REQUEST['Version'])) {
    /* Invalid update check */
    $Error = 'Invalid Parameters - expected OnlineProductID and Version';
  }
  else {
    /* Valid update check */
    $OnlineProductID = $_REQUEST['OnlineProductID'];
    $Version = $_REQUEST['Version'];

    if(!array_key_exists($OnlineProductID, $versions)) {
      $Error = 'Invalid OnlineProductID';
    } 
    else {
      $v = $versions[$OnlineProductID];
      if($v['version'] == $Version || $OnlineProductID == 4) {
        // We don't have any updates for Developer 7.x
        $Message = 'No updates are currently available.';
      } else {
        $Message = "An update, version ${v['version']}, is available for download from http://keyman.com/downloads/archive but is not currently available as an automatic update.";
        $update = "<update ".
          "onlineproductid='${v['id']}' ".
          "oldversion='$Version' ".
          "newversion='${v['version']}' ".
          "installurl='${v['url']}' ".
          "installsize='${v['size']}' ".
          "patchurl='' ".
          "patchsize='0' />";
      }
    }
  }


  if($Raw) {
    // We don't need to list update details for older versions with Raw=1 because
    // these were only called from the installer. Most people installing older versions
    // will have the latest older version.
    
    if(!empty($Error)) {
      echo "fatal=$Error";
    }
    if(!empty($Message)) {
      echo "message=$Message";
    }
  } else {
    //
    // Report back a valid blob of data so older versions continue to behave correctly
    //

    echo '<?xml version="1.0" encoding="utf-8"?>';
    echo "<updatecheck>";
    
    echo $update;

    if(!empty($Error)) {
      echo "<message severity='fatal'>$Error</message>";
    }
    if(!empty($Message)) {
      echo "<message>$Message</message>";
    }
    echo "</updatecheck>";
  }
