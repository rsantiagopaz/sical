<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlEspacio"] = str_replace('\"','"',$_REQUEST["xmlEspacio"]);
		$xml_Espacio = loadXML($_REQUEST["xmlEspacio"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_espacio) 'cc' ";
		$sql.="FROM espacios ";
		$sql.="WHERE codigo=".$xml_Espacio["codigo"];
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0)
		{
			$sql="INSERT espacios ";
			$sql.="SET codigo='".$xml_Espacio["codigo"]."', ";
			$sql.="denominacion='".$xml_Espacio["denominacion"]."' ";			
			toXML($xml, $sql, "add");	
		}
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'update': 
	{
		$_REQUEST["xmlEspacio"] = str_replace('\"','"',$_REQUEST["xmlEspacio"]);
		$xml_Espacio = loadXML($_REQUEST["xmlEspacio"]);	
				
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_espacio) 'cc' ";
		$sql.="FROM espacios ";
		$sql.="WHERE codigo=".$xml_Espacio["codigo"]." ";
		$sql.="AND id_espacio <> ".$xml_Espacio["id_espacio"];
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0) {
			$sql="UPDATE espacios ";
			$sql.="SET codigo='".$xml_Espacio["codigo"]."', ";
			$sql.="denominacion='".$xml_Espacio["denominacion"]."' ";
			$sql.="WHERE id_espacio='".$xml_Espacio["id_espacio"]."' ";
			toXML($xml, $sql, "upd");
		}		
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'delete': 
	{
		$_REQUEST["xmlEspacio"] = str_replace('\"','"',$_REQUEST["xmlEspacio"]);
		$xml_Espacio = loadXML($_REQUEST["xmlEspacio"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="DELETE FROM espacios ";
		$sql.="WHERE id_espacio='".$xml_Espacio["id_espacio"]."' ";
		toXML($xml, $sql, "del");
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
 	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
				   		
	  	$xml2=new SimpleXMLElement('<rows/>');
	  	
	  	$sql="SELECT * ";
		$sql.="FROM espacios ";		
		$sql.="ORDER BY codigo";
		toXML($xml2, $sql, "espacios");
		
		$sql="SELECT * ";
		$sql.="FROM niveles ";
		$sql.="WHERE id_nivel = '$SYSusuario_nivel_id' ";
		$sql.="ORDER BY nivel";
		toXML($xml2, $sql, "niveles");
		
		header('Content-Type: text/xml');
     	//$xml=simplexml_load_string($xml);
     	simplexml_merge($xml2, $xml);     	
     	echo $xml2->asXML();
    	break;
   }
   case 'traer_carreras':
 	{ 		
 		$nombre = strtoupper($nombre);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_carrera, codigo, nombre, id_nivel, nivel ";
		$sql.="FROM carreras ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE nombre like'%$nombre%' ";
		//$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "carrera");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_carrera':
 	{ 		
 		//$nombre = strtoupper($nombre);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_carrera, codigo, nombre, id_nivel, nivel ";
		$sql.="FROM carreras ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE codigo = '$codigo' ";
		//$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";	
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "carrera");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_espacios':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_espacio, codigo, denominacion, 'A' as origen ";
		$sql.="FROM carreras_espacios ";
		$sql.="INNER JOIN espacios USING(id_espacio) ";
		$sql.="WHERE id_carrera = '$id_carrera' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "espacios");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_espacios_n':
 	{ 		
 		$denominacion = strtoupper($denominacion);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_espacio, codigo, denominacion, 'N' as origen ";
		$sql.="FROM espacios ";		
		$sql.="WHERE denominacion LIKE '%$denominacion%' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "espacio");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_espacio':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_espacio, codigo, denominacion, 'N' as origen ";
		$sql.="FROM espacios ";		
		$sql.="WHERE codigo = '$codigo' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "espacio");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'dar_alta':
 	{
 		$error = "";		
 		$_REQUEST["xmlEspacios"] = str_replace('\"','"',$_REQUEST["xmlEspacios"]);
 		$espacios = loadXML($_REQUEST['xmlEspacios']);			
		for ($idx=0;$idx<count($espacios->espacios);$idx++) {
			$sql="SELECT nombre FROM carreras WHERE id_carrera = '$id_carrera'";
			$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row=mysqli_fetch_array($result);
			$carrera = $row['nombre'];
			
			$sql="SELECT denominacion FROM espacios WHERE id_espacio = '".$espacios->espacios[$idx]['id_espacio']."'";
			$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row=mysqli_fetch_array($result);
			$espacio = $row['denominacion'];
			
			$sql = "INSERT INTO carreras_espacios SET id_carrera = '$id_carrera', cod_carrera = '$cod_carrera', " .
					"id_espacio='".$espacios->espacios[$idx]['id_espacio']."', cod_espacio='".$espacios->espacios[$idx]['codigo']."'";										
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
				$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
			} else {
				$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
				$_descrip = "ALTA DE LA CARRERA-ESPACIO CON id='$_id_registro', CARRERA '$carrera', ESPACIO '$espacio'";
				_auditoria($sql, 
	                    $link_salud1,
						$link_salud1,
						'carreras_espacios',
						$_id_registro,
	                    $_descrip,
	                    '',
	                    '');	
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