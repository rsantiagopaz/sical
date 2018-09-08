<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_espacios.php");

switch ($_REQUEST['rutina'])
{	
 	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traerEspecios($xml,'denominacion',$filter);	  		  	
		
		traer_niveles($xml);		
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
   case 'traer_carreras':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	$sql="SELECT id_carrera, codigo, nombre, id_nivel, nivel ";
		$sql.="FROM carreras ";
		$sql.="INNER JOIN carreras_espacios USING(id_carrera) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE id_espacio = '$id_espacio' ";	
		$sql.="ORDER BY nombre";
		toXML($xml, $sql, "carreras");
				
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
   case 'buscar_espacio':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traerEspecios($xml,'denominacion',$filter);	  					
		
		header('Content-Type: text/xml');     	     
     	echo $xml->asXML();
    	break;
   }
}
?>