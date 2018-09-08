<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case 'lista_financiadores': {
		$xml=new SimpleXMLElement('<rows/>');
		
		$query = "SELECT id_persona FROM ingresos WHERE id_ingreso = '$id_ingreso'";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $query);
		
		if ($row = mysqli_fetch_array($result)){						
			$id_persona = $row['id_persona'];
			
			$sql="SELECT id_financiador, nombre, codigo_anssal, descripcion ";
			$sql.="FROM personas p ";		
			$sql.="JOIN padrones USING(id_persona) ";
			$sql.="JOIN financiadores USING(id_financiador) ";
			$sql.="JOIN tipos_financiadores USING(id_tipo_financiador) ";
			$sql.="WHERE p.id_persona='$id_persona' ";
			$sql.="ORDER BY nombre";
		}		
		
		toXML($xml, $sql, "cobertura");
		header('Content-Type: text/xml');
		echo $xml->asXML();
	
		break;
	}
	case 'datos_paciente': {
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$query = "SELECT id_persona FROM ingresos WHERE id_ingreso = '$id_ingreso'";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $query);
		
		if ($row = mysqli_fetch_array($result)){						
			$id_persona = $row['id_persona'];
			
			$sql="SELECT apeynom, tipo_doc, nrodoc, sexo, YEAR(CURDATE())-YEAR(fechanac) + IF(DATE_FORMAT(CURDATE(),'%m-%d') > DATE_FORMAT(fechanac,'%m-%d'), 0, -1)  AS edad, domicilio, localidad ";
			$sql.="FROM personas p ";			
			$sql.="JOIN _localidades ON id_localidad = localidad_id ";
			$sql.="WHERE p.id_persona='$id_persona'";			
		}
		
		toXML($xml, $sql, "paciente");
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		
		break;
	}	
}
?>