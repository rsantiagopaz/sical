<?php
/*
 * Created on 21/01/2010
 *
 */
include("../control_acceso_flex.php");

error_reporting(E_ALL);

function genero_xml_ok_errores($_ok,$_errores,$otroNodoXml)
//       _______________________________________________
{
	$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	$xml.= "<xml>";
	if(!empty($_ok)) {
		$xml.=  "<ok>$_ok</ok>";
	}
	if(!empty($_errores))	{ 
		$xml.=  "<error>$_errores</error>";
	}	
	$xml.=$otroNodoXml;	
	$xml.= "</xml>";
	header('Content-Type: text/xml');
	print $xml;
}
$html='<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
body{font-size:13px;font-family:Arial, Helvetica, Serif;margin: 0 auto; width: 850px;}
h1,h2,h3{text-align:center;background-color:#999999;}
h1{font-size:20px;}
h2{font-size:18px;}
h3{font-size:15px;}
table{width:100%; border-collapse: collapse;}
th{font-weight: bold;text-align:center;background-color:#CCCCCC;}
.title{background-color:#CCCCCC;font-weight:bold;}
</style>
</head>
<body>';

$sql = "SELECT nro_llamado, dl.id_llamado 'id_llamado', id_tipo_clasificacion, dl.orden 'orden', dl.con_cargo 'con_cargo', descripcion, nivel ".
	   "FROM docentes_llamados dl ".
	   "JOIN llamados USING(id_llamado) ".
	   "JOIN niveles USING(id_nivel) ".
	   "WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
$row = mysqli_fetch_array($result);
$id_llamado = $row['id_llamado'];
$id_tipo_clasificacion = $row['id_tipo_clasificacion'];
$orden = $row['orden'];
$con_cargo = $row['con_cargo'];

$html.='<h1>Llamado</h1>';
$html.='<table>
			<tr>
				<td class="title">Nro:</td>
				<td>'.$row['nro_llamado'].'</td>
				<td class="title">Nombre:</td>
				<td>'.$row['descripcion'].'</td>
				<td class="title">Nivel:</td>
				<td>'.$row['nivel'].'</td>
			</tr>	
		</table>';

$html.='<h1>Antecedentes Declarados por el Docente</h1>';
$date = date("d/m/Y");
$html.='<h3>Fecha: '. $date .'</h3>';
$sql = "SELECT apellido, nombres, tipo_doc, nro_doc FROM docentes " .
		"JOIN tipos_documentos USING(id_tipo_doc) JOIN docentes_llamados USING(id_docente) " .
		"WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
		
$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
$row = mysqli_fetch_array($result);
$html.='<h2>Datos del Docente</h2>';
$html.='<table>
			<tr>
				<td class="title">Nombre:</td>
				<td>'.$row['apellido'] . ', ' . $row['nombres'].'</td>
				<td class="title">Tipo Doc:</td>
				<td>'.$row['tipo_doc'].'</td>
				<td class="title">Nro Doc:</td>
				<td>'.$row['nro_doc'].'</td>
			</tr>	
		</table>';
if ($_REQUEST['idNivel'] == '1' || $_REQUEST['idNivel'] == '2') {		
	$sql = "SELECT id_region FROM docentes_llamados WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
	
	$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	$row = mysqli_fetch_array($result);	
	
	$array_regiones = array('1','2','3','4','5','6','7','8');
	if (in_array($row['id_region'],$array_regiones)) {
		$html.='<h2>Región: '.$row['id_region'].'</h2>';		
	}
	if ($_REQUEST['idNivel'] == '2' && $id_tipo_clasificacion == '1') {
		if ($con_cargo == '1') {
			$situacion_revista = "Docente Con Cargo";
		} else {
			$situacion_revista = "Docente Sin Cargo";
		}		
		$html.='<h2>Situación de Revista: '.$situacion_revista.'</h2>';		
	}
}
if ($_REQUEST['idNivel'] == '5') {
	if ($id_tipo_clasificacion == '1') {
		if ($con_cargo == '1') {
			$situacion_revista = "Docente Con Cargo";
		} else {
			$situacion_revista = "Docente Sin Cargo";
		}		
		$html.='<h2>Situación de Revista: '.$situacion_revista.'</h2>';		
	}
} 
$sql = "SELECT * FROM docentes_llamados_titulos " .
		"JOIN titulos USING(id_titulo) " .
		"WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";

$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
$html.='<h2>Títulos y Antecdentes</h2>';	
while ($row = mysqli_fetch_array($result)) {
	$html.='<table>
				<tr>
					<td class="title" style="width:50px;">Título:</td>
					<td style="width:500px;">'.$row['denominacion'].'</td>
					<td class="title" style="width:50px;">Código:</td>
					<td>'.$row['codigo'].'</td>
				</tr>
			</table>';
	$html.='<table>							
				<tr>
					<td>Código</td>
					<td>Cantidad</td>
					<td>Puntaje</td>
					<td>Ac. Hist.</td>
				</tr>';
		
	$sql2 = "SELECT * FROM docentes_llamados_titulos_antecedentes " .
			"JOIN antecedentes USING(id_antecedente) " .
			"WHERE id_docente_llamado_titulo = '".$row['id_docente_llamado_titulo']."'";
			
	$result2 = mysqli_query($GLOBALS["___mysqli_ston"], $sql2);
	
	$array_c4 = array("C4A","C4B","C4C","C4D","C5");
										
	while ($row2 = mysqli_fetch_array($result2)) {
		if (in_array($row2['codigo'],$array_c4))
			$denominacion = ' ('.$row2['denominacion'].')';
		else
			$denominacion = '';
				
		$html.='<tr>
					<td>'.$row2['codigo'].$denominacion.'</td>
					<td>'.$row2['unidades'].'</td>
					<td>'.$row2['puntos'].'</td>
					<td>'.$row2['acum_historico'].'</td>
				</tr>';
	}	
	$html.='</table>';		
}

if ($_REQUEST['idNivel'] == '1' || $_REQUEST['idNivel'] == '2' || $_REQUEST['idNivel'] == '5') {
	$sql="SELECT * FROM docentes_llamados_cargos JOIN cargos USING(id_cargo) WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
	$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	$html.='<h2>Cargos</h2>';															
	if ($_REQUEST['idNivel'] == '1' || $_REQUEST['idNivel'] == '2') {
		while ($row = mysqli_fetch_array($result)) {
			$html.='<table>
						<tr>
							<td>'.$row['denominacion'] . " (CÓDIGO: ".$row['codigo'].")".'</td>
						</tr>
					</table>';							
		}
	} else {
		while ($row = mysqli_fetch_array($result)) {
			switch ($row['subtipo']) {
				case 'E': {
					$modalidad='ESPECIAL';
					break;
				}
				case 'A': {
					$modalidad='ADULTOS';
					break;
				}
				case 'C': {
					$modalidad='CAPACITACIÓN';
					break;
				}
			}
			$html.='<table>
						<tr>
							<td>'.$row['denominacion'] . " (CÓDIGO: ".$row['codigo'].", MODALIDAD: $modalidad)".'</td>
						</tr>
					</table>';			
		}	
	}		
} else {
	$sql="SELECT * FROM docentes_llamados_escuelas JOIN escuelas USING(id_escuela) WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
	$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	$html.='<h2>Establecimientos</h2>';																										
	while ($row = mysqli_fetch_array($result)) {
		$html.='<table>
					<tr>
						<td>'.$row['nombre'] . " (CÓDIGO: ".$row['codigo'].")".'</td>
					</tr>
				</table>';				
	}
}					
$html.='<h3>Operador: '.$_SESSION['usuario_nombre'].'</h3>';
$html.='</body></html>';
echo $html;
?>
