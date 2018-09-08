<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");
include("../_phpincludes/_cargos.php");
include("../_phpincludes/_titulos.php");
include("../_phpincludes/_tipos_titulos.php");
include("../_phpincludes/_tipos_clasificacion.php");
include("../_phpincludes/_vertablatomoespacio.php");

switch ($_REQUEST['rutina'])
{	
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
   case 'traer_carreras':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_carreras($xml,'nombre',1,'',$nombre);	  	
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_carrera':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_carreras($xml,'codigo',1,'',$codigo);	  	
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_espacios':
 	{ 	
 		if (isset($opcion)) {
 			$tabla = determinar_tabla_tomo($opcion,$SYSusuario_nivel_id); 			
 		} else
 			$tabla = "tomo_espacios";
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_tomo_espacio, id_carrera, cod_carrera, id_espacio, cod_espacio, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="e.codigo, nombre, e.denominacion 'denomesp', t.denominacion 'denomclas', 'A' as origen ";
		$sql.="FROM $tabla ";
		$sql.="INNER JOIN espacios e USING(id_espacio) ";
		$sql.="INNER JOIN carreras c USING(id_carrera) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="WHERE id_titulo = '$id_titulo' ";
		$sql.="ORDER BY nombre";
		toXML($xml, $sql, "espacios");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_espacios_n':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_espacios($xml,'denominacion',$denominacion);	  	
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_espacio':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_espacios($xml,'codigo',$codigo);	  	
		
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