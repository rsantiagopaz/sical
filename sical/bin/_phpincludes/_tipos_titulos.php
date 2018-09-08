<?php
 function traer_tipos_titulos(&$xml)
 { 		  	
  	$sql="SELECT * ";
	$sql.="FROM tipos_titulos ";				
	$sql.="ORDER BY tipo";
	toXML($xml, $sql, "tipostitulos");
 }
?>
