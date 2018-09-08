<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");
include("../_phpincludes/_cargos.php");
include("../_phpincludes/_titulos.php");
include("../_phpincludes/_tipos_titulos.php");
include("../_phpincludes/_tipos_clasificacion.php");
include("../_phpincludes/_vertablatomocargo.php");

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
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_titulos':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
	  	traer_titulos($xml,'denominacion',$denominacion);
		
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
 		if (isset($opcion)) {
 			$tabla = determinar_tabla_tomo($opcion,$SYSusuario_nivel_id); 			
 		} else
 			$tabla = "tomo_cargos";
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_tomo_cargo, id_cargo, cod_cargo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, nivel, 'A' as origen ";
		$sql.="FROM $tabla ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE id_titulo = '$id_titulo' ";
		$sql.="ORDER BY denomcar";
		toXML($xml, $sql, "cargos");
		
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
		
		traer_tipos_titulos($xml);
		
		traer_tipos_clasificacion($xml);		
		
		echo $xml->asXML();
				
    	break;
   }   
}
?>