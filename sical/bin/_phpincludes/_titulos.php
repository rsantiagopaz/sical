<?php
function traer_titulos(&$xml,$criterio,$filter)
{
 	$sql="SELECT id_titulo, codigo, denominacion ";
	$sql.="FROM titulos ";
	if ($criterio=='denominacion')
		$sql.="WHERE denominacion like'%$filter%' ";
	else
		$sql.="WHERE codigo = '$filter' ";		
	$sql.="ORDER BY codigo";
	toXML($xml, $sql, "titulo");	
}		
?>
