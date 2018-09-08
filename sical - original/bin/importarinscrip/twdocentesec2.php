<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{		
	case 'traer_datos': {
		$xml=new SimpleXMLElement('<rows/>');
		
		//$sql= "SELECT id_llamado, CONCAT(nro_llamado,'-',descripcion) 'desc' ";
		$sql= "SELECT id_llamado, CONCAT(CAST(nro_llamado AS CHAR),'-',descripcion) 'desc' ";
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
		
		$sql = "SELECT dl.id_docente_llamado, ";
		$sql.= "l.nro_llamado, l.descripcion, l.id_llamado, l.id_nivel, ";
		$sql.= "d.id_docente, d.apellido, d.nombres, d.nro_doc, td.tipo_doc, ";
		$sql.= "d.domicilio ";
		$sql.= "FROM docentes d ";
		$sql.= "INNER JOIN docentes_llamados dl USING(id_docente) ";
		$sql.= "INNER JOIN llamados l USING(id_llamado) ";
		$sql.= "INNER JOIN tipos_documentos td USING(id_tipo_doc) ";
		$sql.= "WHERE d.id_tipo_doc = '$tipo_doc' ";
		$sql.= "AND d.nro_doc = '$nro_doc' ";
		$sql.= "AND l.id_llamado = '$id_llamado' ";
		
		toXML($xml, $sql, "llamadodocente");						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}	
}
?>