<?php
 function traer_tipos_clasificacion(&$xml)
 {
 	$sql="SELECT * ";
	$sql.="FROM tipos_clasificacion ";				
	$sql.="ORDER BY denominacion";
	toXML($xml, $sql, "tiposclasificacion");
 }
?>
