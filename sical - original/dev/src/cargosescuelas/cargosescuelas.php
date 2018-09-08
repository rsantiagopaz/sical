<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");
include("../_phpincludes/_cargos.php");
include("../_phpincludes/_escuelas.php");
include("../_phpincludes/_tipos_clasificacion.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlEscuela"] = str_replace('\"','"',$_REQUEST["xmlEscuela"]);
		$xml_Escuela = loadXML($_REQUEST["xmlEscuela"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_escuela_cargo) 'cc' ";
		$sql.="FROM escuelas_cargos ";
		$sql.="WHERE id_cargo='".$xml_Escuela["id_cargo"]."' ";
		$sql.="AND id_escuela='$id_escuela' ";				
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n['cc']==0)
		{							
			$sql="SELECT count(id_tomo_cargo) 'cc1' ";
			$sql.="FROM tomo_cargos ";
			$sql.="WHERE id_cargo='".$xml_Escuela['id_cargo']."'";
			toXML($xml, $sql, "tomocargos");
			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$row = mysqli_fetch_array($result);
			
			if($row['cc1']!=0) {
				$sql="SELECT nombre FROM escuelas WHERE id_escuela = '$id_escuela'";
				$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row=mysqli_fetch_array($result);
				$escuela = $row['nombre'];
				
				$sql="SELECT denominacion FROM cargos WHERE id_cargo = '".$xml_Escuela["id_cargo"]."'";
				$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				$row=mysqli_fetch_array($result);
				$cargo = $row['denominacion'];
				
				$sql="INSERT escuelas_cargos SET id_escuela = '$id_escuela', cod_escuela = '".$xml_Escuela["codigo"]."', " .
					"id_cargo='".$xml_Escuela['id_cargo']."', cod_cargo='".$xml_Escuela['cod_cargo']."'";			
				toXML($xml, $sql, "add");
				
				if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
					$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
					$_descrip = "ALTA DE LA ESCUELA-CARGO CON id='$_id_registro', ESCUELA '$escuela', CARGO '$cargo'";
					_auditoria($sql, 
		                    $link_salud1,
							$link_salud1,
							'escuelas_cargos',
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
		$_REQUEST["xmlCargo"] = str_replace('\"','"',$_REQUEST["xmlCargo"]);
		$xml_Cargo = loadXML($_REQUEST["xmlCargo"]);	
				
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_cargo) 'cc' ";
		$sql.="FROM cargos ";
		$sql.="WHERE codigo=".$xml_Cargo["codigo"]." ";
		$sql.="AND id_cargo <> ".$xml_Cargo["id_cargo"];
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0) {
			$sql="UPDATE cargos ";
			$sql.="SET codigo='".$xml_Cargo["codigo"]."', ";
			$sql.="denominacion='".$xml_Cargo["denominacion"]."' ";
			$sql.="WHERE id_cargo='".$xml_Cargo["id_cargo"]."' ";
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
		
		$sql="SELECT nombre FROM escuelas WHERE id_escuela = '".$xml_Escuela["id_escuela"]."'";
		$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row=mysqli_fetch_array($result);
		$escuela = $row['nombre'];
		
		$sql="SELECT denominacion FROM cargos WHERE id_cargo = '".$xml_Escuela["id_cargo"]."'";
		$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row=mysqli_fetch_array($result);
		$cargo = $row['denominacion'];
		
		$sql="DELETE FROM escuelas_cargos ";
		$sql.="WHERE id_escuela_cargo='".$xml_Escuela["id_escuela_cargo"]."' ";
		toXML($xml, $sql, "del");
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
			$_id_registro = $xml_Escuela["id_escuela_cargo"];
			$_descrip = "BAJA DE LA ESCUELA-CARGO CON id='".$xml_Escuela["id_escuela_cargo"]."', ESCUELA '$escuela', CARGO '$cargo'";
			_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'escuelas_cargos',
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
	  	
	  	traer_cargos($xml,1,'denominacion','');
		
		traer_niveles($xml,$SYSusuario_nivel_id);				
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
   case 'buscar_escuela':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		//traer_escuelas($xml,'codigo',$codigo,$SYSusuario_nivel_id,0);
		$sql="SELECT id_escuela, codigo, nombre, n.id_nivel 'id_nivel' ";
		$sql.="FROM escuelas ";
		$sql.="INNER JOIN niveles n USING(id_nivel) ";	
		$sql.="WHERE codigo = '$codigo' ";
		if ($SYSusuario_nivel_id != '4')
			$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";		
		$sql.="ORDER BY codigo";				  	
		toXML($xml, $sql, "escuelas");
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }
   case 'traer_escuelas_n':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		//traer_escuelas($xml,'nombre',$nombre,$SYSusuario_nivel_id,0);		
		$nombre = strtoupper($nombre);			  	
	  	$sql="SELECT id_escuela, codigo, nombre, n.id_nivel 'id_nivel' ";
		$sql.="FROM escuelas ";
		$sql.="INNER JOIN niveles n USING(id_nivel) ";	
		$sql.="WHERE nombre like'%$nombre%' ";
		if ($SYSusuario_nivel_id != '4')
			$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.="ORDER BY codigo";
		toXML($xml, $sql, "escuelas");
		
		header('Content-Type: text/xml');
		echo $xml->asXML();				
    	break;
   }   
   case 'traer_cargos':
 	{ 	 		
		$xml=new SimpleXMLElement('<rows/>');
	  	$sql="SELECT id_escuela_cargo, id_cargo, cod_cargo, ca.denominacion 'denomcar', id_escuela, cod_escuela, nombre, n.id_nivel 'id_nivel', n.nivel 'nivel', 'A' as origen ";
		$sql.="FROM escuelas_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";
		$sql.="INNER JOIN escuelas USING(id_escuela) ";
		$sql.="INNER JOIN niveles n ON ca.id_nivel = n.id_nivel ";	
		$sql.="WHERE id_escuela = '$id_escuela' ";
		if ($SYSusuario_nivel_id != '4')	
			$sql.="AND n.id_nivel = '$SYSusuario_nivel_id' ";	
		$sql.="ORDER BY denomcar";
		toXML($xml, $sql, "escuelas");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'traer_cargos_n':
 	{ 		 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_cargos($xml,0,'denominacion',$denominacion,$SYSusuario_nivel_id);	  	
		
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
		
		traer_cargos($xml,$caso,'codigo',$codigo,$SYSusuario_nivel_id);		
		
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
		
		traer_tipos_clasificacion($xml);
		
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