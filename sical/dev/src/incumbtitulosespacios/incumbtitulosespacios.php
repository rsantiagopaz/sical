<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

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
		$sql.="AND id_carrera='$id_carrera' ";
		//$sql.="AND id_tipo_titulo='".$xml_Titulo["id_tipo_titulo"]."'";		
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n['cc']==0)
		{	
			$sql="SELECT COUNT(id_tomo_espacio) 'ccn' ";
			$sql.="FROM nov_tomo_espacios ";
			$sql.="WHERE id_titulo='".$xml_Titulo["id_titulo"]."' ";
			$sql.="AND id_espacio='$id_espacio' ";
			$sql.="AND id_carrera='$id_carrera' ";
			$sql.="AND estado='S'";
			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$row = mysqli_fetch_array($result);
			
			if ($row['ccn']==0) {
				$sql="SELECT count(id_carrera_espacio) 'cc1' ";
				$sql.="FROM carreras_espacios ";
				$sql.="WHERE id_espacio='$id_espacio' ";
				$sql.="AND id_carrera='$id_carrera'";
				toXML($xml, $sql, "carrerasespacios");
				
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				
				$row = mysqli_fetch_array($result);
				
				if($row['cc1']!=0) {
					// Buscar si existe el espacio en tomo_espacios
					$sql="SELECT COUNT(id_tomo_espacio) 'cc2' ";
					$sql.="FROM tomo_espacios ";
					$sql.="WHERE id_espacio='$id_espacio' ";
					toXML($xml, $sql, "espacios");
					
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					
					$row = mysqli_fetch_array($result);
					
					// Si no existe, darlo de alta en tomo espacios, y generar una novedad con tipo_novedad = 'N'
					if ($row['cc2']==0) {
						$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Titulo['tipo']."'";
						$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						$row = mysqli_fetch_array($result);
						$id_tipo_titulo = $row['id_tipo_titulo'];
						$cod_tipo_titulo = $row['codigo'];
						
						$sql = "SELECT denominacion 'titulo' FROM titulos ";				
						$sql.="WHERE id_titulo='".$xml_Titulo["id_titulo"]."'";
						$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						$row = mysqli_fetch_array($result);
						$titulo = $row['titulo'];
						
						$sql = "SELECT nombre 'carrera' FROM carreras ";				
						$sql.="WHERE id_carrera='$id_carrera'";
						$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						$row = mysqli_fetch_array($result);
						$carrera = $row['carrera'];
						
						$sql = "SELECT denominacion 'espacio' FROM espacios ";				
						$sql.="WHERE id_espacio='$id_espacio'";
						$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						$row = mysqli_fetch_array($result);
						$espacio = $row['espacio'];	
						
						$sql="INSERT tomo_espacios SET id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '".$xml_Titulo['cod_titulo']."', " .
								"id_espacio='$id_espacio', cod_espacio='".$xml_Titulo['cod_espacio']."', " .
								"id_carrera='$id_carrera', cod_carrera='".$xml_Titulo['cod_carrera']."', " .
								"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
								"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."'";								
						toXML($xml, $sql, "add");
						
						if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
							$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
							$_descrip = "ALTA DE TOMO-ESPACIO CON id='$_id_registro', TÍTULO '$titulo' CARRERA '$carrera', ESPACIO '$espacio'";
							_auditoria($sql, 
				                    $link_salud1,
									$link_salud1,
									'tomo_espacios',
									$_id_registro,
				                    $_descrip,
				                    '',
				                    '');
						}
						
						$sql="INSERT nov_tomo_espacios SET id_tomo_espacio='".$xml_Titulo["id_tomo_espacio"]."', id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '".$xml_Titulo['cod_titulo']."', " .
								"id_espacio='$id_espacio', cod_espacio='".$xml_Titulo['cod_espacio']."', " .
								"id_carrera='$id_carrera', cod_carrera='".$xml_Titulo['cod_carrera']."', " .
								"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
								"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."', " .
								"tipo_novedad = 'N', " .
								"estado='V', " .
								"fecha_novedad=NOW(), " .
								"timestamp=NOW(), " .
								"usuario_novedad='".$_SESSION['usuario']."'";
						toXML($xml, $sql, "add");
					} else {
						// Si el espacio existe en tomo espacios, verificar si existe una novedad con tipo_novedad = 'N',
						// con una antiguedad menor o igual a un día. Eso significa que la incumbencia de título será 
						// impactada, ya que no se trataba de un espacio preexistente sino de un nuevo, al cual recién 
						// se está categorizando						
						$sql = "SELECT COUNT(id_nov_tomo_espacios) 'cc3' FROM nov_tomo_espacios WHERE id_espacio='$id_espacio' " .
							" AND tipo_novedad='N' AND CURDATE() <= DATE_ADD(fecha_novedad, INTERVAL 1 DAY)";
							
						toXML($xml, $sql, "novedades");
						
						$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						$row = mysqli_fetch_array($result);
						
						if ($row['cc3'] > 0) {
							$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Titulo['tipo']."'";
							$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
							$row = mysqli_fetch_array($result);
							$id_tipo_titulo = $row['id_tipo_titulo'];
							$cod_tipo_titulo = $row['codigo'];
							
							$sql = "SELECT denominacion 'titulo' FROM titulos ";				
							$sql.="WHERE id_titulo='".$xml_Titulo["id_titulo"]."'";
							$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
							$row = mysqli_fetch_array($result);
							$titulo = $row['titulo'];
							
							$sql = "SELECT nombre 'carrera' FROM carreras ";				
							$sql.="WHERE id_carrera='$id_carrera'";
							$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
							$row = mysqli_fetch_array($result);
							$carrera = $row['carrera'];
							
							$sql = "SELECT denominacion 'espacio' FROM espacios ";				
							$sql.="WHERE id_espacio='$id_espacio'";
							$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
							$row = mysqli_fetch_array($result);
							$espacio = $row['espacio'];
							
							$sql="INSERT tomo_espacios SET id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '".$xml_Titulo['cod_titulo']."', " .
									"id_espacio='$id_espacio', cod_espacio='".$xml_Titulo['cod_espacio']."', " .
									"id_carrera='$id_carrera', cod_carrera='".$xml_Titulo['cod_carrera']."', " .
									"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
									"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."'";								
							toXML($xml, $sql, "add");
							
							if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
								$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
								$_descrip = "ALTA DE TOMO-ESPACIO CON id='$_id_registro', TÍTULO '$titulo' CARRERA '$carrera', ESPACIO '$espacio'";
								_auditoria($sql, 
					                    $link_salud1,
										$link_salud1,
										'tomo_espacios',
										$_id_registro,
					                    $_descrip,
					                    '',
					                    '');
							}
						} else {
							$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Titulo['tipo']."'";
							$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
							$row = mysqli_fetch_array($result);
							$id_tipo_titulo = $row['id_tipo_titulo'];
							$cod_tipo_titulo = $row['codigo'];
							
							$sql="INSERT nov_tomo_espacios SET id_tomo_espacio='".$xml_Titulo["id_tomo_espacio"]."', id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '".$xml_Titulo['cod_titulo']."', " .
									"id_espacio='$id_espacio', cod_espacio='".$xml_Titulo['cod_espacio']."', " .
									"id_carrera='$id_carrera', cod_carrera='".$xml_Titulo['cod_carrera']."', " .
									"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
									"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."', " .
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
		
		$sql="SELECT COUNT(id_tomo_espacio) 'cc' FROM nov_tomo_espacios WHERE id_tomo_espacio='".$xml_Titulo["id_tomo_espacio"]."'";
		$sql.=" AND estado='S'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		if ($row['cc'] == 0) {
			$sql="UPDATE tomo_espacios SET marcado='1' WHERE id_tomo_espacio='".$xml_Titulo["id_tomo_espacio"]."'";
			query($sql);
			
			$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Titulo['tipo']."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_tipo_titulo = $row['id_tipo_titulo'];
			$cod_tipo_titulo = $row['codigo'];
			
			$sql="INSERT nov_tomo_espacios SET id_tomo_espacio='".$xml_Titulo["id_tomo_espacio"]."', id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '".$xml_Titulo['cod_titulo']."', " .
					"id_espacio='$id_espacio', cod_espacio='".$xml_Titulo['cod_espacio']."', " .
					"id_carrera='$id_carrera', cod_carrera='".$xml_Titulo['cod_carrera']."', " .
					"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
					"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."', " .
					"tipo_novedad = 'B', " .
					"estado='S', " .
					"fecha_novedad=NOW(), " .
					"timestamp=NOW(), " .
					"usuario_novedad='".$_SESSION['usuario']."'";
			
			/*$sql="DELETE FROM tomo_espacios ";
			$sql.="WHERE id_tomo_espacio='".$xml_Titulo["id_tomo_espacio"]."' ";*/
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
   case 'traer_titulos':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_tomo_espacio, id_espacio, id_carrera, cod_carrera, cod_espacio, cod_titulo, tit.denominacion 'denomtit', id_titulo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', marcado, 'A' as origen ";
		$sql.="FROM tomo_espacios ";
		$sql.="INNER JOIN espacios ca USING(id_espacio) ";
		$sql.="INNER JOIN carreras cr USING(id_carrera) ";
		$sql.="INNER JOIN titulos tit USING(id_titulo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="WHERE id_espacio = '$id_espacio' ";
		$sql.="AND id_carrera = '$id_carrera' ";	
		$sql.="ORDER BY denomcar";
		toXML($xml, $sql, "titulos");
		
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
	  	$sql="SELECT id_tomo_espacio, id_espacio, cod_espacio, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, 'A' as origen ";
		$sql.="FROM tomo_espacios ";
		$sql.="INNER JOIN espacios ca USING(id_espacio) ";		
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="WHERE id_titulo = '$id_titulo' ";		
		$sql.="ORDER BY denomcar";
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