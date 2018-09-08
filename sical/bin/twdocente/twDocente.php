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
		$sql.= "ORDER BY nro_llamado DESC";
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
		
		$sql= "SELECT id_llamado, descripcion, nro_llamado, id_nivel ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE (estado='A' or estado='C') ";
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
		
		$sql= "SELECT id_llamado, descripcion, nro_llamado, id_nivel ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE (estado='A' or estado='C') ";
		$sql.= "AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.= "AND nro_llamado = '$nro_llamado' ";
		$sql.= "ORDER BY nro_llamado DESC";
		toXML($xml, $sql, "llamados");						
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	
	case "buscar_docente_llamado":{
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql = "SELECT dl.id_docente_llamado, dl.estado, ";
		$sql.= "l.nro_llamado, l.descripcion, l.id_llamado, l.id_nivel, l.id_tipo_clasificacion, ";
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
		
		if ($accion == "M") {
			$sql = "SELECT count( id_doc_llamado_observ ) 'cantobs'
				FROM docentes d
				JOIN `docentes_llamados`
				USING ( id_docente )
				JOIN llamados l
				USING ( id_llamado )
				JOIN docentes_llamados_observaciones
				USING(id_docente_llamado)
				WHERE d.id_tipo_doc = '$tipo_doc'
				AND d.nro_doc = '$nro_doc'
				AND id_nivel = '$SYSusuario_nivel_id'
				AND l.id_llamado = '$id_llamado'";
				
			toXML($xml, $sql, "obsllamado");
		}
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}	
}
?>