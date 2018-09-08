<?php 
header('Expires: Wed, 23 Dec 1980 00:30:00 GMT');
header('Last-Modified: ' . gmdate('D, d M Y H:i:s') . ' GMT');
header('Cache-Control: no-cache, must-revalidate');
header('Pragma: no-cache');


 global $_sessionid;
 
 global $SYSusuario;
 global $SYSusuario_nombre;
 global $SYSusuario_estado;
 global $SYSusuario_organismo_id;
 global $SYSusuario_nivel_id;
 global $SYSusuario_organismo;
 global $SYSusuario_organismo_area_id;
 global $SYSusuario_organismo_area;
 global $SYSusuario_organismo_area_mesa_entrada;
 global $SYSsistemas_perfiles_usuario;
 
 global $link_salud1;
 
 // USO DE SESION
 session_start();
 
//$_sessionid=$HTTP_SESSION_VARS['_sessionid']; 
$_sessionid = $_SESSION['SYSsesion_id'];
$SYSusuario = $_SESSION['usuario'];
 
 include($SYSpathraiz.'config.php');

function mysqli_result($res, $row, $field=0) { 
    $res->data_seek($row); 
    $datarow = $res->fetch_array(); 
    return $datarow[$field]; 
}
  
 $_acceso='NO';
 
 if (empty($_sessionid))
  {
   $_acceso='NO';
   $_mensaje='NO EXISTE SESION (si el mensaje persiste, comuníquelo al administrador de sistemas) !';
   $_login ='SI';
  }

 else

  { 
   $result=mysqli_query($GLOBALS["___mysqli_ston"], "SELECT * FROM _sesiones WHERE _sessionid='$_sessionid'");
   $num=mysqli_num_rows($result);
   $_acceso='SI';
   $_login='NO';
   if ($num<=0)
     {
      $_acceso='NO';
      $_mensaje='NO SE ENCONTRO SESION: '.$_sessionid.' (es probable que UD. no haya ingresado sus datos de acceso aún) !';
      $_login ='SI';
     }
   else
     {
      $SYSusuario            = mysqli_result($result,0,'SYSusuario');
	  $SYSsesiondetalle      = mysqli_result($result,0,'SYSsesiondetalle');
	  $SYSsesionfecha_cierre = mysqli_result($result,0,'SYSsesionfecha_cierre');
	  $SYSsesionhora_cierre  = mysqli_result($result,0,'SYSsesionhora_cierre');
	  $SYSsesionfecha_ultimo = mysqli_result($result,0,'SYSsesionfecha_ultimo');
	  $SYSsesionhora_ultimo  = mysqli_result($result,0,'SYSsesionhora_ultimo');
	  
	  

	  if (empty($SYSusuario))
	   {
		$_acceso='NO';
		$_mensaje='NO SE ENCONTRO EL USUARIO VINCULADO A LA SESION: '.$_sessionid.' !';
       } 
	  else
	   {
         // Verifico si el usuario está activo es decir que "SYSusuario_estado = 1" 
         $result=mysqli_query($GLOBALS["___mysqli_ston"], "SELECT * FROM _usuarios 
		                       LEFT JOIN _organismos_areas_usuarios
							          ON _organismos_areas_usuarios.SYSusuario = _usuarios.SYSusuario
		                       LEFT JOIN _organismos_areas
							          ON _organismos_areas.organismo_area_id = _organismos_areas_usuarios.organismo_area_id
		                       LEFT JOIN _organismos
							          ON _organismos.organismo_id = _organismos_areas.organismo_id
		                        WHERE _usuarios.SYSusuario= BINARY '$SYSusuario'");
		 
		 
         $num=mysqli_num_rows($result);
         if ($num==1)
          {
		   $SYSusuario_nombre            = mysqli_result($result,0,'SYSusuarionombre');
		   $SYSusuario_estado            = mysqli_result($result,0,'SYSusuario_estado');
		   $SYSusuario_organismo_id      = mysqli_result($result,0,'organismo_id');
		   $SYSusuario_nivel_id      = mysqli_result($result,0,'organismo_area_id_nivel');
		   $SYSusuario_organismo         = mysqli_result($result,0,'organismo');
		   $SYSusuario_organismo_area_id = mysqli_result($result,0,'organismo_area_id');
		   $SYSusuario_organismo_area    = mysqli_result($result,0,'organismo_area');
		   //$SYSusuario_organismo_area_mesa_entrada = mysqli_result($result,0,'organismo_area_mesa_entrada');
		   //$SYSusuario_ = mysqli_result($result,0,);
		   $SYSsistemas_perfiles_usuario[0]='';
		   
		   		   
		   if ($SYSusuario_estado==1)
		      {
               $_acceso='SI';
               $_login ='NO';
			   
               // Verifico si el usuario está autorizado a utilizar el sistema.
			   if (empty($SYSsistema_id))
			     {
                  $_acceso='NO';
                  $_login ='NO';
				  $_mensaje='ERROR DE SISTEMA: SYSsistema_id vacío !';
   				 }
				else
				 {
				  // Veo en tabla _sistemas_ususarios si está autorizado el usuario
                  $result=mysqli_query($GLOBALS["___mysqli_ston"], "SELECT SYSusuario, sistema_id FROM _sistemas_usuarios 
				                        WHERE SYSusuario='$SYSusuario' 
										  AND sistema_id='$SYSsistema_id'
								      ");
                  $num=mysqli_num_rows($result);
                  if ($num==1)
                    {
                     $_acceso='SI';
                     $_login ='NO';
					 
					 
					 
					 // Agregado el 2/1/2007
		             // Obtengo un arreglo $SYSsistemas_perfiles_usuario con los perfiles del usuario
		             $result=mysqli_query($GLOBALS["___mysqli_ston"], "SELECT * FROM _sistemas_perfiles_usuarios 
				                                   WHERE SYSusuario= BINARY '$SYSusuario' 
								         ");
                      $num=mysqli_num_rows($result);
                      if ($num>0)
					   {
					    // Cargo en el arreglo SYSsistemas_perfiles_usuarios los perfiles del usuario SYSusuario
						// para ver si un perfil está en el arreglo, usar la func. in_array($perfil_id,$SYSsistemas_perfiles_usuario)
						// devolverá true si está o false.
						$SYSsistemas_perfiles_usuario='';
						$indice=0;
						if ($row=mysqli_fetch_array($result) )
                         {
						  do
						   {
						    $indice++;
							$SYSsistemas_perfiles_usuario[$indice]=$row["perfil_id"];
						   }
						  while($row=mysqli_fetch_array($result)); 
						  /*
   						  print "<br>Arreglo con perfiles: <br>";
						  $i=0;
						  foreach($SYSsistemas_perfiles_usuario AS $elemento)
						   {
						    $i++;
						    print "<b>$i)</b>$elemento ";
						   }
						  print "<br>";
						  */
						 }
					   }
		             // ------------------------------------
					 
					 
					 

			         // Verifica si la sesión no está cerrada  
			         if(empty($SYSsesionfecha_cierre) OR $SYSsesionfecha_cierre=='0000-00-00')
		               {
		                $_acceso='SI';
		               }
		              else
		               {
		                $_acceso='NO';
			            $_mensaje.='La sesión ya se encuentra cerrada !';
			            $_login='SI';
		               } 
                     // FIN: Verifica si la sesión no está cerrada
					 
				    }
				   else
				    {
		              $_acceso='NO';
			          $_mensaje.='El usuario '.$SYSusuario.' NO ESTA AUTORIZADO a utilizar el sistema '.$SYSsistema_id.' !';
			          $_login='SI';
				    }
				  // FIN: Veo en tabla _sistemas_ususarios si está autorizado el usuario
				 }
			    // FIN: Verifico si el usuario está autorizado a utilizar el sistema.			   
			    
			   
			   
			  }
			 else
			  {
               $_acceso='NO';
               $_mensaje='El usuario '.$SYSusuario.' no está AUTORIZADO PARA EL USO DE NINGUN SISTEMA !';
               $_login ='NO';
			  }
	
          }
		 else
		  {
           $_acceso='NO';
           $_mensaje='El usuario '.$SYSusuario.' NO EXISTE !';
           $_login ='NO';
		  }
		     
			
         // FIN: Verifico si el usuario está activo es decir que "SYSusuario_estado = 1" 
		 			
	   } 
     }
  }	 


  if ($_acceso=='SI')
    {
	 $_fechaactual = date("d/m/Y");
	 $_horaactual  = date("H:i:s");
     $SYSsesiondetalle.=$SYSpatharchivo.'<br>';
	 mysqli_query($GLOBALS["___mysqli_ston"], "UPDATE _sesiones SET 
	        SYSsesiondetalle='$SYSsesiondetalle',
			SYSsesionfecha_ultimo='$_fechaactual',
			SYSsesionhora_ultimo='$_horaactual'
           WHERE _sessionid='$_sessionid'"); 
	}
   
 // FIN: USO DE SESION

//print $_mensaje;
//print $_acceso;
?>
