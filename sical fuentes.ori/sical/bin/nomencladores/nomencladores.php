<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

ini_set('memory_limit', '512M');

set_time_limit(1200);

require_once("../dompdf/dompdf_config.inc.php");

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

switch ($_REQUEST['rutina'])
{
	case 'titulos':
	{				
		$sql="SELECT id_titulo, t.codigo, t.denominacion 'nombre', id_grado_titulo, id_institucion, norma_creacion, disciplina_unica, id_nivel_otorga, i.denominacion, descripcion 'nivel', anios_duracion, ";
	  	$sql.="carga_horaria, requisitos_ingreso, modalidad_cursado, especifico ";
		$sql.="FROM titulos t ";		
		$sql.="LEFT JOIN instituciones i USING(id_institucion) ";		
		$sql.="LEFT JOIN nivel_otorga USING(id_nivel_otorga) ";
		
		if ($orden == 'codigo')
			$sql.="ORDER BY codigo";
		else
			$sql.="ORDER BY nombre";				
				
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		$width="700px";
		
		$html.='<h1 style="width:'.$width.'">Títulos</h1>';
		$date = date("d/m/Y");
		$html.='<h3 style="width:'.$width.'">Fecha: '. $date .'</h3>';
		
		/*$html.='<table style="width:700px;">
					<thead>
					<tr>
						<th class="title" style="width:80px;">Código</th>
						<th class="title" style="width:300px;">Denominación</th>
						<th class="title" style="width:300px;">Institución</th>
					</tr>
					</thead>';*/
		$html.='<table style="width:700px;">
					<thead>
					<tr>
						<th class="title" style="width:80px;">Código</th>
						<th class="title" style="width:600px;">Denominación</th>						
					</tr>
					</thead>';
		$html.='<tbody>';
		while ($row = mysqli_fetch_array($result)) {
			/*$html.='<tr>
						<td>'.$row['codigo'].'</td>
						<td>'.$row['nombre'].'</td>
						<td>'.$row['denominacion'].'</td>												
					</tr>';*/
			$html.='<tr>
						<td>'.$row['codigo'].'</td>
						<td>'.$row['nombre'].'</td>																		
					</tr>';											
		}
		$html.='</tbody>';
		$html.='</table>';
		$html.='</body></html>';						
		
		echo $html;				
		exit;
	}
	case 'espacios':
	{			
		$sql="SELECT * ";
		$sql.="FROM espacios ";
		
		if ($orden == 'codigo')
			$sql.="ORDER BY codigo";
		else
			$sql.="ORDER BY denominacion";				
				
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);		
		
		$width="700px";
		
		$html.='<h1 style="width:'.$width.'">Espacios</h1>';
		$date = date("d/m/Y");
		$html.='<h3 style="width:'.$width.'">Fecha: '. $date .'</h3>';
				
		$html.='<table style="width:700px;">
					<thead>
					<tr>
						<th class="title" style="width:80px;">Código</th>
						<th class="title" style="width:300px;">Denominación</th>												
					</tr>
					</thead>';
		$html.='<tbody>';
		while ($row = mysqli_fetch_array($result)) {
			$html.='<tr>
						<td>'.$row['codigo'].'</td>
						<td>'.$row['denominacion'].'</td>												
					</tr>';											
		}
		$html.='</tbody>';
		$html.='</table>';
		$html.='</body></html>';												
				
		echo $html;				
		exit;
	}
	case 'cargos':
	{			
		$sql="SELECT id_cargo, codigo, denominacion, id_nivel, nivel, IF(jornada_completa='1','Si','No') 'jornada_completa', (CASE WHEN subtipo='C' THEN 'Capacitación' WHEN subtipo='E' THEN 'Especial' WHEN subtipo='A' THEN 'Adultos' END) 'subtipo' ";
		$sql.="FROM cargos ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";		
		
		if ($orden == 'codigo')
			$sql.="ORDER BY codigo";
		else
			$sql.="ORDER BY denominacion";				
				
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		$width="700px";
		
		$html.='<h1 style="width:'.$width.'">Cargos</h1>';
		$date = date("d/m/Y");
		$html.='<h3 style="width:'.$width.'">Fecha: '. $date .'</h3>';
		
		$html.='<table style="width:700px;">
					<thead>
					<tr>
						<th class="title" style="width:80px;">Código</th>
						<th class="title" style="width:300px;">Denominación</th>
						<th class="title" style="width:200px;">Nivel</th>						
					</tr>
					</thead>';
		$html.='<tbody>';
		while ($row = mysqli_fetch_array($result)) {
			$html.='<tr>
						<td>'.$row['codigo'].'</td>
						<td>'.$row['denominacion'].'</td>
						<td>'.$row['nivel'].'</td>						
					</tr>';											
		}
		$html.='</tbody>';
		$html.='</table>';
		$html.='</body></html>';						
				
		echo $html;
		exit;
	}
}
?>
