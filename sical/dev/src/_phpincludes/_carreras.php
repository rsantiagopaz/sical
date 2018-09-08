<?php
function traer_carreras(&$xml,$criterio,$caso,$nivel_id,$filter,$query=false)
{
 	$sql="SELECT id_carrera, codigo, nombre, id_nivel, nivel ";
	$sql.="FROM carreras ";
	$sql.="INNER JOIN niveles USING(id_nivel) ";
	if ($criterio=='nombre')
		$sql.="WHERE nombre LIKE '%$filter%' ";
	else
		$sql.="WHERE codigo = '$filter' ";
	if ($caso != 1) {
		if ($nivel_id != '4')
			$sql.="AND id_nivel = '$nivel_id' ";	
	}
 	if ($query == false) { 		
		toXML($xml, $sql, "carreras");
		return;	
 	}  else {
 		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
 		while ($row = mysqli_fetch_array($result)) {
			$nodo2=$xml->addChild("carrera");			
			foreach($row as $key => $value) {						 
				if (!is_numeric($key)) $nodo2->addAttribute($key, $value);
			}			
			$sql2 = "SELECT * FROM espacios ";
			$sql2 .= "JOIN carreras_espacios USING(id_espacio) ";			
			$sql2 .= "WHERE id_carrera='".$row['id_carrera']."'";			
			$result2 = mysqli_query($GLOBALS["___mysqli_ston"], $sql2);			
			while ($row2 = mysqli_fetch_array($result2)) {
				$nodo3=$nodo2->addChild("espacio");										 
				foreach($row2 as $key => $value) {										 
					if (!is_numeric($key)) $nodo3->addAttribute($key, $value);
				}
			}			
		}
		return $xml->asXML();		
 	}
}
?>
