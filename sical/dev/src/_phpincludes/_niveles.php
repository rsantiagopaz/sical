<?php 
function traer_niveles(&$xml,$nivel_id='')
{
	$sql="SELECT * ";
	$sql.="FROM niveles ";
	if ($nivel_id != '')
		if ($nivel_id != '4')
			$sql.="WHERE id_nivel = '$nivel_id' ";
	$sql.="ORDER BY nivel";
	toXML($xml, $sql, "niveles");
}
?>
