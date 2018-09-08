<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
include("../_phpincludes/_vertablatomoespacio.php");

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

$sql="SELECT id_titulo, t.codigo, t.denominacion 'nombre', id_grado_titulo, id_institucion, norma_creacion, disciplina_unica, id_nivel_otorga, i.denominacion, descripcion 'nivel', anios_duracion, ";
$sql.="carga_horaria, requisitos_ingreso, modalidad_cursado, especifico ";
$sql.="FROM titulos t ";		
$sql.="LEFT JOIN instituciones i USING(id_institucion) ";		
$sql.="LEFT JOIN nivel_otorga USING(id_nivel_otorga) ";
$sql.="WHERE id_titulo = '$id_titulo'";		
		
$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
$row = mysqli_fetch_array($result);

$width="768px";

$html.='<h1 style="width:'.$width.'">Espacios por Título</h1>';
$date = date("d/m/Y");
$html.='<h3 style="width:'.$width.'">Fecha: '. $date .'</h3>';
$html.='<h3 style="width:'.$width.'">TÍTULO: '.$row['nombre'].' CÓDIGO: '.$row['codigo'].'</h3>';
$html.='<h3 style="width:'.$width.'">Institución: '.$row['denominacion'].'</h3>';

if (isset($opcion)) {
	$tabla = determinar_tabla_tomo($opcion,$SYSusuario_nivel_id); 			
} else
	$tabla = "tomo_espacios";

$sql="SELECT id_tomo_espacio, id_carrera, cod_carrera, id_espacio, cod_espacio, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
$sql.="e.codigo, nombre, e.denominacion 'denomesp', t.denominacion 'denomclas', 'A' as origen ";
$sql.="FROM $tabla ";
$sql.="INNER JOIN espacios e USING(id_espacio) ";
$sql.="INNER JOIN carreras c USING(id_carrera) ";
$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
$sql.="WHERE id_titulo = '$id_titulo' ";

if ($_REQUEST['status'] == "sorted") {	
	$field = str_replace('@', '', $_REQUEST['field']);
	$order = $_REQUEST['order'];
	$sql.="ORDER BY $field $order";
}

$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);

$html.='<table style="width:768px;">
			<thead>
			<tr>
				<th class="title" style="width:100px;">Carrera</th>
				<th class="title" style="width:300px;">Espacio</th>
				<th class="title" style="width:200px;">Tipo Clasificación</th>
				<th class="title" style="width:100px;">Tipo Título</th>
			</tr>
			</thead>';
$html.='<tbody>';
while ($row = mysqli_fetch_array($result)) {
	$html.='<tr>
				<td>'.$row['nombre'].'</td>
				<td>'.$row['denomesp'].'</td>
				<td>'.$row['denomclas'].'</td>
				<td>'.$row['tipo'].'</td>
			</tr>';											
}
$html.='</tbody>';
$html.='</table>';
$html.='</body></html>';

echo $html;
?>
