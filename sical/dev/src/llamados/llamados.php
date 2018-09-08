<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case 'alta_modificacion': {
		
		$error="";
		//// INSERT O UPDATE EN LA TABLA LLAMADOS
		$insert_llamados = "";
		$id_llamado = "";
		$xml_llamados = loadXML($_REQUEST["llamado"]);
		$count_childs = 0;
		foreach($xml_llamados->children() as $child)
		{
			$count_childs++;
		}
		$i = 0;
		foreach($xml_llamados->children() as $child)
		{
			$i++;
			if ($child->getName()!='id_llamado') {								
				if ($i < $count_childs)											
					if ($child->getName() == 'fecha_desde') {
						$fecha_desde = YYYYDM($child);
						$insert_llamados.= $child->getName() . "='" . $fecha_desde. "', ";
					} elseif ($child->getName() == 'fecha_hasta') {
						$fecha_hasta = YYYYDM($child);
						$insert_llamados.= $child->getName() . "='" . $fecha_hasta. "', ";
					} 
					else						
						$insert_llamados.= $child->getName() . "='" . $child . "', ";
				else
					$insert_llamados.= $child->getName() . "='" . $child . "'";
			} else {
				if (!$child){
					$id_llamado = $child; 
				}
			}
		}			 	
		if (!$id_llamado) {			
			$insert_llamados = "INSERT INTO llamados SET " . $insert_llamados;			
			mysqli_query($GLOBALS["___mysqli_ston"], $insert_llamados);
			if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
				$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
			} else {
				$id_llamado=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);	
			}			
		}
		$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
		$xml .= "<xml>";
		if (!empty($error))
			$xml .= "<error>$error</error>";
		$xml .= $xmlO;
		$xml.= "</xml>";
		header('Content-Type: text/xml');
		print $xml;					
		break;
	}
	case 'traer_niveles': {
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT id_nivel, nivel ";
		$sql.="FROM niveles ";
		$sql.="ORDER BY nivel ";
		toXML($xml, $sql, "nivel");
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'traer_llamados': {
		$xml=new SimpleXMLElement('<rows/>');
		
		/*$sql = "SELECT organismo_area_id_nivel FROM _organismos_areas WHERE organismo_area_id = '$SYSusuario_organismo_area_id'";
		
		$result = mysql_query($sql);
		
		$row = mysql_fetch_array($result);
		
		$id_nivel = $row['organismo_area_id_nivel'];*/
	  	
	  	$sql="SELECT id_llamado, nro_llamado, descripcion, id_nivel, nivel, id_tipo_clasificacion, ";
	  	$sql.="DATE_FORMAT(fecha_desde,'%d/%m/%Y') 'fecha_desde', ";
	  	$sql.="DATE_FORMAT(fecha_hasta,'%d/%m/%Y') 'fecha_hasta' ";
		$sql.="FROM llamados ";		
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE id_nivel = '$SYSusuario_nivel_id' ";
		$sql.="AND estado = 'A' ";		
		$sql.="ORDER BY id_llamado DESC";
		toXML($xml, $sql, "llamados");
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
}
?>