<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");
include("../_phpincludes/_titulos.php");
include("../_phpincludes/_carreras.php");
include("../_phpincludes/_espacios.php");
include("../_phpincludes/_tipos_titulos.php");
include("../_phpincludes/_tipos_clasificacion.php");

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
	  	
	  	traer_espacios($xml,'denominacion','');
	  	
	  	traer_niveles($xml);				
		
		header('Content-Type: text/xml');     	     
     	echo $xml->asXML();
    	break;
   }
   case 'traer_titulos':
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
   case 'traer_carreras':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_carreras($xml,'nombre',1,'',$nombre);	  	
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }
   case 'buscar_carrera':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_carreras($xml,'codigo',1,'',$codigo);	  	
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }
   case 'traer_espacios':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_tomo_espacio, id_carrera, cod_carrera, id_espacio, cod_espacio, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="e.codigo, nombre, e.denominacion 'denomesp', t.denominacion 'denomclas', 'A' as origen ";
		$sql.="FROM tomo_espacios ";
		$sql.="INNER JOIN espacios e USING(id_espacio) ";
		$sql.="INNER JOIN carreras c USING(id_carrera) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="WHERE id_titulo = '$id_titulo' ";		
		$sql.="ORDER BY nombre";
		toXML($xml, $sql, "espacios");
		
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
   case 'buscar_espacio':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_espacios($xml,'codigo',$codigo);	  	
		
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
   case 'controlar_carrera_espacio':
   {
   		$xml=new SimpleXMLElement('<rows/>');
   		
   		$sql="SELECT count(id_carrera_espacio) 'cc1' ";
			$sql.="FROM carreras_espacios ";
			$sql.="WHERE id_espacio='$id_espacio' ";
			$sql.="AND id_carrera='$id_carrera'";
		
		toXML($xml, $sql, "carreraespacio");
		
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
			
			// Buscar si existe el espacio en tomo_espacios
			$sql="SELECT COUNT(id_tomo_espacio) 'cc2' ";
			$sql.="FROM tomo_espacios ";
			$sql.="WHERE id_espacio='".$espacios->espacios[$idx]['id_espacio']."'";
			//toXML($xml, $sql, "espacios");
			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$row = mysqli_fetch_array($result);
			
			// Si no existe, darlo de alta en tomo espacios, y generar una novedad con tipo_novedad = 'N'
			if ($row['cc2']==0) {
				$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$espacios->espacios[$idx]['tipo']."'";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row = mysqli_fetch_array($result);
				$id_tipo_titulo = $row['id_tipo_titulo'];
				$cod_tipo_titulo = $row['codigo'];
				
				$sql = "SELECT denominacion 'titulo' FROM titulos ";				
				$sql.="WHERE id_titulo='$id_titulo'";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row = mysqli_fetch_array($result);
				$titulo = $row['titulo'];
				
				$sql = "SELECT nombre 'carrera' FROM carreras ";				
				$sql.="WHERE id_carrera='".$espacios->espacios[$idx]['id_carrera']."'";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row = mysqli_fetch_array($result);
				$carrera = $row['carrera'];
				
				$sql = "SELECT denominacion 'espacio' FROM espacios ";				
				$sql.="WHERE id_espacio='".$espacios->espacios[$idx]['id_espacio']."'";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row = mysqli_fetch_array($result);
				$espacio = $row['espacio'];
					
				$sql = "INSERT INTO tomo_espacios SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
						"id_espacio='".$espacios->espacios[$idx]['id_espacio']."', cod_espacio='".$espacios->espacios[$idx]['cod_espacio']."', " .
						"id_carrera='".$espacios->espacios[$idx]['id_carrera']."', cod_carrera='".$espacios->espacios[$idx]['cod_carrera']."', " .
						"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
						"id_tipo_clasificacion='".$espacios->espacios[$idx]['id_tipo_clasificacion']."'";										
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
					$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
				} else {
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
				
				$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$espacios->espacios[$idx]['tipo']."'";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row = mysqli_fetch_array($result);
				$id_tipo_titulo = $row['id_tipo_titulo'];
				$cod_tipo_titulo = $row['codigo'];
				$sql = "INSERT INTO nov_tomo_espacios SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
						"id_espacio='".$espacios->espacios[$idx]['id_espacio']."', cod_espacio='".$espacios->espacios[$idx]['cod_espacio']."', " .
						"id_carrera='".$espacios->espacios[$idx]['id_carrera']."', cod_carrera='".$espacios->espacios[$idx]['cod_carrera']."', " .
						"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
						"id_tipo_clasificacion='".$espacios->espacios[$idx]['id_tipo_clasificacion']."', " .
						"tipo_novedad = 'N', " .
						"estado='V', " .
						"fecha_novedad=NOW(), " .
						"timestamp=NOW(), " .
						"usuario_novedad='".$_SESSION['usuario']."'";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
					$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
				}
			} else {
				// Si el espacio existe en tomo espacios, verificar si existe una novedad con tipo_novedad = 'N',
				// con una antiguedad menor o igual a un día. Eso significa que la incumbencia de título será 
				// impactada, ya que no se trataba de un espacio preexistente sino de un nuevo, al cual recién 
				// se está categorizando						
				$sql = "SELECT COUNT(id_nov_tomo_espacios) 'cc3' FROM nov_tomo_espacios WHERE id_espacio='".$espacios->espacios[$idx]['id_espacio']."'" .
					" AND tipo_novedad='N' AND CURDATE() <= DATE_ADD(fecha_novedad, INTERVAL 1 DAY)";									
				
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row = mysqli_fetch_array($result);
				
				if ($row['cc3'] > 0) {
					$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$espacios->espacios[$idx]['tipo']."'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$id_tipo_titulo = $row['id_tipo_titulo'];
					$cod_tipo_titulo = $row['codigo'];
					
					$sql = "SELECT denominacion 'titulo' FROM titulos ";				
					$sql.="WHERE id_titulo='$id_titulo'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$titulo = $row['titulo'];
					
					$sql = "SELECT nombre 'carrera' FROM carreras ";				
					$sql.="WHERE id_carrera='".$espacios->espacios[$idx]['id_carrera']."'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$carrera = $row['carrera'];
					
					$sql = "SELECT denominacion 'espacio' FROM espacios ";				
					$sql.="WHERE id_espacio='".$espacios->espacios[$idx]['id_espacio']."'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$espacio = $row['espacio'];
					
					$sql = "INSERT INTO tomo_espacios SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
							"id_espacio='".$espacios->espacios[$idx]['id_espacio']."', cod_espacio='".$espacios->espacios[$idx]['cod_espacio']."', " .
							"id_carrera='".$espacios->espacios[$idx]['id_carrera']."', cod_carrera='".$espacios->espacios[$idx]['cod_carrera']."', " .
							"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
							"id_tipo_clasificacion='".$espacios->espacios[$idx]['id_tipo_clasificacion']."'";										
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
						$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
					} else {
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
					$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$espacios->espacios[$idx]['tipo']."'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$id_tipo_titulo = $row['id_tipo_titulo'];
					$cod_tipo_titulo = $row['codigo'];
					$sql = "INSERT INTO nov_tomo_espacios SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
						"id_espacio='".$espacios->espacios[$idx]['id_espacio']."', cod_espacio='".$espacios->espacios[$idx]['cod_espacio']."', " .
						"id_carrera='".$espacios->espacios[$idx]['id_carrera']."', cod_carrera='".$espacios->espacios[$idx]['cod_carrera']."', " .
						"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
						"id_tipo_clasificacion='".$espacios->espacios[$idx]['id_tipo_clasificacion']."', " .
						"tipo_novedad = 'A', " .
						"estado='S', " .
						"fecha_novedad=NOW(), " .
						"timestamp=NOW(), " .
						"usuario_novedad='".$_SESSION['usuario']."'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					
					if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
						$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
					}	
				}
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