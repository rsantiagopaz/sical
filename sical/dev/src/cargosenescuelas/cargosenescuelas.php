<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_cargos.php");
include("../_phpincludes/_escuelas.php");

switch ($_REQUEST['rutina'])
{	 	
   case 'traer_escuelas':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_escuelas($xml,'nombre',$nombre,$SYSusuario_nivel_id,0);			  		  	
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_cargos':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_cargo, codigo, denominacion, 'A' as origen ";
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
		
		traer_cargos($xml,0,'denominacion',$denominacion,$SYSusuario_nivel_id);			  		  	
		
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