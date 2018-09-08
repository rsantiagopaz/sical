<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_cargos.php");
include("../_phpincludes/_tipos_titulos.php");
include("../_phpincludes/_tipos_clasificacion.php");
include("../_phpincludes/_vertablatomocargo.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlTitulo"] = str_replace('\"','"',$_REQUEST["xmlTitulo"]);
		$xml_Titulo = loadXML($_REQUEST["xmlTitulo"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_tomo_cargo) 'cc' ";
		$sql.="FROM tomo_cargos ";
		$sql.="WHERE id_titulo='".$xml_Titulo["id_titulo"]."' ";
		$sql.="AND id_cargo='$id_cargo' ";
		//$sql.="AND id_tipo_titulo='".$xml_Titulo["id_tipo_titulo"]."'";		
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n['cc']==0)
		{
			$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Titulo['tipo']."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_tipo_titulo = $row['id_tipo_titulo'];
			$cod_tipo_titulo = $row['codigo'];	
						
			$sql="INSERT tomo_cargos SET id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '$cod_titulo', " .
					"id_cargo='$id_cargo', cod_cargo='".$xml_Titulo['cod_cargo']."', " .					
					"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
					"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."', " .
					"cod_tipo_clasificacion='".$xml_Titulo['cod_tipo_clasificacion']."'";			
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
		$_REQUEST["xmlTitulo"] = str_replace('\"','"',$_REQUEST["xmlTitulo"]);
		$xml_Titulo = loadXML($_REQUEST["xmlTitulo"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="DELETE FROM tomo_cargos ";
		$sql.="WHERE id_tomo_cargo='".$xml_Titulo["id_tomo_cargo"]."' ";
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
     	echo $xml->asXML();
    	break;
   }
   case 'traer_titulos_n':
 	{ 		
 		$denominacion = strtoupper($denominacion);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_titulo, codigo, denominacion ";
		$sql.="FROM titulos ";		
		$sql.="WHERE denominacion like'%$denominacion%' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "titulo");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_titulo':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
			  	
	  	traer_titulos($xml,'codigo',$codigo);
		
		echo $xml->asXML();
				
    	break;
   }   
   case 'traer_titulos':
 	{ 	
 		if (isset($opcion)) {
 			$tabla = determinar_tabla_tomo($opcion,$SYSusuario_nivel_id); 			
 		} else
 			$tabla = "tomo_cargos";
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_tomo_cargo, id_cargo, cod_cargo, tit.codigo 'codtit', tit.denominacion 'denomtit', id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, 'A' as origen ";
		$sql.="FROM $tabla ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";
		$sql.="INNER JOIN titulos tit USING(id_titulo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="WHERE id_cargo = '$id_cargo' ";		
		$sql.="ORDER BY denomcar";
		toXML($xml, $sql, "titulos");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_cargo':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_cargos($xml,1,'codigo',$codigo);	  	
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }
   case 'traer_cargos_n':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_cargos($xml,1,'denominacion',$denominacion);	  	
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }   
   case 'traer_datos2':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_tipos_titulos($xml);
		
		traer_tipos_clasificacion($xml);	  	
		
		echo $xml->asXML();
				
    	break;
   }
   case 'dar_alta':
 	{
 		$error = "";		
 		$_REQUEST["xmlCargos"] = str_replace('\"','"',$_REQUEST["xmlCargos"]);
 		$cargos = loadXML($_REQUEST['xmlCargos']);			
		for ($idx=0;$idx<count($cargos->cargos);$idx++) {
			$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$cargos->cargos[$idx]['tipo']."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_tipo_titulo = $row['id_tipo_titulo'];
			$cod_tipo_titulo = $row['codigo'];
			$sql = "INSERT INTO tomo_cargos SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
					"id_cargo='".$cargos->cargos[$idx]['id_cargo']."', cod_cargo='".$cargos->cargos[$idx]['cod_cargo']."', " .					
					"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
					"id_tipo_clasificacion='".$cargos->cargos[$idx]['id_tipo_clasificacion']."', " .
					"cod_tipo_clasificacion='".$cargos->cargos[$idx]['cod_tipo_clasificacion']."'";										
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