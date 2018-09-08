<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");
include("../_phpincludes/_cargos.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlCargo"] = str_replace('\"','"',$_REQUEST["xmlCargo"]);
		$xml_Cargo = loadXML($_REQUEST["xmlCargo"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_cargo) 'cc' ";
		$sql.="FROM escuelas_cargos ";
		$sql.="WHERE id_cargo='".$xml_Cargo["id_cargo"]."' ";
		$sql.="AND id_escuela = '$id_escuela'";
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0)
		{
			$sql="INSERT escuelas_cargos SET id_escuela = '$id_escuela', cod_escuela = '$cod_escuela', " .
					"id_cargo='".$xml_Cargo['id_cargo']."', cod_cargo='".$xml_Cargo['codigo']."', cod_nivel='$id_nivel'";			
			toXML($xml, $sql, "add");	
		}
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'update': 
	{
		$_REQUEST["xmlCargo"] = str_replace('\"','"',$_REQUEST["xmlCargo"]);
		$xml_Cargo = loadXML($_REQUEST["xmlCargo"]);	
				
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_cargo) 'cc' ";
		$sql.="FROM cargos ";
		$sql.="WHERE codigo=".$xml_Cargo["codigo"]." ";
		$sql.="AND id_cargo <> ".$xml_Cargo["id_cargo"];
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0) {
			$sql="UPDATE cargos ";
			$sql.="SET codigo='".$xml_Cargo["codigo"]."', ";
			$sql.="denominacion='".$xml_Cargo["denominacion"]."' ";
			$sql.="WHERE id_cargo='".$xml_Cargo["id_cargo"]."' ";
			toXML($xml, $sql, "upd");
		}		
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'delete': 
	{
		$_REQUEST["xmlCargo"] = str_replace('\"','"',$_REQUEST["xmlCargo"]);
		$xml_Cargo = loadXML($_REQUEST["xmlCargo"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="DELETE FROM escuelas_cargos ";
		$sql.="WHERE id_cargo='".$xml_Cargo["id_cargo"]."' ";
		$sql.="AND id_escuela='$id_escuela'";
		toXML($xml, $sql, "del");
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
 	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_cargos($xml,1,'denominacion','');
		
		traer_niveles($xml);
		
		header('Content-Type: text/xml');     	     	
     	echo $xml2->asXML();
    	break;
   }
   case 'traer_escuelas':
 	{ 		
 		$nombre = strtoupper($nombre);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_escuela, codigo, nombre, id_nivel, nivel ";
		$sql.="FROM escuelas ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE nombre like'%$nombre%' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "escuela");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_cargos':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_escuela_cargo, id_cargo, codigo, denominacion, 'A' as origen ";
		$sql.="FROM escuelas_cargos ";
		$sql.="INNER JOIN cargos USING(id_cargo) ";
		$sql.="WHERE id_escuela = '$id_escuela' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "cargos");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_cargos_n':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
			  	
	  	traer_cargos($xml,1,'denominacion',$denominacion);
		
		echo $xml->asXML();
				
    	break;
   }
   case 'dar_alta':
 	{
 		$error = "";		
 		$_REQUEST["xmlCargos"] = str_replace('\"','"',$_REQUEST["xmlCargos"]);
 		$cargos = loadXML($_REQUEST['xmlCargos']);			
		for ($idx=0;$idx<count($cargos->cargos);$idx++) {						
			$sql = "INSERT INTO escuelas_cargos SET id_escuela = '$id_escuela', cod_escuela = '$cod_escuela', " .
					"id_cargo='".$cargos->cargos[$idx]['id_cargo']."', cod_cargo='".$cargos->cargos[$idx]['codigo']."', cod_nivel='$id_nivel'";										
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
				$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
			}
		}
		$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
		$xml .= "<xml>";
		if (!empty($error))
			$xml .= "<error>$error</error>";		
		$xml.= "</xml>";
		header('Content-Type: text/xml');
		print $xml;		
    	break;
   }
}
?>