<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

$id_llamado = $_REQUEST['id_llamado'];

$sql = "SELECT DISTINCT id_docente_llamado
			FROM docentes_llamados
			JOIN docentes_llamados_cargos
			USING ( id_docente_llamado )
			JOIN cargos
			USING ( id_cargo )
			WHERE id_llamado = '$id_llamado'
			AND jornada_completa = '1'";

$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);

while ($row = mysqli_fetch_array($result)) {
	$sql2="UPDATE docentes_llamados SET tipo_jornada = 'CC' WHERE id_docente_llamado='".$row['id_docente_llamado']."'";
	
	$result2=mysqli_query($GLOBALS["___mysqli_ston"], $sql2);	
}
?>
