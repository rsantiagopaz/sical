<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case 'obtener_numero_llamado':
	{
		// Determinar el máximo número de llamado para el nivel correspondiente
        @mysqli_query($GLOBALS["___mysqli_ston"], "LOCK TABLES llamados READ WRITE");
	
		$sql="SELECT MAX(nro_llamado) 'maxnro' FROM llamados WHERE id_nivel = '$SYSusuario_nivel_id'";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		// el nuevo número de llamado es igual al mayor número + 1
		$nro_llamado = $row['maxnro'] + 1;
		
		@mysqli_query($GLOBALS["___mysqli_ston"], "UNLOCK TABLES");
        // Devolver el nuevo número de llamado
        $xml = "<?xml version='1.0' encoding='UTF-8' ?>";
		$xml.= "<xml>";
		$xml.= "<nrollamado>$nro_llamado</nrollamado>";			
		$xml.= "</xml>";
		header('Content-Type: text/xml');
		print $xml;
        break;
	}
	case 'insert': 
	{
		$_REQUEST["xmlLlamado"] = str_replace('\"','"',$_REQUEST["xmlLlamado"]);
		$xml_Llamado = loadXML($_REQUEST["xmlLlamado"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql = "SELECT count(nro_llamado) 'cc' FROM llamados WHERE nro_llamado='".$xml_Llamado["nro_llamado"]."' AND id_nivel = '$SYSusuario_nivel_id'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		if ($row['cc']==0) {
			$sql = "SELECT id_quinquenio FROM quinquenios WHERE activo = '1'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_quinquenio = $row['id_quinquenio'];								
			
			$sql ="INSERT INTO llamados ";
			$sql.="SET nro_llamado='".$xml_Llamado["nro_llamado"]."', ";
			$sql.="descripcion='".$xml_Llamado["descripcion"]."', ";
			$sql.="id_tipo_clasificacion='".$xml_Llamado["tipo_clasificacion"]."', ";
			$sql.="id_subtipo_clasificacion='".$xml_Llamado["id_subtipo_clasificacion"]."', ";
			if ($xml_Llamado["fecha_desde"] != "")
				$sql.="fecha_desde='".YYYYDM($xml_Llamado["fecha_desde"])."', ";
			else
				$sql.="fecha_desde='0000-00-00', ";	
			if ($xml_Llamado["fecha_hasta"] != "")	
				$sql.="fecha_hasta='".YYYYDM($xml_Llamado["fecha_hasta"])."', ";
			else
				$sql.="fecha_hasta='0000-00-00', ";
			$sql.="estado='A', ";
			$sql.="oculto='".$xml_Llamado["oculto"]."', ";
			$sql.="id_nivel='".$xml_Llamado["id_nivel"]."', ";
			$sql.="id_quinquenio='$id_quinquenio', ";
			$sql.="ordinario='".$xml_Llamado['ordinario']."', ";
			$sql.="id_llam_ant_acum='".$xml_Llamado['id_llam_ant_acum']."' ";
			if ($xml_Llamado['id_llamado_conflictivo'] != '')
				$sql.=",id_llamado_conflictivo='".$xml_Llamado['id_llamado_conflictivo']."' ";
			toXML($xml, $sql, "add");
			
			if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
				$_id_registro=((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
				$_descrip = "ALTA DEL LLAMADO '".$xml_Llamado["descripcion"]."' CON id='$_id_registro'";
				_auditoria($sql, 
	                    $link_salud1,
						$link_salud1,
						'llamados',
						$_id_registro,
	                    $_descrip,
	                    '',
	                    '');	
			}
							
			header('Content-Type: text/xml');
			echo $xml->asXML();				
		} else {
			$error = "Se produjeron errores\n";
			$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
			$xml.= "<xml>";
			$xml.= "<error>$error</error>";			
			$xml.= "</xml>";
			header('Content-Type: text/xml');
			print $xml;
		}
		break;
	}
	case 'update': 
	{
		$_REQUEST["xmlLlamado"] = str_replace('\"','"',$_REQUEST["xmlLlamado"]);
		$xml_Llamado = loadXML($_REQUEST["xmlLlamado"]);	
		
		$xml=new SimpleXMLElement('<rows/>');
		$sql="SELECT * FROM llamados WHERE id_llamado='".$xml_Llamado["id_llamado"]."' ";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$campos=(($___mysqli_tmp = mysqli_num_fields($result)) ? $___mysqli_tmp : false);
		$row=mysqli_fetch_array($result);
		$datos_llamado="";	
	    for($j=0;$j<$campos;$j++)
	    {
	       $nombre=((($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)->name) && (!is_null($___mysqli_tmp))) ? $___mysqli_tmp : false);
	       $tipo=((is_object($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)) && !is_null($___mysqli_tmp = $___mysqli_tmp->type)) ? ((($___mysqli_tmp = (string)(substr(( (($___mysqli_tmp == MYSQLI_TYPE_STRING) || ($___mysqli_tmp == MYSQLI_TYPE_VAR_STRING) ) ? "string " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY, MYSQLI_TYPE_SHORT, MYSQLI_TYPE_LONG, MYSQLI_TYPE_LONGLONG, MYSQLI_TYPE_INT24))) ? "int " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_FLOAT, MYSQLI_TYPE_DOUBLE, MYSQLI_TYPE_DECIMAL, ((defined("MYSQLI_TYPE_NEWDECIMAL")) ? constant("MYSQLI_TYPE_NEWDECIMAL") : -1)))) ? "real " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIMESTAMP) ? "timestamp " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_YEAR) ? "year " : "" ) . ( (($___mysqli_tmp == MYSQLI_TYPE_DATE) || ($___mysqli_tmp == MYSQLI_TYPE_NEWDATE) ) ? "date " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIME) ? "time " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_SET) ? "set " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_ENUM) ? "enum " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_GEOMETRY) ? "geometry " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_DATETIME) ? "datetime " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY_BLOB, MYSQLI_TYPE_BLOB, MYSQLI_TYPE_MEDIUM_BLOB, MYSQLI_TYPE_LONG_BLOB))) ? "blob " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_NULL) ? "null " : "" ), 0, -1))) == "") ? "unknown" : $___mysqli_tmp) : false);
	       $valor=mysql_result($result,0,$j);
	       $valor="'$valor'";
	       $datos_llamado.="$nombre".'=';           
	       $datos_llamado.="$valor,";
	    }
				
		$sql="UPDATE llamados ";
		$sql.="SET nro_llamado='".$xml_Llamado["nro_llamado"]."', ";
		$sql.="descripcion='".$xml_Llamado["descripcion"]."', ";
		$sql.="id_tipo_clasificacion='".$xml_Llamado["tipo_clasificacion"]."', ";
		$sql.="id_subtipo_clasificacion='".$xml_Llamado["id_subtipo_clasificacion"]."', ";
		if ($xml_Llamado["fecha_desde"] != "")
			$sql.="fecha_desde='".YYYYDM($xml_Llamado["fecha_desde"])."', ";
		else
			$sql.="fecha_desde='0000-00-00', ";	
		if ($xml_Llamado["fecha_hasta"] != "")	
			$sql.="fecha_hasta='".YYYYDM($xml_Llamado["fecha_hasta"])."', ";
		else
			$sql.="fecha_hasta='0000-00-00', ";
		//$sql.="estado='A', ";
		$sql.="oculto='".$xml_Llamado["oculto"]."', ";
		$sql.="id_nivel='".$xml_Llamado["id_nivel"]."', ";
		$sql.="ordinario='".$xml_Llamado['ordinario']."', ";
		$sql.="id_llam_ant_acum='".$xml_Llamado['id_llam_ant_acum']."' ";
		if ($xml_Llamado['id_llamado_conflictivo'] != '')
			$sql.=",id_llamado_conflictivo='".$xml_Llamado['id_llamado_conflictivo']."' ";
		$sql.="WHERE id_llamado='".$xml_Llamado["id_llamado"]."' ";
		toXML($xml, $sql, "upd");
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
			$_id_registro=$xml_Llamado["id_llamado"];
			$_descrip = "MODIFICACIÓN DEL LLAMADO '".$xml_Llamado["descripcion"]."' CON id='".$xml_Llamado["id_llamado"]."' ";
			$_descrip.= "DATOS DEL LLAMADO ANTES DE LA MODIFICACIÓN: ";
			$_descrip.= $datos_llamado;
			_auditoria($sql, 
                $link_salud1,
				$link_salud1,
				'llamados',
				$_id_registro,
                $_descrip,
                '',
                '');	
		}
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'delete': 
	{
		$_REQUEST["xmlLlamado"] = str_replace('\"','"',$_REQUEST["xmlLlamado"]);
		$xml_Llamado = loadXML($_REQUEST["xmlLlamado"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT count(id_llamado) 'cc' FROM docentes_llamados WHERE id_llamado ='".$xml_Llamado["id_llamado"]."'";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		if ($row['cc'] == 0) {
			$sql="DELETE FROM llamados ";
			$sql.="WHERE id_llamado='".$xml_Llamado["id_llamado"]."' ";
			toXML($xml, $sql, "del");
					
			header('Content-Type: text/xml');
			echo $xml->asXML();	
		} else {
			$error = "El Llamado no puede ser eliminado una vez que se han registrado inscripciones para él";
			$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
			$xml.= "<xml>";
			$xml.= "<error>$error</error>";			
			$xml.= "</xml>";
			header('Content-Type: text/xml');
			print $xml;
		}
		
		break;
	}
	case 'buscar_cargo':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	$sql ="SELECT id_cargo, codigo, denominacion, id_nivel, nivel, IF(jornada_completa='1','Si','No') 'jornada_completa', (CASE WHEN subtipo='C' THEN 'Capacitación' WHEN subtipo='E' THEN 'Especial' WHEN subtipo='A' THEN 'Adultos' END) 'subtipo', 'N' as origen ";
		$sql.="FROM cargos ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE denominacion LIKE '$filter' ";
		if ($caso != 1)
			$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";		
		$sql.="ORDER BY denominacion";
		toXML($xml, $sql, "cargos");				
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
    }
	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	$sql ="SELECT llamados.id_llamado, llamados.nro_llamado, llamados.descripcion, llamados.id_tipo_clasificacion 'tipo_clasificacion', ";
	  	$sql.="llamados.ordinario, llamados.id_llam_ant_acum, llamados.id_llamado_conflictivo, llamados.oculto, llamados.id_subtipo_clasificacion, ";
	  	$sql.="llamados.id_nivel, nivel, ll.id_llamado 'id_llamado_conflictivo', ";
	  	$sql.="ll.descripcion 'descripcion_llamado_conflictivo', ll.nro_llamado 'nro_llamado_conflictivo', ";
	  	$sql.="DATE_FORMAT(llamados.fecha_desde,'%d/%m/%Y') 'fecha_desde', ";
	  	$sql.="DATE_FORMAT(llamados.fecha_hasta,'%d/%m/%Y') 'fecha_hasta' ";
		$sql.="FROM llamados ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="LEFT JOIN llamados ll ON llamados.id_llamado_conflictivo = ll.id_llamado ";
		$sql.="WHERE llamados.descripcion LIKE '%$filter%' ";
		$sql.="AND llamados.id_nivel = '$SYSusuario_nivel_id' ";		
		$sql.="ORDER BY id_llamado DESC";
		toXML($xml, $sql, "llamados");
		
		$sql ="SELECT * ";
		$sql.="FROM niveles ";
		$sql.="ORDER BY nivel";
		toXML($xml, $sql, "niveles");
		
		header('Content-Type: text/xml');     	     
     	echo $xml->asXML();
    	break;
    }
    case 'traer_datos_llamados_acumulado': {
    	$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
    	$xml .= "<rows>";    			
		
		$sql = "SELECT id_llamado, CONCAT(nro_llamado,'-',UPPER(descripcion)) 'desc' ";
		$sql.= "FROM llamados ";
		$sql.= "WHERE estado='C' ";
		$sql.= "AND id_nivel = '$SYSusuario_nivel_id' ";
		$sql.= "ORDER BY nro_llamado DESC";
		
		$result = @mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		while ($row = mysqli_fetch_array($result)) {
			$xml .= '<llamados id_llamado="'.$row['id_llamado'].'" desc="'.$row['desc'].'"></llamados>';
		}
		
		$xml .= '</rows>';						
		
		header('Content-Type: text/xml');		
		print $xml;
		break;
	}
 	case 'traer_datos2':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  		  	
		
		$sql ="SELECT * ";
		$sql.="FROM niveles ";
		$sql.="WHERE id_nivel = '$SYSusuario_nivel_id' ";
		$sql.="ORDER BY nivel";
		toXML($xml, $sql, "niveles");
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
   case 'traer_datos3':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  		  	
		
		$sql ="SELECT * ";
		$sql.="FROM subtipos_clasificacion ";
		$sql.="WHERE id_nivel = '$SYSusuario_nivel_id' ";		
		toXML($xml, $sql, "tiposllamados");
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }   
}
?>