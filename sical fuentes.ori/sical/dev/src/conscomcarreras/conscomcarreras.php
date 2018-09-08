<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_carreras.php");
include("../_phpincludes/_niveles.php");

switch ($_REQUEST['rutina'])
{	
   case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');	  		  	
		
		traer_carreras($xml,'nombre',1,$SYSusuario_nivel_id,$filter,true);				
				
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
 	case 'traer_datos2':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_carreras($xml,'nombre',1,$SYSusuario_nivel_id,'');
	  	
	  	traer_niveles($xml);				
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
   case 'buscar_carrera':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');	  		  	
		
		traer_carreras($xml,'nombre',1,$SYSusuario_nivel_id,$filter,true);				
				
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
}
?>