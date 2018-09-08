<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

switch ($_REQUEST['rutina'])
{		
	case "importar_inscripcion": {
		$sql = "SELECT id_docente FROM docentes_llamados WHERE id_docente_llamado = '$id_docente_llamado'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		$id_docente = $row['id_docente'];		
		
		$sql="SELECT estado FROM llamados WHERE id_llamado='$id_llamado'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		if ($row['estado']!='C') {
			$sql = "SELECT count(id_docente_llamado) as 'c' FROM docentes_llamados ";
			$sql .= "WHERE id_docente = '$id_docente' ";
			$sql .= "AND id_llamado = '$id_llamado'";		
			$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
			$row = mysqli_fetch_array($result);		
			if ($row['c'] == 0) {
				try {
				   	$xml=new SimpleXMLElement('<rows/>');
				   	header('Content-Type: text/xml');
				   	
				   	$sql= "INSERT INTO docentes_llamados ";
					$sql.= "(id_docente,id_llamado,fecha_inscripcion,estado,selecciona_cargo,folios,tipo_jornada,ruralidad,id_region,orden,usuario) ";
					$sql.="SELECT id_docente,$id_llamado,NOW(),1,selecciona_cargo,folios,tipo_jornada,ruralidad,id_region,orden,'" . $_SESSION['usuario'] . "' ";
					$sql.= "FROM docentes_llamados ";
					$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
					$id_docente_llamado_new = query($sql);
					
					$sql= "INSERT INTO docentes_llamados_observaciones ";
					$sql.= "(id_docente_llamado,id_observacion,comentarios) ";
					$sql.="SELECT $id_docente_llamado_new,id_observacion,comentarios ";
					$sql.= "FROM docentes_llamados_observaciones ";
					$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
					query($sql);
					
					$sql= "INSERT INTO docentes_llamados_escuelas ";
					$sql.= "(id_docente_llamado,id_escuela) ";
					$sql.="SELECT $id_docente_llamado_new,id_escuela ";
					$sql.= "FROM docentes_llamados_escuelas ";
					$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
					query($sql);
					
					$sql= "INSERT INTO docentes_llamados_cargos ";
					$sql.= "(id_docente_llamado,id_cargo) ";
					$sql.="SELECT $id_docente_llamado_new,id_cargo ";
					$sql.= "FROM docentes_llamados_cargos ";
					$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
					query($sql);
					
					$sql="SELECT * ";
					$sql.= "FROM docentes_llamados_titulos ";
					$sql.= "WHERE id_docente_llamado=$id_docente_llamado ";
					
					$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
					if (!((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))){
						while($row = mysqli_fetch_array($result)){
							$sql= "INSERT INTO docentes_llamados_titulos ";
							$sql.= "SET id_docente_llamado=$id_docente_llamado_new, ";
							$sql.="id_titulo='".$row['id_titulo']."', ";
							$sql.="id_observ_titulo='".$row['id_observ_titulo']."', ";
							$sql.="comentario='".$row['comentario']."'";
							$id_docente_llamado_titulo_new = query($sql);
							
							$sql= "INSERT INTO docentes_llamados_titulos_antecedentes ";
							$sql.= "(id_docente_llamado_titulo,id_antecedente,unidades,acum_historico) ";
							$sql.="SELECT $id_docente_llamado_titulo_new,id_antecedente,unidades,acum_historico ";
							$sql.= "FROM docentes_llamados_titulos_antecedentes ";
							$sql.= "WHERE id_docente_llamado_titulo=".$row['id_docente_llamado_titulo']." ";
							query($sql);
						}
					}else{
						throw new Exception(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
					}
					
					$xml->addChild("ok", 1);
					echo $xml->asXML();	
					} catch (Exception $e) {
					    $xml->addChild("error", $e->getMessage());
						echo $xml->asXML();
					}
				   	break;	
			} else {
				$error = "La Importación de la inscripción ya ha sido efectuada";
				$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
				$xml .= "<xml>";
				$xml .= "<error>$error</error>";			
				$xml.= "</xml>";
				header('Content-Type: text/xml');
				print $xml;		
				break;
			}	
		} else {
			$error = "La Importación de la inscripción no puede realizarse ya que el llamado extraordinario se encuentra cerrado";
			$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
			$xml .= "<xml>";
			$xml .= "<error>$error</error>";			
			$xml.= "</xml>";
			header('Content-Type: text/xml');
			print $xml;		
			break;
		}								      
	}
}
?>