<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case "traer_establecimientos":{
		$nombre = strtoupper($nombre);
		$xml=new SimpleXMLElement('<rows/>');
		$sql= "SELECT id_escuela, codigo, nombre ";		
		$sql.= "FROM escuelas ";
		$sql.= "WHERE nombre LIKE '%$nombre%' ";
		$sql.= "AND id_nivel = '$idNivel' ";
		$sql.= "ORDER BY nombre ";
		
		$SELECT = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		toXML($xml, $sql, "establecimiento");
		header('Content-Type: text/xml');
		echo $xml->asXML();

		break;
	}
	
	case "buscar_est":{		
		$xml=new SimpleXMLElement('<rows/>');	
		$sql= "SELECT id_escuela, codigo, nombre ";		
		$sql.= "FROM escuelas ";
		$sql.= "WHERE codigo = '$codigo' ";
		$sql.= "AND id_nivel = '$idNivel' ";
		$sql.= "ORDER BY nombre ";
		
		$SELECT = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		toXML($xml, $sql, "establecimiento");
		header('Content-Type: text/xml');
		echo $xml->asXML();

		break;
	}
}
?>