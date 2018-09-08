import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.validators.Validator;

include "../control_acceso.as";

[Bindable] private var httpDatos:HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
[Bindable] public var idLlamadoDocente : String;
private var _xmlDatos : XML;

public function get xmlDatos():XML{return _xmlDatos;}

public function fncInit():void
{	
	_xmlDatos = <xml></xml>;
	//preparo el PopUp Para que se cierre con esc		
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btncancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});
	idLlamadoDocente = '';			
	httpDatos.url = "secundario/twdocentesec.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);
	
	httpCombos.url = "secundario/twdocentesec.php";
	httpCombos.addEventListener("acceso",acceso);
	httpCombos.send({rutina:"traer_datos"});
	
	btnMostrar.addEventListener("click",fncIniciarBusqueda);	
	btncancel.addEventListener("click",fncCerrar);	
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("Close"));
}

private function fncValidar():Boolean
{
	var error:Array = Validator.validateAll([validNDOC]);
	if (error.length>0) {
		((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
		return false;
	}else{
		return true;	
	}	
}

private function fncIniciarBusqueda(e:Event):void
{
	if (fncValidar()){
		httpDatos.send({rutina:"buscar_docente_llamado", tipo_doc:cmbTiposDoc.selectedItem.@id_tipo_doc, nro_doc:txtNroDoc.text,id_llamado:cmbLlamado.selectedItem.id_llamado});
	}	
}

private function fncCargarDatos(e:Event):void
{
	idLlamadoDocente = httpDatos.lastResult.llamadodocente.@id_docente_llamado;
	if (idLlamadoDocente != '0' && idLlamadoDocente){
		_xmlDatos.appendChild(httpDatos.lastResult.llamadodocente);
		dispatchEvent(new Event("verDocente"));
	}else{
		Alert.show("El Docente ingresado no se encuentra Inscripto en el Llamado Seleccionado","ERROR");		
	}
}