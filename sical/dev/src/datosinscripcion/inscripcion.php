<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{
	case 'baja_inscripcion': {
		$xml=new SimpleXMLElement('<rows/>');
		
		$datos_docente = '';
		$detalle_baja = '';
		$sql="SELECT apellido, nombres, nro_doc, id_docente, l.id_llamado, l.descripcion 'llamado' FROM docentes_llamados ";
		$sql.="INNER JOIN docentes USING(id_docente) ";
		$sql.="INNER JOIN llamados l USING(id_llamado) ";
		$sql.="WHERE id_docente_llamado='$id_docente_llamado'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$campos=(($___mysqli_tmp = mysqli_num_fields($result)) ? $___mysqli_tmp : false);
		$row=mysqli_fetch_array($result);		
        for($j=0;$j<$campos;$j++)
        {
           $nombre=((($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)->name) && (!is_null($___mysqli_tmp))) ? $___mysqli_tmp : false);
           $tipo=((is_object($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)) && !is_null($___mysqli_tmp = $___mysqli_tmp->type)) ? ((($___mysqli_tmp = (string)(substr(( (($___mysqli_tmp == MYSQLI_TYPE_STRING) || ($___mysqli_tmp == MYSQLI_TYPE_VAR_STRING) ) ? "string " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY, MYSQLI_TYPE_SHORT, MYSQLI_TYPE_LONG, MYSQLI_TYPE_LONGLONG, MYSQLI_TYPE_INT24))) ? "int " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_FLOAT, MYSQLI_TYPE_DOUBLE, MYSQLI_TYPE_DECIMAL, ((defined("MYSQLI_TYPE_NEWDECIMAL")) ? constant("MYSQLI_TYPE_NEWDECIMAL") : -1)))) ? "real " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIMESTAMP) ? "timestamp " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_YEAR) ? "year " : "" ) . ( (($___mysqli_tmp == MYSQLI_TYPE_DATE) || ($___mysqli_tmp == MYSQLI_TYPE_NEWDATE) ) ? "date " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIME) ? "time " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_SET) ? "set " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_ENUM) ? "enum " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_GEOMETRY) ? "geometry " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_DATETIME) ? "datetime " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY_BLOB, MYSQLI_TYPE_BLOB, MYSQLI_TYPE_MEDIUM_BLOB, MYSQLI_TYPE_LONG_BLOB))) ? "blob " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_NULL) ? "null " : "" ), 0, -1))) == "") ? "unknown" : $___mysqli_tmp) : false);
           $valor=mysql_result($result,0,$j);
           $valor="'$valor'";
           $datos_docente.="$nombre".'=';           
           $datos_docente.="$valor,";
        }
		
		$sql= "DELETE ta FROM docentes_llamados_titulos_antecedentes ta ";
		$sql.= "INNER JOIN docentes_llamados_titulos t USING(id_docente_llamado_titulo) ";
		$sql.= "WHERE t.id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");
		$detalle_baja .= $sql . ' ';
		
		$sql= "DELETE FROM docentes_llamados_titulos ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");
		$detalle_baja .= $sql . ' ';
		
		$sql= "DELETE FROM docentes_llamados_escuelas ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");
		$detalle_baja .= $sql . ' ';
		
		$sql= "DELETE FROM docentes_llamados_cargos ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");
		$detalle_baja .= $sql . ' ';
		
		$sql= "DELETE FROM docentes_llamados_observaciones ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");
		$detalle_baja .= $sql . ' ';
		
		$sql= "DELETE FROM reclamos ";
		$sql.= "WHERE id_docentes_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");
		$detalle_baja .= $sql . ' ';
		
		$sql= "DELETE FROM docentes_llamados ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "baja");
		$detalle_baja .= $sql . ' ';
		
		$_descrip = "BAJA DEL DOCENTE_LLAMADO CON id='$id_docente_llamado' ";
		$_descrip.="DATOS DE LA INSCRIPCIÓN ELIMINADA: ";
		$_descrip.=$datos_docente . ' ';
		$_descrip.="DETALLE DE LA BAJA (ANTECEDENTES, TÍTULOS, ESCUELAS, CARGOS, OBSERVACIONES, RECLAMOS): ";
		$_descrip.=$detalle_baja;
		_auditoria($sql, 
                $link_salud1,
				$link_salud1,
				'docentes_llamados',
				$id_docente_llamado,
                $_descrip,
                '',
                '');
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}	
	
	case 'traer_datos': {
		//Traer la id del docente, del nivel, y del llamado del cual se trae la información de acumulados históricos
		//correspondientes a la id_docente_llamado
		$sql = "SELECT id_docente, id_nivel, id_llam_ant_acum, id_subtipo_clasificacion FROM docentes_llamados JOIN llamados USING(id_llamado) ";
		$sql .= "WHERE id_docente_llamado = '$id_docente_llamado'";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		$id_docente = $row['id_docente'];
		
		$id_nivel = $row['id_nivel'];
		
		$id_llam_ant_acum = $row['id_llam_ant_acum'];
		
		$id_subtipo_clasificacion = $row['id_subtipo_clasificacion'];
		
		$xml=new SimpleXMLElement('<rows/>');
		
		//Traer los datos del docente
		$sql="SELECT * ";
		$sql.="FROM docentes JOIN tipos_documentos USING(id_tipo_doc) ";
		$sql.="INNER JOIN docentes_llamados USING(id_docente) ";
		$sql.="LEFT JOIN localidades USING(id_localidad) ";
		$sql.="WHERE id_docente_llamado = '$id_docente_llamado'";		
		toXML($xml, $sql, "docente");
		
		//Traer las instancias de clasificación
		$nodo2=$xml->addChild("instancias");
		$nodo2->addAttribute("id_inst_clas", "0");
		$nodo2->addAttribute("id_subtipo_clasificacion", "0");
		$nodo2->addAttribute("instancia_clasificacion", "--Seleccione--");
		$nodo2->addAttribute("orden", "0");
		$nodo2->addAttribute("nemonico", "");		
		
		$sql="SELECT * FROM instancias_clasificacion ";
		$sql.="WHERE id_subtipo_clasificacion = '$id_subtipo_clasificacion'";
		toXML($xml, $sql, "instancias");
		
		//Traer los datos del docente_llamado
		$sql= "SELECT * FROM docentes_llamados ";		
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		toXML($xml, $sql, "docentellamado");
		
		//Traer los establecimientos
		$sql= "SELECT id_escuela, nombre, codigo FROM docentes_llamados_escuelas ";
		$sql.= "INNER JOIN escuelas USING(id_escuela) ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		$sql.= "AND codigo <> '2000' AND codigo <> '2001' AND id_nivel='$id_nivel'";
		toXML($xml, $sql, "establecimiento");						
		
		//Traer el id del primer docente_llamado_titulo que corresponde a la inscripción
		$sql= "SELECT id_docente_llamado_titulo, id_titulo, codigo, denominacion ";
		$sql.= "FROM docentes_llamados_titulos ";
		$sql.= "INNER JOIN docentes_llamados_titulos_antecedentes USING(id_docente_llamado_titulo) ";
		$sql.= "INNER JOIN titulos USING(id_titulo) ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		$row = mysqli_fetch_array($result);
		
		//Traer los antecedentes correspondientes al id_docente_llamado_titulo
		//encontrado anteriormente
		$sql = "SELECT * FROM docentes_llamados_titulos_antecedentes ";
		$sql .= "JOIN antecedentes USING(id_antecedente) ";
		$sql .= "WHERE id_docente_llamado_titulo='".$row['id_docente_llamado_titulo']."' ";
		$sql .= "AND codigo NOT IN('B','A31','A41','A42','A43','A44','A45','K71','K72')";
				
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		while ($row = mysqli_fetch_array($result)) {
			$nodo=$xml->addChild("antecedente");
			foreach($row as $key => $value) {						 
				if (!is_numeric($key)) {
					if ($key != 'unidades' && $key != 'acum_historico')
						$nodo->addAttribute($key, $value);
					else
						$nodo->addAttribute($key, intval($value));	
				}				
			}
		}		
		
		//Buscar si existe un docente_llamado del cual tomar el acumulado
		$sql="SELECT id_docente_llamado FROM docentes_llamados WHERE id_llamado = '$id_llam_ant_acum' " .
				"AND id_docente='$id_docente'";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		if ($row = mysqli_fetch_array($result)) {
			$id_docente_llamado_buscar_titulo = $row['id_docente_llamado'];
			//Si existe un llamado del cual tomar el acumulado, traer el id_docente_llamado_titulo			
			$sql= "SELECT id_docente_llamado_titulo, id_titulo, codigo, denominacion ";
			$sql.= "FROM docentes_llamados_titulos ";
			$sql.= "INNER JOIN docentes_llamados_titulos_antecedentes USING(id_docente_llamado_titulo) ";
			$sql.= "INNER JOIN titulos USING(id_titulo) ";
			$sql.= "WHERE id_docente_llamado='".$row['id_docente_llamado']."'";
			
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$row = mysqli_fetch_array($result);
			
			//Traer los antecedentes acumulados para el id_docente_llamado_titulo encontrado anteriormente
			$sql = "SELECT id_antecedente, codigo, unidades, acum_historico FROM docentes_llamados_titulos_antecedentes ";
			$sql .= "JOIN antecedentes USING(id_antecedente) ";
			$sql .= "WHERE id_docente_llamado_titulo='".$row['id_docente_llamado_titulo']."' ";
			$sql .= "AND codigo NOT IN('B','A31','A41','A42','A43','A44','A45','K71','K72')";
					
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			while ($row = mysqli_fetch_array($result)) {
				$nodo=$xml->addChild("acum_antecedente");
				foreach($row as $key => $value) {						 
					if (!is_numeric($key)) {
						if ($key != 'unidades' && $key != 'acum_historico')
							$nodo->addAttribute($key, $value);
						else
							$nodo->addAttribute($key, intval($value));	
					}				
				}
			}
		} else {
			$id_docente_llamado_buscar_titulo = '';
			//Si no existe, el acumulado es cero			
			$sql="SELECT id_antecedente, codigo, '0' as unidades, '0' as acum_historico " .
					"FROM antecedentes JOIN antecedentes_padres USING(id_antec_padre) " .
					"WHERE codigo NOT IN('B','A31','A41','A42','A43','A44','A45','K71','K72')";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			while ($row = mysqli_fetch_array($result)) {
				$nodo=$xml->addChild("acum_antecedente");
				foreach($row as $key => $value) {						 
					if (!is_numeric($key)) {
						if ($key != 'unidades' && $key != 'acum_historico')
							$nodo->addAttribute($key, $value);
						else
							$nodo->addAttribute($key, intval($value));	
					}				
				}
			}
		}
		
		// Buscar solamente los topes de aquellos antecedentes que tienen tope por quinquenio
		$sql="SELECT codigo, puntos, descripcion, tope, tipo_tope
				FROM `antecedentes`
				JOIN antecedentes_padres
				USING ( id_antec_padre )
				WHERE control_quinquenio = 'S'";
		toXML($xml, $sql, "tope_antecedente");
		
		//Verificar si existen títulos para la inscripción actual
		$sql= "SELECT COUNT(id_docente_llamado_titulo) 'cc' ";
		$sql.= "FROM docentes_llamados_titulos ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		if ($row['cc'] > 0) {
			//Si existen, los traigo
			$sql= "SELECT id_docente_llamado_titulo, id_titulo, t.codigo, denominacion, observacion, comentario FROM docentes_llamados_titulos ";
			$sql.= "INNER JOIN titulos t USING(id_titulo) ";
			$sql.= "LEFT JOIN observaciones_titulo o USING(id_observ_titulo) ";
			$sql.= "WHERE id_docente_llamado='$id_docente_llamado'";	
		} else {
			//Si no existen, me fijo si hay un llamado del cual tomar el acumulado
			if ($id_docente_llamado_buscar_titulo != '') {
				//Si es así, traigo los títulos correspondientes a dicho llamado
				$sql= "SELECT id_docente_llamado_titulo, id_titulo, t.codigo, denominacion, observacion, comentario FROM docentes_llamados_titulos ";
				$sql.= "INNER JOIN titulos t USING(id_titulo) ";
				$sql.= "LEFT JOIN observaciones_titulo o USING(id_observ_titulo) ";
				$sql.= "WHERE id_docente_llamado='$id_docente_llamado_buscar_titulo'";	
			} else {
				$sql= "SELECT id_docente_llamado_titulo, id_titulo, t.codigo, denominacion, observacion, comentario FROM docentes_llamados_titulos ";
				$sql.= "INNER JOIN titulos t USING(id_titulo) ";
				$sql.= "LEFT JOIN observaciones_titulo o USING(id_observ_titulo) ";
				$sql.= "WHERE id_docente_llamado='$id_docente_llamado'";
			}			
		}	
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		while ($row = mysqli_fetch_array($result)) {
			$nodo=$xml->addChild("titulo");
			foreach($row as $key => $value) {						 
				if (!is_numeric($key)) $nodo->addAttribute($key, $value);
			}
			$sql2 = "SELECT id_antecedente, codigo, unidades FROM docentes_llamados_titulos_antecedentes ";
			$sql2 .= "JOIN antecedentes USING(id_antecedente) ";
			$sql2 .= "WHERE id_docente_llamado_titulo='".$row['id_docente_llamado_titulo']."' ";
			$sql2 .= "AND codigo IN('B','A31','A41','A42','A43','A44','A45','K71','K72')";
			$result2 = mysqli_query($GLOBALS["___mysqli_ston"], $sql2);
			while ($row2 = mysqli_fetch_array($result2)) {
				if ($row2['codigo'] == 'B')
					$nodo->addAttribute("promedio", $row2['unidades']);
				else		 
					$nodo->addAttribute(strtolower($row2['codigo']), intval($row2['unidades']));
			}			
		}
		
		$sql= "SELECT * FROM docentes_llamados_cargos ";
		$sql.="JOIN cargos USING(id_cargo) ";
		$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";		
		toXML($xml, $sql, "cargo");
		
		$sql="SELECT COUNT(id_quinquenio) 'fq' FROM quinquenios";
		toXML($xml, $sql, "quinquenio");		
		
		header('Content-Type: text/xml');
		echo $xml->asXML();
		break;
	}
	
	case 'cancelar_inscripcion': {
		$error = "";
		$datos_docente = '';
		$sql="SELECT apellido, nombres, nro_doc, id_docente, l.id_llamado, l.descripcion 'llamado' FROM docentes_llamados ";
		$sql.="INNER JOIN docentes USING(id_docente) ";
		$sql.="INNER JOIN llamados l USING(id_llamado) ";
		$sql.="WHERE id_docente_llamado='".$_REQUEST['id_docente_llamado']."'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$campos=(($___mysqli_tmp = mysqli_num_fields($result)) ? $___mysqli_tmp : false);
		$row=mysqli_fetch_array($result);		
        for($j=0;$j<$campos;$j++)
        {
           $nombre=((($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)->name) && (!is_null($___mysqli_tmp))) ? $___mysqli_tmp : false);
           $tipo=((is_object($___mysqli_tmp = mysqli_fetch_field_direct($result, 0)) && !is_null($___mysqli_tmp = $___mysqli_tmp->type)) ? ((($___mysqli_tmp = (string)(substr(( (($___mysqli_tmp == MYSQLI_TYPE_STRING) || ($___mysqli_tmp == MYSQLI_TYPE_VAR_STRING) ) ? "string " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY, MYSQLI_TYPE_SHORT, MYSQLI_TYPE_LONG, MYSQLI_TYPE_LONGLONG, MYSQLI_TYPE_INT24))) ? "int " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_FLOAT, MYSQLI_TYPE_DOUBLE, MYSQLI_TYPE_DECIMAL, ((defined("MYSQLI_TYPE_NEWDECIMAL")) ? constant("MYSQLI_TYPE_NEWDECIMAL") : -1)))) ? "real " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIMESTAMP) ? "timestamp " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_YEAR) ? "year " : "" ) . ( (($___mysqli_tmp == MYSQLI_TYPE_DATE) || ($___mysqli_tmp == MYSQLI_TYPE_NEWDATE) ) ? "date " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_TIME) ? "time " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_SET) ? "set " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_ENUM) ? "enum " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_GEOMETRY) ? "geometry " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_DATETIME) ? "datetime " : "" ) . ( (in_array($___mysqli_tmp, array(MYSQLI_TYPE_TINY_BLOB, MYSQLI_TYPE_BLOB, MYSQLI_TYPE_MEDIUM_BLOB, MYSQLI_TYPE_LONG_BLOB))) ? "blob " : "" ) . ( ($___mysqli_tmp == MYSQLI_TYPE_NULL) ? "null " : "" ), 0, -1))) == "") ? "unknown" : $___mysqli_tmp) : false);
           $valor=mysql_result($result,0,$j);
           $valor="'$valor'";
           $datos_docente.="$nombre".'=';           
           $datos_docente.="$valor,";
        }
        
		$sql = "DELETE FROM docentes_llamados WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
			$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
		} else {
			$_descrip = "CANCELACIÓN DEL DOCENTE_LLAMADO CON id='".$_REQUEST['id_docente_llamado']."' ";
			$_descrip.="(EQUIVALE A UNA BAJA DE DOCENTE_LLAMADO CUANDO AÚN NO SE HAN GRABADO ANTECEDENTES, TÍTULOS, ESCUELAS, CARGOS): ";
			$_descrip.="DATOS DE LA INSCRIPCIÓN ELIMINADA: ";
			$_descrip.=$datos_docente;
			_auditoria($sql, 
	                $link_salud1,
					$link_salud1,
					'docentes_llamados',
					$id_docente_llamado,
	                $_descrip,
	                '',
	                '');
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
	
	case 'realizar_inscripcion': {
		$error = "";
		$datos_inscripcion = "";
		$detalle_inscripcion = "";
		$_REQUEST["inscripcion"] = str_replace('\"','"',$_REQUEST["inscripcion"]);
		$inscripcion = loadXML($_REQUEST['inscripcion']);
		$sql = "SELECT id_docente_llamado, id_llamado FROM docentes_llamados WHERE id_docente_llamado = '$id_docente_llamado'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
			$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
		} else {
			$row = mysqli_fetch_array($result);
			$id_docente_llamado = $row['id_docente_llamado'];
			$id_llamado = $row['id_llamado'];
			
			$sql= "DELETE ta FROM docentes_llamados_titulos_antecedentes ta ";
			$sql.= "INNER JOIN docentes_llamados_titulos t USING(id_docente_llamado_titulo) ";
			$sql.= "WHERE t.id_docente_llamado='$id_docente_llamado' ";
			$detalle_inscripcion.=$sql . ' ';
			mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$sql= "DELETE FROM docentes_llamados_titulos ";
			$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
			$detalle_inscripcion.=$sql . ' ';
			mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$sql= "DELETE FROM docentes_llamados_escuelas ";
			$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
			$detalle_inscripcion.=$sql . ' ';
			mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			
			$sql= "DELETE FROM docentes_llamados_cargos ";
			$sql.= "WHERE id_docente_llamado='$id_docente_llamado' ";
			$detalle_inscripcion.=$sql . ' ';
			mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
			$sql = "SELECT id_nivel, id_tipo_clasificacion, estado FROM llamados WHERE id_llamado = '$id_llamado'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$id_nivel = $row['id_nivel'];
			$id_tipo_clasificacion = $row['id_tipo_clasificacion'];
			$estado_llamado = $row['estado'];
			if ($estado_llamado == 'A') {
				$estado_doc_llam = 1; 
			} else {
				$estado_doc_llam = 0;
			}			
			$sql = "UPDATE docentes_llamados SET depto_inicial = '".$_REQUEST['depto_aplicacion_inicial']."', " .
				   	"depto_primario = '".$_REQUEST['depto_aplicacion_primario']."', estado = '$estado_doc_llam' " .
				   	"WHERE id_docente_llamado = '$id_docente_llamado'";
			$datos_inscripcion .= $sql;
			$detalle_inscripcion .= $sql . ' ';				
			mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			if ($id_nivel == '1' or $id_nivel == '2') {				
				$sql = "UPDATE docentes_llamados SET tipo_jornada='$tipo_jornada', ";
				if ($_REQUEST['tipo_jornada'] != 'CC' && $_REQUEST['tipo_jornada'] != 'DP') {					
					$sql .= "id_region = '".$_REQUEST['nro_region']."'";					
				} else {
					$sql .= "id_region = ''";					
				}				
				if (($id_tipo_clasificacion == '1' and $id_nivel == '2') or $id_tipo_clasificacion == '2' or $id_tipo_clasificacion == '5') {
					if ($id_tipo_clasificacion == '1' and $id_nivel == '2') {
						$situacion_revista = ($_REQUEST['situacion_revista'] == '1') ? '1' : '0';						
						$sql .= ",con_cargo = '".$situacion_revista."'";
					} else {
						$sql .= ",orden = '".$_REQUEST['situacion_revista']."'";
					}												
				}				
				$sql .= " WHERE id_docente_llamado = '$id_docente_llamado'";				
				$detalle_inscripcion.=$sql . ' ';
				mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
					$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
				}
			}
			if ($id_nivel == '3' or $id_nivel == '4') {				
				$sql = "UPDATE docentes_llamados SET selecciona_cargo = '".$_REQUEST['selecciona_cargo']."', " .
						"ruralidad = '".$_REQUEST['ruralidad']."' WHERE id_docente_llamado = '$id_docente_llamado'";
				$detalle_inscripcion.=$sql . ' ';							
				mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				if ($id_tipo_clasificacion == '2' or $id_tipo_clasificacion == '5') {
					$sql = "UPDATE docentes_llamados SET orden = '".$_REQUEST['situacion_revista']."' WHERE id_docente_llamado = '$id_docente_llamado'";
					$detalle_inscripcion.=$sql . ' ';
					mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
						$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
					}
				}
			}
			if ($id_nivel == '5') {
				if ($id_tipo_clasificacion == '2' or $id_tipo_clasificacion == '5') {
					$sql = "UPDATE docentes_llamados SET orden = '".$_REQUEST['situacion_revista']."' ";
					$sql.= "WHERE id_docente_llamado = '$id_docente_llamado'";
					mysqli_query($GLOBALS["___mysqli_ston"], $sql);							
				}
				if ($id_tipo_clasificacion == '1') {
					$sql = "UPDATE docentes_llamados SET ";
					$situacion_revista = ($_REQUEST['situacion_revista'] == '1') ? '1' : '0';						
					$sql.= "con_cargo = '".$situacion_revista."' ";
					$sql.= "WHERE id_docente_llamado = '$id_docente_llamado'";
					mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				}
			}			
		}
		$establecimientos = $inscripcion->establecimientos;				
		for ($idx=0;$idx<count($establecimientos->establecimiento);$idx++) {
			if ($id_nivel == '4') {
				$sql = "SELECT id_escuela FROM escuelas WHERE codigo = '".$establecimientos->establecimiento[$idx]['codigo']."' AND id_nivel <> 7";
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				while ($row = mysqli_fetch_array($result)) {
					$sql2 = "INSERT INTO docentes_llamados_escuelas SET id_escuela = '".$row['id_escuela']."', id_docente_llamado = '$id_docente_llamado'";
					$detalle_inscripcion.=$sql2 . ' ';										
					$result2 = mysqli_query($GLOBALS["___mysqli_ston"], $sql2);
					if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
						$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
					}
				}	
			} else {
				$sql = "INSERT INTO docentes_llamados_escuelas SET id_escuela = '".$establecimientos->establecimiento[$idx]['id_escuela']."', id_docente_llamado = '$id_docente_llamado'";
				$detalle_inscripcion.=$sql . ' ';										
				$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
				if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
					$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
				}
			}			
		}
		$antiguedad = $inscripcion->antiguedades;
		$antiguedadc5 = $inscripcion->antiguedadesc5;
		$titulos = $inscripcion->titulos;
		$cargossimp = $inscripcion->cargossimp;
		$cargoscomp = $inscripcion->cargoscomp;
		$cargosc = $inscripcion->cargosc;
		$cargosa = $inscripcion->cargosa;
		$cargose = $inscripcion->cargose;
		$cargosp = $inscripcion->cargosp;
		$postitulos = $inscripcion->postitulos;
		$posgrados = $inscripcion->posgrados;
		$cursosap = $inscripcion->cursosap;
		$cursosad = $inscripcion->cursosad;
		$cursoscost = $inscripcion->cursoscost;
		$cursossr = $inscripcion->cursossr;
		$cursoscr = $inscripcion->cursoscr;
		$congresoexp = $inscripcion->congresosexp;
		$congresopart = $inscripcion->congresospart;
		$congresoasist = $inscripcion->congresosasist;
		$capacitaciones = $inscripcion->capacitaciones;
		$publicaciones = $inscripcion->publicaciones;
		$producciones = $inscripcion->producciones;
		$premiosic = $inscripcion->premiosic;
		$premiosp = $inscripcion->premiosp;
		$concursostit = $inscripcion->concursost;
		$concursosant = $inscripcion->concantec;
		$concursosop = $inscripcion->concopos;
		$participacion = $inscripcion->participacion;
		$desempenio = $inscripcion->desempenio;
		$nativas = $inscripcion->lenguasnat;
		$desempent = $inscripcion->desempenioent;
		$extranjeras = $inscripcion->lenguasext;
		$deducciones = $inscripcion->deducciones;
		$jurado = $inscripcion->jurado;
		$array_antecedentes = array($antiguedad->antiguedad,
									$postitulos->postitulo,
									$posgrados->postitulo,
									$cursosap->curso,
									$cursosad->curso,
									$cursoscost->curso,
									$cursossr->curso,
									$cursoscr->curso,
									$congresoexp->curso,
									$congresopart->curso,
									$congresoasist->curso,
									$capacitaciones->curso,
									$publicaciones->curso,
									$producciones->curso,
									$premiosic->curso,
									$premiosp->curso,
									$concursostit->curso,
									$concursosant->curso,
									$concursosop->curso,
									$participacion->curso,
									$desempenio->curso,
									$nativas->curso,
									$desempent->curso,
									$extranjeras->curso,
									$deducciones->curso,
									$jurado->curso);
		$array_cargos = array($cargossimp->cargo,$cargoscomp->cargo,$cargosc->cargo,$cargosa->cargo,$cargose->cargo,$cargosp->cargo);
		foreach ( $array_cargos as $cargo ) {
			for ($idx2=0;$idx2<count($cargo);$idx2++) {
				$sql = "INSERT INTO docentes_llamados_cargos SET id_docente_llamado = '$id_docente_llamado', id_cargo = '".$cargo[$idx2]['id_cargo']."'";
				$detalle_inscripcion.=$sql . ' ';
				mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			}
		}		
		for ($idx=0;$idx<count($titulos->titulo);$idx++) {
			$sql = "SELECT id_titulo FROM titulos WHERE codigo = '".$titulos->titulo[$idx]['codigo']."'";
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);
			$sql = "INSERT INTO docentes_llamados_titulos SET id_titulo = '".$row['id_titulo']."', id_docente_llamado = '$id_docente_llamado'";
			$detalle_inscripcion.=$sql . ' ';
			mysqli_query($GLOBALS["___mysqli_ston"], $sql);			
			if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))) {
				$error.=((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));
			} else {
				$id_docente_llamado_titulo = ((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);	
				if ($titulos->titulo[$idx]['observacion'] != "") {					
					$sql = "SELECT id_observ_titulo FROM observaciones_titulo WHERE observacion = '".$titulos->titulo[$idx]['observacion']."'";
					$detalle_inscripcion.=$sql . ' ';
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$row = mysqli_fetch_array($result);
					$id_observ_titulo = $row['id_observ_titulo'];
					$sql = "UPDATE docentes_llamados_titulos SET id_observ_titulo = '$id_observ_titulo' WHERE id_docente_llamado_titulo = '$id_docente_llamado_titulo'";
					$detalle_inscripcion.=$sql . ' ';
					mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					if ($titulos->titulo[$idx]['observacion'] == "otro") {
						$sql = "UPDATE docentes_llamados_titulos SET comentario = '".$titulos->titulo[$idx]['comentario']."' WHERE id_docente_llamado_titulo = '$id_docente_llamado_titulo'";
						$detalle_inscripcion.=$sql . ' ';
						mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					}
				} else {
					$sql = "INSERT INTO docentes_llamados_titulos_antecedentes ";
					$sql .= "SET id_docente_llamado_titulo = '$id_docente_llamado_titulo', ";
					$sql .= "id_antecedente = '19', ";
					$sql .= "unidades = '".$titulos->titulo[$idx]['promedio']."'";
					$detalle_inscripcion.=$sql . ' ';
					mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					$array_antecedentes_titulos = array('a31','a41','a42','a43','a44','a45','k71','k72');
					for ($idx2=0;$idx2<count($array_antecedentes_titulos);$idx2++) {						
						$antecedente = $array_antecedentes_titulos[$idx2];
						if (intval($titulos->titulo[$idx][$antecedente]) > 0) {
							$codigo = $array_antecedentes_titulos[$idx2];
							$sql = "SELECT id_antecedente FROM antecedentes WHERE UCASE(codigo) = '$codigo'";									
							$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
							$row = mysqli_fetch_array($result);
							$id_antecedente = $row['id_antecedente'];
							$sql = "INSERT INTO docentes_llamados_titulos_antecedentes ";
							$sql .= "SET id_docente_llamado_titulo = '$id_docente_llamado_titulo', ";
							$sql .= "id_antecedente = '$id_antecedente', ";
							$sql .= "unidades = '".$titulos->titulo[$idx][$antecedente]."'";
							$detalle_inscripcion.=$sql . ' ';
							mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						}
					}
					for ($idx2=0;$idx2<count($antiguedadc5->antiguedad);$idx2++) {
						if (intval($antiguedadc5->antiguedad[$idx2]['cantidad']) > 0) {
							$sql = "INSERT INTO docentes_llamados_titulos_antecedentes ";
							$sql .= "SET id_docente_llamado_titulo = '$id_docente_llamado_titulo', ";
							$sql .= "id_antecedente = '".$antiguedadc5->antiguedad[$idx2]['id_antecedente']."', ";
							$sql .= "unidades = '".intval($antiguedadc5->antiguedad[$idx2]['cantidad'])."'";
							$detalle_inscripcion.=$sql . ' ';
							mysqli_query($GLOBALS["___mysqli_ston"], $sql);
						}
					}			
					foreach ( $array_antecedentes as $antecedente ) {																								
						for ($idx2=0;$idx2<count($antecedente);$idx2++) {
							if (intval($antecedente[$idx2]['cantidad']) > 0 || intval($antecedente[$idx2]['acum']) > 0) {
								$codigo = str_replace(".","",$antecedente[$idx2]['codigo']);
								$codigo = strtoupper($codigo);
								$sql = "SELECT id_antecedente FROM antecedentes WHERE UCASE(codigo) = '$codigo'";									
								$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
								$row = mysqli_fetch_array($result);
								$id_antecedente = $row['id_antecedente'];
								$sql = "INSERT INTO docentes_llamados_titulos_antecedentes ";
								$sql .= "SET id_docente_llamado_titulo = '$id_docente_llamado_titulo', ";
								$sql .= "id_antecedente = '$id_antecedente', ";
								$sql .= "unidades = '".intval($antecedente[$idx2]['cantidad'])."', ";
								$sql .= "acum_historico = '".intval($antecedente[$idx2]['acum'])."'";
								$detalle_inscripcion.=$sql . ' ';
								mysqli_query($GLOBALS["___mysqli_ston"], $sql);
							}							
						}
					}
				}												
			}
		}
		$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
		$xml .= "<xml>";
		if (!empty($error))
			$xml .= "<error>$error</error>";
		else {
			$_descrip = "MODIFICACIÓN DEL DOCENTE_LLAMADO CON id='$id_docente_llamado'. SI fecha ES POSTERIOR A fecha_incripcion ";
			$_descrip.="EN DOCENTE_LLAMADO SE TRATA DE UNA MODIFICACIÓN, EN CASO CONTRARIO SE TRATA DEL PRIMER GRABADO DE FICHA ";
			$_descrip.="DE INSCRIPCIÓN. ";
			$_descrip.="DATOS DE LA INSCRIPCIÓN MODIFICADA: ";
			$_descrip.=$datos_inscripcion . ' ';
			$_descrip.="DETALLE DE LA MODIFICACIÓN (ANTECEDENTES, TÍTULOS, ESCUELAS, CARGOS, OBSERVACIONES, RECLAMOS): ";
			$_descrip.=$detalle_inscripcion;
			_auditoria($sql, 
	                $link_salud1,
					$link_salud1,
					'docentes_llamados',
					$id_docente_llamado,
	                $_descrip,
	                '',
	                '');
			}		
		$xml.= "</xml>";
		header('Content-Type: text/xml');
		print $xml;
		break;
	}
}
?>