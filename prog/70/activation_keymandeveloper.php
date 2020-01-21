<?php /*
  Name:             activation_keymandeveloper
  Copyright:        Copyright (C) 2005 Tavultesoft Pty Ltd.
  Documentation:    
  Description:      
  Create Date:      20 Feb 2009

  Modified Date:    20 Feb 2009
  Authors:          mcdurdin
  Related Files:    
  Dependencies:     

  Bugs:             
  Todo:             
  Notes:            
  History:          20 Feb 2009 - mcdurdin - I1865 - Online activation should include computer name
*/
  require_once('licencenumber.php');
  require_once('machinedata.php');
  
  if(!isset($_REQUEST['LicenceNumber']) || !isset($_REQUEST['ActivationRequestBlob']))
  {
    echo "<error>Invalid input: wrong parameters</error>";
    exit;
  }
  
  $licno = new CRM_Activation_LicenceNumber();
  $LicenceNumber = $licno->Cleanup($_REQUEST['LicenceNumber']); // I1406 - allow licence numbers without hyphens to be accepted
  if(!$licno->Validate($LicenceNumber)) // validates the licence number internally and against the CRM database
  {
    echo "<error>Invalid licence number</error>";
    exit;
  }
  
  $machdata = new CRM_Activation_MachineData();
  if(!$machdata->Validate($_REQUEST['ActivationRequestBlob'], $LicenceNumber))
  {
    echo "<error>Invalid input: request blob not valid</error>";
    exit;
  }

  echo $machdata->ActivationResponseBlob;
?>
