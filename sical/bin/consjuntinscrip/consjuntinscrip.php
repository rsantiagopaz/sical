<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{	
	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
				   		
	  	$xml2=new SimpleXMLElement('<rows/>');
	  	
	  	$sql="SELECT id_reclamo, id_docentes_llamado, id_reclamo_entrada, id_reclamo_respuesta, e.descripcion 'motivo', ";
	  	$sql.="r.descripcion 'respuesta', DATE_FORMAT(fecha_reclamo,'%d/%m/%Y') 'fecha_reclamo', DATE_FORMAT(fecha_respuesta,'%d/%m/%Y') 'fecha_respuesta', observaciones_reclamo, observaciones_respuesta, estado ";	  	
		$sql.="FROM reclamos ";
		$sql.="LEFT JOIN reclamos_entrada e ON id_reclamo_entrada = id_tipo_reclamo_ent ";
		$sql.="LEFT JOIN reclamos_respuesta r ON id_reclamo_respuesta = id_tipo_reclamo_resp ";
		$sql.="WHERE id_docentes_llamado = '$id_docente_llamado' ";		
		$sql.="ORDER BY fecha_reclamo DESC";
		toXML($xml2, $sql, "reclamos");
		
		$sql="SELECT * ";
		$sql.="FROM niveles ";
		$sql.="ORDER BY nivel";
		toXML($xml2, $sql, "niveles");
		
		header('Content-Type: text/xml');
     	//$xml=simplexml_load_string($xml);
     	simplexml_merge($xml2, $xml);     	
     	echo $xml2->asXML();
    	break;
    }
    case 'traer_datos_combos': {
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql= "SELECT id_llamado, CONCAT(nro_llamado,'-',descripcion) 'desc', id_nivel ";
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
		
		$sql = "SELECT * FROM docentes d ";
		$sql.= "WHERE d.id_tipo_doc = '$tipo_doc' ";
		$sql.= "AND d.nro_doc = '$nro_doc' ";
		
		toXML($xml, $sql, "docente");
		
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
		$sql.= "AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.= "AND l.id_llamado = '$id_llamado' ";
		
		toXML($xml, $sql, "llamadodocente");
		
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
							
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
 	case 'traer_datos2':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  		  	
		
		$sql="SELECT * ";
		$sql.="FROM reclamos_entrada ";		
		$sql.="ORDER BY descripcion";
		toXML($xml, $sql, "motivos");
		
		$sql="SELECT * ";
		$sql.="FROM reclamos_respuesta ";		
		$sql.="ORDER BY descripcion";
		toXML($xml, $sql, "respuestas");
		
		header('Content-Type: text/xml');
     	//$xml=simplexml_load_string($xml);
     	//simplexml_merge($xml2, $xml);     	
     	echo $xml->asXML();
    	break;
   }	
}
?>