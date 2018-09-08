<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

function copiar_inscripcion($id_llamado_destino_copia,$id_docente_llamado,$con_cargo) {
	$sql = "INSERT INTO docentes_llamados ";
	$sql.= "(id_docente,id_llamado,fecha_inscripcion,estado,selecciona_cargo,depto_aplicacion,depto_inicial,depto_primario,folios,tipo_jornada,ruralidad,id_region,orden,con_cargo,usuario) ";
	$sql.= "SELECT id_docente,$id_llamado_destino_copia,fecha_inscripcion,estado,selecciona_cargo,depto_aplicacion,depto_inicial,depto_primario,folios,tipo_jornada,ruralidad,id_region,orden,$con_cargo,usuario ";
	$sql.= "FROM docentes_llamados ";
	$sql.= "WHERE id_docente_llamado=$id_docente_llamado AND con_cargo=$con_cargo";	
	$id_docente_llamado_new = query($sql);
	
	$sql = "INSERT INTO docentes_llamados_observaciones ";
	$sql.= "(id_docente_llamado,id_observacion,comentarios) ";
	$sql.= "SELECT $id_docente_llamado_new,id_observacion,comentarios ";
	$sql.= "FROM docentes_llamados_observaciones ";
	$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
	query($sql);
	
	$sql = "INSERT INTO docentes_llamados_escuelas ";
	$sql.= "(id_docente_llamado,id_escuela) ";
	$sql.= "SELECT $id_docente_llamado_new,id_escuela ";
	$sql.= "FROM docentes_llamados_escuelas ";
	$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
	query($sql);
	
	$sql = "INSERT INTO docentes_llamados_cargos ";
	$sql.= "(id_docente_llamado,id_cargo) ";
	$sql.= "SELECT $id_docente_llamado_new,id_cargo ";
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

function dar_de_baja_inscripciones($id_llamado) {
	$sql = "SELECT id_docente_llamado FROM docentes_llamados WHERE id_llamado='$id_llamado'";
	$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	while ($row = mysqli_fetch_array($result)) {
		$xml=new SimpleXMLElement('<rows/>');
		
		$id_docente_llamado = $row['id_docente_llamado'];
		$sql= "DELETE ta FROM docentes_llamados_titulos_antecedentes ta ";
		$sql.= "INNER JOIN docentes_llamados_titulos t USING(id_docente_llamado_titulo) ";
		$sql.= "WHERE t.id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");		
		
		$sql= "DELETE FROM docentes_llamados_titulos ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");		
		
		$sql= "DELETE FROM docentes_llamados_escuelas ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");		
		
		$sql= "DELETE FROM docentes_llamados_cargos ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");		
		
		$sql= "DELETE FROM docentes_llamados_observaciones ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");		
		
		$sql= "DELETE FROM reclamos ";
		$sql.= "WHERE id_docentes_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");		
		
		$sql= "DELETE FROM docentes_llamados ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");
	}				
}

