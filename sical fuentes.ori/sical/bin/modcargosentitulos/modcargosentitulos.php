<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");
include("../_phpincludes/_cargos.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlCargo"] = str_replace('\"','"',$_REQUEST["xmlCargo"]);
		$xml_Cargo = loadXML($_REQUEST["xmlCargo"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_tomo_cargo) 'cc' ";
		$sql.="FROM tomo_cargos ";
		$sql.="WHERE id_titulo='$id_titulo' ";
		$sql.="AND id_cargo='".$xml_Cargo["id_cargo"]."' ";
		//$sql.="AND id_tipo_titulo='".$xml_Cargo["id_tipo_titulo"]."'";		
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n['cc']==0)
		{
			$sql="SELECT COUNT(id_tomo_cargo) 'ccn' ";
			$sql.="FROM nov_tomo_cargos ";
			$sql.="WHERE id_titulo='$id_titulo' ";
			$sql.="AND id_cargo='".$xml_Cargo["id_cargo"]."' ";
			$sql.="AND estado='S'";
			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$row = mysqli_fetch_array($result);
			
			if ($row['ccn']==0) {
				$sql="SELECT COUNT(id_tomo_cargo) 'cc1' ";
				$sql.="FROM tomo_cargos ";
				$sql.="WHERE id_cargo='".$xml_Cargo["id_cargo"]."'";			
				toXML($xml, $sql, "cargos");
				
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				
				$row = mysqli_fetch_array($result);
				
				if ($row['cc1']==0) {
					$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Cargo['tipo']."'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$id_tipo_titulo = $row['id_tipo_titulo'];
					$cod_tipo_titulo = $row['codigo'];	
								
					$sql="INSERT tomo_cargos SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
							"id_cargo='".$xml_Cargo['id_cargo']."', cod_cargo='".$xml_Cargo['cod_cargo']."', " .					
							"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
							"id_tipo_clasificacion='".$xml_Cargo['id_tipo_clasificacion']."', " .
							"cod_tipo_clasificacion='".$xml_Cargo['cod_tipo_clasificacion']."', " .
							"cod_nivel='".$xml_Cargo['cod_nivel']."'";
					toXML($xml, $sql, "add");
					
					$sql="INSERT nov_tomo_cargos SET id_tomo_cargo='".$xml_Cargo["id_tomo_cargo"]."', id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
							"id_cargo='".$xml_Cargo['id_cargo']."', cod_cargo='".$xml_Cargo['cod_cargo']."', " .					
							"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
							"id_tipo_clasificacion='".$xml_Cargo['id_tipo_clasificacion']."', " .
							"cod_tipo_clasificacion='".$xml_Cargo['cod_tipo_clasificacion']."', " .
							"cod_nivel='".$xml_Cargo['cod_nivel']."', " .
							"tipo_novedad = 'N', " .
							"estado='V', " .
							"fecha_novedad=NOW(), " .
							"timestamp=NOW(), " .
							"usuario_novedad='".$_SESSION['usuario']."'";			
					toXML($xml, $sql, "add");	
				} else {
					$sql = "SELECT COUNT(id_nov_tomo_cargos) 'cc2' FROM nov_tomo_cargos WHERE id_cargo='".$xml_Cargo['id_cargo']."' " .
							" AND tipo_novedad='N' AND CURDATE() <= DATE_ADD(fecha_novedad, INTERVAL 1 DAY)";
							
					toXML($xml, $sql, "novedades");
					
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					
					if ($row['cc2'] > 0) {
						$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Cargo['tipo']."'";
						$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						$row = mysqli_fetch_array($result);
						$id_tipo_titulo = $row['id_tipo_titulo'];
						$cod_tipo_titulo = $row['codigo'];	
									
						$sql="INSERT tomo_cargos SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
								"id_cargo='".$xml_Cargo['id_cargo']."', cod_cargo='".$xml_Cargo['cod_cargo']."', " .					
								"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
								"id_tipo_clasificacion='".$xml_Cargo['id_tipo_clasificacion']."', " .
								"cod_tipo_clasificacion='".$xml_Cargo['cod_tipo_clasificacion']."', " .
								"cod_nivel='".$xml_Cargo['cod_nivel']."'";			
						toXML($xml, $sql, "add");
					} else {
						$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Cargo['tipo']."'";
						$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						$row = mysqli_fetch_array($result);
						$id_tipo_titulo = $row['id_tipo_titulo'];
						$cod_tipo_titulo = $row['codigo'];	
									
						$sql="INSERT nov_tomo_cargos SET id_tomo_cargo='".$xml_Cargo["id_tomo_cargo"]."', id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
								"id_cargo='".$xml_Cargo['id_cargo']."', cod_cargo='".$xml_Cargo['cod_cargo']."', " .					
								"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
								"id_tipo_clasificacion='".$xml_Cargo['id_tipo_clasificacion']."', " .
								"cod_tipo_clasificacion='".$xml_Cargo['cod_tipo_clasificacion']."', " .
								"cod_nivel='".$xml_Cargo['cod_nivel']."', " .
								"tipo_novedad = 'A', " .
								"estado='S', " .
								"fecha_novedad=NOW(), " .
								"timestamp=NOW(), " .
								"usuario_novedad='".$_SESSION['usuario']."'";
						toXML($xml, $sql, "add");
					}				
				}	
			} else {
				$error="Existe una novedad pendiente de ser impactada para el título y cargo seleccionados\n";
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
		
		$sql="SELECT COUNT(id_tomo_cargo) 'cc' FROM nov_tomo_cargos WHERE id_tomo_cargo='".$xml_Cargo["id_tomo_cargo"]."'";
		$sql.=" AND estado='S'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		if ($row['cc'] == 0) {
			$sql="UPDATE tomo_cargos SET marcado='1' WHERE id_tomo_cargo='".$xml_Cargo["id_tomo_cargo"]."'";
			query($sql);
			
			$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Cargo['tipo']."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_tipo_titulo = $row['id_tipo_titulo'];
			$cod_tipo_titulo = $row['codigo'];
			
			$sql="INSERT nov_tomo_cargos SET id_tomo_cargo='".$xml_Cargo["id_tomo_cargo"]."', id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
							"id_cargo='".$xml_Cargo['id_cargo']."', cod_cargo='".$xml_Cargo['cod_cargo']."', " .					
							"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
							"id_tipo_clasificacion='".$xml_Cargo['id_tipo_clasificacion']."', " .
							"cod_tipo_clasificacion='".$xml_Cargo['cod_tipo_clasificacion']."', " .
							"cod_nivel='".$xml_Cargo['cod_nivel']."', " .
							"tipo_novedad = 'B', " .
							"estado='S', " .
							"fecha_novedad=NOW(), " .
							"timestamp=NOW(), " .
							"usuario_novedad='".$_SESSION['usuario']."'";
			
			/*$sql="DELETE FROM tomo_cargos ";
			$sql.="WHERE id_tomo_cargo='".$xml_Cargo["id_tomo_cargo"]."' ";*/
			toXML($xml, $sql, "del");
					
			header('Content-Type: text/xml');
			echo $xml->asXML();	
		} else {
			$error="Existe una novedad pendiente de ser impactada para el tomo_cargo seleccionado\n";
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
	  	
	  	traer_cargos($xml,1,'denominacion','');
		
		traer_niveles($xml);
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
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
   case 'traer_cargos':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_tomo_cargo, id_cargo, cod_cargo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, marcado, 'A' as origen ";
		$sql.="FROM tomo_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";		
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="WHERE id_titulo = '$id_titulo' ";		
		$sql.="ORDER BY denomcar";
		toXML($xml, $sql, "cargos");
		
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
   case 'buscar_cargo':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_cargos($xml,1,'codigo',$codigo);					  		  	
		
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