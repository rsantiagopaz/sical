<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

set_time_limit(240);

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
		
$sql="SELECT * ";
$sql.="FROM escuelas ";				
$sql.="WHERE nombre LIKE'%$nombre%' ";
$sql.="ORDER BY codigo";				
		
$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);

$width="700px";

$html.='<h1 style="width:'.$width.'">Escuelas</h1>';
$date = date("d/m/Y");

$html.='<table style="width:700px;">
			<thead>
			<tr>
				<th class="title" style="width:80px;">Código</th>
				<th class="title" style="width:300px;">Nombre</th>				
			</tr>
			</thead>';
$html.='<tbody>';
while ($row = mysqli_fetch_array($result)) {
	$html.='<tr>
				<td>'.$row['codigo'].'</td>
				<td>'.$row['nombre'].'</td>				
			</tr>';											
}
$html.='</tbody>';
$html.='</table>';
$html.='</body></html>';		
		
echo $html;
?>
