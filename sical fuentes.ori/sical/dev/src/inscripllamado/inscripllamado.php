<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

function armarObs()
{	
	$error="";	
	$xmlO= "<observaciones>";
	$query = "SELECT * FROM observaciones";
	$result = mysqli_query($GLOBALS["___mysqli_ston"], $query);
	if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false)) > 0) {
  		$error.="Error devuelto por la Base de Datos: ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))." ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))."\n";
	} else {	        
	   	while($row = mysqli_fetch_array($result)) {	
	      $xmlO.= "<observacion>";
	        $xmlO.= "<id_observacion>".$row["id_observacion"]."</id_observacion>";
	        $xmlO.= "<descripcion>".$row["descripcion"]."</descripcion>";
	      $xmlO.= "</observacion>";
	    }
  	} 
    $xmlO.= "</observaciones>";
    $xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	$xml .= "<xml>";
	if (!empty($error))
		$xml .= "<error>$error</error>";
	$xml .= $xmlO;
	$xml.= "</xml>";
	header('Content-Type: text/xml');
	print $xml;
}

function buscarDocente($tipo_doc,$nro_doc)
{
	$error = "";
	$xmlD = "";
	$query = "SELECT * FROM docentes WHERE id_tipo_doc = '$tipo_doc' AND nro_doc = '$nro_doc'";
	$result = mysqli_query($GLOBALS["___mysqli_ston"], $query);
	if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false)) > 0) {
		$error.="Error devuelto por la Base de Datos: ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))." ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))."\n";
	} else {
		$row = mysqli_fetch_array($result);
		$xmlD .= '<docente>';
		$xmlD .= '<id_docente>'.$row['id_docente'].'</id_docente>';
		$xmlD .= '<apellido>'.$row['apellido'].'</apellido>';
		$xmlD .= '<nombres>'.$row['nombres'].'</nombres>';
		$xmlD .= '<domicilio>'.$row['domicilio'].'</domicilio>';
		$xmlD .= '</docente>';
	}
	$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	$xml .= "<xml>";
	if (!empty($error))
		$xml .= "<error>$error</error>";
	$xml .= $xmlD;
	$xml.= "</xml>";
	header('Content-Type: text/xml');
	print $xml;
}

function verificarDobleInscripcion($id_docente,$id_llamado)
{
	$error = "";
	$sql = "SELECT count(id_docente_llamado) as 'c' FROM docentes_llamados ";
	$sql.= "WHERE id_docente = '$id_docente' ";
	$sql.= "AND id_llamado = '$id_llamado'";		
	$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	$row = mysqli_fetch_array($result);		
	if ($row['c'] > 0) {			
		$error.="El docente seleccionado ya ha sido inscripto en el llamado indicado";
	}/* else {
		$sql = "SELECT id_llamado_conflictivo ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE id_llamado = '$id_llamado'";
		$result = mysql_query($sql);
		$row = mysql_fetch_array($result);
		if ($row['id_llamado_conflictivo'] != 0) {
			$sql = "SELECT count(id_docente_llamado) as 'c' FROM docentes_llamados ";
			$sql.= "WHERE id_docente = '$id_docente' ";
			$sql.= "AND id_llamado = '".$row['id_llamado_conflictivo']."'";		
			$result = mysql_query($sql);
			$row = mysql_fetch_array($result);
			if ($row['c'] > 0) {			
				$error.="El docente seleccionado ha sido inscripto en un llamado conflictivo con el llamado indicado";
			}
		}
	}*/
	return $error;
}

