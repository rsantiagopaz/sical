<?php
define("NIVEL_INICIAL","1");
define("NIVEL_PRIMARIO","2");
define("NIVEL_SECUNDARIO","3");
define("NIVEL_SUPERIOR","4");
define("NIVEL_MODALIDADES","5");

function determinar_tabla_tomo($opcion,$SYSusuario_nivel_id)
{	
	switch ($opcion) {
		case 'V':
		{
			$tabla = "tomo_cargos";
			break;
		}
		case 'A':
		{
			switch ($SYSusuario_nivel_id) {
				case NIVEL_INICIAL: {
					$tabla = "tomo_cargos_inicial";
					break;
				}
				case NIVEL_PRIMARIO: {
					$tabla = "tomo_cargos_primario";
					break;
				}
				case NIVEL_SECUNDARIO: {
					$tabla = "tomo_cargos_secundario";
					break;
				}
				case NIVEL_SUPERIOR: {
					$tabla = "tomo_cargos_superior";
					break;
				}
				case NIVEL_MODALIDADES: {
					$tabla = "tomo_cargos_primario";
					break;
				}
			}
			break;
		}
	}	
	return $tabla;
}
?>
