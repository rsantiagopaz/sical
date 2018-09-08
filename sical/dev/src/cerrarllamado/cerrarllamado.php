<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{		
	case 'traer_datos': {
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql= "SELECT id_llamado, CONCAT(nro_llamado,'-',descripcion) 'desc' ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE estado='A' ";
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
		$sql.= "WHERE estado='A' ";
		$sql.= "AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.= "AND nro_llamado = '$nro_llamado' ";
		$sql.= "ORDER BY nro_llamado DESC";
		toXML($xml, $sql, "llamados");						
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	
	case "cerrar_llamado":{
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql = "UPDATE llamados SET estado = 'C' ";		
		$sql.= "WHERE id_llamado = '$id_llamado' ";				
		
		toXML($xml, $sql, "llamado");
		
		$sql = "UPDATE docentes_llamados SET estado = '0' ";		
		$sql.= "WHERE id_llamado = '$id_llamado' ";				
		
		toXML($xml, $sql, "docentellamado");				
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}	
}
?>