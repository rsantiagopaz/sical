<?php
include("../control_acceso_flex.php");
include("../rutinas.php");

$sql = "SELECT * FROM cargos";
$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);

while ($row = mysqli_fetch_array($result)) {
	$sql2 = "UPDATE tomo_cargos SET cod_nivel ='".$row['id_nivel']."' ";
	$sql2.= "WHERE id_cargo = '".$row['id_cargo']."' ";
	$sql2.= "AND cod_nivel IS NULL OR cod_nivel='0'";
	
	query($sql2);
	
	$sql3 = "UPDATE nov_tomo_cargos SET cod_nivel ='".$row['id_nivel']."' ";
	$sql3.= "WHERE id_cargo = '".$row['id_cargo']."' ";
	$sql3.= "AND cod_nivel IS NULL OR cod_nivel='0'";
	
	query($sql3);
	
	$sql2 = "UPDATE tomo_cargos_inicial SET cod_nivel ='".$row['id_nivel']."' ";
	$sql2.= "WHERE id_cargo = '".$row['id_cargo']."' ";
	$sql2.= "AND cod_nivel IS NULL OR cod_nivel='0'";
	
	query($sql2);
	
	$sql2 = "UPDATE tomo_cargos_primario SET cod_nivel ='".$row['id_nivel']."' ";
	$sql2.= "WHERE id_cargo = '".$row['id_cargo']."' ";
	$sql2.= "AND cod_nivel IS NULL OR cod_nivel='0'";
	
	query($sql2);
	
	$sql2 = "UPDATE tomo_cargos_secundario SET cod_nivel ='".$row['id_nivel']."' ";
	$sql2.= "WHERE id_cargo = '".$row['id_cargo']."' ";
	$sql2.= "AND cod_nivel IS NULL OR cod_nivel='0'";
	
	query($sql2);
	
	$sql2 = "UPDATE tomo_cargos_superior SET cod_nivel ='".$row['id_nivel']."' ";
	$sql2.= "WHERE id_cargo = '".$row['id_cargo']."' ";
	$sql2.= "AND cod_nivel IS NULL OR cod_nivel='0'";
	
	query($sql2);
}
?>
