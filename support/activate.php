<!DOCTYPE html>
<html>
<head>
  <title>Keyman Desktop/Developer 7.0-9.0 Manual Activation Self-Service</title>
</head>
<body>

<?php
  require_once('../prog/70/licencenumber.php');
  require_once('../prog/70/machinedata.php');

  $result = '';
  $error = '';

  if(!CheckResult($result, $error)) {
    $result = "<p style='color:red'>$error</p>";
  }

  function CheckResult(&$result, &$error) {
    if(!isset($_POST['ActivationRequestBlob'])) {
      return true;
    }

    $blob = $_POST['ActivationRequestBlob'];
    if(!preg_match('/^[a-fA-F0-9 \r\n]+$/', $blob)) {
      $error = "Activation Request Data is not valid format. Only hexadecimal formatted blobs are permitted.";
      return false;
    }

    $licno = new CRM_Activation_LicenceNumber();
    $FLicenceNumber = '';

    $machdata = new CRM_Activation_MachineData();
    if(!$machdata->Validate($blob, '', $err)) {
      $error = "Invalid input: request was not valid.  Make sure you paste the request data unmodified: $err.";
      return false;
    }

    if(!$licno->Validate($machdata->LicenceNumber)) {
      $error = "Activation Request licence number was not valid";
      return false;
    }

    if($licno->OnlineProductID == 1246) {
      /* Do not activate per request of vendor */
      $error = "Please contact the seller or developer for Activation Code.";
      return false;
    }

    $result = "<p>Activation was successful.  Please copy the activation response below to the clipboard and paste ".
    "it into the manual activation dialog to complete activation.</p>";
    $result .= "<textarea id='block' cols='100' rows='20' class='block'>".chunk_split($machdata->ActivationResponseBlob, 96, "\n")."</textarea>";
    $result .= "<script>with(document.getElementById('block')) { focus(); select(); }</script>";
    $result .= "<p><a href='/'>Return home</a> | <a href='activate.php'>Process another manual activation</a></p>";
    return true;
  }
?>

<h1>Manual Product Activation Self-Service</h1>

<p>This activation tool is for Keyman Desktop and Keyman Developer, versions 7.0 - 9.0.</p>

<p>Recommended: <a href='https://keyman.com/downloads'>Download current versions of Keyman Desktop and Keyman Developer</a></p>

<form method="post" action="activate.php">
  Paste activation request data: <textarea rows="16" cols="64" name="ActivationRequestBlob"></textarea>
  <input type="submit" value="Submit">
</form>

<?php echo $result; ?>
<p><a href='http://help.keyman.com/products/desktop/9.0/docs/basic_manual_activate.php'>Help on Manual Activation</a></p>

</body>
</html>