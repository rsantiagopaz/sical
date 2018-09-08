<?php
//-------------- BUSCO LA RAIZ PARA ACCEDER A config.php ------------------
$SYSpathraiz='';
 while (!file_exists($SYSpathraiz.'_raiz.php'))	
  {
   $SYSpathraiz='../'.$SYSpathraiz;
  }
// ------------ FIN: BUSCO LA RAIZ PARA ACCEDER A config.php  -------------

 header('Cache-Control: no-cache, must-revalidate');
 session_start();
 
 //sleep(3);

// Conexión a la BD ----------------------------------------------------- 
include($SYSpathraiz."config.php");

// Auditoría ------------------------------------------------------------
include($SYSpathraiz.'_scripts/_auditoria.php');

 // Parámetros de entrada ---------------------------
 $rutina        = $_REQUEST['rutina'];
 if(isset($_REQUEST['usuario']))
 	$SYSusuario    = $_REQUEST['usuario'];
 if(isset($_REQUEST['password']))
 	$SYSpassword   = $_REQUEST['password'];
 if(isset($_REQUEST['sistema_id'])) 
 	$SYSsistema_id = $_REQUEST['sistema_id']; 
 // FIN: Parámetros de entrada ----------------------

function mysqli_result($res, $row, $field=0) { 
    $res->data_seek($row); 
    $datarow = $res->fetch_array(); 
    return $datarow[$field]; 
}

 switch($rutina)
 {
  //************************************************************************************************
  case 'login':
  //************************************************************************************************
   {
    session_destroy();
	session_start();
	// Si ya había un usuario logueado, lo borra
	$_SESSION['usuario']   = '';
	$_SESSION['sesion_id'] = '';


	$_mensaje='';
	
	if (empty($SYSusuario))
	 $_mensaje.='No ingresó su nombre de usuario. ';
	
	if (empty($SYSpassword))
	 $_mensaje.='No ingresó su contraseña. ';

	if (empty($SYSsistema_id))
	 $_mensaje.='No está indicado a que sistema desea conectarse. ';
	 
	
	// Verifico si el suario es válido
	if (!empty($SYSusuario) AND !empty($SYSpassword))
	 {
	  $result = mysqli_query($GLOBALS["___mysqli_ston"], "SELECT * FROM _usuarios WHERE SYSusuario = BINARY '$SYSusuario' AND SYSpassword = MD5('$SYSpassword')");
	  // ---------------
	  $fila=mysqli_fetch_array($result);
	  $num=mysqli_num_rows($result);
	  if ($num==1)
		{
         // Verifico si el usuario está activo es decir que "SYSusuario_estado = 1" 
         $result=@mysqli_query($GLOBALS["___mysqli_ston"], "SELECT * FROM _usuarios 
		                        LEFT JOIN _organismos_areas_usuarios
							          ON _organismos_areas_usuarios.SYSusuario = _usuarios.SYSusuario
		                        LEFT JOIN _organismos_areas
							          ON _organismos_areas.organismo_area_id = _organismos_areas_usuarios.organismo_area_id
		                        LEFT JOIN _organismos
							          ON _organismos.organismo_id = _organismos_areas.organismo_id
		                        WHERE _usuarios.SYSusuario= BINARY '$SYSusuario'");
		 
		 
         $num=@mysqli_num_rows($result);
         if ($num==1)
          {
		   $_SESSION['usuario']                             = mysqli_result($result,0,'SYSusuario');
   		   /*$_SESSION['usuario_id']                             = mysqli_result($result,0,'id_usuario');*/
		   $_SESSION['usuario_nombre']                         = mysqli_result($result,0,'SYSusuarionombre');
		   $_SESSION['usuario_estado']                         = mysqli_result($result,0,'SYSusuario_estado');
		   $SYSusuario_estado = $_SESSION['usuario_estado'];
		   $_SESSION['usuario_organismo_id']                = mysqli_result($result,0,'organismo_id');
		   $_SESSION['usuario_nivel_id']                = mysqli_result($result,0,'organismo_area_id_nivel');
		   $_SESSION['usuario_organismo']                   = mysqli_result($result,0,'organismo');
		   $_SESSION['usuario_organismo_area_id']           = mysqli_result($result,0,'organismo_area_id');
		   $_SESSION['usuario_organismo_area']              = mysqli_result($result,0,'organismo_area');
		   //$_SESSION['usuario_organismo_area_mesa_entrada'] = mysqli_result($result,0,'organismo_area_mesa_entrada');
		   
		   //$SYSusuario_ = mysqli_result($result,0,);
		   $SYSsistemas_perfiles_usuario[0]='';
		   		   
		   if ($SYSusuario_estado==1)
		      {
               // Verifico si el usuario está autorizado a utilizar el sistema.
			   // Veo en tabla _sistemas_ususarios si está autorizado el usuario
			   $query = "SELECT SYSusuario, sistema_id FROM _sistemas_usuarios 
				                        WHERE SYSusuario= BINARY '$SYSusuario' 
										  AND sistema_id='$SYSsistema_id'
								      ";
			   //print $query;					  
               $result=@mysqli_query($GLOBALS["___mysqli_ston"], $query);
               $num=@mysqli_num_rows($result);
               if ($num==1)
                    {
					 // Agregado el 2/1/2007
		             // Obtengo un arreglo $SYSsistemas_perfiles_usuario con los perfiles del usuario
		             $result=@mysqli_query($GLOBALS["___mysqli_ston"], "SELECT * FROM _sistemas_perfiles_usuarios 
				                                   WHERE SYSusuario= BINARY '$SYSusuario' 
								         ");
                      $num=@mysqli_num_rows($result);
                      if ($num>0)
					   {
					    // Cargo en el arreglo SYSsistemas_perfiles_usuarios los perfiles del usuario SYSusuario
						// para ver si un perfil está en el arreglo, usar la func. in_array($perfil_id,$SYSsistemas_perfiles_usuario)
						// devolverá true si está o false.
						$SYSsistemas_perfiles_usuario = array();
						$indice=0;
						if ($row=@mysqli_fetch_array($result) )
                         {
						  do
						   {
						    $indice++;
							$SYSsistemas_perfiles_usuario[$indice]=$row["perfil_id"];
						   }
						  while($row=@mysqli_fetch_array($result)); 
					      $_SESSION['sistemas_perfiles_usuario'] = $SYSsistemas_perfiles_usuario;
						 }
					   }
		             // ------------------------------------

					 // Como todo está bien, guardo la sesión en la BD
					 $_sessionid = date('YmdHis')."-".session_id();	
					 // Grabo en las variables de sesión:
					 $_SESSION['SYSsesion_id'] = $_sessionid;
					 $_SESSION['SYSusuario']   = $SYSusuario;
					 // --
					 $SYSsesionfecha = date('Y-m-d');
					 $SYSsesionhora  = date('H:i:s');
					 // Ingreso en tabla _sesiones los campos _sessionid y SYSusuario
					 $ip = $_SERVER["REMOTE_ADDR"];
					 mysqli_query($GLOBALS["___mysqli_ston"], "INSERT INTO _sesiones 
						   (
							 _sessionid,
							 SYSusuario,
							 SYSsesionfecha,
							 SYSsesionhora,
							 SYSsesiondetalle,
							 ip
							 )  
						   VALUES 
							(
							 '$_sessionid',	  
							 '$SYSusuario',
							 '$SYSsesionfecha',
							 '$SYSsesionhora',
							 '',
							 '$ip'
							)");
						 // Verifico si se grabaron los datos
					 $result=mysqli_query($GLOBALS["___mysqli_ston"], "SELECT * FROM _sesiones WHERE _sessionid='$_sessionid' AND SYSusuario='$SYSusuario'");
					 $num=mysqli_num_rows($result);
					 if ($num<=0)
						  $_mensaje.='No se pudo grabar la sesión y el usuario en tabla _sesiones. Contáctese con el administrador del sistema. ';
				
					 // ------------------------------------ 
				    }
				   else
				    {
			          $_mensaje.='¡El usuario '.$SYSusuario.' NO ESTA AUTORIZADO a utilizar el sistema '.$SYSsistema_id.'! ';
				    }
				  // FIN: Veo en tabla _sistemas_ususarios si está autorizado el usuario
				 }
			    // FIN: Verifico si el usuario está autorizado a utilizar el sistema.			   
			   else
			    {
                 $_mensaje='¡El usuario '.$SYSusuario.' no está AUTORIZADO PARA EL USO DE NINGUN SISTEMA! ';
			    }
          }
		 else
		  {
           $_mensaje='¡El usuario '.$SYSusuario.' NO EXISTE! ';
		  }
		     
			
         // FIN: Verifico si el usuario está activo es decir que "SYSusuario_estado = 1" 
		 			
	   
		}  
	   else
		{
		 $_mensaje.="¡ Sus datos de acceso NO SON VALIDOS !\n\n";
		 $_mensaje.="Verifique haber ingresado bien su nombre de usuario y contraseña, respetando mayúsculas y minúsculas.\n";
		 $_mensaje.="Por ejemplo, si su nombre de usuario es juanperez, no intente escribir JuanPerez ni JUANPEREZ, u otra forma. Idem para la contraseña.";
		}
		  
	 }
	
	 // Armo el XML ---------------------------------------
	 $xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	 $xml.= "<xml>";
	 if (!empty($_mensaje))
	   {     
	    $xml.="<error>$_mensaje</error>";
	   }
	  else
	   {
	    $xml.="<ok>";
		$xml.="¡¡Bienvenido ".$_SESSION['usuario_nombre']." (".$SYSusuario.")!!\n\n";
		$xml.="Puede comenzar a trabajar. Recuerde CERRAR SESION cuando termine o si desea cambiar de usuario.\n\n";
		$xml.="¡NUNCA DEJE EL NAVEGADOR ABIERTO Y SE RETIRE!";
		$xml.="</ok>";
		// Aquí mando todos los valores necesarios para algunas propiedades de la clase ControlAcceso
		$xml.="<ControlAcceso>";
		
		$xml.=  "<_sistema_id>";
		$xml.=    $SYSsistema_id;
		$xml.=  "</_sistema_id>";

		$xml.=  "<_usuario>";
		$xml.=    utf8_encode($_SESSION['usuario']);
		$xml.=  "</_usuario>";
		
		//$xml.=  "<_usuario_id>";
		//$xml.=    utf8_encode($_SESSION['usuario_id']);
		//$xml.=  "</_usuario_id>";
		
		$xml.=  "<_usuario_nombre>";
		$xml.=    utf8_encode($_SESSION['usuario_nombre']);
		$xml.=  "</_usuario_nombre>";
		
		$xml.=  "<_usuario_estado>";
		$xml.=    $_SESSION['usuario_estado'];
		$xml.=  "</_usuario_estado>";
		
		$xml.=  "<_sesion_id>";
		$xml.=    $_SESSION['SYSsesion_id'];
		$xml.=  "</_sesion_id>";
		
		$xml.=  "<_autorizado>";
		$xml.=   "true";
		$xml.=  "</_autorizado>";
		
		$xml.=  "<_usuario_organismo_id>";
		$xml.=    $_SESSION['usuario_organismo_id'];
		$xml.=  "</_usuario_organismo_id>";

		$xml.=  "<_usuario_nivel_id>";
		$xml.=    $_SESSION['usuario_nivel_id'];
		$xml.=  "</_usuario_nivel_id>";

		$xml.=  "<_usuario_organismo>";
		$xml.=   utf8_encode($_SESSION['usuario_organismo']);
		$xml.=  "</_usuario_organismo>";
		
		$xml.=  "<_usuario_organismo_area_id>";
		$xml.=   $_SESSION['usuario_organismo_area_id'];
		$xml.=  "</_usuario_organismo_area_id>";
		
		$xml.=  "<_usuario_organismo_area>";
		$xml.=    utf8_encode($_SESSION['usuario_organismo_area']);
		$xml.=  "</_usuario_organismo_area>";
		
		$xml.=  "<_usuario_sistemas_perfiles>";
		if(isset($_SESSION['sistemas_perfiles_usuario']) and !empty($_SESSION['sistemas_perfiles_usuario'])) 
		 {
		           $vectorPerfiles = $_SESSION['sistemas_perfiles_usuario'];
		           foreach($vectorPerfiles as $perfil_id)
				    {
					 $xml.= "<perfil_id>";
					 $xml.=   $perfil_id;
					 $xml.= "</perfil_id>";
					}
		 }			
		
		$xml.=  "</_usuario_sistemas_perfiles>";
		
		$xml.=  "<_usuario_organismo_area_mesa_entradas>";
		           if (empty($_SESSION['usuario_organismo_area_mesa_entrada']) )
				      $xml.= "0";
					 else 
					  $xml.= $_SESSION['usuario_organismo_area_mesa_entrada'];
		$xml.=  "</_usuario_organismo_area_mesa_entradas>";
		
	    $xml.="</ControlAcceso>";
		
		
	   }
     $xml.= "</xml>";
	 header('Content-Type: text/xml');
     print $xml;
	 // FIN: Armo el XML -----------------------------------
	 
    break;
   }
   
  //************************************************************************************************ 
  case 'logout':
  //************************************************************************************************
   {
    $ok='';
	$error='';
    if(isset($_SESSION['SYSsesion_id']) and !empty($_SESSION['SYSsesion_id']))
	  {

		$_sessionid = $_SESSION['SYSsesion_id'];
		$_fechaactual = date('Y-m-d');
		$_horaactual  = date('H:i:s');
		mysqli_query($GLOBALS["___mysqli_ston"], "UPDATE _sesiones SET 
				  SYSsesionfecha_cierre = '$_fechaactual' ,
				  SYSsesionhora_cierre  = '$_horaactual'
				  WHERE _sessionid='$_sessionid'"); 
		$_SESSION['SYSusuario']   = '';
		$_SESSION['SYSsesion_id'] = '';
		session_destroy();
		session_start();
		
	    $ok.="¡¡Sesión CERRADA EXITOSAMENTE!!\n\n";
		$ok.="Cierre todas las ventanas de su navegador."."\n";
		$ok.="($_sessionid)";
	  }
	 else
	  {
       $error.="¡¡No existe iniciada la sesión o la misma ya fue cerrada!!";	   
	  } 
    
	// Devuelvo el xml
	$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	$xml.= "<xml>";
	if(!empty($error))
	 {
	  $xml.="<error>$error</error>";
	 }

  	if(!empty($ok))
	 {
	  $xml.="<ok>".$ok."</ok>";
	 }
	$xml.="</xml>";  	  
	header('Content-Type: text/xml');
    print $xml;
    break;	  
   }



  //************************************************************************************************ 
  case 'ver_variables_sesion':
  //************************************************************************************************
   {
    print '$_SESSION[SYSsesion_id] = '.$_SESSION['SYSsesion_id'].'<br>';
	print '$_SESSION[SYSusuario] = '.$_SESSION['SYSusuario'].'<br>';
	print '$_SESSION[usuario_nombre] = '.$_SESSION['usuario_nombre'].'<br>';
	print '$_SESSION[usuario_estado] = '.$_SESSION['usuario_estado'].'<br>';
	print '$_SESSION[usuario_organismo_id] = '.$_SESSION['usuario_organismo_id'].'<br>';
	print '$_SESSION[usuario_organismo] = '.$_SESSION['usuario_organismo'].'<br>';
	print '$_SESSION[usuario_organismo_area_id] = '.$_SESSION['usuario_organismo_area_id'].'<br>';
	print '$_SESSION[usuario_organismo_area] = '.$_SESSION['usuario_organismo_area'].'<br>';
	print '$_SESSION[usuario_organismo_area_mesa_entrada] = '.$_SESSION['usuario_organismo_area_mesa_entrada'].'<br>';
	
	print '$_SESSION[sistemas_perfiles_usuario] = ';
	if(isset($_SESSION['sistemas_perfiles_usuario']))
	 {
	  foreach($_SESSION['sistemas_perfiles_usuario'] as $perfil_id)
	   {
	    print $perfil_id." | ";
	   }
	 } 
	
/*
	print '$_SESSION[]= '.$_SESSION[''].'<br>';
	print '$_SESSION[]= '.$_SESSION[''].'<br>';
	print '$_SESSION[]= '.$_SESSION[''].'<br>';
	print '$_SESSION[]= '.$_SESSION[''].'<br>';
	print '$_SESSION[]= '.$_SESSION[''].'<br>';
	print '$_SESSION[]= '.$_SESSION[''].'<br>';
*/	

    break;	
   }


  //************************************************************************************************ 
  case 'matar_sesion':
  //************************************************************************************************
   {
    session_destroy();
	session_start();
   }



  //************************************************************************************************ 
  case 'cambiar_password':
  //************************************************************************************************
   {
    // Parámetros de entrada:
	
	// --------------------------------------------
	$SYSusuario         = $_REQUEST["usuario"];
	$SYSpassword        = $_REQUEST["passwordActual"];
	$SYSpassword_nuevo1 = $_REQUEST["passwordNueva"];
	$SYSpassword_nuevo2 = $_REQUEST["passwordNuevaConfirmada"];	
	
//	$SYSpathraiz        = $_REQUEST["SYSpathraiz"];
//	$SYSpatharchivo     = $_REQUEST["SYSpatharchivo"];
	// --------------------------------------------
	
	//include('../config.php');
	
	
	$mensaje='';
	
	if (empty($SYSusuario))
	 $mensaje.="No ingresó su nombre de usuario.\n";
	
	if (empty($SYSpassword))
	 $mensaje.="No ingresó su password.\n";
	
	// Verifico si el suario es válido
	if (!empty($SYSusuario) AND !empty($SYSpassword))
	 {
	  // Modificado el 3/5/2007 para uso de MD5
	  $result=mysqli_query($GLOBALS["___mysqli_ston"], "SELECT * FROM _usuarios WHERE SYSusuario = BINARY '$SYSusuario' AND SYSpassword = MD5('$SYSpassword')");
	  $num=mysqli_num_rows($result);
	  if ($num==1)
		   {
			if ($SYSpassword_nuevo1==$SYSpassword_nuevo2)
			  {
				if (strlen($SYSpassword_nuevo1)>20 OR strlen($SYSpassword_nuevo1)<5)
				  {
				   $mensaje.="La contraseña nueva no debe exceder los 20 caracteres ni debe ser menor que 5 caracteres.\n";  
				  }
				 else
				  {
				   $CaracteresNoValidos="&/*!¡¿?+[]()%·$\=@'".'"';
				   // VERIFICO CARACTERES NO VALIDOS EN LA CONTRASEÑA
				   for ($i = 0; $i < (strlen($CaracteresNoValidos)); $i++)
					{
					 // Busco en el campo a validar si existe un caracter no válido
					 if(strstr($SYSpassword_nuevo1,$CaracteresNoValidos[$i]))
						 $mensaje.="No se permitre el caracter \" ".$CaracteresNoValidos[$i]." \" en la contraseña.\n";
					 }
				  // Fin VERIFICO CARACTERES NO VALIDOS 
	   
	
				  }
			  }
			 else
			  {
			   $mensaje.="No hay coincidencia en la confirmación de la contraseña nueva.\n";
			  }  	
		   }
		 else
		   {
			 $mensaje.="Sus datos de acceso no son válidos. Verifique haber ingresado bien su nombre de usuario y contraseña.\n";
		   }
	 }
	
	
	 if (!empty($mensaje))
	  {
	   $error = $mensaje;
      }
	 else
	  {
	/* Antes del 3/5/2007
		mysql_query ("UPDATE _usuarios SET 
				SYSpassword='$SYSpassword_nuevo1'
			   WHERE SYSusuario='$SYSusuario'"); 
	*/
	 // Desde el 3/5/2007
		mysqli_query($GLOBALS["___mysqli_ston"], "UPDATE _usuarios SET 
				SYSpassword=MD5('$SYSpassword_nuevo1') 
			   WHERE SYSusuario= BINARY '$SYSusuario'");
	 // Desde el 29/06/2011
	 if(isset($_SESSION['SYSsesion_id']) and !empty($_SESSION['SYSsesion_id'])) {
	 	$_sessionid = $_SESSION['SYSsesion_id'];
	 }
	 $_descrip = "CAMBIO DE CONTRASEÑA DEL USUARIO '$SYSusuario'";
	_auditoria('UPDATE _usuarios', 
            '',
			'',
			'_usuarios',
			$_sessionid,
            $_descrip,
            '',
            '');
	 // ---------------------------------------------		   
	   if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0)	
		 {
		  $error = "Error en BD: ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false)).": ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false));	 
		 } 
		else     
		 {
		  $ok = "¡ CAMBIO DE CONTRASEÑA EXITOSO !";
		 } 
	  }
	
	
    // Devuelvo el xml
	$xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	$xml.= "<xml>";
	if(!empty($error))
	 {
	  $xml.="<error>$error</error>";
	 }

  	if(!empty($ok))
	 {
	  $xml.="<ok>".$ok."</ok>";
	 }
	$xml.="</xml>";  	  
	header('Content-Type: text/xml');
    print $xml;
	break;
   }



 }

?>