<?php
//include("control_acceso_flex.php");
include("config.php");
include("rutinas.php");

switch ($_REQUEST['rutina'])
{
	case 'traer_datos':
 	{
 		$sql = "SELECT id_departamento, departamento 'denom' ";
   		$sql.="FROM departamentos WHERE id_provincia='21'";   		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$xml=new SimpleXMLElement('<rows/>');
				
		while ($row = mysqli_fetch_array($result)) {
			$nodo2=$xml->addChild("departamento");			
			foreach($row as $key => $value) {						 
				if (!is_numeric($key)) $nodo2->addAttribute($key, $value);
			}
			$sql2 = "SELECT id_departamento, id_localidad, localidad 'denom' FROM localidades JOIN departamentos USING(id_departamento) ";			
			$sql2 .= "WHERE id_departamento='".$row['id_departamento']."'";			
			$result2 = mysqli_query($GLOBALS["___mysqli_ston"], $sql2);			
			while ($row2 = mysqli_fetch_array($result2)) {
				$nodo3=$nodo2->addChild("localidad");										 
				foreach($row2 as $key => $value) {										 
					if (!is_numeric($key)) $nodo3->addAttribute($key, $value);
				}
			}			
		}		   			  	
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
}
?>
