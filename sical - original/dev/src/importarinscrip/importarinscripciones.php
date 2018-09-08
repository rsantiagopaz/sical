<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

ini_set('memory_limit', '256M');

set_time_limit(1200);

$sql_l = "SELECT id_docente, id_docente_llamado
	FROM docentes_llamados 
	WHERE id_llamado = '$id_llamado_origen'";
$result_l = mysqli_query($GLOBALS["___mysqli_ston"], $sql_l);						
while ($row_l = mysqli_fetch_array($result_l)) {
	$id_docente = $row_l['id_docente'];
	$id_docente_llamado = $row_l['id_docente_llamado'];
	$sql_d = "SELECT count(id_docente_llamado) as 'c' FROM docentes_llamados ";
	$sql_d .= "WHERE id_docente = '$id_docente' ";
	$sql_d .= "AND id_llamado = '$id_llamado_destino'";		
	$result_d = mysqli_query($GLOBALS["___mysqli_ston"], $sql_d);
	$row_d = mysqli_fetch_array($result_d);		
	if ($row_d['c'] == 0) {					   						   	
	   	$sql= "INSERT INTO docentes_llamados ";
		$sql.= "(id_docente,id_llamado,fecha_inscripcion,estado,selecciona_cargo,depto_aplicacion,depto_inicial,depto_primario,folios,tipo_jornada,ruralidad,id_region,orden,usuario) ";
		$sql.="SELECT id_docente,$id_llamado_destino,NOW(),1,selecciona_cargo,depto_aplicacion,depto_inicial,depto_primario,folios,tipo_jornada,ruralidad,id_region,orden,'" . $_SESSION['usuario'] . "' ";
		$sql.= "FROM docentes_llamados ";
		$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
		$id_docente_llamado_new = query($sql);
		
		$sql= "INSERT INTO docentes_llamados_observaciones ";
		$sql.= "(id_docente_llamado,id_observacion,comentarios) ";
		$sql.="SELECT $id_docente_llamado_new,id_observacion,comentarios ";
		$sql.= "FROM docentes_llamados_observaciones ";
		$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
		query($sql);
		
		$sql= "INSERT INTO docentes_llamados_escuelas ";
		$sql.= "(id_docente_llamado,id_escuela) ";
		$sql.="SELECT $id_docente_llamado_new,id_escuela ";
		$sql.= "FROM docentes_llamados_escuelas ";
		$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
		query($sql);
		
		$sql= "INSERT INTO docentes_llamados_cargos ";
		$sql.= "(id_docente_llamado,id_cargo) ";
		$sql.="SELECT $id_docente_llamado_new,id_cargo ";
		$sql.= "FROM docentes_llamados_cargos ";
		$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
		query($sql);
		
		$sql="SELECT * ";
		$sql.= "FROM docentes_llamados_titulos ";
		$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		if (!((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))){
			while($row = mysqli_fetch_array($result)){
				$sql= "INSERT INTO docentes_llamados_titulos ";
				$sql.= "SET id_docente_llamado=$id_docente_llamado_new, ";
				$sql.="id_titulo='".$row['id_titulo']."', ";
				$sql.="id_observ_titulo='".$row['id_observ_titulo']."', ";
				$sql.="comentario='".$row['comentario']."'";
				$id_docente_llamado_titulo_new = query($sql);
				
				$sql= "INSERT INTO docentes_llamados_titulos_antecedentes ";
				$sql.= "(id_docente_llamado_titulo,id_antecedente,unidades,acum_historico) ";
				$sql.="SELECT $id_docente_llamado_titulo_new,id_antecedente,unidades,acum_historico ";
				$sql.= "FROM docentes_llamados_titulos_antecedentes ";
				$sql.= "WHERE id_docente_llamado_titulo=".$row['id_docente_llamado_titulo']." ";
				query($sql);
			}
		} else {
			$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))."\n";
		}	
	}					
}
if ($error!="") {
	$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	$xml .= "<xml>";
	$xml .= "<error>$error</error>";			
	$xml.= "</xml>";
	header('Content-Type: text/xml');
	print $xml;					
} else {					
	$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	$xml .= "<xml>";
	$xml .= "<ok>1</ok>";
	$xml.= "</xml>";					
	header('Content-Type: text/xml');
	print $xml;					
}
?>
