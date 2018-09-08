<?php 
 function traer_espacios(&$xml,$criterio,$filter)
 {
 	$sql="SELECT * ";
	$sql.="FROM espacios ";
	if ($criterio=='denominacion')
		$sql.="WHERE denominacion LIKE '%$filter%' ";
	else
		$sql.="WHERE codigo = '$filter' ";		
	$sql.="ORDER BY codigo";
	toXML($xml, $sql, "espacios");
 }
?>
