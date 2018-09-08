<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case 'traer_llamados': {
		$descripcion = strtoupper($descripcion);
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql= "SELECT id_llamado, descripcion, nro_llamado, id_nivel ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE estado='C' ";
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
		$sql.= "WHERE estado='C' ";
		$sql.= "AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.= "AND nro_llamado = '$nro_llamado' ";
		$sql.= "ORDER BY nro_llamado DESC";
		toXML($xml, $sql, "llamados");						
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	
	case 'insert': 
	{
		$_REQUEST["xmlReclamo"] = str_replace('\"','"',$_REQUEST["xmlReclamo"]);
		$xml_Reclamo = loadXML($_REQUEST["xmlReclamo"]);	
		
		$xml=new SimpleXMLElement('<rows/>');			
		
		$sql="INSERT INTO reclamos ";
		$sql.="SET id_docentes_llamado='$id_docente_llamado', ";
		$sql.="id_reclamo_entrada='".$xml_Reclamo["id_reclamo_entrada"]."', ";
		$sql.="fecha_reclamo=NOW(), ";
		$sql.="observaciones_reclamo='".$xml_Reclamo["observaciones_reclamo"]."', ";
		$sql.="estado='A',";
		$sql.="usuario='" . $_SESSION['usuario'] . "'";		
		toXML($xml, $sql, "add");
		
		$sql="SELECT id_reclamo FROM reclamos WHERE id_reclamo = '".((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res)."'";
		toXML($xml, $sql, "insert");
		
		$sql = "SELECT DATE_FORMAT(fecha_reclamo,'%d/%m/%Y') 'fecha_reclamo' FROM reclamos WHERE id_reclamo = '".((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res)."'";
		toXML($xml, $sql, "fechareclamo");	
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'update': 
	{
		$_REQUEST["xmlReclamo"] = str_replace('\"','"',$_REQUEST["xmlReclamo"]);
		$xml_Reclamo = loadXML($_REQUEST["xmlReclamo"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql = "SELECT id_reclamo, fecha_reclamo, IF (CURDATE() <= DATE_ADD(fecha_reclamo, INTERVAL 1 DAY),'S','N') 'modif' ";
		$sql .= "FROM reclamos WHERE id_reclamo='".$xml_Reclamo["id_reclamo"]."' ";
		toXML($xml, $sql, "modific");
		$n = $xml->children()->attributes();								
		
		if ($n["modif"]=='S') {
			$sql="UPDATE reclamos ";
			$sql.="SET id_reclamo_entrada='".$xml_Reclamo["id_reclamo_entrada"]."', ";			
			$sql.="observaciones_reclamo='".$xml_Reclamo["observaciones_reclamo"]."' ";
			$sql.="WHERE id_reclamo='".$xml_Reclamo["id_reclamo"]."' ";		
			toXML($xml, $sql, "add");
		}								
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'delete': 
	{
		$_REQUEST["xmlReclamo"] = str_replace('\"','"',$_REQUEST["xmlReclamo"]);
		$xml_Reclamo = loadXML($_REQUEST["xmlReclamo"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql = "SELECT id_reclamo, fecha_reclamo, IF (CURDATE() <= DATE_ADD(fecha_reclamo, INTERVAL 1 DAY),'S','N') 'modif' ";
		$sql .= "FROM reclamos WHERE id_reclamo='".$xml_Reclamo["id_reclamo"]."' ";
		toXML($xml, $sql, "modific");
		$n = $xml->children()->attributes();								
		
		if ($n["modif"]=='S') {
			$sql="DELETE FROM reclamos ";
			$sql.="WHERE id_reclamo='".$xml_Reclamo["id_reclamo"]."' ";
			toXML($xml, $sql, "del");
		}				
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'responder': 
	{
		$error = '';
		$_REQUEST["xmlReclamo"] = str_replace('\"','"',$_REQUEST["xmlReclamo"]);
		$xml_Reclamo = loadXML($_REQUEST["xmlReclamo"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT estado FROM docentes_llamados WHERE id_docente_llamado='$id_docente_llamado'";
		$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row=mysqli_fetch_array($result);
		$estado_doc_llam = $row['estado'];
		
		$sql="SELECT favorable FROM reclamos_respuesta WHERE id_tipo_reclamo_resp ='".$xml_Reclamo["id_reclamo_respuesta"]."'";
			
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
		$row = mysqli_fetch_array($result);
		
		$favorable = $row['favorable'];
		
		if ($estado_doc_llam == 0) {
			$sql="UPDATE reclamos ";
			$sql.="SET id_reclamo_respuesta='".$xml_Reclamo["id_reclamo_respuesta"]."', ";		
			$sql.="observaciones_respuesta='".$xml_Reclamo["observaciones_respuesta"]."', ";
			$sql.="fecha_respuesta=NOW(), ";
			$sql.="estado='C'";
			$sql.="WHERE id_reclamo='".$xml_Reclamo["id_reclamo"]."' ";		
			toXML($xml, $sql, "res");						
			
			if ($favorable == 1) {
				$sql="UPDATE docentes_llamados SET estado = '1' ";
				$sql.="WHERE id_docente_llamado = '$id_docente_llamado'";
				toXML($xml, $sql, "docllamado");	
			}								
							
			header('Content-Type: text/xml');
			echo $xml->asXML();	
		} else {
			$error = 'Hay una modificación de inscripción pendiente debida a una respuesta favorable de un reclamo anterior. ' .
					 'Debe realizar dicha modificación antes de poder responder un nuevo reclamo';
			$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
			$xml .= "<xml>";
			if (!empty($error))
				$xml .= "<error>$error</error>";		
			$xml.= "</xml>";
			header('Content-Type: text/xml');
			print $xml;
		}		
				
		break;
	}
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
		
		$sql= "SELECT id_llamado, CONCAT(nro_llamado,'-',descripcion) 'desc' ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE estado='C' ";
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