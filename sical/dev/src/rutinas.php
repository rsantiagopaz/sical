<?php
//extrae todo el arreglo Request y lo pone como variables
foreach ($_REQUEST as $key => $value)
{
 	if(get_magic_quotes_gpc()) {
    	${$key} = ((isset($GLOBALS["___mysqli_ston"]) && is_object($GLOBALS["___mysqli_ston"])) ? mysqli_real_escape_string($GLOBALS["___mysqli_ston"], stripslashes($value)) : ((trigger_error("[MySQLConverterToo] Fix the mysql_escape_string() call! This code does not work.", E_USER_ERROR)) ? "" : ""));
    } else {
        ${$key} = ((isset($GLOBALS["___mysqli_ston"]) && is_object($GLOBALS["___mysqli_ston"])) ? mysqli_real_escape_string($GLOBALS["___mysqli_ston"], $value) : ((trigger_error("[MySQLConverterToo] Fix the mysql_escape_string() call! This code does not work.", E_USER_ERROR)) ? "" : ""));
    }
}

function loadXML($data) {
  $xml = @simplexml_load_string($data);
  if (!is_object($xml))
    throw new Exception('Error en la lectura del XML',1001);
  return $xml;
}

function toXML(&$xml, $sql , $tag = "row") {

	$paramet = @mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	$nodo = null;
	if (((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res)){ 
		$nodo=$xml->addChild("insert_id", ((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res));
	}
	if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) {
	 	$error="Error devuelto por la Base de Datos: ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))." ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))."\n";
	 	$nodo=$xml->addChild("error", $error);
	}
	else{
		if (is_a($paramet, 'mysqli_result')) {
			WHILE ($row = mysqli_fetch_array($paramet)) {
				$nodo=$xml->addChild($tag);	
				foreach($row as $key => $value) {
					if (!is_numeric($key)) $nodo->addAttribute($key, $value);
				}
			}
			$nodo=null;
		} else if (is_array($paramet)) {
			$nodo=$xml->addChild($tag);
			foreach($paramet as $key => $value) {
				if (!is_numeric($key)) $nodo->addAttribute($key, $value);
			}
		} else if (is_a($paramet, "SimpleXMLElement")) {
			$nodo=$xml->addChild($paramet->getName(), $paramet);
			foreach($paramet->attributes() as $key => $value) {
	    		$nodo->addAttribute($key, $value);
			}
			foreach ($paramet->children() as $hijo) {
				toXML($nodo, $hijo);
			}
		} else if (is_string($paramet)) {
			$nodo=new SimpleXMLElement($paramet);
			$nodo=$xml->addChild($nodo->getName(), $nodo[0]);
		}
	}
	return $nodo;
}
function simplexml_merge (SimpleXMLElement &$xml1, SimpleXMLElement $xml2)
{
   // convert SimpleXML objects into DOM ones
   $dom1 = new DomDocument();
   $dom2 = new DomDocument();
   $dom1->loadXML($xml1->asXML());
   $dom2->loadXML($xml2->asXML());

   // pull all child elements of second XML
   $xpath = new domXPath($dom2);
   $xpathQuery = $xpath->query('/*/*');
   for ($i = 0; $i < $xpathQuery->length; $i++)
   {
       // and pump them into first one
       $dom1->documentElement->appendChild(
           $dom1->importNode($xpathQuery->item($i), true));
   }
   $xml1 = simplexml_import_dom($dom1);
}

function DMYYYY($fecha) {
	$f=explode("-", $fecha);
	return (int) $f[2] . "/" . (int) $f[1] . "/" . (int) $f[0];
}
function YYYYDM($fecha) {
	$fecha = explode('/',$fecha);
	$fecha = $fecha[2].'-'.$fecha[1].'-'.$fecha[0];
	
	return $fecha;
}
function toXMLtag(&$xml, $sql , $tag = "row") {
	$nodo = null;
	$paramet = @mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	if (((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res)){ 
		$nodo=$xml->addChild("insert_id", ((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res));
	}
	if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))>0) {
	 	$error="Error devuelto por la Base de Datos: ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))." ".((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false))."\n";
	 	$nodo=$xml->addChild("error", $error);
	}
	else{
		if (is_a($paramet, 'mysqli_result')) {
			while ($row = mysqli_fetch_array($paramet)) {
				$nodo=$xml->addChild($tag);	
				foreach($row as $key => $value) {
					if (!is_numeric($key)) $nodo->addChild($key, $value);
				}
			}
			$nodo=null;
		} else if (is_array($paramet)) {
			$nodo=$xml->addChild($tag);
			foreach($paramet as $key => $value) {
				if (!is_numeric($key)) $nodo->addChild($key, $value);
			}
		} else if (is_a($paramet, "SimpleXMLElement")) {
			$nodo=$xml->addChild($paramet->getName(), $paramet);
			foreach($paramet->attributes() as $key => $value) {
	    		$nodo->addChild($key, $value);
			}
			foreach ($paramet->children() as $hijo) {
				toXML($nodo, $hijo);
			}
		} else if (is_string($paramet)) {
			$nodo=new SimpleXMLElement($paramet);
			$nodo=$xml->addChild($nodo->getName(), $nodo[0]);
		}
	}
	return $nodo;
}

function query($sql){
	$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	if (((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_errno($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_errno()) ? $___mysqli_res : false))){
		throw new Exception(((is_object($GLOBALS["___mysqli_ston"])) ? mysqli_error($GLOBALS["___mysqli_ston"]) : (($___mysqli_res = mysqli_connect_error()) ? $___mysqli_res : false)));
	}
	return ((is_null($___mysqli_res = mysqli_insert_id($GLOBALS["___mysqli_ston"]))) ? false : $___mysqli_res);
}
?>