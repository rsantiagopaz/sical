<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");

ini_set('memory_limit', '256M');

set_time_limit(1200);

switch ($_REQUEST['rutina'])
{	
 	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	$sql="SELECT * ";
		$sql.="FROM cargos ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "cargos");
		
		$sql="SELECT * ";
		$sql.="FROM niveles ";
		$sql.="ORDER BY nivel";
		toXML($xml, $sql, "niveles");
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
   case 'delete': 
	{		
		$xml=new SimpleXMLElement('<rows/>');
				
		$sql="UPDATE tomo_cargos SET marcado='0' WHERE id_tomo_cargo='$id_tomo_cargo'";
		query($sql);				
		
		$sql="DELETE FROM nov_tomo_cargos ";
		$sql.="WHERE id_nov_tomo_cargos='$id_nov_tomo_cargos' ";
		toXML($xml, $sql, "del");
				
		header('Content-Type: text/xml');
		echo $xml->asXML();		
		break;
	}
   case 'impactar': 
	{		
		$xml=new SimpleXMLElement('<rows/>');
		$datos_impactado = '';
		
		$sql="SELECT tipo_novedad, t.denominacion 'titulo', c.denominacion 'cargo' FROM nov_tomo_cargos ";
		$sql.="INNER JOIN titulos t USING(id_titulo) ";
		$sql.="INNER JOIN cargos c USING(id_cargo) ";
		$sql.="WHERE id_nov_tomo_cargos='$id_nov_tomo_cargos'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);				
		$titulo=$row['titulo'];		
		$cargo=$row['cargo'];
		
		if ($row['tipo_novedad'] == 'B') {
			$sql="DELETE FROM tomo_cargos WHERE id_tomo_cargo='$id_tomo_cargo'";
			$tipo_novedad = 'BAJA';
			$datos_impactado .= $sql . ' ';
			query($sql);
		} else {
			$sql="INSERT INTO tomo_cargos (id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_cargo,cod_cargo,id_tipo_clasificacion,cod_tipo_clasificacion,cod_nivel,marcado) " .
					"SELECT id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_cargo,cod_cargo,id_tipo_clasificacion,cod_tipo_clasificacion,cod_nivel,0 " .
					"FROM nov_tomo_cargos WHERE id_nov_tomo_cargos='$id_nov_tomo_cargos'";
			//$sql="UPDATE tomo_cargos SET marcado='0' WHERE id_tomo_cargo='$id_tomo_cargo'";
			$tipo_novedad = 'ALTA';
			$datos_impactado .= $sql . ' ';
			query($sql);				
		}										
		
		$sql="UPDATE nov_tomo_cargos SET estado='V', fecha_volcado=NOW(), usuario_volcado='".$_SESSION['usuario']."' ";
		$sql.="WHERE id_nov_tomo_cargos='$id_nov_tomo_cargos' ";
		$datos_impactado .= $sql . ' ';
		toXML($xml, $sql, "del");
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {			
			$_descrip = "IMPACTADO DE LA NOVEDAD CON id='$id_nov_tomo_cargos', CORRESPONDIENTE A UNA '$tipo_novedad'. ";
			$_descrip.="TÍTULO '$titulo' CARGO '$cargo'";
			_auditoria($datos_impactado, 
                    $link_salud1,
					$link_salud1,
					'tomo_cargos',
					$id_nov_tomo_cargos,
                    $_descrip,
                    '',
                    '');	
		}
				
		header('Content-Type: text/xml');
		echo $xml->asXML();		
		break;
	}
   case 'impactar_todas': 
	{		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql_todas="SELECT tipo_novedad, id_nov_tomo_cargos, id_tomo_cargo, t.denominacion 'titulo', c.denominacion 'cargo' FROM nov_tomo_cargos ";
		$sql_todas.="INNER JOIN titulos t USING(id_titulo) ";
		$sql_todas.="INNER JOIN cargos c USING(id_cargo) ";
		$sql_todas.="WHERE estado='S'";
		
		if (isset($_REQUEST['id_nivel']))
			$sql_todas.=" AND c.id_nivel = '$id_nivel'";
		
		//$sql_todas="SELECT tipo_novedad, id_nov_tomo_cargos, id_tomo_cargo FROM nov_tomo_cargos WHERE estado='S'";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql_todas);
		
		while ($row = mysqli_fetch_array($result)) {
			/*$sql="SELECT tipo_novedad FROM nov_tomo_cargos WHERE id_nov_tomo_cargos='$id_nov_tomo_cargos'";
			$result = mysql_query($sql);
			$row = mysql_fetch_array($result);*/
						
			$datos_impactado = '';
			
			if ($row['tipo_novedad'] == 'B') {
				$sql="DELETE FROM tomo_cargos WHERE id_tomo_cargo='".$row['id_tomo_cargo']."'";
				$tipo_novedad = 'BAJA';
				$datos_impactado .= $sql . ' ';
				query($sql);
			} else {
				$sql="INSERT INTO tomo_cargos (id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_cargo,cod_cargo,id_tipo_clasificacion,cod_tipo_clasificacion,cod_nivel,marcado) " .
						"SELECT id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_cargo,cod_cargo,id_tipo_clasificacion,cod_tipo_clasificacion,cod_nivel,0 " .
						"FROM nov_tomo_cargos WHERE id_nov_tomo_cargos='".$row['id_nov_tomo_cargos']."'";
				//$sql="UPDATE tomo_cargos SET marcado='0' WHERE id_tomo_cargo='$id_tomo_cargo'";
				$tipo_novedad = 'ALTA';
				$datos_impactado .= $sql . ' ';
				query($sql);				
			}										
			
			$sql="UPDATE nov_tomo_cargos SET estado='V', fecha_volcado=NOW(), usuario_volcado='".$_SESSION['usuario']."' ";
			$sql.="WHERE id_nov_tomo_cargos='".$row['id_nov_tomo_cargos']."' ";
			toXML($xml, $sql, "del");
			
			if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {			
				$_descrip = "IMPACTADO DE LA NOVEDAD CON id='".$row['id_nov_tomo_cargos']."', CORRESPONDIENTE A UNA '$tipo_novedad'. ";
				$_descrip.="TÍTULO '".$row['titulo']."' CARGO '".$row['cargo']."'";
				_auditoria($datos_impactado, 
	                    $link_salud1,
						$link_salud1,
						'tomo_cargos',
						$row['id_nov_tomo_cargos'],
	                    $_descrip,
	                    '',
	                    '');	
			}
		}			
				
		header('Content-Type: text/xml');
		echo $xml->asXML();		
		break;
	}
	case 'impactar_seleccionadas': 
	{		
		$xml=new SimpleXMLElement('<rows/>');
		
		$_REQUEST["novedades"] = str_replace('\"','"',$_REQUEST["xmlNovedades"]);
		$novedades = loadXML($_REQUEST['novedades']);				
		
		for ($idx=0;$idx<count($novedades->cargos);$idx++) {						
			$datos_impactado = '';
			
			$sql_query="SELECT tipo_novedad, id_nov_tomo_cargos, id_tomo_cargo, nt.estado 'estado', t.denominacion 'titulo', c.denominacion 'cargo' FROM nov_tomo_cargos nt ";
			$sql_query.="INNER JOIN titulos t USING(id_titulo) ";
			$sql_query.="INNER JOIN cargos c USING(id_cargo) ";
			$sql_query.="WHERE id_nov_tomo_cargos = '".$novedades->cargos[$idx]['id_nov_tomo_cargos']."'";
			$result_query = mysqli_query($GLOBALS["___mysqli_ston"], $sql_query);
			$row = mysqli_fetch_array($result_query);
			
			if ($row['estado'] != 'V') {
				if ($row['tipo_novedad'] == 'B') {
					$sql="DELETE FROM tomo_cargos WHERE id_tomo_cargo='".$row['id_tomo_cargo']."'";
					$tipo_novedad = 'BAJA';
					$datos_impactado .= $sql . ' ';
					query($sql);
				} else {
					$sql="INSERT INTO tomo_cargos (id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_cargo,cod_cargo,id_tipo_clasificacion,cod_tipo_clasificacion,cod_nivel,marcado) " .
							"SELECT id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_cargo,cod_cargo,id_tipo_clasificacion,cod_tipo_clasificacion,cod_nivel,0 " .
							"FROM nov_tomo_cargos WHERE id_nov_tomo_cargos='".$row['id_nov_tomo_cargos']."'";
					
					$tipo_novedad = 'ALTA';
					$datos_impactado .= $sql . ' ';
					query($sql);				
				}										
				
				$sql="UPDATE nov_tomo_cargos SET estado='V', fecha_volcado=NOW(), usuario_volcado='".$_SESSION['usuario']."' ";
				$sql.="WHERE id_nov_tomo_cargos='".$row['id_nov_tomo_cargos']."' ";
				toXML($xml, $sql, "del");
				
				if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {			
					$_descrip = "IMPACTADO DE LA NOVEDAD CON id='".$row['id_nov_tomo_cargos']."', CORRESPONDIENTE A UNA '$tipo_novedad'. ";
					$_descrip.="TÍTULO '".$row['titulo']."' CARGO '".$row['cargo']."'";
					_auditoria($datos_impactado, 
		                    $link_salud1,
							$link_salud1,
							'tomo_cargos',
							$row['id_nov_tomo_cargos'],
		                    $_descrip,
		                    '',
		                    '');	
				}
			}						
		}			
				
		header('Content-Type: text/xml');
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
	  	$sql="SELECT id_nov_tomo_cargos, DATE_FORMAT(fecha_novedad,'%d/%m/%Y') 'fecha_novedad', id_tomo_cargo, id_cargo, cod_cargo, id_titulo, cod_titulo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', ti.denominacion 'denomtit', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, nivel, 'A' as origen, ";
	  	$sql.="tipo_novedad ";
		$sql.="FROM nov_tomo_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";
		$sql.="INNER JOIN titulos ti USING(id_titulo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE estado = 'S' ";
		$sql.="ORDER BY fecha_novedad ASC";
		toXML($xml, $sql, "cargos");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_cargos_2':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_nov_tomo_cargos, DATE_FORMAT(fecha_novedad,'%d/%m/%Y') 'fecha_novedad', id_tomo_cargo, id_cargo, cod_cargo, id_titulo, cod_titulo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', ti.denominacion 'denomtit', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, nivel, 'A' as origen, ";
	  	$sql.="tipo_novedad ";
		$sql.="FROM nov_tomo_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";
		$sql.="INNER JOIN titulos ti USING(id_titulo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE estado = 'S' ";
		if ($cod_titulo != '')
			$sql.="AND cod_titulo = '$cod_titulo' ";
		if ($cod_cargo != '')
			$sql.="AND cod_cargo = '$cod_cargo' ";
		if ($nombre != '') {
			if ($tipo == "Título") {
				$sql .= "AND ti.denominacion LIKE '$nombre' ";
			} else {
				$sql .= "AND ca.denominacion LIKE '$nombre' ";
			}
		}
		if ($id_nivel != "")
			$sql .= "AND id_nivel='$id_nivel' ";
		if ($usuario != 'TODOS')
			$sql .= "AND usuario_novedad = '$usuario'";
		$sql.="ORDER BY fecha_novedad ASC";
		toXML($xml, $sql, "cargos");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_cargo':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_cargo, codigo, denominacion, 'N' as origen ";
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
	  	$sql="SELECT id_cargo, codigo, denominacion, 'N' as origen ";
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
   case 'traer_usuarios':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT u.SYSusuario, SYSusuarionombre ";
		$sql.="FROM _organismos_areas_usuarios oau JOIN _usuarios u USING(SYSusuario) ";				
		$sql.="WHERE organismo_area_id='6'";
		toXML($xml, $sql, "usuarios");		
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_niveles':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  		  	
		
		traer_niveles($xml);
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
}
?>