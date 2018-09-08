<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");
include("../_phpincludes/_espacios.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlEspacio"] = str_replace('\"','"',$_REQUEST["xmlEspacio"]);
		$xml_Espacio = loadXML($_REQUEST["xmlEspacio"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		@mysqli_query($GLOBALS["___mysqli_ston"], "LOCK TABLES espacios READ WRITE");
	
		$sql="SELECT MAX(codigo) 'maxcod' FROM espacios";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		$codigo = $row['maxcod'] + 1;
				
		$sql="INSERT espacios ";
		$sql.="SET codigo='$codigo', ";
		$sql.="denominacion='".$xml_Espacio["denominacion"]."' ";			
		toXML($xml, $sql, "add");
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
			$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
			$_descrip = "ALTA DEL ESPACIO '".$xml_Espacio["denominacion"]."' CON id='$_id_registro'";
			_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'espacios',
					$_id_registro,
                    $_descrip,
                    '',
                    '');	
		}
		
		$sql="SELECT codigo 'cc' FROM espacios WHERE codigo='$codigo'";
		toXML($xml, $sql, "codigos");
		
		@mysqli_query($GLOBALS["___mysqli_ston"], "UNLOCK TABLES");
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'update': 
	{
		$_REQUEST["xmlEspacio"] = str_replace('\"','"',$_REQUEST["xmlEspacio"]);
		$xml_Espacio = loadXML($_REQUEST["xmlEspacio"]);	
				
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_espacio) 'cc' ";
		$sql.="FROM espacios ";
		$sql.="WHERE codigo=".$xml_Espacio["codigo"]." ";
		$sql.="AND id_espacio <> '".$xml_Espacio["id_espacio"]."'";
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0) {
			$sql="SELECT * FROM espacios WHERE id_espacio='".$xml_Espacio["id_espacio"]."' ";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$campos=(($___mysqli_tmp = mysqli_num_fields($result)) ? $___mysqli_tmp : false);
			$row=mysqli_fetch_array($result);
			$datos_espacio="";	
		    for($j=0;$j<$campos;$j++)
		    {
		       $nombre=((($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)->name) && (!is_null($___mysqli_tmp))) ? $___mysqli_tmp : false);
		       $tipo=((is_object($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)) && !is_null($___mysqli_tmp = $___mysqli_tmp->type)) ? ((($___mysqli_tmp = (string)(substr(( (($___mysqli_tmp == MYSQLI_TYPE_STRING) || ($___mysqli_tmp == MYSQLI_TYPE_VAR_STRING) ) ? "string " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY, MYSQLI_TYPE_SHORT, MYSQLI_TYPE_LONG, MYSQLI_TYPE_LONGLONG, MYSQLI_TYPE_INT24))) ? "int " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_FLOAT, MYSQLI_TYPE_DOUBLE, MYSQLI_TYPE_DECIMAL, ((defined("MYSQLI_TYPE_NEWDECIMAL")) ? constant("MYSQLI_TYPE_NEWDECIMAL") : -1)))) ? "real " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIMESTAMP) ? "timestamp " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_YEAR) ? "year " : "" ) . ( (($___mysqli_tmp == MYSQLI_TYPE_DATE) || ($___mysqli_tmp == MYSQLI_TYPE_NEWDATE) ) ? "date " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIME) ? "time " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_SET) ? "set " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_ENUM) ? "enum " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_GEOMETRY) ? "geometry " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_DATETIME) ? "datetime " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY_BLOB, MYSQLI_TYPE_BLOB, MYSQLI_TYPE_MEDIUM_BLOB, MYSQLI_TYPE_LONG_BLOB))) ? "blob " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_NULL) ? "null " : "" ), 0, -1))) == "") ? "unknown" : $___mysqli_tmp) : false);
		       $valor=mysql_result($result,0,$j);
		       $valor="'$valor'";
		       $datos_espacio.="$nombre".'=';           
		       $datos_espacio.="$valor,";
		    }
		    
			$sql="UPDATE espacios ";
			$sql.="SET codigo='".$xml_Espacio["codigo"]."', ";
			$sql.="denominacion='".$xml_Espacio["denominacion"]."' ";
			$sql.="WHERE id_espacio='".$xml_Espacio["id_espacio"]."' ";
			toXML($xml, $sql, "upd");
			
			if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
				$_id_registro=$xml_Espacio["id_espacio"];
				$_descrip = "MODIFICACIÓN DEL ESPACIO '".$xml_Espacio["denominacion"]."' CON id='".$xml_Espacio["id_espacio"]."' ";
				$_descrip.="DATOS DEL ESPACIO ANTES DE LA MODIFICACIÓN: ";
				$_descrip.=$datos_espacio;
				_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'espacios',
					$_id_registro,
                    $_descrip,
                    '',
                    '');	
			}
		}		
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'delete': 
	{
		$_REQUEST["xmlEspacio"] = str_replace('\"','"',$_REQUEST["xmlEspacio"]);
		$xml_Espacio = loadXML($_REQUEST["xmlEspacio"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="DELETE FROM espacios ";
		$sql.="WHERE id_espacio='".$xml_Espacio["id_espacio"]."' ";
		toXML($xml, $sql, "del");
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'buscar_espacio':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_espacios($xml,'denominacion',$filter);	  		  				
		
		header('Content-Type: text/xml');     	     
     	echo $xml->asXML();
    	break;
   }
   case 'buscar_espacio_codigo':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_espacios($xml,'codigo',$codigo);				
		
		header('Content-Type: text/xml');     	     
     	echo $xml->asXML();
    	break;
   }
 	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
				   		
	  	$xml2=new SimpleXMLElement('<rows/>');
	  	
	  	traer_espacios($xml,'denominacion',$filter);
		
		traer_niveles($xml);
		
		header('Content-Type: text/xml');
     	//$xml=simplexml_load_string($xml);
     	simplexml_merge($xml2, $xml);     	
     	echo $xml2->asXML();
    	break;
   }	
}
?>