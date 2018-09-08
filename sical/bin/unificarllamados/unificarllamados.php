<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

ini_set('memory_limit', '256M');

set_time_limit(1200);

function importar_inscripciones($id_docente, $id_docente_llamado, $id_llamado_destino, &$error)
{												
	$sql_d = "SELECT count(id_docente_llamado) as 'c' FROM docentes_llamados ";
	$sql_d .= "WHERE id_docente = '$id_docente' ";
	$sql_d .= "AND id_llamado = '$id_llamado_destino'";		
	$result_d = mysqli_query($GLOBALS["___mysqli_ston"], $sql_d);
	$row_d = mysqli_fetch_array($result_d);		
	if ($row_d['c'] == 0) {					   						   	
	   	$sql= "INSERT INTO docentes_llamados ";
		$sql.= "(id_docente,id_llamado,fecha_inscripcion,estado,selecciona_cargo,folios,tipo_jornada,ruralidad,id_region,orden,usuario) ";
		$sql.="SELECT id_docente,$id_llamado_destino,NOW(),1,selecciona_cargo,folios,tipo_jornada,ruralidad,id_region,orden,'" . $_SESSION['usuario'] . "' ";
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

switch ($_REQUEST['rutina'])
{
	case 'traer_datos': {
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql= "SELECT id_llamado, CONCAT(CAST(nro_llamado AS CHAR),'-',descripcion) 'desc' ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE (estado='A' or estado='C') ";
		$sql.= "AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.= "ORDER BY nro_llamado ";
		toXMLtag($xml, $sql, "llamados");				
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case "listar_docentes_ambos_llamados": {
		$html='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<style type="text/css">
		body{font-size:13px;font-family:Arial, Helvetica, Serif;margin: 0 auto; width: 850px;}
		h1,h2,h3{text-align:center;background-color:#999999;}
		h1{font-size:20px;}
		h2{font-size:18px;}
		h3{font-size:15px;}
		table{width:100%; border-collapse: collapse;}
		th{font-weight: bold;text-align:center;background-color:#CCCCCC;}
		.title{background-color:#CCCCCC;font-weight:bold;}
		</style>
		</head>
		<body>';
		$html.="<h1>Docentes Inscriptos en Ambos Llamados</h1>";
		// Escribir fecha del reporte
		$date = date("d/m/Y");
		$html.="<p>Fecha: $date</p>";				
		
		$sql = "SELECT id_docente, apellido, nombres, tipo_doc, nro_doc, count( id_docente ) 'cant'
					FROM docentes
					JOIN tipos_documentos
					USING ( id_tipo_doc )
					JOIN docentes_llamados
					USING ( id_docente )
					WHERE id_llamado = '$id_llamado_origen_uno'
					OR id_llamado = '$id_llamado_origen_dos'
					GROUP BY id_docente
					HAVING count( id_docente ) >1
					ORDER BY apellido ASC , nombres ASC";				
				
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$html.="<table>";
		$html.="<thead>";
		$html.="<tr>";
		$html.="<th class='title'>Apellido</th>";
		$html.="<th class='title'>Nombre</th>";
		$html.="<th class='title'>Tipo Doc</th>";
		$html.="<th class='title'>Nro Doc</th>";
		$html.="</tr>";
		$html.="</thead>";
								
		$html.='<tbody>';
		while ($row = mysqli_fetch_array($result)) {		
			$html.="<tr>";
			$html.="<td>".$row['apellido']."</td>";
			$html.="<td>".$row['nombres']."</td>";
			$html.="<td>".$row['tipo_doc']."</td>";
			$html.="<td>".$row['nro_doc']."</td>";
			$html.="</tr>";			
		}
		
		$html.='</tbody>';
		$html.='</table>';
		$html.='</body></html>';
	    
		echo $html;				
		break;
	}	
	case "unificar_llamados": {
		$error = "";
		// Verificar que no existan docentes inscriptos simultáneamente en los dos llamados
		$sql = "SELECT id_docente, apellido, nombres, tipo_doc, nro_doc, count( id_docente ) 'cant'
					FROM docentes
					JOIN tipos_documentos
					USING ( id_tipo_doc )
					JOIN docentes_llamados
					USING ( id_docente )
					WHERE id_llamado = '$id_llamado_origen_uno'
					OR id_llamado = '$id_llamado_origen_dos'
					GROUP BY id_docente
					HAVING count( id_docente ) >1
					ORDER BY apellido ASC , nombres ASC";
					
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		if (mysqli_num_rows($result) <= 0) {
			$sql = "SELECT COUNT(id_docente) 'cd' FROM docentes_llamados WHERE id_llamado='$id_llamado_destino'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			if ($row['cd'] == 0) {
				$sql_l = "SELECT id_docente, id_docente_llamado
					FROM docentes_llamados 
					WHERE id_llamado = '$id_llamado_origen_uno'
					OR id_llamado = '$id_llamado_origen_dos'";
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
						$sql.= "(id_docente,id_llamado,fecha_inscripcion,estado,selecciona_cargo,folios,ruralidad,id_region,orden,usuario) ";
						$sql.="SELECT id_docente,$id_llamado_destino,NOW(),1,selecciona_cargo,folios,ruralidad,id_region,orden,'" . $_SESSION['usuario'] . "' ";
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
			} else {
				$error = "La Unificación de Llamados no puede realizarse ya que existen docentes inscriptos en el llamado destino";
				$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
				$xml .= "<xml>";
				$xml .= "<error>$error</error>";			
				$xml.= "</xml>";
				header('Content-Type: text/xml');
				print $xml;				
			}										
		} else {			
			$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
			$xml .= "<xml>";
			$xml .= "<ok>0</ok>";						
			$xml.= "</xml>";
			header('Content-Type: text/xml');
			print $xml;			
		}
		break;						      
	}
	case "unificar_llamados_dos": {
		$error = "";		
				
		$sql = "SELECT COUNT(id_docente) 'cd' FROM docentes_llamados WHERE id_llamado='$id_llamado_destino'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		if ($row['cd'] == 0) {
			$sql_l = "SELECT id_docente_llamado, id_docente FROM docentes_llamados a WHERE NOT EXISTS (SELECT * FROM docentes_llamados b					
					WHERE b.id_docente = a.id_docente AND (id_llamado = '$id_llamado_origen_uno'
					OR id_llamado = '$id_llamado_origen_dos')
					GROUP BY id_docente
					HAVING count( id_docente ) > 1) AND (id_llamado='$id_llamado_origen_uno' OR id_llamado='$id_llamado_origen_dos')";
			$result_l = mysqli_query($GLOBALS["___mysqli_ston"], $sql_l);
			while ($row_l = mysqli_fetch_array($result_l)) {
				$id_docente = $row_l['id_docente'];
				$id_docente_llamado = $row_l['id_docente_llamado'];
				importar_inscripciones($id_docente, $id_docente_llamado, $id_llamado_destino, $error);								
			}
			/*$_REQUEST["xmlInscripciones"] = str_replace('\"','"',$_REQUEST["xmlInscripciones"]);
 			$inscripciones = loadXML($_REQUEST['xmlInscripciones']);
 			for ($idx=0;$idx<count($inscripciones->inscripciones);$idx++) {
				$sql_r="SELECT id_docente, id_docente_llamado ";
				$sql_r.="FROM docentes_llamados ";
				$sql_r.="WHERE id_docente_llamado='".$inscripciones->inscripciones[$idx]['id_docente_llamado']."'";
				$result_r = mysql_query($sql_r);
				while ($row_r = mysql_fetch_array($result_r)) {
					$id_docente = $row_r['id_docente'];
					$id_docente_llamado = $row_r['id_docente_llamado'];
					importar_inscripciones($id_docente, $id_docente_llamado, $id_llamado_destino, $error);
				}				
 			}*/
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
		} else {
			$error = "La Unificación de Llamados no puede realizarse ya que existen docentes inscriptos en el llamado destino";
			$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
			$xml .= "<xml>";
			$xml .= "<error>$error</error>";			
			$xml.= "</xml>";
			header('Content-Type: text/xml');
			print $xml;						
		}
		break;
	}
	case "consultar_doble_inscripcion": {		
		// Verificar si existen docentes inscriptos simultáneamente en los dos llamados
		$sql = "SELECT id_docente, apellido, nombres, tipo_doc, nro_doc, count( id_docente ) 'cant'
					FROM docentes
					JOIN tipos_documentos
					USING ( id_tipo_doc )
					JOIN docentes_llamados
					USING ( id_docente )
					WHERE id_llamado = '$id_llamado_origen_uno'
					OR id_llamado = '$id_llamado_origen_dos'
					GROUP BY id_docente
					HAVING count( id_docente ) > 1
					ORDER BY apellido ASC , nombres ASC";
					
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		if (mysqli_num_rows($result) <= 0) {
			//No existen docentes inscriptos simultáneamente en ambos llamados;										
			$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
			$xml.= "<xml>";
			$xml.= "<ok>1</ok>";
			$xml.= "</xml>";					
			header('Content-Type: text/xml');
			print $xml;					
			break;
		} else {
			//Existen docentes inscriptos simultáneamente en ambos llamados;
			$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
			$xml.= "<xml>";
			$xml.= "<ok>0</ok>";						
			$xml.= "</xml>";
			header('Content-Type: text/xml');
			print $xml;	
			break;
		}										      
	}
	case "buscar_inscripciones_conflictivas": {
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT id_docente_llamado, id_docente, CONCAT(apellido, ', ', nombres) 'apenom', nro_doc, nro_llamado, descripcion FROM docentes a JOIN docentes_llamados USING(id_docente) JOIN llamados USING(id_llamado) WHERE EXISTS (SELECT * FROM docentes_llamados b					
					WHERE b.id_docente = a.id_docente AND (id_llamado = '$id_llamado_origen_uno'
					OR id_llamado = '$id_llamado_origen_dos')
					GROUP BY id_docente
					HAVING count( id_docente ) > 1) AND (id_llamado='$id_llamado_origen_uno' OR id_llamado='$id_llamado_origen_dos') ORDER BY nro_doc";
		toXML($xml, $sql, "inscripciones");
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
}
?>
