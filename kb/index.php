<?php
  if(isset($_REQUEST['ID']))
  {
    $KnowledgeBaseID = $_REQUEST['ID'];
  }
  else if(isset($_REQUEST['id']))
  {
    $KnowledgeBaseID = $_REQUEST['id'];
  }
  else if(isset($_REQUEST['KnowledgeBaseID']))
  {
    $KnowledgeBaseID = $_REQUEST['KnowledgeBaseID'];
  }

  if(isset($KnowledgeBaseID)) {
    header("Location: https://help.keyman.com/knowledge-base/$KnowledgeBaseID", true, 301);
  } else {
    header("Location: https://help.keyman.com/knowledge-base", true, 301);
  }
