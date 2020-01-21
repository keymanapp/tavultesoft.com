<?php
  class CRM_Activation_LicenceNumber
  {
    public $LicenceNumber;
    public $OnlinePurchaseID, $RndComponent, $OnlineProductID, $SeatCount, $OnlinePurchaseTypeID;
    
    function Validate($LicenceNumber)
    {
      $klicence_path = __DIR__ . '\\klicence.exe';
      
      $infpath = tempnam('', 'inf');
    
      $fp = fopen($infpath, 'w');
      fputs($fp, "LicenceNumber=$LicenceNumber\n");
      fclose($fp);

      $dir = getcwd();
      chdir(__DIR__);
      exec($klicence_path . ' -D "'.$infpath.'"', $str, $retval);
      chdir($dir);

      unlink($infpath);
      if($retval == 1)
      {
        $details = implode(",", $str);
        if(preg_match("/OnlinePurchaseID=(\d+),RndComponent=(\d+),OnlineProductID=(\d+),".
          "SeatCount=(\d+),OnlinePurchaseTypeID=(\d+)/", $details, $dformat))
        {
          $this->LicenceNumber = $LicenceNumber;
          $this->OnlinePurchaseID = $dformat[1];
          $this->RndComponent = $dformat[2];
          $this->OnlineProductID = $dformat[3];
          $this->SeatCount = $dformat[4];
          $this->OnlinePurchaseTypeID = $dformat[5];
          return true;
        }
      }
      return false;
    }
    
    function CleanUp($LicenceNumber)
    {
      $LicenceNumber = trim(str_replace('-', '', $LicenceNumber));
      return 
        substr($LicenceNumber, 0, 4) . '-' .
        substr($LicenceNumber, 4, 4) . '-' .
        substr($LicenceNumber, 8, 4) . '-' .
        substr($LicenceNumber, 12, 4) . '-' .
        substr($LicenceNumber, 16, 4);
    }
  }
?>