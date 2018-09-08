import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.ListEvent;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.validators.Validator;

include "../control_acceso.as";

[Bindable] private var httpDatos:HTTPServices = new HTTPServices;
[Bindable] private var httpLlamado:HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
[Bindable] private var httpAcLlamados : HTTPServices = new HTTPServices;
[Bindable] public var idLlamadoDocente : String;
private var _accion : String;
private var _xmlDatos : XML;
private var _xmlObs : XML;

public function get xmlDatos():XML{return _xmlDatos;}
public function get xmlObs():XML{return _xmlObs;}

public function set accion(acc:String):void{_accion = acc;}

public function fncInit():void
{	
	_xmlDatos = <xml></xml>;
	_xmlObs = <observaciones></observaciones>;
	//preparo el PopUp Para que se cierre con esc		
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btncancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});
	//preparo el autocomplete		
	acLlamado.addEventListener(ListEvent.CHANGE,ChangeAcLlamado);
	acLlamado.addEventListener("close",CloseAcLlamado);
	acLlamado.labelField = "@descripcion";
	
	//preparo el httpservice necesario para el autocomplete
	httpAcLlamados.url = "twdocente/twdocente.php";
	httpAcLlamados.addEventListener("acceso",acceso);
	httpAcLlamados.addEventListener(ResultEvent.RESULT,fncCargarAcLlamado);
	
	idLlamadoDocente = '';			
	httpDatos.url = "desobservar/desobservar.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);
	
	httpLlamado.url = "twdocente/twdocente.php";
	httpLlamado.addEventListener("acceso",acceso);
	httpLlamado.addEventListener(ResultEvent.RESULT,fncCargarLlamado);
	
	httpCombos.url = "desobservar/desobservar.php";
	httpCombos.addEventListener("acceso",acceso);
	httpCombos.send({rutina:"traer_datos"});
	
	txiNroLlamado.addEventListener("focusOut",fncBuscarLlamado);
	
	btnMostrar.addEventListener("click",fncIniciarBusqueda);	
	btncancel.addEventListener("click",fncCerrar);	
}		
	

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("Close"));		
}

private function fncCargarAcLlamado(e:Event):void{
	acLlamado.typedText = acLlamado.text;
	acLlamado.dataProvider = httpAcLlamados.lastResult.llamados;		
}

private function fncBuscarLlamado(e:Event):void
{
	if (txiNroLlamado.text != "") {
		httpLlamado.send({rutina:"buscar_llamado",nro_llamado:txiNroLlamado.text});	
	}		
}

private function fncCargarLlamado(e:Event):void{		
	acLlamado.dataProvider = httpLlamado.lastResult.llamados;		
}

private function ChangeAcLlamado(e:Event):void{
	if (acLlamado.text.length==3){
		httpAcLlamados.send({rutina:"traer_llamados",descripcion:acLlamado.text});
	}
}

private function CloseAcLlamado(e:Event):void {
	if (acLlamado.selectedIndex!=-1) {
		txiNroLlamado.text = acLlamado.selectedItem.@nro_llamado;
	}		
}

private function fncValidar():Boolean
{
	var error:Array = Validator.validateAll([validNDOC]);
	if (error.length>0) {
		((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
		return false;
	}else{
		if (acLlamado.selectedItem==null) {
			return false;
		} else {
			return true;
		}	
	}	
}

private function fncIniciarBusqueda(e:Event):void
{
	if (fncValidar()){
		//httpDatos.send({rutina:"buscar_docente_llamado", tipo_doc:cmbTiposDoc.selectedItem.@id_tipo_doc, nro_doc:txtNroDoc.text,id_llamado:cmbLlamado.selectedItem.id_llamado});
		httpDatos.send({rutina:"buscar_docente_llamado", tipo_doc:cmbTiposDoc.selectedItem.@id_tipo_doc, nro_doc:txtNroDoc.text, id_llamado:acLlamado.selectedItem.@id_llamado});
	}	
}

private function fncCargarDatos(e:Event):void
{
	idLlamadoDocente = httpDatos.lastResult.llamadodocente.@id_docente_llamado;
	var estado_doc_llam:String = httpDatos.lastResult.llamadodocente.@estado_doc_llam;
	if (idLlamadoDocente != '0' && idLlamadoDocente){			
		if (estado_doc_llam == '0') {
			Alert.show("La inscripción del Docente al Llamado Seleccionado no puede ser modificada","ERROR");
		} else {
			if (httpDatos.lastResult.obsllamado.@cantobs != "0") {
				_xmlDatos.appendChild(httpDatos.lastResult.llamadodocente);
				_xmlObs.appendChild(httpDatos.lastResult.observaciones);
				dispatchEvent(new Event("verDocente"));							
			} else {
				Alert.show("La inscripción del Docente al Llamado Seleccionado no presenta ninguna observación","ERROR");
			}	
		}									
	}else{
		Alert.show("El Docente ingresado no se encuentra Inscripto en el Llamado Seleccionado","ERROR");		
	}
}
	
private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@descripcion;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}