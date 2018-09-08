<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case 'insert': 
	{
		$_REQUEST["xmlTitulo"] = str_replace('\"','"',$_REQUEST["xmlTitulo"]);
		$xml_Titulo = loadXML($_REQUEST["xmlTitulo"]);
		
		$_REQUEST["xmlTitNivel"] = str_replace('\"','"',$_REQUEST["xmlTitNivel"]);
		$xml_TitNivel = loadXML($_REQUEST["xmlTitNivel"]);
		
		$xml=new SimpleXMLElement('<rows/>');
		
		@mysqli_query($GLOBALS["___mysqli_ston"], "LOCK TABLES titulos READ WRITE");
	
		$sql="SELECT MAX(codigo) 'maxcod' FROM titulos";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		$codigo = $row['maxcod'] + 1;
		
		$sql="INSERT titulos ";
		$sql.="SET codigo='$codigo', ";
		$sql.="denominacion='".$xml_Titulo["nombre"]."', ";
		$sql.="id_grado_titulo='".$xml_Titulo["id_grado_titulo"]."', ";
		$sql.="id_institucion='".$xml_Titulo["id_institucion"]."', ";
		$sql.="norma_creacion='".$xml_Titulo["norma_creacion"]."', ";
		$sql.="disciplina_unica='".$xml_Titulo["disciplina_unica"]."', ";
		$sql.="id_nivel_otorga='".$xml_Titulo["id_nivel_otorga"]."', ";
		$sql.="requisitos_ingreso='".$xml_Titulo["requisitos_ingreso"]."', ";
		$sql.="modalidad_cursado='".$xml_Titulo["modalidad_cursado"]."', ";
		$sql.="anios_duracion='".$xml_Titulo["anios_duracion"]."', ";
		$sql.="carga_horaria='".$xml_Titulo["carga_horaria"]."', ";
		$sql.="especifico='".$xml_Titulo["especifico"]."' ";
		toXML($xml, $sql, "add");
		
		$id_titulo = ((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);				
		
		for ($idx=0;$idx<count($xml_TitNivel->titulospara);$idx++) {							
			$sql = "INSERT titulos_nivel_para SET id_nivel_para = '".$xml_TitNivel->titulospara[$idx]['id_nivel_para']."', " .
					"id_titulo = '$id_titulo'";										
			toXML($xml, $sql, "add");
		}
		
		if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {			
			$_descrip = "ALTA DEL TÍTULO '".$xml_Titulo["nombre"]."' CON id='$id_titulo'";
			_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'titulos',
					$id_titulo,
                    $_descrip,
                    '',
                    '');	
		}
		
		$sql="SELECT codigo 'cc' FROM titulos WHERE codigo='$codigo'";
		toXML($xml, $sql, "codigos");
		
		@mysqli_query($GLOBALS["___mysqli_ston"], "UNLOCK TABLES");
						
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'update': 
	{
		$_REQUEST["xmlTitulo"] = str_replace('\"','"',$_REQUEST["xmlTitulo"]);
		$xml_Titulo = loadXML($_REQUEST["xmlTitulo"]);
		
		$_REQUEST["xmlTitNivel"] = str_replace('\"','"',$_REQUEST["xmlTitNivel"]);
		$xml_TitNivel = loadXML($_REQUEST["xmlTitNivel"]);
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="SELECT COUNT(id_titulo) 'cc' ";
		$sql.="FROM titulos ";
		$sql.="WHERE codigo='".$xml_Titulo["codigo"]."' ";
		$sql.="AND id_titulo <> '".$xml_Titulo["id_titulo"]."'";
		toXML($xml, $sql, "codigos");
		$n = $xml->children()->attributes();
		if($n["cc"]==0)
		{
			$sql="SELECT * FROM titulos WHERE id_titulo='".$xml_Titulo["id_titulo"]."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$campos=(($___mysqli_tmp = mysqli_num_fields($result)) ? $___mysqli_tmp : false);
			$row=mysqli_fetch_array($result);
			$datos_titulo="";	
		    for($j=0;$j<$campos;$j++)
		    {
		       $nombre=((($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)->name) && (!is_null($___mysqli_tmp))) ? $___mysqli_tmp : false);
		       $tipo=((is_object($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)) && !is_null($___mysqli_tmp = $___mysqli_tmp->type)) ? ((($___mysqli_tmp = (string)(substr(( (($___mysqli_tmp == MYSQLI_TYPE_STRING) || ($___mysqli_tmp == MYSQLI_TYPE_VAR_STRING) ) ? "string " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY, MYSQLI_TYPE_SHORT, MYSQLI_TYPE_LONG, MYSQLI_TYPE_LONGLONG, MYSQLI_TYPE_INT24))) ? "int " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_FLOAT, MYSQLI_TYPE_DOUBLE, MYSQLI_TYPE_DECIMAL, ((defined("MYSQLI_TYPE_NEWDECIMAL")) ? constant("MYSQLI_TYPE_NEWDECIMAL") : -1)))) ? "real " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIMESTAMP) ? "timestamp " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_YEAR) ? "year " : "" ) . ( (($___mysqli_tmp == MYSQLI_TYPE_DATE) || ($___mysqli_tmp == MYSQLI_TYPE_NEWDATE) ) ? "date " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIME) ? "time " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_SET) ? "set " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_ENUM) ? "enum " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_GEOMETRY) ? "geometry " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_DATETIME) ? "datetime " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY_BLOB, MYSQLI_TYPE_BLOB, MYSQLI_TYPE_MEDIUM_BLOB, MYSQLI_TYPE_LONG_BLOB))) ? "blob " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_NULL) ? "null " : "" ), 0, -1))) == "") ? "unknown" : $___mysqli_tmp) : false);
		       $valor=mysql_result($result,0,$j);
		       $valor="'$valor'";
		       $datos_titulo.="$nombre".'=';           
		       $datos_titulo.="$valor,";
		    }
		    
			$sql="UPDATE titulos ";
			$sql.="SET codigo='".$xml_Titulo["codigo"]."', ";
			$sql.="denominacion='".$xml_Titulo["nombre"]."', ";
			$sql.="id_grado_titulo='".$xml_Titulo["id_grado_titulo"]."', ";
			$sql.="id_institucion='".$xml_Titulo["id_institucion"]."', ";
			$sql.="norma_creacion='".$xml_Titulo["norma_creacion"]."', ";
			$sql.="disciplina_unica='".$xml_Titulo["disciplina_unica"]."', ";
			$sql.="id_nivel_otorga='".$xml_Titulo["id_nivel_otorga"]."', ";
			$sql.="requisitos_ingreso='".$xml_Titulo["requisitos_ingreso"]."', ";
			$sql.="modalidad_cursado='".$xml_Titulo["modalidad_cursado"]."', ";
			$sql.="anios_duracion='".$xml_Titulo["anios_duracion"]."', ";
			$sql.="carga_horaria='".$xml_Titulo["carga_horaria"]."', ";
			$sql.="especifico='".$xml_Titulo["especifico"]."' ";
			$sql.="WHERE id_titulo='".$xml_Titulo["id_titulo"]."'";
			toXML($xml, $sql, "upd");
			
			$sql="DELETE FROM titulos_nivel_para WHERE id_titulo='".$xml_Titulo["id_titulo"]."'";
			toXML($xml, $sql, "upd");
			
			for ($idx=0;$idx<count($xml_TitNivel->titulospara);$idx++) {							
				$sql = "INSERT titulos_nivel_para SET id_nivel_para = '".$xml_TitNivel->titulospara[$idx]['id_nivel_para']."', " .
						"id_titulo = '".$xml_Titulo["id_titulo"]."'";										
				toXML($xml, $sql, "upd");
			}
			
			if( !(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) ) {
				$_id_registro=$xml_Titulo["id_titulo"];
				$_descrip = "MODIFICACIÓN DEL TÍTULO '".$xml_Titulo["nombre"]."' CON id='".$xml_Titulo["id_titulo"]."' ";
				$_descrip.="DATOS DEL TÍTULO ANTES DE LA MODIFICACIÓN: ";
				$_descrip.=$datos_titulo;
				_auditoria($sql, 
                    $link_salud1,
					$link_salud1,
					'titulos',
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
		$_REQUEST["xmlTitulo"] = str_replace('\"','"',$_REQUEST["xmlTitulo"]);
		$xml_Titulo = loadXML($_REQUEST["xmlTitulo"]);	
		
		
		$xml=new SimpleXMLElement('<rows/>');
		
		$sql="DELETE FROM titulos ";
		$sql.="WHERE id_titulo='".$xml_Titulo["id_titulo"]."' ";
		toXML($xml, $sql, "del");
		
		$sql="DELETE FROM titulos_nivel_para WHERE id_titulo='".$xml_Titulo["id_titulo"]."'";
		toXML($xml, $sql, "del");
				
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	case 'traer_instituciones':
 	{ 		
 		$denominacion = strtoupper($denominacion);
		$xml=new SimpleXMLElement('<rows/>');	  	
	  	$sql="SELECT id_institucion, i.denominacion, id_provincia, p.denominacion 'provincia' ";
		$sql.="FROM instituciones i ";
		$sql.="INNER JOIN provincias p USING(id_provincia) ";
		$sql.="WHERE i.denominacion like'%$denominacion%' ";		
		$sql.="ORDER BY i.denominacion";		
		toXML($xml, $sql, "institucion");
		
		echo $xml->asXML();
				
    	break;
   }
   case 'buscar_titulo':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	$sql="SELECT id_titulo, t.codigo, t.denominacion 'nombre', id_grado_titulo, id_institucion, norma_creacion, disciplina_unica, id_nivel_otorga, i.denominacion, descripcion 'nivel', anios_duracion, ";
	  	$sql.="carga_horaria, requisitos_ingreso, modalidad_cursado, especifico ";
		$sql.="FROM titulos t ";		
		$sql.="LEFT JOIN instituciones i USING(id_institucion) ";		
		$sql.="LEFT JOIN nivel_otorga USING(id_nivel_otorga) ";
		$sql.="WHERE t.denominacion LIKE '$filter' ";
		$sql.="ORDER BY t.denominacion";
		toXML($xml, $sql, "titulos");				
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
   case 'buscar_titulo_codigo':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');				   			  	
	  	
	  	$sql="SELECT id_titulo, t.codigo, t.denominacion 'nombre', id_grado_titulo, id_institucion, norma_creacion, disciplina_unica, id_nivel_otorga, i.denominacion, descripcion 'nivel', anios_duracion, ";
	  	$sql.="carga_horaria, requisitos_ingreso, modalidad_cursado, especifico ";
		$sql.="FROM titulos t ";		
		$sql.="LEFT JOIN instituciones i USING(id_institucion) ";		
		$sql.="LEFT JOIN nivel_otorga USING(id_nivel_otorga) ";
		$sql.="WHERE t.codigo = '$codigo' ";
		$sql.="ORDER BY t.denominacion";
		toXML($xml, $sql, "titulos");				
		
		header('Content-Type: text/xml');     	     	
     	echo $xml->asXML();
    	break;
   }
 	case 'traer_datos':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
				   		
	  	$xml2=new SimpleXMLElement('<rows/>');
	  	
	  	$sql="SELECT id_titulo, t.codigo, t.denominacion 'nombre', id_grado_titulo, id_institucion, norma_creacion, disciplina_unica, id_nivel_otorga, i.denominacion, descripcion 'nivel', anios_duracion, ";
	  	$sql.="carga_horaria, requisitos_ingreso, modalidad_cursado, especifico ";
		$sql.="FROM titulos t ";		
		$sql.="LEFT JOIN instituciones i USING(id_institucion) ";		
		$sql.="LEFT JOIN nivel_otorga USING(id_nivel_otorga) ";
		$sql.="WHERE t.denominacion LIKE '%$filter%' ";
		$sql.="ORDER BY t.denominacion";
		toXML($xml2, $sql, "titulos");				
		
		header('Content-Type: text/xml');     	
     	simplexml_merge($xml2, $xml);     	
     	echo $xml2->asXML();
    	break;
   }
   case 'traer_datos2':
 	{ 		
		$xml=new SimpleXMLElement('<rows/>');
				   		
	  	$xml2=new SimpleXMLElement('<rows/>');	  		  	
		
		$sql="SELECT * ";
		$sql.="FROM nivel_otorga ";
		$sql.="ORDER BY descripcion";
		toXML($xml2, $sql, "niveles");
		
		$sql="SELECT * ";
		$sql.="FROM nivel_para ";
		$sql.="ORDER BY descripcion";
		toXML($xml2, $sql, "niveles_para");
		
		$sql="SELECT * ";
		$sql.="FROM grados_titulos ";
		$sql.="ORDER BY denominacion";
		toXML($xml2, $sql, "grados");
		
		header('Content-Type: text/xml');
     	//$xml=simplexml_load_string($xml);
     	simplexml_merge($xml2, $xml);     	
     	echo $xml2->asXML();
    	break;
   }
   case 'traer_titulo_nivel_para':
   {
   		$xml=new SimpleXMLElement('<rows/>');
   		
   		$sql="SELECT id_nivel_para, descripcion FROM titulos_nivel_para ";
   		$sql.="JOIN nivel_para USING(id_nivel_para)";
   		$sql.="WHERE id_titulo='$id_titulo'";
   		
   		toXML($xml, $sql, "titulospara");
   		
   		echo $xml->asXML();
   		break;
   }	
}
?>