<?php
   $SERVIDOR = "localhost";
   $USUARIO  = "root";
   $PASSWORD = "";
   $BASE     = "sical";
   $link = @($GLOBALS["___mysqli_ston"] = mysqli_connect($SERVIDOR,  $USUARIO,  $PASSWORD));
   @((bool)mysqli_query( $link, "USE $BASE"));
   mysqli_query($GLOBALS["___mysqli_ston"], "SET NAMES 'utf8'");
?>