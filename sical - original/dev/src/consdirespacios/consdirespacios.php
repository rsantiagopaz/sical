<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");
include("../_phpincludes/_titulos.php");
include("../_phpincludes/_espacios.php");
include("../_phpincludes/_tipos_titulos.php");
include("../_phpincludes/_tipos_clasificacion.php");
include("../_phpincludes/_vertablatomoespacio.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlTitulo"] = str_replace('\"','"',$_REQUEST["xmlTitulo"]);
		$xml_Titulo = loadXML($_REQUEST["xmlTitulo"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_tomo_espacio) 'cc' ";
		$sql.="FROM tomo_espacios ";
		$sql.="WHERE id_titulo='".$xml_Titulo["id_titulo"]."' ";
		$sql.="AND id_espacio='$id_espacio' ";
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
						
			$sql="INSERT tomo_espacios SET id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '$cod_titulo', " .
					"id_espacio='$id_espacio', cod_espacio='".$xml_Titulo['cod_espacio']."', " .					
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
		$_REQUEST["xmlTitulo"] = str_replace('\"','"',$_REQUEST["xmlTitulo"]);
		$xml_Titulo = loadXML($_REQUEST["xmlTitulo"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="DELETE FROM tomo_espacios ";
		$sql.="WHERE id_tomo_espacio='".$xml_Titulo["id_tomo_espacio"]."' ";
		toXML($xml, $sql, "del");
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
 	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_espacios($xml,'denominacion','');	  	
		
		traer_niveles($xml);				
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
   case 'traer_titulos_n':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_titulos($xml,'denominacion',$denominacion);			  	
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }
   case 'buscar_titulo':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_titulos($xml,'codigo',$codigo);	  	
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }   
   case 'traer_titulos':
 	{ 	
 		if (isset($opcion)) {
 			$tabla = determinar_tabla_tomo($opcion,$SYSusuario_nivel_id); 			
 		} else
 			$tabla = "tomo_espacios";	
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_tomo_espacio, id_espacio, cod_espacio, tit.codigo 'codtit', tit.denominacion 'denomtit', id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="cr.nombre, ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion' ";
		$sql.="FROM $tabla ";
		$sql.="INNER JOIN espacios ca USING(id_espacio) ";
		$sql.="INNER JOIN carreras cr USING(id_carrera) ";
		$sql.="INNER JOIN titulos tit USING(id_titulo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="WHERE id_espacio = '$id_espacio' ";
		
		if (isset($haycarrera) && $haycarrera=='S')
			$sql.="AND id_carrera = '$id_carrera'";
						
		$sql.="ORDER BY denomcar";
		toXML($xml, $sql, "titulos");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_espacio':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_espacios($xml,'codigo',$codigo);		
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }
   case 'traer_espacios_n':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_espacios($xml,'denominacion',$denominacion);	  	
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }   
   case 'traer_datos2':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_tipos_titulos($xml);
		
		traer_tipos_clasificacion($xml);				
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }
   case 'dar_alta':
 	{
 		$error = "";		
 		$_REQUEST["xmlEspacios"] = str_replace('\"','"',$_REQUEST["xmlEspacios"]);
 		$espacios = loadXML($_REQUEST['xmlEspacios']);			
		for ($idx=0;$idx<count($espacios->espacios);$idx++) {
			$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$espacios->espacios[$idx]['tipo']."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_tipo_titulo = $row['id_tipo_titulo'];
			$cod_tipo_titulo = $row['codigo'];
			$sql = "INSERT INTO tomo_espacios SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
					"id_espacio='".$espacios->espacios[$idx]['id_espacio']."', cod_espacio='".$espacios->espacios[$idx]['cod_espacio']."', " .					
					"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
					"id_tipo_clasificacion='".$espacios->espacios[$idx]['id_tipo_clasificacion']."', " .
					"cod_tipo_clasificacion='".$espacios->espacios[$idx]['cod_tipo_clasificacion']."'";										
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