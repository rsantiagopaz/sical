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
			$tabla = "tomo_espacios";
			break;
		}
		case 'A':
		{
			switch ($SYSusuario_nivel_id) {				
				case NIVEL_SECUNDARIO: {
					$tabla = "tomo_espacios_secundario";
					break;
				}
				case NIVEL_SUPERIOR: {
					$tabla = "tomo_espacios_superior";
					break;
				}				
			}
			break;
		}
	}	
	return $tabla;
}
?>
