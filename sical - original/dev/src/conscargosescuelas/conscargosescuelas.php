<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");
include("../_phpincludes/_cargos.php");

switch ($_REQUEST['rutina'])
{	
 	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
				   		
	  	$xml2=new SimpleXMLElement('<rows/>');
	  	
	  	traer_cargos($xml,1,'denominacion','');
		
		traer_niveles($xml);
		
		header('Content-Type: text/xml');
     	//$xml=simplexml_load_string($xml);
     	simplexml_merge($xml2, $xml);     	
     	echo $xml2->asXML();
    	break;
   }
   case 'buscar_escuela':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_escuela, codigo, nombre, n.id_nivel 'id_nivel', n.nivel 'nivel' ";
		$sql.="FROM escuelas ";
		$sql.="INNER JOIN niveles n USING(id_nivel) ";	
		$sql.="WHERE codigo = '$codigo' ";
		if ($SYSusuario_nivel_id != '4' && $_SESSION['usuario_organismo_area_id'] != '6')
			$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "escuelas");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_escuelas_n':
 	{ 		
 		$nombre = strtoupper($nombre);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_escuela, codigo, nombre, n.id_nivel 'id_nivel', n.nivel 'nivel' ";
		$sql.="FROM escuelas ";
		$sql.="INNER JOIN niveles n USING(id_nivel) ";	
		$sql.="WHERE nombre like'%$nombre%' ";
		if ($SYSusuario_nivel_id != '4' && $_SESSION['usuario_organismo_area_id'] != '6')
			$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";	
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "escuelas");
		
		echo $xml->asXML();
				
    	break;
   }   
   case 'traer_cargos':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	//$sql="SELECT id_escuela_cargo, id_cargo, cod_cargo, ca.denominacion 'denomcar', id_escuela, cod_escuela, nombre, n.id_nivel 'id_nivel', n.nivel 'nivel', 'A' as origen ";
	  	$sql="SELECT id_escuela_cargo, id_cargo, ca.codigo 'cod_cargo', ca.denominacion 'denomcar', id_escuela, cod_escuela, nombre, n.id_nivel 'id_nivel', n.nivel 'nivel', 'A' as origen ";
		$sql.="FROM escuelas_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";
		$sql.="INNER JOIN escuelas USING(id_escuela) ";
		$sql.="INNER JOIN niveles n ON ca.id_nivel = n.id_nivel ";	
		$sql.="WHERE id_escuela = '$id_escuela' ";
		if ($SYSusuario_nivel_id != '4' && $_SESSION['usuario_organismo_area_id'] != '6')	
			$sql.="AND n.id_nivel = '$SYSusuario_nivel_id' ";	
		$sql.="ORDER BY denomcar";
		toXML($xml, $sql, "escuelas");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_cargos_n':
 	{ 	 		 		
 		if ($SYSusuario_nivel_id != '4')
			$caso = 0;
		else
			$caso = 1;
		
		traer_cargos($xml,$caso,'denominacion',$denominacion);
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_cargo':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
			  	
	  	if ($SYSusuario_nivel_id != '4')
			$caso = 0;
		else
			$caso = 1;
		
		traer_cargos($xml,$caso,'codigo',$codigo);
		
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
 		$_REQUEST["xmlCargos"] = str_replace('\"','"',$_REQUEST["xmlCargos"]);
 		$cargos = loadXML($_REQUEST['xmlCargos']);			
		for ($idx=0;$idx<count($cargos->cargos);$idx++) {
			$sql = "SELECT id_tipo_escuela, codigo FROM tipos_escuelas WHERE tipo='".$cargos->cargos[$idx]['tipo']."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_tipo_escuela = $row['id_tipo_escuela'];
			$cod_tipo_escuela = $row['codigo'];
			$sql = "INSERT INTO tomo_cargos SET id_escuela = '$id_escuela', cod_escuela = '$cod_escuela', " .
					"id_cargo='".$cargos->cargos[$idx]['id_cargo']."', cod_cargo='".$cargos->cargos[$idx]['cod_cargo']."', " .					
					"id_tipo_escuela='$id_tipo_escuela', cod_tipo_escuela='$cod_tipo_escuela', " .
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