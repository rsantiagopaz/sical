<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlEscuela"] = str_replace('\"','"',$_REQUEST["xmlEscuela"]);
		$xml_Escuela = loadXML($_REQUEST["xmlEscuela"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_escuela_carrera_espacio) 'cc' ";
		$sql.="FROM escuelas_carreras_espacios ";
		$sql.="WHERE id_escuela='".$xml_Escuela["id_escuela"]."' ";
		$sql.="AND id_carrera='$id_carrera' ";
		$sql.="AND id_espacio='$id_espacio' ";
		//$sql.="AND id_tipo_escuela='".$xml_Escuela["id_tipo_escuela"]."'";		
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n['cc']==0)
		{	
			$sql="SELECT count(id_tomo_espacio) 'cc1' ";
			$sql.="FROM tomo_espacios ";
			$sql.="WHERE id_espacio='$id_espacio' ";
			$sql.="AND id_carrera='$id_carrera'";
			toXML($xml, $sql, "tomoespacios");
			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$row = mysqli_fetch_array($result);
			
			if($row['cc1']!=0) {
				$sql="SELECT nombre FROM escuelas WHERE id_escuela = '".$xml_Escuela["id_escuela"]."'";
				$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row=mysqli_fetch_array($result);
				$escuela = $row['nombre'];
				
				$sql="SELECT nombre FROM carreras WHERE id_carrera = '$id_carrera'";
				$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row=mysqli_fetch_array($result);
				$carrera = $row['nombre'];
				
				$sql="SELECT denominacion FROM espacios WHERE id_espacio = '$id_espacio'";
				$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row=mysqli_fetch_array($result);
				$espacio = $row['denominacion'];
				
				$sql="INSERT escuelas_carreras_espacios SET id_escuela = '".$xml_Escuela["id_escuela"]."', cod_escuela = '".$xml_Escuela["codigo"]."', " .
					"id_carrera='$id_carrera', cod_carrera='".$xml_Escuela['cod_carrera']."', " .
					"id_espacio='$id_espacio', cod_espacio='".$xml_Escuela['cod_espacio']."'";						
				toXML($xml, $sql, "add");
				
				if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
					$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
					$_descrip = "ALTA DE LA ESCUELA-CARRERA-ESPACIO CON id='$_id_registro', ESCUELA '$escuela', CARRERA '$carrera', ESPACIO '$espacio'";
					_auditoria($sql, 
		                    $link_salud1,
							$link_salud1,
							'escuelas_carreras_espacios',
							$_id_registro,
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
		$_REQUEST["xmlEscuela"] = str_replace('\"','"',$_REQUEST["xmlEscuela"]);
		$xml_Escuela = loadXML($_REQUEST["xmlEscuela"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		/*$sql="SELECT id_escuela, id_carrera, id_espacio FROM escuelas_carreras_espacios WHERE id_escuela_carrera_espacio = '".$xml_Escuela["id_escuela_carrera_espacio"]."'";
		$result=mysql_query($sql);
		$row=mysql_fetch_array($result);*/		
		
		$sql="SELECT nombre FROM escuelas WHERE id_escuela = '".$xml_Escuela["id_escuela"]."'";
		$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row=mysqli_fetch_array($result);
		$escuela = $row['nombre'];
		
		$sql="SELECT nombre FROM carreras WHERE id_carrera = '".$xml_Escuela["id_carrera"]."'";
		$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row=mysqli_fetch_array($result);
		$carrera = $row['nombre'];
		
		$sql="SELECT denominacion FROM espacios WHERE id_espacio = '".$xml_Escuela["id_espacio"]."'";
		$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row=mysqli_fetch_array($result);
		$espacio = $row['denominacion'];
		
		$sql="DELETE FROM escuelas_carreras_espacios ";
		$sql.="WHERE id_escuela_carrera_espacio='".$xml_Escuela["id_escuela_carrera_espacio"]."' ";
		toXML($xml, $sql, "del");
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
			$_id_registro = $xml_Escuela["id_escuela_carrera_espacio"];	
			$_descrip = "BAJA DE LA ESCUELA-CARRERA-ESPACIO CON id='".$xml_Escuela["id_escuela_carrera_espacio"]."', ESCUELA '$escuela', CARRERA '$carrera', ESPACIO '$espacio'";
			_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'escuelas_carreras_espacios',
					$_id_registro,
                    $_descrip,
                    '',
                    '');	
		}
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
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
   case 'traer_escuelas_n':
 	{ 		
 		$denominacion = strtoupper($denominacion);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_escuela, codigo, nombre, n.id_nivel 'id_nivel' ";
		$sql.="FROM escuelas ";
		$sql.="INNER JOIN niveles n USING(id_nivel) ";	
		$sql.="WHERE nombre like'%$nombre%' ";
		if ($SYSusuario_nivel_id != '4')
			$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "escuela");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_escuela':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_escuela, codigo, nombre, n.id_nivel 'id_nivel' ";
		$sql.="FROM escuelas ";
		$sql.="INNER JOIN niveles n USING(id_nivel) ";	
		$sql.="WHERE codigo = '$codigo' ";
		if ($SYSusuario_nivel_id != '4')
			$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "escuela");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_escuelas':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_escuela_carrera_espacio, id_carrera, cod_carrera, id_espacio, cod_espacio, ca.denominacion 'denomcar', id_escuela, cod_escuela 'codigo', nombre, n.id_nivel 'id_nivel', 'A' as origen ";
		$sql.="FROM escuelas_carreras_espacios ";
		$sql.="INNER JOIN espacios ca USING(id_espacio) ";
		$sql.="INNER JOIN escuelas USING(id_escuela) ";
		$sql.="INNER JOIN niveles n ON escuelas.id_nivel = n.id_nivel ";	
		$sql.="WHERE id_espacio = '$id_espacio' ";
		$sql.="AND id_carrera = '$id_carrera' ";
		if ($SYSusuario_nivel_id != '4')
			$sql.="AND n.id_nivel = '$SYSusuario_nivel_id' ";
		$sql.="ORDER BY denomcar";
		toXML($xml, $sql, "escuelas");
		
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
   case 'traer_carreras':
 	{ 		
 		$nombre = strtoupper($nombre);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_carrera, codigo, nombre, id_nivel, nivel ";
		$sql.="FROM carreras ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE nombre like'%$nombre%' ";
		if ($SYSusuario_nivel_id != '4')
			$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "carrera");
		
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
		if ($SYSusuario_nivel_id != '4')
			$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";		
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
   case 'traer_datos2':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT * ";
		$sql.="FROM tipos_escuelas ";				
		$sql.="ORDER BY tipo";
		toXML($xml, $sql, "tiposescuelas");
		
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
			$sql = "SELECT id_tipo_escuela, codigo FROM tipos_escuelas WHERE tipo='".$espacios->espacios[$idx]['tipo']."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_tipo_escuela = $row['id_tipo_escuela'];
			$cod_tipo_escuela = $row['codigo'];
			$sql = "INSERT INTO tomo_espacios SET id_escuela = '$id_escuela', cod_escuela = '$cod_escuela', " .
					"id_espacio='".$espacios->espacios[$idx]['id_espacio']."', cod_espacio='".$espacios->espacios[$idx]['cod_espacio']."', " .					
					"id_tipo_escuela='$id_tipo_escuela', cod_tipo_escuela='$cod_tipo_escuela', " .
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