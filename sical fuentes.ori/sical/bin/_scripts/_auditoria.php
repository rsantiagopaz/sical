<?php
// Creado: 4/9/2007 By Jorge Mitre

// Parámetros de entrada:
//    $_mysql_query
//    $_mysql_link
//    $_auditoria_php_file = __FILE__
//    $_auditoria_php_line = __LINE__

// Parámetros de salida:
//    $_mysql_result
//    $_mysql_errno
//    $_mysql_error 

function _auditoria($_mysql_query, 
                    $_mysql_link,
					$_link_auditoria,
					$_auditoria_mysql_table,
					$_id_registro,
					$_descrip,
					$_auditoria_php_file,
                    $_auditoria_php_line)
{
$_auditoria_query_user     = 'SELECT USER()     AS mysql_user';
$_auditoria_query_database = 'SELECT DATABASE() AS mysql_database';

if($_mysql_link) {	
	//$_mysql_result=@mysql_query($_mysql_query,$_mysql_link);
    //$_mysql_insert_id=mysql_insert_id();
} else {    
    //$_mysql_result=@mysql_query($_mysql_query);  
	//$_mysql_insert_id=mysql_insert_id();
}
  
if(mysql_errno()>0) {	
    $_mysql_errno = mysql_errno();
    $_mysql_error = mysql_error();
} else {    
    $_auditoria_query_user     = 'SELECT USER()     AS mysql_user';
    $_auditoria_query_database = 'SELECT DATABASE() AS mysql_database';
    if($_mysql_link) {		
     	$_auditoria_result_user     = @mysql_query($_auditoria_query_user    , $_mysql_link);
	 	$_auditoria_result_database = @mysql_query($_auditoria_query_database, $_mysql_link);
    } else {				
     			$_auditoria_result_user     = @mysql_query($_auditoria_query_user    );
	 			$_auditoria_result_database = @mysql_query($_auditoria_query_database);
    } 
    if( !(mysql_errno()>0) ) {		
	    $_auditoria_row=@mysql_fetch_array($_auditoria_result_user);
	    $_auditoria_mysql_user = $_auditoria_row["mysql_user"];

	    $_auditoria_row=@mysql_fetch_array($_auditoria_result_database);
	    $_auditoria_mysql_database = $_auditoria_row["mysql_database"];
	} else {
	  	$_auditoria_mysql_user     = '?';
	  	$_auditoria_mysql_database = '?';
	}    
	 
    // ----------------------------
    $_auditoria_mysql_operacion  = substr(trim(strtoupper($_mysql_query)),0,6);
    $_auditoria_fecha            = date("Y-m-d"); 
    $_auditoria_hora             = date("H:i:s");
    $_auditoria_ip               = $_SERVER["REMOTE_ADDR"]; 

    // Agregado el 27/6/2008, por el problemas de las comillas simples:
    $AuxCadena = "_barra_invertida_comilla_simple_" ;
    $_mysql_query = str_replace("\'",$AuxCadena,$_mysql_query);
    // ---
    $_mysql_query = trim(str_replace("'","\'",$_mysql_query));
    $_mysql_query = trim(str_replace($AuxCadena,"\'",$_mysql_query));
    
    // --
    $_descrip = str_replace("\'",$AuxCadena,$_descrip);
    // ---
    $_descrip = trim(str_replace("'","\'",$_descrip));
    $_descrip = trim(str_replace($AuxCadena,"\'",$_descrip));
       
    $SYSusuario = $GLOBALS["SYSusuario"];
    if (isset($GLOBALS["_sessionid"]))
    	$_sessionid = $GLOBALS["_sessionid"];
    else {
    	if ($_auditoria_mysql_table == '_usuarios')
   			$_sessionid = $_id_registro;	
    }    	
   
    $_auditoria_query = "
	          INSERT INTO _auditoria 
			    (SYSusuario, _sessionid, id_registro, mysql_query, mysql_user, mysql_database, mysql_table, mysql_operacion, mysql_descrip, php_file, php_line, fecha, hora, ip )
              VALUES 
			    ('$SYSusuario', '$_sessionid', '$_id_registro', '$_mysql_query', '$_auditoria_mysql_user', '$_auditoria_mysql_database', '$_auditoria_mysql_table', '$_auditoria_mysql_operacion' , '$_descrip', '$_auditoria_php_file' , '$_auditoria_php_line' , '$_auditoria_fecha', '$_auditoria_hora', '$_auditoria_ip')
	          ";
	
    if($_link_auditoria)
   		@mysql_query($_auditoria_query,$_link_auditoria);
    else
   		@mysql_query($_auditoria_query);       	
  }  
}  
?>