<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_carreras.php");
include("../_phpincludes/_niveles.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlCarrera"] = str_replace('\"','"',$_REQUEST["xmlCarrera"]);
		$xml_Carrera = loadXML($_REQUEST["xmlCarrera"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		@mysqli_query($GLOBALS["___mysqli_ston"], "LOCK TABLES carreras READ WRITE");
	
		$sql="SELECT MAX(codigo) 'maxcod' FROM carreras";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		$codigo = $row['maxcod'] + 1;
				
		$sql="INSERT INTO carreras ";
		$sql.="SET codigo='$codigo', ";
		$sql.="nombre='".$xml_Carrera["nombre"]."', ";			
		$sql.="id_nivel='".$xml_Carrera["id_nivel"]."' ";
		toXML($xml, $sql, "add");
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
			$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
			$_descrip = "ALTA DE LA CARRERA '".$xml_Carrera["nombre"]."' CON id='$_id_registro'";
			_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'carreras',
					$_id_registro,
                    $_descrip,
                    '',
                    '');	
		}
		
		$sql="SELECT codigo 'cc' FROM carreras WHERE codigo='$codigo'";
		toXML($xml, $sql, "codigos");
		
		@mysqli_query($GLOBALS["___mysqli_ston"], "UNLOCK TABLES");
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'update': 
	{
		$_REQUEST["xmlCarrera"] = str_replace('\"','"',$_REQUEST["xmlCarrera"]);
		$xml_Carrera = loadXML($_REQUEST["xmlCarrera"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_carrera) 'cc' ";
		$sql.="FROM carreras ";
		$sql.="WHERE codigo=".$xml_Carrera["codigo"]." ";
		$sql.="AND id_carrera <> '".$xml_Carrera["id_carrera"]."'";
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0)
		{
			$sql="SELECT * FROM carreras WHERE id_carrera='".$xml_Carrera["id_carrera"]."' ";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$campos=(($___mysqli_tmp = mysqli_num_fields($result)) ? $___mysqli_tmp : false);
			$row=mysqli_fetch_array($result);
			$datos_carrera="";	
		    for($j=0;$j<$campos;$j++)
		    {
		       $nombre=((($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)->name) && (!is_null($___mysqli_tmp))) ? $___mysqli_tmp : false);
		       $tipo=((is_object($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)) && !is_null($___mysqli_tmp = $___mysqli_tmp->type)) ? ((($___mysqli_tmp = (string)(substr(( (($___mysqli_tmp == MYSQLI_TYPE_STRING) || ($___mysqli_tmp == MYSQLI_TYPE_VAR_STRING) ) ? "string " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY, MYSQLI_TYPE_SHORT, MYSQLI_TYPE_LONG, MYSQLI_TYPE_LONGLONG, MYSQLI_TYPE_INT24))) ? "int " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_FLOAT, MYSQLI_TYPE_DOUBLE, MYSQLI_TYPE_DECIMAL, ((defined("MYSQLI_TYPE_NEWDECIMAL")) ? constant("MYSQLI_TYPE_NEWDECIMAL") : -1)))) ? "real " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIMESTAMP) ? "timestamp " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_YEAR) ? "year " : "" ) . ( (($___mysqli_tmp == MYSQLI_TYPE_DATE) || ($___mysqli_tmp == MYSQLI_TYPE_NEWDATE) ) ? "date " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIME) ? "time " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_SET) ? "set " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_ENUM) ? "enum " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_GEOMETRY) ? "geometry " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_DATETIME) ? "datetime " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY_BLOB, MYSQLI_TYPE_BLOB, MYSQLI_TYPE_MEDIUM_BLOB, MYSQLI_TYPE_LONG_BLOB))) ? "blob " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_NULL) ? "null " : "" ), 0, -1))) == "") ? "unknown" : $___mysqli_tmp) : false);
		       $valor=mysql_result($result,0,$j);
		       $valor="'$valor'";
		       $datos_carrera.="$nombre".'=';           
		       $datos_carrera.="$valor,";
		    }
		    
			$sql="UPDATE carreras ";
			$sql.="SET codigo='".$xml_Carrera["codigo"]."', ";
			$sql.="nombre='".$xml_Carrera["nombre"]."', ";			
			$sql.="id_nivel='".$xml_Carrera["id_nivel"]."' ";
			$sql.="WHERE id_carrera='".$xml_Carrera["id_carrera"]."' ";
			toXML($xml, $sql, "upd");
			
			if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
				$_id_registro=$xml_Carrera["id_carrera"];
				$_descrip = "MODIFICACIÓN DE LA CARRERA '".$xml_Carrera["nombre"]."' CON id='".$xml_Carrera["id_carrera"]."' ";
				$_descrip.="DATOS DE LA CARRERA ANTES DE LA MODIFICACIÓN: ";
				$_descrip.=$datos_carrera;
				_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'carreras',
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
		$_REQUEST["xmlCarrera"] = str_replace('\"','"',$_REQUEST["xmlCarrera"]);
		$xml_Carrera = loadXML($_REQUEST["xmlCarrera"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="DELETE FROM carreras ";
		$sql.="WHERE id_carrera='".$xml_Carrera["id_carrera"]."' ";
		toXML($xml, $sql, "del");
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'buscar_carrera':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_carreras($xml,'nombre',$caso,$SYSusuario_nivel_id,$filter);	  		  	
				
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	traer_carreras($xml,'nombre',0,$SYSusuario_nivel_id,$filter);
				
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
 	case 'traer_datos2':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
		
		traer_niveles($xml,$SYSusuario_nivel_id);				
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }	
}
?>