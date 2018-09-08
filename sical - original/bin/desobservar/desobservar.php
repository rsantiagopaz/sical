<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{		
	case 'traer_datos': {
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql= "SELECT id_llamado, CONCAT(nro_llamado,'-',descripcion) 'desc' ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE (estado='A' or estado='C') ";
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
	
	case "buscar_docente_llamado":{
		$xml=new SimpleXMLElement('<rows/>');
		
		
		// Buscar la inscripción del docente para el llamado seleccionado
		$sql = "SELECT dl.id_docente_llamado, dl.estado 'estado_doc_llam', ";
		$sql.= "l.nro_llamado, l.descripcion, l.id_llamado, l.id_nivel, ";
		$sql.= "d.id_docente, d.apellido, d.nombres, d.nro_doc, td.tipo_doc, ";
		$sql.= "d.domicilio ";
		$sql.= "FROM docentes d ";
		$sql.= "INNER JOIN docentes_llamados dl USING(id_docente) ";
		$sql.= "INNER JOIN llamados l USING(id_llamado) ";
		$sql.= "INNER JOIN tipos_documentos td USING(id_tipo_doc) ";
		$sql.= "WHERE d.id_tipo_doc = '$tipo_doc' ";
		$sql.= "AND d.nro_doc = '$nro_doc' ";
		$sql.= "AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.= "AND l.id_llamado = '$id_llamado' ";				
		
		toXML($xml, $sql, "llamadodocente");
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		$estado_doc_llam = $row['estado_doc_llam'];
		
		$id_docente_llamado = $row['id_docente_llamado'];
		
		// Verificar si la inscripción se encuentra abierta
		if ($row['estado_doc_llam'] == 1) {
			// Verificar si existen observaciones a la inscripción
			$sql = "SELECT count( id_doc_llamado_observ ) 'cantobs'
					FROM `docentes_llamados` dl					
					JOIN docentes_llamados_observaciones
					USING(id_docente_llamado)
					WHERE dl.id_docente_llamado = '$id_docente_llamado'";								
					
			toXML($xml, $sql, "obsllamado");
			
			// Buscar las observaciones realizadas a la inscripción. En caso de corresponder a la descripción genérica "NO CUMPLE CON LOS REQUISITOS",
			// devolver tanto la descripción como el comentario aclaratorio correspondiente
			$sql = "SELECT ob.id_observacion, IF (ob.id_observacion<>19,descripcion,CONCAT(descripcion,' - ',comentarios)) 'descripcion' 
					FROM `docentes_llamados` dl					
					JOIN docentes_llamados_observaciones
					USING(id_docente_llamado) 
					JOIN observaciones ob
					USING(id_observacion)  
					WHERE dl.id_docente_llamado = '$id_docente_llamado'";								
					
			toXML($xml, $sql, "observaciones");
			
			/*$sql = "DELETE FROM docentes_llamados_observaciones " .
				   "WHERE id_docente_llamado = '$id_docente_llamado'";
			
			$result = mysql_query($sql);*/
		}								
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case "quitar_observaciones":{
		$xml=new SimpleXMLElement('<rows/>');
		$sql = "DELETE FROM docentes_llamados_observaciones " .
			   "WHERE id_docente_llamado = '$id_docente_llamado'";
		
		toXML($xml, $sql, "del");
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}	
}
?>