switch ($_REQUEST['rutina'])
{
	case 'realizar_inscripcion': {		
		$error = "";		
		$inscripcion = loadXML($_REQUEST["inscripcion"]);
		$insert_inscripcion="";						
		
		$count_childs = 0;
		foreach($inscripcion->children() as $child)
		{						
			$count_childs++;
			if ($child->getName() == 'id_docente')
				$id_docente = $child;
			elseif ($child->getName() == 'id_llamado')
				$id_llamado = $child;			
		}
		$i = 0;
		foreach($inscripcion->children() as $child)
		{	
			$i++;
			if ($i < $count_childs) {
				$insert_inscripcion.= $child->getName() . "='" . $child . "', ";	
			} else {
				$insert_inscripcion.= $child->getName() . "='" . $child . "'";
			}
		}
		$sql = "SELECT estado FROM llamados WHERE id_llamado='$id_llamado'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		$estado_llamado = $row['estado'];
		if ($estado_llamado == 'A') {
			$estado_doc_llam = 1;
		} else {
			$estado_doc_llam = 0;
		}		
		$error.=verificarDobleInscripcion($id_docente,$id_llamado);		
		if ($error == "") {						
			$insert_inscripcion="INSERT INTO docentes_llamados SET " . $insert_inscripcion . ", fecha_inscripcion = NOW(), estado='$estado_doc_llam', usuario='" . $_SESSION['usuario'] . "'";		
			mysqli_query($GLOBALS["___mysqli_ston"], $insert_inscripcion);
			if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
				$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
			} else {
				$id_docente_llamado = ((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);				
				$_descrip = "ALTA DEL DOCENTE_LLAMADO CON id='$id_docente_llamado'";
				_auditoria($insert_inscripcion . ' '. $sql, 
	                    $link_salud1,
						$link_salud1,
						'docentes_llamados',
						$id_docente_llamado,
	                    $_descrip,
	                    '',
	                    '');
				if ($_REQUEST['clasifica'] == 'no') {
					$observaciones = loadXML($_REQUEST['observaciones']);
					foreach ($observaciones->observacion as $observacion) {
						$sql = "INSERT INTO docentes_llamados_observaciones SET id_docente_llamado = '$id_docente_llamado', ";
						$sql .= "id_observacion = '".$observacion->id_observacion."' ";
						if ($observacion->id_observacion == '19')
							$sql .= " ,comentarios='".$observacion->comentarios."'";
						mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
							$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
						}
					}
				}
			}
		}
		$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
		$xml .= "<xml>";
		if (!empty($error))
			$xml .= "<error>$error</error>";
		else
			$xml .= "<id_docente_llamado>$id_docente_llamado</id_docente_llamado>";
		$xml.= "</xml>";
		header('Content-Type: text/xml');
		print $xml;		
		break;
	}
	case "buscar_llamado": {
		$sql = "SELECT organismo_area_id_nivel FROM _organismos_areas WHERE organismo_area_id = '$SYSusuario_organismo_area_id'";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		$id_nivel = $row['organismo_area_id_nivel'];
		
		$sql = "SELECT count(id_llamado) 'c', id_llamado, id_nivel, id_tipo_clasificacion, id_subtipo_clasificacion, descripcion FROM llamados " .
				"WHERE nro_llamado = '".$_REQUEST['nro_llamado']."' AND id_nivel = '$id_nivel'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
		$xml .= "<xml>";
		if ($row['c'] > 0) {
			$xml .= "<id_llamado>".$row['id_llamado']."</id_llamado>";
			$xml .= "<id_nivel>".$row['id_nivel']."</id_nivel>";
			$xml .= "<id_tipo_clasificacion>".$row['id_tipo_clasificacion']."</id_tipo_clasificacion>";
			$xml .= "<id_subtipo_clasificacion>".$row['id_subtipo_clasificacion']."</id_subtipo_clasificacion>";
			$xml .= "<descripcion>".$row['descripcion']."</descripcion>";
		} else {
			$xml .= "<id_llamado></id_llamado>";
			$xml .= "<id_nivel></id_nivel>";
			$xml .= "<id_tipo_clasificacion></id_tipo_clasificacion>";
			$xml .= "<id_tipo_llamado></id_tipo_llamado>";
		}
		$xml.= "</xml>";
		header('Content-Type: text/xml');
		print $xml;
		break;
	}		
	case "traer_observaciones": {	 
	   	armarObs();
	   	break;    
	}	
	case "consulta": {	 
	   	buscarDocente($_REQUEST["tipo_doc"],$_REQUEST["nro_doc"]);
	   	break;    
	}
	case "verificar_doble_inscripcion": {
		$error = 0;
		$id_docente = $_REQUEST['id_docente'];
		$id_llamado = $_REQUEST['id_llamado'];
		$sql = "SELECT count(id_docente_llamado) as 'c' FROM docentes_llamados ";
		$sql.= "WHERE id_docente = '$id_docente' ";
		$sql.= "AND id_llamado = '$id_llamado'";		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);		
		if ($row['c'] > 0) {			
			$error = 1;
		} else {
			$sql = "SELECT id_llamado_conflictivo ";
			$sql.= "FROM llamados ";
			$sql.= "WHERE id_llamado = '$id_llamado'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			if ($row['id_llamado_conflictivo'] != 0) {
				$sql = "SELECT nro_llamado ";
				$sql.= "FROM docentes_llamados ";
				$sql.= "JOIN llamados USING(id_llamado) ";
				$sql.= "WHERE id_docente = '$id_docente' ";
				$sql.= "AND id_llamado = '".$row['id_llamado_conflictivo']."'";		
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);				
				if (mysqli_num_rows($result) > 0) {
					$row = mysqli_fetch_array($result);
					$nro_llamado = $row['nro_llamado'];			
					$error = 2;
				}
			}
		}
		$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
		$xml.= "<xml>";
		$xml.= "<estado>$error</estado>";
		if ($error == 2) $xml.="<nro_llamado>$nro_llamado</nro_llamado>";
		$xml.= "</xml>";					
		header('Content-Type: text/xml');
		print $xml;
		break;
	}
}
?>