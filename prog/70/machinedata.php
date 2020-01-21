<?php
  class CRM_Activation_MachineData
  {
    public $ActivationRequestBlob, $ActivationResponseBlob, $Date, $LicenceNumber, $MachineData, $ComputerName;
    
    function Validate($ActivationRequestBlob, $LicenceNumber = '', &$err = '')
    {
      $klicence_path = __DIR__ . '\\klicence.exe';
      $infpath = tempnam('', 'inf');
    
      $fp = fopen($infpath, 'w');
      fputs($fp, $ActivationRequestBlob);
      fclose($fp);

      $dir = getcwd();
      chdir(__DIR__);
      exec($klicence_path . ' -M "'.$infpath.'"', $str, $retval);
      chdir($dir);

      unlink($infpath);

      if($retval == 1)
      {
        $details = implode(",", $str);
        if(preg_match("/ActivationResponseBlob=(\w+),Date=(\d+),LicenceNumber=(\w{4}-\w{4}-\w{4}-\w{4}-\w{4}+),".
          "MachineData=(\w+),ComputerName=\"(.*)\"/", $details, $dformat))
        {
          $this->ActivationResponseBlob = $dformat[1];
          $this->Date = $dformat[2];
          $this->LicenceNumber = $dformat[3];
          $this->MachineData = $dformat[4];
          $this->ComputerName = iconv("CP1252", "UTF-8//IGNORE", $dformat[5]);
          
          $err = $str;
          return empty($LicenceNumber) || $this->LicenceNumber == $LicenceNumber;
        }
      }
      $err = $str;
      return false;
    }
  }
