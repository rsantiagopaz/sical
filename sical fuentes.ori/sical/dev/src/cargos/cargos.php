<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_niveles.php");
include("../_phpincludes/_cargos.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlCargo"] = str_replace('\"','"',$_REQUEST["xmlCargo"]);
		$xml_Cargo = loadXML($_REQUEST["xmlCargo"]);	
		
		$xml=new SimpleXMLElement('<rows/>');				
				
		@mysqli_query($GLOBALS["___mysqli_ston"], "LOCK TABLES cargos READ WRITE");
	
		$sql="SELECT MAX(codigo) 'maxcod' FROM cargos";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		$codigo = $row['maxcod'] + 1;
		
		$sql="INSERT INTO cargos ";
		$sql.="SET codigo='$codigo', ";
		$sql.="denominacion='".$xml_Cargo["denominacion"]."', ";
		$sql.="jornada_completa='".$xml_Cargo["jornada_completa"]."', ";
		$sql.="subtipo='".$xml_Cargo["subtipo"]."', ";
		$sql.="id_nivel='".$xml_Cargo["id_nivel"]."' ";
		toXML($xml, $sql, "add");
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
			$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
			$_descrip = "ALTA DEL CARGO '".$xml_Cargo["denominacion"]."' CON id='$_id_registro'";
			_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'cargos',
					$_id_registro,
                    $_descrip,
                    '',
                    '');	
		}	
		
		$sql="SELECT codigo 'cc' FROM cargos WHERE codigo='$codigo'";
		toXML($xml, $sql, "codigos");
		
		@mysqli_query($GLOBALS["___mysqli_ston"], "UNLOCK TABLES");
						
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
		$sql.="AND id_cargo <> '".$xml_Cargo["id_cargo"]."'";
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0)
		{
			$sql="SELECT * FROM cargos WHERE id_cargo='".$xml_Cargo["id_cargo"]."' ";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$campos=(($___mysqli_tmp = mysqli_num_fields($result)) ? $___mysqli_tmp : false);
			$row=mysqli_fetch_array($result);
			$datos_cargo="";	
		    for($j=0;$j<$campos;$j++)
		    {
		       $nombre=((($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)->name) && (!is_null($___mysqli_tmp))) ? $___mysqli_tmp : false);
		       $tipo=((is_object($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)) && !is_null($___mysqli_tmp = $___mysqli_tmp->type)) ? ((($___mysqli_tmp = (string)(substr(( (($___mysqli_tmp == MYSQLI_TYPE_STRING) || ($___mysqli_tmp == MYSQLI_TYPE_VAR_STRING) ) ? "string " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY, MYSQLI_TYPE_SHORT, MYSQLI_TYPE_LONG, MYSQLI_TYPE_LONGLONG, MYSQLI_TYPE_INT24))) ? "int " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_FLOAT, MYSQLI_TYPE_DOUBLE, MYSQLI_TYPE_DECIMAL, ((defined("MYSQLI_TYPE_NEWDECIMAL")) ? constant("MYSQLI_TYPE_NEWDECIMAL") : -1)))) ? "real " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIMESTAMP) ? "timestamp " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_YEAR) ? "year " : "" ) . ( (($___mysqli_tmp == MYSQLI_TYPE_DATE) || ($___mysqli_tmp == MYSQLI_TYPE_NEWDATE) ) ? "date " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIME) ? "time " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_SET) ? "set " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_ENUM) ? "enum " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_GEOMETRY) ? "geometry " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_DATETIME) ? "datetime " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY_BLOB, MYSQLI_TYPE_BLOB, MYSQLI_TYPE_MEDIUM_BLOB, MYSQLI_TYPE_LONG_BLOB))) ? "blob " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_NULL) ? "null " : "" ), 0, -1))) == "") ? "unknown" : $___mysqli_tmp) : false);
		       $valor=mysql_result($result,0,$j);
		       $valor="'$valor'";
		       $datos_cargo.="$nombre".'=';           
		       $datos_cargo.="$valor,";
		    }
			$sql="UPDATE cargos ";
			$sql.="SET codigo='".$xml_Cargo["codigo"]."', ";
			$sql.="denominacion='".$xml_Cargo["denominacion"]."', ";
			$sql.="jornada_completa='".$xml_Cargo["jornada_completa"]."', ";
			$sql.="subtipo='".$xml_Cargo["subtipo"]."', ";
			$sql.="id_nivel='".$xml_Cargo["id_nivel"]."' ";
			$sql.="WHERE id_cargo='".$xml_Cargo["id_cargo"]."' ";
			toXML($xml, $sql, "upd");
			
			if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
				$_id_registro=$xml_Cargo["id_cargo"];
				$_descrip = "MODIFICACIÓN DEL CARGO '".$xml_Cargo["denominacion"]."' CON id='".$xml_Cargo["id_cargo"]."' ";
				$_descrip.="DATOS DEL CARGO ANTES DE LA MODIFICACIÓN: ";
				$_descrip.=$datos_cargo;
				_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'cargos',
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
		$_REQUEST["xmlCargo"] = str_replace('\"','"',$_REQUEST["xmlCargo"]);
		$xml_Cargo = loadXML($_REQUEST["xmlCargo"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="DELETE FROM cargos ";
		$sql.="WHERE id_cargo='".$xml_Cargo["id_cargo"]."' ";
		toXML($xml, $sql, "del");
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'buscar_cargo':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_cargos($xml,1,'denominacion',$filter);				
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
    }
    case 'buscar_cargo_codigo':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_cargos($xml,$caso,'codigo',$codigo);				
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
    }
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
		
		traer_niveles($xml);
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }	
}
?>