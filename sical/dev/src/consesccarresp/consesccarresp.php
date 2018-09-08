<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_espacios.php");
include("../_phpincludes/_niveles.php");

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
   case 'traer_escuelas_n':
 	{ 		
 		$nombre = strtoupper($nombre);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_escuela, codigo, nombre, n.id_nivel 'id_nivel' ";
		$sql.="FROM escuelas ";
		$sql.="INNER JOIN niveles n USING(id_nivel) ";	
		$sql.="WHERE nombre like'%$nombre%' ";
		if ($SYSusuario_nivel_id != '4' && $_SESSION['usuario_organismo_area_id'] != '6')
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
		if ($SYSusuario_nivel_id != '4' && $_SESSION['usuario_organismo_area_id'] != '6')
			$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";		
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "escuela");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_carreras_espacios':
 	{ 	
 		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	$sql="SELECT DISTINCT id_carrera, codigo, nombre, id_nivel, nivel ";
		$sql.="FROM carreras ";
		$sql.="INNER JOIN escuelas_carreras_espacios USING(id_carrera) ";
		$sql.="INNER JOIN niveles n USING(id_nivel) ";
		$sql.="WHERE id_escuela = '$id_escuela' ";
		//if ($SYSusuario_nivel_id != '4')	
			//$sql.="AND n.id_nivel = '$SYSusuario_nivel_id' ";		
		$sql.="ORDER BY nombre";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		while ($row = mysqli_fetch_array($result)) {
			$nodo2=$xml->addChild("carrera");			
			foreach($row as $key => $value) {						 
				if (!is_numeric($key)) $nodo2->addAttribute($key, $value);
			}			
			$sql2 = "SELECT distinct e.id_espacio, e.codigo, e.denominacion ";			
			$sql2 .= "FROM escuelas_carreras_espacios ";
			$sql2 .= "JOIN espacios e USING(id_espacio) ";			
			$sql2 .= "WHERE id_carrera='".$row['id_carrera']."' ";
			$sql2 .= "AND id_escuela = '$id_escuela'";			
			$result2 = mysqli_query($GLOBALS["___mysqli_ston"], $sql2);			
			while ($row2 = mysqli_fetch_array($result2)) {
				$nodo3=$nodo2->addChild("espacio");										 
				foreach($row2 as $key => $value) {										 
					if (!is_numeric($key)) $nodo3->addAttribute($key, $value);
				}
			}			
		}
				
		header('Content-Type: text/xml');     	     	
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
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }
   case 'traer_datos2':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traerTiposEscuelas($xml);
		
		traer_tipos_clasificacion($xml);		
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }   
}
?>