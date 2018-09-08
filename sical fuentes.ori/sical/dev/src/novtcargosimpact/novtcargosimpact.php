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
	  	$sql="SELECT id_nov_tomo_cargos, DATE_FORMAT(fecha_volcado,'%d/%m/%Y') 'fecha_volcado', id_tomo_cargo, id_cargo, cod_cargo, id_titulo, cod_titulo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', ti.denominacion 'denomtit', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, nivel, 'A' as origen, ";
	  	$sql.="tipo_novedad ";
		$sql.="FROM nov_tomo_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";
		$sql.="INNER JOIN titulos ti USING(id_titulo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE estado = 'V' ";
		
		$fecha_inicio = explode('/', $fecha_inicio);
		$fecha_inicio = $fecha_inicio[2] . '-' . $fecha_inicio[1] . '-' . $fecha_inicio[0];
		
		$fecha_fin = explode('/', $fecha_fin);
		$fecha_fin = $fecha_fin[2] . '-' . $fecha_fin[1] . '-' . $fecha_fin[0];
		
		if ($fecha_inicio != '')
			$sql.="AND fecha_volcado >= '$fecha_inicio' ";
		if ($fecha_fin != '')
			$sql.="AND fecha_volcado <= '$fecha_fin' ";
		
		$sql.="ORDER BY fecha_novedad ASC";
		toXML($xml, $sql, "cargos");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_cargos_2':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_nov_tomo_cargos, DATE_FORMAT(fecha_volcado,'%d/%m/%Y') 'fecha_volcado', id_tomo_cargo, id_cargo, cod_cargo, id_titulo, cod_titulo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', ti.denominacion 'denomtit', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, nivel, 'A' as origen, ";
	  	$sql.="tipo_novedad ";
		$sql.="FROM nov_tomo_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";
		$sql.="INNER JOIN titulos ti USING(id_titulo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE estado = 'V' ";
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
		
		$fecha_inicio = explode('/', $fecha_inicio);
		$fecha_inicio = $fecha_inicio[2] . '-' . $fecha_inicio[1] . '-' . $fecha_inicio[0];
		
		$fecha_fin = explode('/', $fecha_fin);
		$fecha_fin = $fecha_fin[2] . '-' . $fecha_fin[1] . '-' . $fecha_fin[0];
		
		if ($fecha_inicio != '')
			$sql.="AND fecha_volcado >= '$fecha_inicio' ";
		if ($fecha_fin != '')
			$sql.="AND fecha_volcado <= '$fecha_fin' ";
					
		$sql.="ORDER BY fecha_volcado ASC";
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
		$sql.="WHERE organismo_area_id='".$_SESSION['usuario_organismo_area_id']."'";
		toXML($xml, $sql, "usuarios");		
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_niveles':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  		  	
		
		$sql="SELECT * ";
		$sql.="FROM niveles ";		
		$sql.="ORDER BY nivel";
		toXML($xml, $sql, "niveles");
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
}
?>