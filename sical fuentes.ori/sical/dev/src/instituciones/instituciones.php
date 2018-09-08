<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlInstitucion"] = str_replace('\"','"',$_REQUEST["xmlInstitucion"]);
		$xml_Institucion = loadXML($_REQUEST["xmlInstitucion"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_institucion) 'cc' ";
		$sql.="FROM instituciones ";
		$sql.="WHERE denominacion='".$xml_Institucion["denominacion"]."'";
		toXML($xml, $sql, "denominaciones");
		$n = $xml->children()->attributes();
		if($n["cc"]==0)
		{
			$sql="INSERT instituciones ";
			$sql.="SET denominacion='".$xml_Institucion["denominacion"]."', ";			
			$sql.="id_provincia='".$xml_Institucion["id_provincia"]."' ";
			toXML($xml, $sql, "add");
			
			if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
				$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
				$_descrip = "ALTA DE LA INSTITUCIÓN '".$xml_Institucion["denominacion"]."' CON id='$_id_registro'";
				_auditoria($sql, 
	                    $link_salud1,
						$link_salud1,
						'instituciones',
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
	case 'update': 
	{
		$_REQUEST["xmlInstitucion"] = str_replace('\"','"',$_REQUEST["xmlInstitucion"]);
		$xml_Institucion = loadXML($_REQUEST["xmlInstitucion"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_institucion) 'cc' ";
		$sql.="FROM instituciones ";
		$sql.="WHERE denominacion='".$xml_Institucion["denominacion"]."' ";
		$sql.="AND id_institucion <> '".$xml_Institucion["id_institucion"]."'";
		toXML($xml, $sql, "denominaciones");
		$n = $xml->children()->attributes();
		if($n["cc"]==0)
		{
			$sql="SELECT * FROM instituciones WHERE id_institucion='".$xml_Institucion["id_institucion"]."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$campos=(($___mysqli_tmp = mysqli_num_fields($result)) ? $___mysqli_tmp : false);
			$row=mysqli_fetch_array($result);
			$datos_institucion="";	
		    for($j=0;$j<$campos;$j++)
		    {
		       $nombre=((($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)->name) && (!is_null($___mysqli_tmp))) ? $___mysqli_tmp : false);
		       $tipo=((is_object($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)) && !is_null($___mysqli_tmp = $___mysqli_tmp->type)) ? ((($___mysqli_tmp = (string)(substr(( (($___mysqli_tmp == MYSQLI_TYPE_STRING) || ($___mysqli_tmp == MYSQLI_TYPE_VAR_STRING) ) ? "string " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY, MYSQLI_TYPE_SHORT, MYSQLI_TYPE_LONG, MYSQLI_TYPE_LONGLONG, MYSQLI_TYPE_INT24))) ? "int " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_FLOAT, MYSQLI_TYPE_DOUBLE, MYSQLI_TYPE_DECIMAL, ((defined("MYSQLI_TYPE_NEWDECIMAL")) ? constant("MYSQLI_TYPE_NEWDECIMAL") : -1)))) ? "real " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIMESTAMP) ? "timestamp " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_YEAR) ? "year " : "" ) . ( (($___mysqli_tmp == MYSQLI_TYPE_DATE) || ($___mysqli_tmp == MYSQLI_TYPE_NEWDATE) ) ? "date " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIME) ? "time " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_SET) ? "set " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_ENUM) ? "enum " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_GEOMETRY) ? "geometry " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_DATETIME) ? "datetime " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY_BLOB, MYSQLI_TYPE_BLOB, MYSQLI_TYPE_MEDIUM_BLOB, MYSQLI_TYPE_LONG_BLOB))) ? "blob " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_NULL) ? "null " : "" ), 0, -1))) == "") ? "unknown" : $___mysqli_tmp) : false);
		       $valor=mysql_result($result,0,$j);
		       $valor="'$valor'";
		       $datos_institucion.="$nombre".'=';           
		       $datos_institucion.="$valor,";
		    }
		    
			$sql="UPDATE instituciones ";
			$sql.="SET denominacion='".$xml_Institucion["denominacion"]."', ";			
			$sql.="id_provincia='".$xml_Institucion["id_provincia"]."' ";
			$sql.="WHERE id_institucion='".$xml_Institucion["id_institucion"]."'";
			toXML($xml, $sql, "upd");
			
			if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
				$_id_registro=$xml_Institucion["id_institucion"];
				$_descrip = "MODIFICACIÓN DE LA INSTITUCIÓN '".$xml_Institucion["denominacion"]."' CON id='".$xml_Institucion["id_institucion"]."' ";
				$_descrip.="DATOS DE LA INSTITUCIÓN ANTES DE LA MODIFICACIÓN: ";
				$_descrip.=$datos_institucion;
				_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'institucion',
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
		$_REQUEST["xmlInstitucion"] = str_replace('\"','"',$_REQUEST["xmlInstitucion"]);
		$xml_Institucion = loadXML($_REQUEST["xmlInstitucion"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="DELETE FROM instituciones ";
		$sql.="WHERE id_institucion='".$xml_Institucion["id_institucion"]."' ";
		toXML($xml, $sql, "del");
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
			$_id_registro=$xml_Institucion["id_institucion"];
			$_descrip = "BAJA DE LA INSTITUCIÓN '".$xml_Institucion["denominacion"]."' CON id='".$xml_Institucion["id_institucion"]."'";			
			_auditoria($sql, 
                $link_salud1,
				$link_salud1,
				'institucion',
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
				   		
	  	$xml2=new SimpleXMLElement('<rows/>');
	  	
	  	$sql="SELECT id_institucion, i.denominacion, id_provincia, p.denominacion 'provincia' ";
		$sql.="FROM instituciones i ";
		$sql.="INNER JOIN provincias p USING(id_provincia) ";		
		$sql.="ORDER BY i.denominacion";
		toXML($xml2, $sql, "instituciones");				
		
		header('Content-Type: text/xml');
     	//$xml=simplexml_load_string($xml);
     	simplexml_merge($xml2, $xml);     	
     	echo $xml2->asXML();
    	break;
   }
   case 'traer_datos2':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
				   		
	  	$xml2=new SimpleXMLElement('<rows/>');	  		  	
		
		$sql="SELECT id_provincia, denominacion 'provincia' ";
		$sql.="FROM provincias ";
		$sql.="ORDER BY provincia";
		toXML($xml2, $sql, "provincias");
		
		header('Content-Type: text/xml');
     	//$xml=simplexml_load_string($xml);
     	simplexml_merge($xml2, $xml);     	
     	echo $xml2->asXML();
    	break;
   }
}
?>