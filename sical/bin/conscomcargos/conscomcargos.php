<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_cargos.php");
include("../_phpincludes/_niveles.php");

switch ($_REQUEST['rutina'])
{	
	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_cargos($xml,1,'denominacion',$filter);	  		  	
		
		traer_niveles($xml);		
		
		header('Content-Type: text/xml');     	     
     	echo $xml->asXML();
    	break;
    }
 	case 'traer_datos2':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_cargos($xml,1,'denominacion','');	  	
		
		traer_niveles($xml);
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
   case 'buscar_cargo':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_cargos($xml,$caso,'denominacion',$filter,$SYSusuario_nivel_id);	  					
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
    }
}
?>