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
		
		$sql="SELECT COUNT(id_tomo_cargo) 'cc' ";
		$sql.="FROM tomo_cargos ";
		$sql.="WHERE id_titulo='".$xml_Titulo["id_titulo"]."' ";
		$sql.="AND id_cargo='$id_cargo' ";				
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n['cc']==0)
		{
			$sql="SELECT COUNT(id_tomo_cargo) 'ccn' ";
			$sql.="FROM nov_tomo_cargos ";
			$sql.="WHERE id_titulo='".$xml_Titulo["id_titulo"]."' ";
			$sql.="AND id_cargo='$id_cargo' ";
			$sql.="AND estado='S'";
			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$row = mysqli_fetch_array($result);
			
			if ($row['ccn']==0) {
				$sql="SELECT COUNT(id_tomo_cargo) 'cc1' ";
				$sql.="FROM tomo_cargos ";
				$sql.="WHERE id_cargo='$id_cargo' ";
				toXML($xml, $sql, "cargos");
				
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				
				$row = mysqli_fetch_array($result);
							
				if ($row['cc1']==0) {
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
					
					$sql = "SELECT denominacion 'cargo' FROM cargos ";				
					$sql.="WHERE id_cargo='$id_cargo'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$cargo = $row['cargo'];
								
					$sql="INSERT tomo_cargos SET id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '".$xml_Titulo['cod_titulo']."', " .
							"id_cargo='$id_cargo', cod_cargo='".$xml_Titulo['cod_cargo']."', " .					
							"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
							"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."', " .
							"cod_tipo_clasificacion='".$xml_Titulo['cod_tipo_clasificacion']."', " .
							"cod_nivel='".$xml_Titulo['cod_nivel']."'";
					toXML($xml, $sql, "add");
					
					if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
						$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
						$_descrip = "ALTA DE TOMO-CARGO CON id='$_id_registro', TÍTULO '$titulo' CARGO '$cargo'";
						_auditoria($sql, 
			                    $link_salud1,
								$link_salud1,
								'tomo_cargos',
								$_id_registro,
			                    $_descrip,
			                    '',
			                    '');
					}
					
					$sql="INSERT nov_tomo_cargos SET id_tomo_cargo='".$xml_Titulo["id_tomo_cargo"]."', id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '".$xml_Titulo['cod_titulo']."', " .
							"id_cargo='$id_cargo', cod_cargo='".$xml_Titulo['cod_cargo']."', " .					
							"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
							"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."', " .
							"cod_tipo_clasificacion='".$xml_Titulo['cod_tipo_clasificacion']."', " .
							"cod_nivel='".$xml_Titulo['cod_nivel']."', " .
							"tipo_novedad = 'N', " .
							"estado='V', " .
							"fecha_novedad=NOW(), " .
							"timestamp=NOW(), " .
							"usuario_novedad='".$_SESSION['usuario']."'";
					toXML($xml, $sql, "add");
				} else {
					$sql = "SELECT COUNT(id_nov_tomo_cargos) 'cc2' FROM nov_tomo_cargos WHERE id_cargo='$id_cargo' " .
							" AND tipo_novedad='N' AND CURDATE() <= DATE_ADD(fecha_novedad, INTERVAL 1 DAY)";
							
					toXML($xml, $sql, "novedades");
					
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					
					if ($row['cc2'] > 0) {
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
						
						$sql = "SELECT denominacion 'cargo' FROM cargos ";				
						$sql.="WHERE id_cargo='$id_cargo'";
						$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						$row = mysqli_fetch_array($result);
						$cargo = $row['cargo'];
									
						$sql="INSERT tomo_cargos SET id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '".$xml_Titulo['cod_titulo']."', " .
								"id_cargo='$id_cargo', cod_cargo='".$xml_Titulo['cod_cargo']."', " .					
								"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
								"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."', " .
								"cod_tipo_clasificacion='".$xml_Titulo['cod_tipo_clasificacion']."', " .
								"cod_nivel='".$xml_Titulo['cod_nivel']."'";			
						toXML($xml, $sql, "add");
						
						if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
							$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
							$_descrip = "ALTA DE TOMO-CARGO CON id='$_id_registro', TÍTULO '$titulo' CARGO '$cargo'";
							_auditoria($sql, 
				                    $link_salud1,
									$link_salud1,
									'tomo_cargos',
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
									
						$sql="INSERT nov_tomo_cargos SET id_tomo_cargo='".$xml_Titulo["id_tomo_cargo"]."', id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '".$xml_Titulo['cod_titulo']."', " .
								"id_cargo='$id_cargo', cod_cargo='".$xml_Titulo['cod_cargo']."', " .					
								"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
								"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."', " .
								"cod_tipo_clasificacion='".$xml_Titulo['cod_tipo_clasificacion']."', " .
								"cod_nivel='".$xml_Titulo['cod_nivel']."', " .
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
		$_REQUEST["xmlTitulo"] = str_replace('\"','"',$_REQUEST["xmlTitulo"]);
		$xml_Titulo = loadXML($_REQUEST["xmlTitulo"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_tomo_cargo) 'cc' FROM nov_tomo_cargos WHERE id_tomo_cargo='".$xml_Titulo["id_tomo_cargo"]."'";
		$sql.=" AND estado='S'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		if ($row['cc'] == 0) {
			$sql="UPDATE tomo_cargos SET marcado='1' WHERE id_tomo_cargo='".$xml_Titulo["id_tomo_cargo"]."'";
			query($sql);
			
			$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$xml_Titulo['tipo']."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_tipo_titulo = $row['id_tipo_titulo'];
			$cod_tipo_titulo = $row['codigo'];
			
			$sql="INSERT nov_tomo_cargos SET id_tomo_cargo='".$xml_Titulo["id_tomo_cargo"]."', id_titulo = '".$xml_Titulo["id_titulo"]."', cod_titulo = '".$xml_Titulo['cod_titulo']."', " .
							"id_cargo='$id_cargo', cod_cargo='".$xml_Titulo['cod_cargo']."', " .					
							"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
							"id_tipo_clasificacion='".$xml_Titulo['id_tipo_clasificacion']."', " .
							"cod_tipo_clasificacion='".$xml_Titulo['cod_tipo_clasificacion']."', " .
							"cod_nivel='".$xml_Titulo['cod_nivel']."', " .
							"tipo_novedad = 'B', " .
							"estado='S', " .
							"fecha_novedad=NOW(), " .
							"timestamp=NOW(), " .
							"usuario_novedad='".$_SESSION['usuario']."'";
			
			/*$sql="DELETE FROM tomo_cargos ";
			$sql.="WHERE id_tomo_cargo='".$xml_Titulo["id_tomo_cargo"]."' ";*/
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
				   		
	  	$xml2=new SimpleXMLElement('<rows/>');
	  	
	  	$sql="SELECT * ";
		$sql.="FROM cargos ";		
		$sql.="ORDER BY codigo";
		toXML($xml2, $sql, "cargos");
		
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
	  	$sql="SELECT id_titulo, codigo, denominacion ";
		$sql.="FROM titulos ";		
		$sql.="WHERE codigo = '$codigo' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "titulo");
		
		echo $xml->asXML();
				
    	break;
   }   
   case 'traer_titulos':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_tomo_cargo, id_cargo, cod_cargo, id_titulo, cod_titulo, tit.denominacion 'denomtit', id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, marcado, 'A' as origen ";
		$sql.="FROM tomo_cargos ";
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
	  	$sql="SELECT id_cargo, codigo, denominacion, id_nivel, 'N' as origen ";
		$sql.="FROM cargos ";		
		$sql.="WHERE codigo = '$codigo' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "cargo");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_cargos_n':
 	{ 		
 		$denominacion = strtoupper($denominacion);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_cargo, codigo, denominacion, id_nivel, 'N' as origen ";
		$sql.="FROM cargos ";		
		$sql.="WHERE denominacion LIKE '%$denominacion%' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "cargo");
		
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