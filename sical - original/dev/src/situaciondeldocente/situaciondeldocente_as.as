import clases.HTTPServices;

import flash.events.Event;

import mx.core.UIComponent;
import mx.events.ValidationResultEvent;
import mx.validators.Validator;

include "../control_acceso.as";

[Bindable] private var httpDatos:HTTPServices = new HTTPServices;
[Bindable] private var httpLlamado:HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
[Bindable] private var httpAcLlamados : HTTPServices = new HTTPServices;
[Bindable] public var idLlamadoDocente : String;
private var _accion : String;
private var _xmlDatos : XML;

public function get xmlDatos():XML{return _xmlDatos;}

public function set accion(acc:String):void{_accion = acc;}

public function fncInit():void
{	
	_xmlDatos = <xml></xml>;
	//preparo el PopUp Para que se cierre con esc		
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btncancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});	
	
	idLlamadoDocente = '';			
		
	httpCombos.url = "twdocente/twdocente.php";
	httpCombos.addEventListener("acceso",acceso);
	httpCombos.send({rutina:"traer_datos"});				
	
	btnMostrar.addEventListener("click",fncIniciarBusqueda);	
	btncancel.addEventListener("click",fncCerrar);	
}		

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));		
}

private function fncValidar():Boolean
{		
	var error:Array = Validator.validateAll([validNDOC]);
	if (error.length>0) {
		((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
		return false;
	}
	return true;
}

private function fncIniciarBusqueda(e:Event):void
{
	if (fncValidar()) {
		var url:String = "situaciondeldocente/situaciondeldocente.php";
		
		//Creo los contenedores para enviar datos y recibir respuesta
		var enviar:URLRequest = new URLRequest(url);
		var recibir:URLLoader = new URLLoader();
	 		 
		//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
		var variables:URLVariables = new URLVariables();
				
		variables.nro_doc = txtNroDoc.text;
					
		//Indico que voy a enviar variables dentro de la petición
		enviar.data = variables;
		
		navigateToURL(enviar);
	}	
}