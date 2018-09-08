<?php
function traer_escuelas($xml,$criterio,$filter,$nivel_id,$caso=1)
{
 	$sql="SELECT * ";
	$sql.="FROM escuelas ";
	$sql.="INNER JOIN niveles USING(id_nivel) ";
	$sql.="INNER JOIN localidades USING(id_localidad) ";
	$sql.="INNER JOIN departamentos USING(id_departamento) ";
	if ($criterio=='nombre') {
		$filter = strtoupper($filter);
		$sql.="WHERE nombre LIKE '%$filter%' ";
	} else
		$sql.="WHERE codigo = '$filter' ";
	if ($caso==1)
		$sql.="AND id_nivel = '$nivel_id' ";
	else {
		if ($nivel_id != 4)
			$sql.="AND id_nivel = '$nivel_id' ";
	}		
	$sql.="ORDER BY nombre";
	toXML($xml, $sql, "escuelas");
}
?>
