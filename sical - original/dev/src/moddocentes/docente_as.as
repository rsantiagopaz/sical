import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlDocente : XML = <titulos  />;
[Bindable] private var httpDocente : HTTPServices = new HTTPServices;
[Bindable] private var httpTiposDoc : HTTPServices = new HTTPServices;
[Bindable] private var httpDocenteNivelPara : HTTPServices = new HTTPServices;
private var httpAcInstitucion:HTTPServices = new HTTPServices;
[Bindable] private var xmlDepartamentos : XML = <departamentos></departamentos>;
[Bindable] private var _xmlLugares:XML = <lugares></lugares>;
[Bindable] private var _xmlTiposDoc:XML = <documentos></documentos>;
[Bindable] private var _xmlDocenteNivelPara : XML = <titnivelpara></titnivelpara>;
private var _accion : String;


public function get xmlDocente():XML{return _xmlDocente.copy();}
public function get accion():String{return _accion;}
public function set xmlDocente(esc:XML):void{
	_xmlDocente = esc;
	_accion = "editar";
}
public function set xmlDocente2(esc:XML):void{
	_xmlDocente = esc;
	_accion = "eliminar";
}

public function modificar():void{
	
}	
private function fncInit():void
{
	httpTiposDoc.url = "moddocentes/moddocentes.php";		
	httpTiposDoc.addEventListener(ResultEvent.RESULT,fncTiposDocResult);		
	httpTiposDoc.send({rutina:"traer_documentos"});
	_xmlLugares.appendChild(parentApplication.xmlLugares.departamento);
	xmlDepartamentos.appendChild(_xmlLugares.departamento);		
	var i:int;
	if (_xmlDocente.@departamento != "" && _xmlDocente.@departamento) {
		for (i = 0;i < xmlDepartamentos.departamento.length();i++) {
			if (xmlDepartamentos.departamento[i].@denom == _xmlDocente.@departamento) {
				cmbDepartamento.selectedIndex = i;
				break;	
			}
		}			
		for (i = 0;i < xmlDepartamentos.departamento.(@id_departamento==cmbDepartamento.selectedItem.@id_departamento).localidad.length();i++) {
			if (xmlDepartamentos.departamento.(@id_departamento==cmbDepartamento.selectedItem.@id_departamento).localidad[i].@denom == _xmlDocente.@localidad) {
				cmbLocalidad.selectedIndex = i;
				break;	
			}					
		}
	}
	txiNroDoc.text = _xmlDocente.@nro_doc;
	txiApellido.text = _xmlDocente.@apellido;
	txiNombres.text = _xmlDocente.@nombres;
	txiDomicilio.text = _xmlDocente.@domicilio;	
	//preparo el PopUp Para que se cierre con esc y marco el default button
	this.defaultButton = btnGrabar;
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});		
	//preparo el httpservice
	httpDocente.url = "moddocentes/moddocentes.php";
	httpDocente.addEventListener("acceso",acceso);
	// escucho evento de los botones
	if (_accion == "editar") {				
		btnGrabar.addEventListener("click",fncEdit);			
	} else if (_accion == "eliminar") {
		this.currentState = "eliminar";		
		btnEliminar.addEventListener("click",fncDelete);
	} else			
		btnGrabar.addEventListener("click",fncAdd);			
	btnCancel.addEventListener("click",fncCerrar);		
}

private function fncTiposDocResult(e:Event) : void 
{  			
	cmbTiposDoc.dataProvider = httpTiposDoc.lastResult.documentos.documento.documento;
	_xmlTiposDoc.appendChild(httpTiposDoc.lastResult.documentos.documento.documento as XMLList);		
	var i:int;
	for (i = 0;i < cmbTiposDoc["dataProvider"]["length"];i++) {
		if (_xmlTiposDoc.documento[i] == _xmlDocente.@tipo_doc)
 	  	{					     	  	
     	  	cmbTiposDoc.selectedIndex  = i;
     	  	break;
 	  	}					
	}
}	

private function fncCargarNivelPara(e:Event):void {
	_xmlDocenteNivelPara.appendChild(httpDocenteNivelPara.lastResult.titulospara);		
}	

private function fncEdit(e:Event):void
{		
	if (fncValidar()) {
		fncArmarXmlDocente();			
		httpDocente.addEventListener(ResultEvent.RESULT,fncResultEdit);
		httpDocente.send({rutina:"update", xmlDocente:_xmlDocente.toXMLString()});
	}
}

private function fncResultEdit(e:Event):void{				
	Alert.show("La modificación se registró con exito","título");
	dispatchEvent(new Event("EventEdit"));		
	httpDocente.removeEventListener(ResultEvent.RESULT,fncResultEdit);
}

private function fncDelete(e:Event):void
{
	Alert.show("¿Realmente desea Eliminar el Docente "+ _xmlDocente.@nombre+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarDocente, null, Alert.OK);		
}

private function fncConfirmEliminarDocente(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		httpDocente.addEventListener(ResultEvent.RESULT,fncResultDelete);
		httpDocente.send({rutina:"delete", xmlDocente:_xmlDocente.toXMLString()});
	}
}

private function fncResultDelete(e:Event):void{		
	Alert.show("La eliminación se registro con exito","título");
	dispatchEvent(new Event("EventDelete"));			
	httpDocente.removeEventListener(ResultEvent.RESULT,fncResultDelete);
}

private function fncArmarXmlDocente():void 
{	
	_xmlDocente.@id_tipo_doc = httpTiposDoc.lastResult.documentos.documento[cmbTiposDoc.selectedIndex].id_tipo_doc.toString();
	_xmlDocente.@apellido = txiApellido.text;
	_xmlDocente.@nombres = txiNombres.text;
	_xmlDocente.@nombre = txiApellido.text + ', ' + txiNombres.text;
	_xmlDocente.@nro_doc = txiNroDoc.text;
	_xmlDocente.@domicilio = txiDomicilio.text;
	_xmlDocente.@id_localidad = cmbLocalidad.selectedItem.@id_localidad;
	_xmlDocente.@localidad = cmbLocalidad.selectedItem.@denom;
}

private function fncCerrar(e:Event):void
{
	PopUpManager.removePopUp(this)	
}

private function fncAdd(e:Event):void
{		
	if (fncValidar()) {
		fncArmarXmlDocente();
		httpDocente.addEventListener(ResultEvent.RESULT,fncResultAdd);
		httpDocente.send({rutina:"insert", xmlDocente:_xmlDocente.toXMLString(), xmlTitNivel:_xmlDocenteNivelPara.toXMLString()});
	}
}

private function fncResultAdd(e:Event):void{
	_xmlDocente.@id_titulo = httpDocente.lastResult.insert_id;
	_xmlDocente.@codigo =  httpDocente.lastResult.codigos.@cc;
	
	Alert.show("El alta se registro con exito","titulo");
	dispatchEvent(new Event("EventAlta"));
	
	httpDocente.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}

private function fncValidar():Boolean
{
	var error:Array = new Array;
	if (error.length>0) {
		((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
		return false;
	}else{					
		return true;	
	}	
}