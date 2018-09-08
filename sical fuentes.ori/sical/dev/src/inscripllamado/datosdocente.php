<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

function genero_xml_ok_errores($_ok,$_errores,$otroNodoXml)
{	
	$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	$xml.= "<xml>";
	if(!empty($_ok)) {
		$xml.=  "<ok>$_ok</ok>";
	}
	if(!empty($_errores)) { 
		$xml.=  "<error>$_errores</error>";
	}	
	$xml.=$otroNodoXml;	
	$xml.= "</xml>";
	header('Content-Type: text/xml');
	print $xml;
}

function transformarFecha($fecha)
{
    $fecha_vector     = explode('/',$fecha);
    // Cambia del formato dd/mm/aaaa al formato aaaa-mm-dd
    $fecha_convertida = $fecha_vector[2].'-'.$fecha_vector[1].'-'.$fecha_vector[0];
    // chequea que la fecha sea válida:
    // Veo si el año es mayor q 3000
    if ($fecha_vector[2]>3000 or $fecha_vector[2]<1900) {
		return '';
	} else {   
		if ( (!empty($fecha_vector[1]) and !empty($fecha_vector[0]) and !empty($fecha_vector[2]) ) and
	        (checkdate($fecha_vector[1],$fecha_vector[0],$fecha_vector[2])) ) {
		    return $fecha_convertida;
		} else {
		    return '';
		} 
	}	  
}
 
function armarTiposDoc()
//       _______________________________________________
{	
	$errores="";	
  	$xmlLoc= "<documentos>";
  	$query = "SELECT * FROM tipos_documentos";
  	$result = mysqli_query($GLOBALS["___mysqli_ston"], $query);
  	if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false)) > 0) {
    	$errores.="Error devuelto por la Base de Datos: ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))." ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))."\n";
	} else {          
	        $xmlLoc.= "<documento>";
	          $xmlLoc.= "<id_tipo_doc></id_tipo_doc>";
	          $xmlLoc.= "<documento></documento>";
	        $xmlLoc.= "</documento>";
           	while($row = mysqli_fetch_array($result))
           	 {	
	          $xmlLoc.= "<documento>";
	            $xmlLoc.= "<id_tipo_doc>".$row["id_tipo_doc"]."</id_tipo_doc>";
	            $xmlLoc.= "<documento>".$row["tipo_doc"]."</documento>";
	          $xmlLoc.= "</documento>";
           	 }
	} 
    $xmlLoc.= "</documentos>";
    $xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	$xml.= "<xml>";	
	if(!empty($errores)) { 
		$xml.=  "<error>$errores</error>";
	}	
	$xml.=$xmlLoc;	
	$xml.= "</xml>";
	header('Content-Type: text/xml');
	print $xml;  
}

function buscarDocente($tipo_doc,$nro_doc)
{
	$errores = "";
	$xmlD = "";
	$query = "SELECT id_docente, apellido, nombres, domicilio, localidad, departamento FROM docentes ";
	$query.="LEFT JOIN localidades USING(id_localidad) ";
	$query.="LEFT JOIN departamentos USING(id_departamento) ";
	//if (intval($nro_doc) >= 10000000)
		$query.="WHERE nro_doc = '$nro_doc'";
	//else
		//$query.="WHERE id_tipo_doc = '$tipo_doc' AND nro_doc = '$nro_doc'";
	$result = mysqli_query($GLOBALS["___mysqli_ston"], $query);
	if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false)) > 0) {
		
	} else {
		$row = mysqli_fetch_array($result);
		$xmlD .= '<docente>';
		$xmlD .= '<id_docente>'.$row['id_docente'].'</id_docente>';
		$xmlD .= '<apellido>'.$row['apellido'].'</apellido>';
		$xmlD .= '<nombres>'.$row['nombres'].'</nombres>';
		$xmlD .= '<domicilio>'.$row['domicilio'].'</domicilio>';
		$xmlD .= '<localidad>'.$row['localidad'].'</localidad>';
		$xmlD .= '<departamento>'.$row['departamento'].'</departamento>';
		$xmlD .= '</docente>';
	}
	genero_xml_ok_errores("",$errores,$xmlD);
}

switch ($_REQUEST['rutina'])
{		
	case 'dar_ingreso': {
		$_ok="";				
		$error="";
		//// INSERT O UPDATE EN LA TABLA DOCENTES
		$insert_docentes = "";
		$id_docente = "";
		$xml_docentes = loadXML($_REQUEST["docente"]);
		$count_childs = 0;
		foreach($xml_docentes->children() as $child)
		{
			$count_childs++;
		}
		$i = 0;
		foreach($xml_docentes->children() as $child)
		{
			$i++;
			if ($child->getName()!='id_docente') {								
				if ($i < $count_childs)											
					$insert_docentes.= $child->getName() . "='" . $child . "', ";
				else
					$insert_docentes.= $child->getName() . "='" . $child . "'";
			} else {
				if ($child){
					$id_docente = $child; 
				}
			}
		}
		if (!$id_docente) {
			$insert_docentes = "INSERT INTO docentes SET " . $insert_docentes;
			mysqli_query($GLOBALS["___mysqli_ston"], $insert_docentes);
			if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
				$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
			} else {
				$id_docente = ((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
								
				$xmlD = "";
				$query = "SELECT * FROM docentes WHERE id_docente = '$id_docente'";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $query);
				if ( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false)) > 0) ) {					
					$row = mysqli_fetch_array($result);
					$_descrip = "ALTA DEL DOCENTE '".$row["apellido"].", " . $row["nombres"]."' CON id='$id_docente'";
					_auditoria($insert_docentes, 
		                    $link_salud1,
							$link_salud1,
							'docentes',
							$id_docente,
		                    $_descrip,
		                    '',
		                    '');
					$xmlD .= '<docente>';
					$xmlD .= '<id_docente>'.$row['id_docente'].'</id_docente>';
					$xmlD .= '<apellido>'.$row['apellido'].'</apellido>';
					$xmlD .= '<nombres>'.$row['nombres'].'</nombres>';
					$xmlD .= '<domicilio>'.$row['domicilio'].'</domicilio>';
					$xmlD .= '</docente>';
				}
			}
		}							
		genero_xml_ok_errores($_ok,$error,$xmlD);						
		break;
	}
	
	case "traer_localidades": {
		$xml=new SimpleXMLElement('<rows/>');
		$sql= "SELECT localidad_id, localidad ";
		$sql.= "FROM $salud._localidades ";
		$sql.= "WHERE localidad LIKE '%$localidad%' ";
		$sql.= "ORDER BY localidad ";
		
		$SELECT = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		toXML($xml, $sql, "localidad");
		header('Content-Type: text/xml');
		echo $xml->asXML();

		break;
	}		
	
	case "traer_documentos": {	 
	   	armarTiposDoc();
	   	break;    
	}
	
	case "consulta": {	 
	   	buscarDocente($_REQUEST["tipo_doc"],$_REQUEST["nro_doc"]);
	   	break;    
	}
}
?>