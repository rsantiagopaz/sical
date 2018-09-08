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
		
		$sql="SELECT COUNT(id_tomo_espacio) 'cc' ";
		$sql.="FROM tomo_espacios ";
		$sql.="WHERE id_espacio='".$xml_Espacio["id_espacio"]."' ";
		$sql.="AND id_titulo='$id_titulo' ";
		$sql.="AND id_carrera='".$xml_Espacio['id_carrera']."'";
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0)
		{
			$sql="SELECT COUNT(id_tomo_espacio) 'ccn' ";
			$sql.="FROM nov_tomo_espacios ";
			$sql.="WHERE id_espacio='".$xml_Espacio["id_espacio"]."' ";
			$sql.="AND id_titulo='$id_titulo' ";
			$sql.="AND id_carrera='".$xml_Espacio['id_carrera']."' ";
			$sql.="AND estado='S'";
			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$row = mysqli_fetch_array($result);
			
			if ($row['ccn']==0) {
				$sql="SELECT count(id_carrera_espacio) 'cc1' ";
				$sql.="FROM carreras_espacios ";
				$sql.="WHERE id_espacio='".$xml_Espacio["id_espacio"]."' ";
				$sql.="AND id_carrera='".$xml_Espacio['id_carrera']."'";
				toXML($xml, $sql, "carrerasespacios");
				
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				
				$row = mysqli_fetch_array($result);
				
				if($row['cc1']!=0) {
					$sql="SELECT COUNT(id_tomo_espacio) 'cc2' ";
					$sql.="FROM tomo_espacios ";
					$sql.="WHERE id_espacio='".$xml_Espacio["id_espacio"]."' ";
					toXML($xml, $sql, "espacios");
						
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					
					$row = mysqli_fetch_array($result);
					
					if ($row['cc2']==0) {
						$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Espacio['tipo']."'";
						$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						$row = mysqli_fetch_array($result);
						$id_tipo_titulo = $row['id_tipo_titulo'];
						$cod_tipo_titulo = $row['codigo'];
						$sql="INSERT tomo_espacios SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
								"id_espacio='".$xml_Espacio['id_espacio']."', cod_espacio='".$xml_Espacio['cod_espacio']."', " .
								"id_carrera='".$xml_Espacio['id_carrera']."', cod_carrera='".$xml_Espacio['cod_carrera']."', " .
								"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
								"id_tipo_clasificacion='".$xml_Espacio['id_tipo_clasificacion']."'";			
						toXML($xml, $sql, "add");
						
						$sql="INSERT nov_tomo_espacios SET id_tomo_espacio='".$xml_Espacio["id_tomo_espacio"]."', id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
								"id_espacio='".$xml_Espacio['id_espacio']."', cod_espacio='".$xml_Espacio['cod_espacio']."', " .
								"id_carrera='".$xml_Espacio['id_carrera']."', cod_carrera='".$xml_Espacio['cod_carrera']."', " .
								"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
								"id_tipo_clasificacion='".$xml_Espacio['id_tipo_clasificacion']."', " .
								"tipo_novedad = 'N', " .
								"estado='V', " .
								"fecha_novedad=NOW(), " .
								"timestamp=NOW(), " .
								"usuario_novedad='".$_SESSION['usuario']."'";
						toXML($xml, $sql, "add");
					} else {
						$sql = "SELECT COUNT(id_nov_tomo_espacios) 'cc3' FROM nov_tomo_espacios WHERE id_espacio='".$xml_Espacio['id_espacio']."' " .
							" AND tipo_novedad='N' AND CURDATE() <= DATE_ADD(fecha_novedad, INTERVAL 1 DAY)";
							
						toXML($xml, $sql, "novedades");
						
						$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						$row = mysqli_fetch_array($result);
						
						if ($row['cc3'] > 0) {
							$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Espacio['tipo']."'";
							$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
							$row = mysqli_fetch_array($result);
							$id_tipo_titulo = $row['id_tipo_titulo'];
							$cod_tipo_titulo = $row['codigo'];
							$sql="INSERT tomo_espacios SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
									"id_espacio='".$xml_Espacio['id_espacio']."', cod_espacio='".$xml_Espacio['cod_espacio']."', " .
									"id_carrera='".$xml_Espacio['id_carrera']."', cod_carrera='".$xml_Espacio['cod_carrera']."', " .
									"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
									"id_tipo_clasificacion='".$xml_Espacio['id_tipo_clasificacion']."'";			
							toXML($xml, $sql, "add");
						} else {
							$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Espacio['tipo']."'";
							$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
							$row = mysqli_fetch_array($result);
							$id_tipo_titulo = $row['id_tipo_titulo'];
							$cod_tipo_titulo = $row['codigo'];
							$sql="INSERT nov_tomo_espacios SET id_tomo_espacio='".$xml_Espacio["id_tomo_espacio"]."', id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
									"id_espacio='".$xml_Espacio['id_espacio']."', cod_espacio='".$xml_Espacio['cod_espacio']."', " .
									"id_carrera='".$xml_Espacio['id_carrera']."', cod_carrera='".$xml_Espacio['cod_carrera']."', " .
									"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
									"id_tipo_clasificacion='".$xml_Espacio['id_tipo_clasificacion']."', " .
									"tipo_novedad = 'A', " .
									"estado='S', " .
									"fecha_novedad=NOW(), " .
									"timestamp=NOW(), " .
									"usuario_novedad='".$_SESSION['usuario']."'";
							toXML($xml, $sql, "add");
						}					
					}	
				}	
			} else {
				$error="Existe una novedad pendiente de ser impactada para el título, carrera, y espacio seleccionados\n";
				$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
				$xml .= "<xml>";			
				$xml .= "<error>$error</error>";				
				$xml.= "</xml>";
				header('Content-Type: text/xml');
				print $xml;
				break;
			}
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
		$sql.="WHERE codigo='".$xml_Espacio["codigo"]."' ";
		$sql.="AND id_espacio <> '".$xml_Espacio["id_espacio"]."'";
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
		
		$sql="SELECT COUNT(id_tomo_espacio) 'cc' FROM nov_tomo_espacios WHERE id_tomo_espacio='".$xml_Espacio["id_tomo_espacio"]."'";
		$sql.=" AND estado='S'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		if ($row['cc'] == 0) {
			$sql="UPDATE tomo_espacios SET marcado='1' WHERE id_tomo_espacio='".$xml_Espacio["id_tomo_espacio"]."'";
			query($sql);
			
			$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Espacio['tipo']."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_tipo_titulo = $row['id_tipo_titulo'];
			$cod_tipo_titulo = $row['codigo'];
			
			$sql="INSERT nov_tomo_espacios SET id_tomo_espacio='".$xml_Espacio["id_tomo_espacio"]."', id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
					"id_espacio='".$xml_Espacio['id_espacio']."', cod_espacio='".$xml_Espacio['cod_espacio']."', " .
					"id_carrera='".$xml_Espacio['id_carrera']."', cod_carrera='".$xml_Espacio['cod_carrera']."', " .
					"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
					"id_tipo_clasificacion='".$xml_Espacio['id_tipo_clasificacion']."', " .
					"tipo_novedad = 'B', " .
					"estado='S', " .
					"fecha_novedad=NOW(), " .
					"timestamp=NOW(), " .
					"usuario_novedad='".$_SESSION['usuario']."'";
			
			/*$sql="DELETE FROM tomo_espacios ";
			$sql.="WHERE id_tomo_espacio='".$xml_Espacio["id_tomo_espacio"]."' ";*/
			toXML($xml, $sql, "del");
					
			header('Content-Type: text/xml');
			echo $xml->asXML();	
		} else {
			$error="Existe una novedad pendiente de ser impactada para el tomo_espacio seleccionado\n";
			$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
			$xml .= "<xml>";			
			$xml .= "<error>$error</error>";
			$xml .= $xmlD;
			$xml.= "</xml>";
			header('Content-Type: text/xml');
			print $xml;
		}			
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
		$sql.="ORDER BY nivel";
		toXML($xml2, $sql, "niveles");
		
		header('Content-Type: text/xml');
     	//$xml=simplexml_load_string($xml);
     	simplexml_merge($xml2, $xml);     	
     	echo $xml2->asXML();
    	break;
   }
   case 'traer_titulos':
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
	  	$sql="SELECT id_titulo, codigo, denominacion ";
		$sql.="FROM titulos ";		
		$sql.="WHERE codigo = '$codigo' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "titulo");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_carrera':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_carrera, codigo, nombre, id_nivel, nivel ";
		$sql.="FROM carreras ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE codigo = '$codigo' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "carrera");
		
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
   case 'traer_carreras':
 	{ 		
 		$nombre = strtoupper($nombre);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_carrera, codigo, nombre, id_nivel, nivel ";
		$sql.="FROM carreras ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE nombre like'%$nombre%' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "carrera");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_espacios':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_tomo_espacio, id_carrera, cod_carrera, id_espacio, cod_espacio, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="e.codigo, nombre, e.denominacion 'denomesp', t.denominacion 'denomclas', marcado, 'A' as origen ";
		$sql.="FROM tomo_espacios ";
		$sql.="INNER JOIN espacios e USING(id_espacio) ";
		$sql.="INNER JOIN carreras c USING(id_carrera) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="WHERE id_titulo = '$id_titulo' ";		
		$sql.="ORDER BY nombre";
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
   case 'traer_datos2':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT * ";
		$sql.="FROM tipos_titulos ";				
		$sql.="ORDER BY tipo";
		toXML($xml, $sql, "tipostitulos");
		
		$sql="SELECT * ";
		$sql.="FROM tipos_clasificacion ";				
		$sql.="ORDER BY denominacion";
		toXML($xml, $sql, "tiposclasificacion");
		
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
					"id_carrera='".$espacios->espacios[$idx]['id_carrera']."', cod_carrera='".$espacios->espacios[$idx]['cod_carrera']."', " .
					"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
					"id_tipo_clasificacion='".$espacios->espacios[$idx]['id_tipo_clasificacion']."'";										
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