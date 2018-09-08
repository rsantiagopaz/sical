<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

ini_set('memory_limit', '256M');

set_time_limit(1200);

// Llamado desde el cual se quieren copiar los comentarios de las observaciones
$sql_l = "SELECT id_docente, id_docente_llamado
	FROM docentes_llamados 
	WHERE (id_llamado = '640' OR id_llamado = '641')";
$result_l = mysqli_query($GLOBALS["___mysqli_ston"], $sql_l);						
while ($row_l = mysqli_fetch_array($result_l)) {
	$id_docente = $row_l['id_docente'];
	$id_docente_llamado = $row_l['id_docente_llamado'];
	// Llamado al cual se quieren copiar los comentarios de las observaciones
	$sql_d = "SELECT count(id_docente_llamado) as 'c' FROM docentes_llamados ";
	$sql_d .= "WHERE id_docente = '$id_docente' ";
	$sql_d .= "AND id_llamado = '887'";		
	$result_d = mysqli_query($GLOBALS["___mysqli_ston"], $sql_d);
	$row_d = mysqli_fetch_array($result_d);		
	if ($row_d['c'] > 0) {
		$sql = "SELECT * FROM docentes_llamados ";
		$sql .= "WHERE id_docente = '$id_docente' ";
		$sql .= "AND id_llamado = '887'";		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		$id_docente_llamado_nuevo = $row['id_docente_llamado'];						   						   		   	
		
		$sql = "SELECT * FROM docentes_llamados_observaciones ";
		$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		if (mysqli_num_rows($result) > 0) {
			$row = mysqli_fetch_array($result);
		
			$id_observacion = $row['id_observacion'];
			$id_doc_llamado_observ = $row['id_doc_llamado_observ'];
			$comentarios = $row['comentarios'];
			
			$sql = "SELECT * FROM docentes_llamados_observaciones ";
			$sql.= "WHERE id_docente_llamado=$id_docente_llamado_nuevo ";			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			
			$id_observacion_nuevo = $row['id_observacion'];
			$id_doc_llamado_observ_nuevo = $row['id_doc_llamado_observ'];						
			
			if ($id_observacion == $id_observacion_nuevo) {
				$sql= "UPDATE docentes_llamados_observaciones SET comentarios = '$comentarios'";				
				$sql.= "WHERE id_doc_llamado_observ=$id_doc_llamado_observ_nuevo ";
				query($sql);	
			}	
		}													
	}					
}
echo "FIN";
?>
