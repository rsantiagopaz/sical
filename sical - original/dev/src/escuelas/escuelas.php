<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_escuelas.php");
include("../_phpincludes/_niveles.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlEscuela"] = str_replace('\"','"',$_REQUEST["xmlEscuela"]);
		$xml_Escuela = loadXML($_REQUEST["xmlEscuela"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		@mysqli_query($GLOBALS["___mysqli_ston"], "LOCK TABLES escuelas READ WRITE");
	
		$sql="SELECT MAX(codigo) 'maxcod' FROM escuelas";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		$codigo = $row['maxcod'] + 1;
		
		$sql="INSERT escuelas ";
		$sql.="SET codigo='$codigo', ";
		$sql.="nombre='".$xml_Escuela["nombre"]."', ";
		$sql.="id_localidad='".$xml_Escuela["id_localidad"]."', ";
		$sql.="id_nivel='".$xml_Escuela["id_nivel"]."' ";
		toXML($xml, $sql, "add");				
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
			$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
			$_descrip = "ALTA DEL ESTABLECIMIENTO '".$xml_Escuela["nombre"]."' CON id='$_id_registro'";
			_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'escuelas',
					$_id_registro,
                    $_descrip,
                    '',
                    '');	
		}				
		
		$sql="SELECT codigo 'cc' FROM escuelas WHERE codigo='$codigo'";
		toXML($xml, $sql, "codigos");
		
		@mysqli_query($GLOBALS["___mysqli_ston"], "UNLOCK TABLES");	
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'update': 
	{
		$_REQUEST["xmlEscuela"] = str_replace('\"','"',$_REQUEST["xmlEscuela"]);
		$xml_Escuela = loadXML($_REQUEST["xmlEscuela"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_escuela) 'cc' ";
		$sql.="FROM escuelas ";
		$sql.="WHERE codigo=".$xml_Escuela["codigo"]." ";
		$sql.="AND id_escuela <> '".$xml_Escuela["id_escuela"]."'";
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0)
		{
			$sql="SELECT * FROM escuelas WHERE id_escuela='".$xml_Escuela["id_escuela"]."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$campos=(($___mysqli_tmp = mysqli_num_fields($result)) ? $___mysqli_tmp : false);
			$row=mysqli_fetch_array($result);
			$datos_escuela="";	
		    for($j=0;$j<$campos;$j++)
		    {
		       $nombre=((($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)->name) && (!is_null($___mysqli_tmp))) ? $___mysqli_tmp : false);
		       $tipo=((is_object($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)) && !is_null($___mysqli_tmp = $___mysqli_tmp->type)) ? ((($___mysqli_tmp = (string)(substr(( (($___mysqli_tmp == MYSQLI_TYPE_STRING) || ($___mysqli_tmp == MYSQLI_TYPE_VAR_STRING) ) ? "string " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY, MYSQLI_TYPE_SHORT, MYSQLI_TYPE_LONG, MYSQLI_TYPE_LONGLONG, MYSQLI_TYPE_INT24))) ? "int " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_FLOAT, MYSQLI_TYPE_DOUBLE, MYSQLI_TYPE_DECIMAL, ((defined("MYSQLI_TYPE_NEWDECIMAL")) ? constant("MYSQLI_TYPE_NEWDECIMAL") : -1)))) ? "real " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIMESTAMP) ? "timestamp " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_YEAR) ? "year " : "" ) . ( (($___mysqli_tmp == MYSQLI_TYPE_DATE) || ($___mysqli_tmp == MYSQLI_TYPE_NEWDATE) ) ? "date " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIME) ? "time " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_SET) ? "set " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_ENUM) ? "enum " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_GEOMETRY) ? "geometry " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_DATETIME) ? "datetime " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY_BLOB, MYSQLI_TYPE_BLOB, MYSQLI_TYPE_MEDIUM_BLOB, MYSQLI_TYPE_LONG_BLOB))) ? "blob " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_NULL) ? "null " : "" ), 0, -1))) == "") ? "unknown" : $___mysqli_tmp) : false);
		       $valor=mysql_result($result,0,$j);
		       $valor="'$valor'";
		       $datos_escuela.="$nombre".'=';           
		       $datos_escuela.="$valor,";
		    }
		    
			$sql="UPDATE escuelas ";
			$sql.="SET codigo='".$xml_Escuela["codigo"]."', ";
			$sql.="nombre='".$xml_Escuela["nombre"]."', ";
			$sql.="id_localidad='".$xml_Escuela["id_localidad"]."', ";
			$sql.="id_nivel='".$xml_Escuela["id_nivel"]."' ";
			$sql.="WHERE id_escuela='".$xml_Escuela["id_escuela"]."'";
			toXML($xml, $sql, "upd");
			
			if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
				$_id_registro=$xml_Escuela["id_escuela"];
				$_descrip = "MODIFICACIÓN DEL ESTABLECIMIENTO '".$xml_Escuela["nombre"]."' CON id='".$xml_Escuela["id_escuela"]."' ";
				$_descrip.="DATOS DE LA ESCUELA ANTES DE LA MODIFICACIÓN: ";
				$_descrip.=$datos_escuela;
				_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'escuelas',
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
		$_REQUEST["xmlEscuela"] = str_replace('\"','"',$_REQUEST["xmlEscuela"]);
		$xml_Escuela = loadXML($_REQUEST["xmlEscuela"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="DELETE FROM escuelas ";
		$sql.="WHERE id_escuela='".$xml_Escuela["id_escuela"]."' ";
		toXML($xml, $sql, "del");
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
			$_id_registro=$xml_Escuela["id_escuela"];
			$_descrip = "BAJA DEL ESTABLECIMIENTO '".$xml_Escuela["nombre"]."' CON id='".$xml_Escuela["id_escuela"]."'";
			_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'escuelas',
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
	  	
	  	traer_escuelas($xml,'nombre',$filter,$SYSusuario_nivel_id);	  		  	
				
		header('Content-Type: text/xml');
     	     	
     	echo $xml->asXML();
    	break;
   }
 	case 'traer_datos2':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_escuelas($xml,'nombre','',$SYSusuario_nivel_id);
	  	
	  	traer_niveles($xml,$SYSusuario_nivel_id);				
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }	
}
?>