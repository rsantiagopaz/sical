<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case "traer_cargos":{
		$denominacion = strtoupper($denominacion);
		$xml=new SimpleXMLElement('<rows/>');
		$sql= "SELECT id_cargo, codigo, denominacion ";		
		$sql.= "FROM cargos ";
		$sql.= "WHERE denominacion LIKE '%$denominacion%' ";
		$sql.= "AND id_nivel = '$idNivel' ";				
		$sql.= "AND jornada_completa = '$jornada' ";
		
		if (isset($subtipo) && $subtipo != '')
			$sql.="AND subtipo = '$subtipo'";
		
		$sql.= "ORDER BY denominacion ";
		
		$SELECT = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		toXML($xml, $sql, "cargo");
		header('Content-Type: text/xml');
		echo $xml->asXML();

		break;
	}
	
	case "buscar_cargo":{		
		$xml=new SimpleXMLElement('<rows/>');		
		$sql= "SELECT id_cargo, codigo, denominacion ";		
		$sql.= "FROM cargos ";
		$sql.= "WHERE codigo = '$codigo' ";
		$sql.= "AND id_nivel = '$idNivel' ";
		$sql.= "AND jornada_completa = '$jornada' ";
		
		if (isset($subtipo) && $subtipo != '')
			$sql.="AND subtipo = '$subtipo'";
		
		$sql.= "ORDER BY denominacion ";
		
		$SELECT = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		toXML($xml, $sql, "cargo");
		header('Content-Type: text/xml');
		echo $xml->asXML();

		break;
	}
}
?>