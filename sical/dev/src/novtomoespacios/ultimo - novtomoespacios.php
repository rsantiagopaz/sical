<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

ini_set('memory_limit', '256M');

set_time_limit(1200);

switch ($_REQUEST['rutina'])
{	
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
   case 'delete': 
	{		
		$xml=new SimpleXMLElement('<rows/>');
				
		$sql="UPDATE tomo_espacios SET marcado='0' WHERE id_tomo_espacio='$id_tomo_espacio'";
		query($sql);				
		
		$sql="DELETE FROM nov_tomo_espacios ";
		$sql.="WHERE id_nov_tomo_espacios='$id_nov_tomo_espacios' ";
		toXML($xml, $sql, "del");
				
		header('Content-Type: text/xml');
		echo $xml->asXML();		
		break;
	}
   case 'impactar': 
	{		
		$xml=new SimpleXMLElement('<rows/>');
		$datos_impactado = '';
		
		$sql="SELECT tipo_novedad, t.denominacion 'titulo', c.nombre 'carrera', e.denominacion 'espacio' FROM nov_tomo_espacios ";
		$sql.="INNER JOIN titulos t USING(id_titulo) ";
		$sql.="INNER JOIN carreras c USING(id_carrera) ";
		$sql.="INNER JOIN espacios e USING(id_espacio) ";
		$sql.="WHERE id_nov_tomo_espacios='$id_nov_tomo_espacios'";
		$result = mysql_query($sql);
		$row = mysql_fetch_array($result);				
		$titulo=$row['titulo'];		
		$carrera=$row['carrera'];		
		$espacio=$row['espacio'];
		
		if ($row['tipo_novedad'] == 'B') {
			$sql="DELETE FROM tomo_espacios WHERE id_tomo_espacio='$id_tomo_espacio'";
			$tipo_novedad = 'BAJA';
			$datos_impactado .= $sql . ' ';
			query($sql);
		} else {
			$sql="INSERT INTO tomo_espacios (id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_carrera,cod_carrera,id_espacio,cod_espacio,id_tipo_clasificacion,marcado) " .
					"SELECT id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_carrera,cod_carrera,id_espacio,cod_espacio,id_tipo_clasificacion,0 " .
					"FROM nov_tomo_espacios WHERE id_nov_tomo_espacios='$id_nov_tomo_espacios'";
			//$sql="UPDATE tomo_espacios SET marcado='1' WHERE id_tomo_espacio='$id_tomo_espacio'";
			$tipo_novedad = 'ALTA';
			$datos_impactado .= $sql . ' ';
			query($sql);	
		}
		
		$sql="UPDATE nov_tomo_espacios SET estado='V', fecha_volcado=NOW(), usuario_volcado='".$_SESSION['usuario']."' ";
		$sql.="WHERE id_nov_tomo_espacios='$id_nov_tomo_espacios' ";
		toXML($xml, $sql, "del");
		
		if( !(mysql_errno()>0) ) {			
			$_descrip = "IMPACTADO DE LA NOVEDAD CON id='$id_nov_tomo_espacios', CORRESPONDIENTE A UNA '$tipo_novedad'. ";
			$_descrip.="TITULO '$titulo', CARRERA '$carrera', ESPACIO '$espacio'";
			_auditoria($datos_impactado, 
                    $link_salud1,
					$link_salud1,
					'tomo_espacios',
					$id_nov_tomo_espacios,
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
		
		$sql_todas="SELECT tipo_novedad, id_nov_tomo_espacios, id_tomo_espacio, t.denominacion 'titulo', c.nombre 'carrera', e.denominacion 'espacio' FROM nov_tomo_espacios ";
		$sql_todas.="INNER JOIN titulos t USING(id_titulo) ";
		$sql_todas.="INNER JOIN carreras c USING(id_carrera) ";
		$sql_todas.="INNER JOIN espacios e USING(id_espacio) ";
		$sql_todas.="WHERE estado='S'";
		
		if (isset($_REQUEST['id_nivel']))
			$sql_todas.=" AND c.id_nivel = '$id_nivel'";
		
		//$sql_todas="SELECT tipo_novedad, id_nov_tomo_espacios, id_tomo_espacio FROM nov_tomo_espacios WHERE estado='S'";
		
		$result = mysql_query($sql_todas);
		
		while ($row = mysql_fetch_array($result)) {
			/*$sql="SELECT tipo_novedad FROM nov_tomo_espacios WHERE id_nov_tomo_espacios='$id_nov_tomo_espacios'";
			$result = mysql_query($sql);
			$row = mysql_fetch_array($result);*/
			
			$datos_impactado = '';
			
			if ($row['tipo_novedad'] == 'B') {
				$sql="DELETE FROM tomo_espacios WHERE id_tomo_espacio='".$row['id_tomo_espacio']."'";
				$tipo_novedad = 'BAJA';
				$datos_impactado .= $sql . ' ';
				query($sql);
			} else {
				$sql="INSERT INTO tomo_espacios (id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_carrera,cod_carrera,id_espacio,cod_espacio,id_tipo_clasificacion,marcado) " .
						"SELECT id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_carrera,cod_carrera,id_espacio,cod_espacio,id_tipo_clasificacion,0 " .
						"FROM nov_tomo_espacios WHERE id_nov_tomo_espacios='".$row['id_nov_tomo_espacios']."'";				
				//$sql="UPDATE tomo_espacios SET marcado='1' WHERE id_tomo_espacio='$id_tomo_espacio'";
				$tipo_novedad = 'ALTA';
				$datos_impactado .= $sql . ' ';
				query($sql);	
			}						
			
			$sql="UPDATE nov_tomo_espacios SET estado='V', fecha_volcado=NOW(), usuario_volcado='".$_SESSION['usuario']."' ";
			$sql.="WHERE id_nov_tomo_espacios='".$row['id_nov_tomo_espacios']."' ";
			toXML($xml, $sql, "del");
			
			if( !(mysql_errno()>0) ) {			
				$_descrip = "IMPACTADO DE LA NOVEDAD CON id='".$row['id_nov_tomo_espacios']."', CORRESPONDIENTE A UNA '$tipo_novedad'. ";
				$_descrip.="TITULO '".$row['titulo']."', CARRERA '".$row['carrera']."', ESPACIO '".$row['espacio']."'";
				_auditoria($datos_impactado, 
	                    $link_salud1,
						$link_salud1,
						'tomo_espacios',
						$row['id_nov_tomo_espacios'],
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
		
		for ($idx=0;$idx<count($novedades->espacios);$idx++) {			
			$datos_impactado = '';
			
			$sql_query="SELECT tipo_novedad, id_nov_tomo_espacios, id_tomo_espacio, nt.estado 'estado', t.denominacion 'titulo', c.nombre 'carrera', e.denominacion 'espacio' FROM nov_tomo_espacios nt ";
			$sql_query.="INNER JOIN titulos t USING(id_titulo) ";
			$sql_query.="INNER JOIN carreras c USING(id_carrera) ";
			$sql_query.="INNER JOIN espacios e USING(id_espacio) ";
			$sql_query.="WHERE id_nov_tomo_espacios = '".$novedades->espacios[$idx]['id_nov_tomo_espacios']."'";						
			$result_query = mysql_query($sql_query);
			$row = mysql_fetch_array($result_query);
			
			if ($row['estado'] != 'V') {
				if ($row['tipo_novedad'] == 'B') {
					$sql="DELETE FROM tomo_espacios WHERE id_tomo_espacio='".$row['id_tomo_espacio']."'";
					$tipo_novedad = 'BAJA';
					$datos_impactado .= $sql . ' ';
					query($sql);
				} else {
					$sql="INSERT INTO tomo_espacios (id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_carrera,cod_carrera,id_espacio,cod_espacio,id_tipo_clasificacion,marcado) " .
							"SELECT id_titulo,cod_titulo,id_tipo_titulo,cod_tipo_titulo,id_carrera,cod_carrera,id_espacio,cod_espacio,id_tipo_clasificacion,0 " .
							"FROM nov_tomo_espacios WHERE id_nov_tomo_espacios='".$row['id_nov_tomo_espacios']."'";				
					//$sql="UPDATE tomo_espacios SET marcado='1' WHERE id_tomo_espacio='$id_tomo_espacio'";
					$tipo_novedad = 'ALTA';
					$datos_impactado .= $sql . ' ';
					query($sql);	
				}						
				
				$sql="UPDATE nov_tomo_espacios SET estado='V', fecha_volcado=NOW(), usuario_volcado='".$_SESSION['usuario']."' ";
				$sql.="WHERE id_nov_tomo_espacios='".$row['id_nov_tomo_espacios']."' ";
				toXML($xml, $sql, "del");
				
				if( !(mysql_errno()>0) ) {			
					$_descrip = "IMPACTADO DE LA NOVEDAD CON id='".$row['id_nov_tomo_espacios']."', CORRESPONDIENTE A UNA '$tipo_novedad'. ";
					$_descrip.="TITULO '".$row['titulo']."', CARRERA '".$row['carrera']."', ESPACIO '".$row['espacio']."'";
					_auditoria($datos_impactado, 
		                    $link_salud1,
							$link_salud1,
							'tomo_espacios',
							$row['id_nov_tomo_espacios'],
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
   case 'traer_espacios':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_nov_tomo_espacios, DATE_FORMAT(fecha_novedad,'%d/%m/%Y') 'fecha_novedad', id_tomo_espacio, id_espacio, cod_carrera, cod_espacio, id_titulo, cod_titulo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="cr.nombre 'denomcar', ca.denominacion 'denomesp', ti.denominacion 'denomtit', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', id_nivel 'cod_nivel', nivel, 'A' as origen, ";
	  	$sql.="tipo_novedad ";
		$sql.="FROM nov_tomo_espacios ";
		$sql.="INNER JOIN carreras cr USING(id_carrera) ";
		$sql.="INNER JOIN espacios ca USING(id_espacio) ";
		$sql.="INNER JOIN titulos ti USING(id_titulo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE estado = 'S' ";		
		$sql.="ORDER BY fecha_novedad ASC";
		toXML($xml, $sql, "espacios");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_espacios_2':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_nov_tomo_espacios, DATE_FORMAT(fecha_novedad,'%d/%m/%Y') 'fecha_novedad', id_tomo_espacio, id_espacio, cod_carrera, cod_espacio, id_titulo, cod_titulo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="cr.nombre 'denomcar', ca.denominacion 'denomesp', ti.denominacion 'denomtit', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', id_nivel 'cod_nivel', nivel, 'A' as origen, ";
	  	$sql.="tipo_novedad ";
		$sql.="FROM nov_tomo_espacios ";
		$sql.="INNER JOIN carreras cr USING(id_carrera) ";
		$sql.="INNER JOIN espacios ca USING(id_espacio) ";
		$sql.="INNER JOIN titulos ti USING(id_titulo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE estado = 'S' ";
		if ($cod_titulo != '')
			$sql.="AND cod_titulo = '$cod_titulo' ";
		if ($cod_espacio != '')
			$sql.="AND cod_espacio = '$cod_espacio' ";
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
		toXML($xml, $sql, "espacios");
		
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
}
?>