switch ($_REQUEST['rutina'])
{		
	case 'traer_datos': {
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql= "SELECT id_llamado, CONCAT(nro_llamado,'-',descripcion) 'desc' ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE id_tipo_clasificacion='1' AND id_subtipo_clasificacion='5' ";
		$sql.= "AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.= "ORDER BY nro_llamado ";
		toXMLtag($xml, $sql, "llamados");
		
		
		$sql= "SELECT id_tipo_doc, tipo_doc ";
		$sql.= "FROM tipos_documentos ";
		toXML($xml, $sql, "tdoc");
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	
	case 'traer_llamados': {
		$descripcion = strtoupper($descripcion);
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql= "SELECT id_llamado, descripcion, nro_llamado ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE estado='A' ";
		$sql.= "AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.= "AND descripcion LIKE '%$descripcion%' ";
		$sql.= "ORDER BY nro_llamado DESC";
		toXML($xml, $sql, "llamados");						
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	
	case 'buscar_llamado': {		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql= "SELECT id_llamado, descripcion, nro_llamado ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE id_tipo_clasificacion='1' AND (id_subtipo_clasificacion='5' OR id_subtipo_clasificacion='9') ";
		$sql.= "AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.= "AND nro_llamado = '$nro_llamado' ";
		$sql.= "ORDER BY nro_llamado DESC";
		toXML($xml, $sql, "llamados");						
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	
	case "separar_llamado":{		
		$sql ="SELECT descripcion, nro_llamado FROM llamados ";
		$sql.= "WHERE id_llamado = '$id_llamado' ";
		$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row=mysqli_fetch_array($result);
		$descripcion = $row['descripcion'];
		$nro_llamado_separado = $row['nro_llamado'];				
		
		// Verificar si ya se había separado el llamado con anterioridad
		$sql = "SELECT COUNT(*) 'CANT' FROM llamados_separados_creados WHERE id_llamado_original='$id_llamado'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		if ($row['CANT'] == 0) {
			// Determinar el máximo número de llamado para el nivel correspondiente
	        @mysqli_query($GLOBALS["___mysqli_ston"], "LOCK TABLES llamados READ WRITE");
		
			$sql="SELECT MAX(nro_llamado) 'maxnro' FROM llamados WHERE id_nivel = '$SYSusuario_nivel_id'";
			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$row = mysqli_fetch_array($result);
			
			// el nuevo número de llamado es igual al mayor número + 1
			$nro_llamado_con_cargo = $row['maxnro'] + 1;
			$nro_llamado_sin_cargo = $row['maxnro'] + 2;
			$descripcion_llamado_con_cargo = $descripcion . ' CON CARGO';
			$descripcion_llamado_sin_cargo = $descripcion . ' SIN CARGO';
			
			@mysqli_query($GLOBALS["___mysqli_ston"], "UNLOCK TABLES");		
			
			$sql = "INSERT INTO llamados (nro_llamado, descripcion, anio_clasificacion, fecha_desde, fecha_hasta, estado, id_nivel, id_tipo_clasificacion, id_quinquenio, ordinario, id_llam_ant_acum, oculto, id_subtipo_clasificacion, id_llamado_conflictivo) ";
			$sql.= "SELECT '$nro_llamado_con_cargo', '$descripcion_llamado_con_cargo', anio_clasificacion, fecha_desde, fecha_hasta, estado, id_nivel, id_tipo_clasificacion, id_quinquenio, ordinario, id_llam_ant_acum, 'S', id_subtipo_clasificacion, id_llamado_conflictivo ";
			$sql.= "FROM llamados WHERE id_llamado = '$id_llamado'";
			query($sql);
			$id_llamado_con_cargo = ((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);				
			
			$sql = "INSERT INTO llamados (nro_llamado, descripcion, anio_clasificacion, fecha_desde, fecha_hasta, estado, id_nivel, id_tipo_clasificacion, id_quinquenio, ordinario, id_llam_ant_acum, oculto, id_subtipo_clasificacion, id_llamado_conflictivo) ";
			$sql.= "SELECT '$nro_llamado_sin_cargo', '$descripcion_llamado_sin_cargo', anio_clasificacion, fecha_desde, fecha_hasta, estado, id_nivel, id_tipo_clasificacion, id_quinquenio, ordinario, id_llam_ant_acum, 'S', id_subtipo_clasificacion, id_llamado_conflictivo ";
			$sql.= "FROM llamados WHERE id_llamado = '$id_llamado'";
			query($sql);
			$id_llamado_sin_cargo = ((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
			
			$sql = "INSERT INTO llamados_separados_creados (id_llamado_original,id_llamado_con_cargo,id_llamado_sin_cargo,nro_llamado_con_cargo,nro_llamado_sin_cargo) ";
			$sql.= "VALUES ('$id_llamado','$id_llamado_con_cargo','$id_llamado_sin_cargo','$nro_llamado_con_cargo','$nro_llamado_sin_cargo')";
			query($sql);	
		} else {
			$sql = "SELECT * FROM llamados_separados_creados WHERE id_llamado_original='$id_llamado'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$nro_llamado_con_cargo = $row['nro_llamado_con_cargo'];
			$nro_llamado_sin_cargo = $row['nro_llamado_sin_cargo'];
			$id_llamado_con_cargo = $row['id_llamado_con_cargo'];
			$id_llamado_sin_cargo = $row['id_llamado_sin_cargo'];
			dar_de_baja_inscripciones($id_llamado_con_cargo);
			dar_de_baja_inscripciones($id_llamado_sin_cargo);			
		}
		
		// Docentes con cargo
		$sql = "SELECT * FROM docentes_llamados ";
		$sql.= "WHERE con_cargo='1' AND id_llamado = '$id_llamado'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		while ($row = mysqli_fetch_array($result)) {
			$id_docente = $row['id_docente'];
			$id_docente_llamado = $row['id_docente_llamado'];
			
			$sql_d = "SELECT count(id_docente_llamado) as 'c' FROM docentes_llamados ";
			$sql_d.= "WHERE id_docente = '$id_docente' ";
			$sql_d.= "AND id_llamado = '$id_llamado_con_cargo'";		
			$result_d = mysqli_query($GLOBALS["___mysqli_ston"], $sql_d);
			$row_d = mysqli_fetch_array($result_d);		
			if ($row_d['c'] == 0) {					   						   	
				copiar_inscripcion($id_llamado_con_cargo,$id_docente_llamado,1);
			}			
		}
		
		// Docentes sin cargo
		$sql = "SELECT * FROM docentes_llamados ";
		$sql.= "WHERE con_cargo='0' AND id_llamado = '$id_llamado'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		while ($row = mysqli_fetch_array($result)) {
			$id_docente = $row['id_docente'];
			$id_docente_llamado = $row['id_docente_llamado'];
			
			$sql_d = "SELECT count(id_docente_llamado) as 'c' FROM docentes_llamados ";
			$sql_d.= "WHERE id_docente = '$id_docente' ";
			$sql_d.= "AND id_llamado = '$id_llamado_sin_cargo'";		
			$result_d = mysqli_query($GLOBALS["___mysqli_ston"], $sql_d);
			$row_d = mysqli_fetch_array($result_d);		
			if ($row_d['c'] == 0) {					   						   	
				copiar_inscripcion($id_llamado_sin_cargo,$id_docente_llamado,0);
			}			
		}		
						
		header('Content-Type: text/xml');
		$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
		$xml .= "<xml>";
		$xml .= "<nro_llamado_con_cargo>$nro_llamado_con_cargo</nro_llamado_con_cargo>";
		$xml .= "<nro_llamado_sin_cargo>$nro_llamado_sin_cargo</nro_llamado_sin_cargo>";
		$xml.= "</xml>";					
		header('Content-Type: text/xml');
		print $xml;
	}	
}
?>