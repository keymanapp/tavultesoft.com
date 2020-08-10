<?php
  require_once('./licencenumber.php');
  require_once('./machinedata.php');

  function LogErrorExit($s)
  {
    echo "<error>$s</error>";
    exit;
  }

  if(!isset($_REQUEST['ActivationRequestBlob']))
  {
    LogErrorExit("Invalid input: wrong parameters");
  }

  $licno = new CRM_Activation_LicenceNumber();

  if(isset($_REQUEST['LicenceNumber']))
  {
    $FLicenceNumber = $licno->Cleanup($_REQUEST['LicenceNumber']);  // I1406 - allow licence numbers without hyphens to be accepted
    if(!$licno->Validate($FLicenceNumber)) // validates the licence number internally and against the CRM database
    {
      LogErrorExit("Invalid licence number");
    }
  }
  else
    $FLicenceNumber = '';

  $machdata = new CRM_Activation_MachineData();
  if(!$machdata->Validate($_REQUEST['ActivationRequestBlob'], $FLicenceNumber, $err))
  {
    LogErrorExit("Invalid input: request blob not valid");
  }

  if(empty($FLicenceNumber))
  {
    $FLicenceNumber = $machdata->LicenceNumber;
    if(!$licno->Validate($FLicenceNumber))
    {
      LogErrorExit("Activation Request licence number not valid");
    }
  }

  if($licno->OnlineProductID == 1246) {
      /* Do not activate per request of vendor */
      LogErrorExit("Please contact the seller or developer for Activation Code.");
  }

  echo $machdata->ActivationResponseBlob;
?>
