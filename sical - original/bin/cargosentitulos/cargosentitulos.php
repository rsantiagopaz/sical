<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");
include("../_phpincludes/_cargos.php");
include("../_phpincludes/_titulos.php");
include("../_phpincludes/_tipos_titulos.php");
include("../_phpincludes/_tipos_clasificacion.php");

switch ($_REQUEST['rutina'])
{	
 	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_cargos($xml,1,'denominacion','');
		
		traer_niveles($xml);
		
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
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_titulos($xml,'denominacion',$denominacion);	  	
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }
   case 'traer_carreras':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_carreras($xml,'nombre',$nombre,'',1);			  		  	
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }
   case 'traer_cargos':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_tomo_cargo, id_cargo, cod_cargo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, nivel, 'A' as origen ";
		$sql.="FROM tomo_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";		
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE id_titulo = '$id_titulo' ";		
		$sql.="ORDER BY denomcar";
		toXML($xml, $sql, "cargos");
		
		header('Content-Type: text/xml');
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
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }   
   case 'dar_alta':
 	{
 		$error = "";		
 		$_REQUEST["xmlCargos"] = str_replace('\"','"',$_REQUEST["xmlCargos"]);
 		$cargos = loadXML($_REQUEST['xmlCargos']);			
		for ($idx=0;$idx<count($cargos->cargos);$idx++) {
			$sql ="SELECT COUNT(id_tomo_cargo) 'cc1' ";
			$sql.="FROM tomo_cargos ";
			$sql.="WHERE id_cargo='".$cargos->cargos[$idx]['id_cargo']."'";			
			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);			
			$row = mysqli_fetch_array($result);						
			
			// Obtener el cod_nivel a partir del id_nivel del cargo.
			// Esto es necesario porque algunos registros de tomo_cargos tienen
			// un valor NULL en cod_nivel.
			// En el futuro esto no será necesario			
			$sql_cod_nivel ="SELECT id_nivel FROM cargos ";
			$sql_cod_nivel.="WHERE id_cargo='".$cargos->cargos[$idx]['id_cargo']."'";
			$result_cod_nivel = mysqli_query($GLOBALS["___mysqli_ston"], $sql_cod_nivel);			
			$row_cod_nivel = mysqli_fetch_array($result_cod_nivel);			
			$cargos->cargos[$idx]['cod_nivel']=$row_cod_nivel['id_nivel'];						
						
			if ($row['cc1']==0) {
				$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$cargos->cargos[$idx]['tipo']."'";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row = mysqli_fetch_array($result);
				$id_tipo_titulo = $row['id_tipo_titulo'];
				$cod_tipo_titulo = $row['codigo'];
				
				$sql = "SELECT denominacion 'titulo' FROM titulos ";				
				$sql.="WHERE id_titulo='$id_titulo'";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row = mysqli_fetch_array($result);
				$titulo = $row['titulo'];
				
				$sql = "SELECT denominacion 'cargo' FROM cargos ";				
				$sql.="WHERE id_cargo='".$cargos->cargos[$idx]['id_cargo']."'";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row = mysqli_fetch_array($result);
				$cargo = $row['cargo'];
				
				$sql = "INSERT INTO tomo_cargos SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
						"id_cargo='".$cargos->cargos[$idx]['id_cargo']."', cod_cargo='".$cargos->cargos[$idx]['cod_cargo']."', " .					
						"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
						"id_tipo_clasificacion='".$cargos->cargos[$idx]['id_tipo_clasificacion']."', " .
						"cod_tipo_clasificacion='".$cargos->cargos[$idx]['cod_tipo_clasificacion']."', " .
						"cod_nivel='".$cargos->cargos[$idx]['cod_nivel']."'";										
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
					$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
				} else {
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
				
				$sql = "INSERT INTO nov_tomo_cargos SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
						"id_cargo='".$cargos->cargos[$idx]['id_cargo']."', cod_cargo='".$cargos->cargos[$idx]['cod_cargo']."', " .					
						"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
						"id_tipo_clasificacion='".$cargos->cargos[$idx]['id_tipo_clasificacion']."', " .
						"cod_tipo_clasificacion='".$cargos->cargos[$idx]['cod_tipo_clasificacion']."', " .
						"cod_nivel='".$cargos->cargos[$idx]['cod_nivel']."', " .
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
				$sql = "SELECT COUNT(id_nov_tomo_cargos) 'cc2' FROM nov_tomo_cargos WHERE id_cargo='".$cargos->cargos[$idx]['id_cargo']."' " .
							" AND tipo_novedad='N' AND CURDATE() <= DATE_ADD(fecha_novedad, INTERVAL 1 DAY)";											
				
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row = mysqli_fetch_array($result);
				
				if ($row['cc2'] > 0) {
					$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$cargos->cargos[$idx]['tipo']."'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$id_tipo_titulo = $row['id_tipo_titulo'];
					$cod_tipo_titulo = $row['codigo'];
					
					$sql = "SELECT denominacion 'titulo' FROM titulos ";				
					$sql.="WHERE id_titulo='$id_titulo'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$titulo = $row['titulo'];
					
					$sql = "SELECT denominacion 'cargo' FROM cargos ";				
					$sql.="WHERE id_cargo='".$cargos->cargos[$idx]['id_cargo']."'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$cargo = $row['cargo'];
					
					$sql = "INSERT INTO tomo_cargos SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
							"id_cargo='".$cargos->cargos[$idx]['id_cargo']."', cod_cargo='".$cargos->cargos[$idx]['cod_cargo']."', " .					
							"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
							"id_tipo_clasificacion='".$cargos->cargos[$idx]['id_tipo_clasificacion']."', " .
							"cod_tipo_clasificacion='".$cargos->cargos[$idx]['cod_tipo_clasificacion']."', " .
							"cod_nivel='".$cargos->cargos[$idx]['cod_nivel']."'";															
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
						$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
					} else {
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
					$sql = "SELECT id_tipo_titulo, codigo FROM tipos_titulos WHERE tipo='".$cargos->cargos[$idx]['tipo']."'";
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$id_tipo_titulo = $row['id_tipo_titulo'];
					$cod_tipo_titulo = $row['codigo'];	
								
					$sql = "INSERT INTO nov_tomo_cargos SET id_titulo = '$id_titulo', cod_titulo = '$cod_titulo', " .
							"id_cargo='".$cargos->cargos[$idx]['id_cargo']."', cod_cargo='".$cargos->cargos[$idx]['cod_cargo']."', " .					
							"id_tipo_titulo='$id_tipo_titulo', cod_tipo_titulo='$cod_tipo_titulo', " .
							"id_tipo_clasificacion='".$cargos->cargos[$idx]['id_tipo_clasificacion']."', " .
							"cod_tipo_clasificacion='".$cargos->cargos[$idx]['cod_tipo_clasificacion']."', " .
							"cod_nivel='".$cargos->cargos[$idx]['cod_nivel']."', " .
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