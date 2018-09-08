<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case "traer_antecedentes":{
		$titulo = strtoupper($titulo);
		$xml=new SimpleXMLElement('<rows/>');
		$sql= "SELECT id_titulo, codigo, denominacion ";		
		$sql.= "FROM titulos ";
		$sql.= "WHERE denominacion LIKE '%$titulo%' ";
		$sql.= "ORDER BY denominacion ";
		
		$SELECT = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		toXML($xml, $sql, "titulo");
		header('Content-Type: text/xml');
		echo $xml->asXML();

		break;
	}
	case "buscar_tit":{
		//$antecedente = strtoupper($antecedente);
		$xml=new SimpleXMLElement('<rows/>');
		$sql= "SELECT id_titulo, codigo, denominacion ";		
		$sql.= "FROM titulos ";
		$sql.= "WHERE codigo = '$codigo' ";
		$sql.= "ORDER BY denominacion ";
		
		$SELECT = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		toXML($xml, $sql, "titulo");
		header('Content-Type: text/xml');
		echo $xml->asXML();

		break;
	}
}
?>