<?php 
 function traer_cargos(&$xml,$caso,$criterio,$filter,$nivel_id='')
 {
 	$sql="SELECT id_cargo, codigo, denominacion, id_nivel, nivel, IF(jornada_completa='1','Si','No') 'jornada_completa', (CASE WHEN subtipo='C' THEN 'Capacitación' WHEN subtipo='E' THEN 'Especial' WHEN subtipo='A' THEN 'Adultos' END) 'subtipo', 'N' as origen ";
	$sql.="FROM cargos ";
	$sql.="INNER JOIN niveles USING(id_nivel) ";
	if ($criterio=='denominacion')
		$sql.="WHERE denominacion LIKE '%$filter%' ";
	else
		$sql.="WHERE codigo = '$filter' ";
	if ($caso != 1)
		$sql.="AND id_nivel = '$nivel_id' ";		
	$sql.="ORDER BY denominacion";	
	toXML($xml, $sql, "cargos");
 }
?>
