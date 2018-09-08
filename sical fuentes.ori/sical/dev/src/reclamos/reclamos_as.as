import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.ListEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.validators.Validator;

import reclamos.reclamo;


include "../control_acceso.as";

[Bindable] private var _xmlReclamos:XML = <reclamos></reclamos>;
[Bindable] private var _xmlMotivos:XML = <motivos></motivos>;
[Bindable] private var _xmlRespuestas:XML = <respuestas></respuestas>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpReclamos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
[Bindable] private var httpLlamado:HTTPServices = new HTTPServices;	
[Bindable] private var httpAcLlamados : HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
[Bindable] public var idDocente : String;
[Bindable] public var idLlamadoDocente : String;
private var twReclamo:reclamo;

public function get xmlMotivos():XML { return _xmlMotivos }

public function get xmlRespuestas():XML { return _xmlRespuestas }

public function get id_docente_llamado():String { return idLlamadoDocente }	


public function fncInit():void
{	
	idLlamadoDocente = '';
	idDocente = '';
	
	//preparo el autocomplete		
	acLlamado.addEventListener(ListEvent.CHANGE,ChangeAcLlamado);
	acLlamado.addEventListener("close",CloseAcLlamado);
	acLlamado.labelField = "@descripcion";
	
	//preparo el httpservice necesario para el autocomplete
	httpAcLlamados.url = "reclamos/reclamos.php";
	httpAcLlamados.addEventListener("acceso",acceso);
	httpAcLlamados.addEventListener(ResultEvent.RESULT,fncCargarAcLlamado);
	
	httpDatos.url = "reclamos/reclamos.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);
	
	httpReclamos.url = "reclamos/reclamos.php";
	httpReclamos.method = URLRequestMethod.POST;
	httpReclamos.addEventListener("acceso",acceso);
	httpReclamos.addEventListener(ResultEvent.RESULT,fncMostrarReclamos);
	
	httpLlamado.url = "reclamos/reclamos.php";
	httpLlamado.addEventListener("acceso",acceso);
	httpLlamado.addEventListener(ResultEvent.RESULT,fncCargarLlamado);
	
	httpDatos2.url = "reclamos/reclamos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2)
	httpDatos2.send({rutina:"traer_datos2"});
	
	httpCombos.url = "reclamos/reclamos.php";
	httpCombos.addEventListener("acceso",acceso);
	httpCombos.send({rutina:"traer_datos_combos"});
	
	btnNuevoReclamo.addEventListener("click" ,fncAgregarReclamo);
	btnCerrar.addEventListener("click" ,fncCerrar);
	
	txiNroLlamado.addEventListener("focusOut",fncBuscarLlamado);
	
	btnBuscar.addEventListener("click",fncIniciarBusqueda);
	btnImprimir.addEventListener("click",fncImprimir);
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

private function fncImprimir(e:Event):void
{		
	//Creo los contenedores para enviar datos y recibir respuesta
	var enviar:URLRequest = new URLRequest("reclamos/reporte_reclamos.php?rutina=reporte_reclamos&");
	var recibir:URLLoader = new URLLoader();
 		 
	//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
	var variables:URLVariables = new URLVariables();
	
	variables.id_docente_llamado = idLlamadoDocente;			
				
	//Indico que voy a enviar variables dentro de la petición
	enviar.data = variables;
	
	navigateToURL(enviar);
}

private function fncIniciarBusqueda(e:Event):void
{
	if (fncValidar()){		
		httpDatos.send({rutina:"buscar_docente_llamado", tipo_doc:cmbTiposDoc.selectedItem.@id_tipo_doc, nro_doc:txtNroDoc.text, id_llamado:acLlamado.selectedItem.@id_llamado});
	}	
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

private function fncCargarDatos(e:Event):void
{
	idDocente = httpDatos.lastResult.docente.@id_docente;
	if (idDocente != '0' && idDocente) {
		txiNombre.text = httpDatos.lastResult.docente.@apellido + ', ' + httpDatos.lastResult.docente.@nombres;
		idLlamadoDocente = httpDatos.lastResult.llamadodocente.@id_docente_llamado;
		if (idLlamadoDocente != '0' && idLlamadoDocente){			
			httpReclamos.send({rutina:"traer_datos",id_docente_llamado:idLlamadoDocente});			
		}else{
			_xmlReclamos = <reclamos></reclamos>;
			Alert.show("El Docente ingresado no se encuentra Inscripto en el Llamado Seleccionado","ERROR");		
		}	
	} else {
		txiNombre.text = '';
		idLlamadoDocente = '';
		_xmlReclamos = <reclamos></reclamos>;
		Alert.show("El Docente ingresado no se encuentra registrado","ERROR");
	}
}		

private function fncMostrarReclamos(e:Event):void {
	_xmlReclamos = <reclamos></reclamos>;
	_xmlReclamos.appendChild(httpReclamos.lastResult.reclamos);				
}

private function fncCargarDatos2(e:Event):void {		
	_xmlMotivos.appendChild(httpDatos2.lastResult.motivos);
	_xmlRespuestas.appendChild(httpDatos2.lastResult.respuestas);
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function fncAgregarReclamo(e:Event):void
{
	twReclamo = new reclamo;
	twReclamo.addEventListener("EventAlta",fncAltaReclamos);
	PopUpManager.addPopUp(twReclamo,this,true);
	PopUpManager.centerPopUp(twReclamo);
}

private function fncAltaReclamos(e:Event):void{
	_xmlReclamos.appendChild(twReclamo.xmlReclamo);
	PopUpManager.removePopUp(e.target as reclamo);
}

public function fncEditar():void
{
	twReclamo = new reclamo;
	twReclamo.xmlReclamo =  (gridReclamos.selectedItem as XML).copy();
	twReclamo.addEventListener("EventEdit",fncEditarReclamo);
	PopUpManager.addPopUp(twReclamo,this,true);
	PopUpManager.centerPopUp(twReclamo);
}

public function fncEliminar():void
{
	twReclamo = new reclamo;
	twReclamo.xmlReclamo2 =  (gridReclamos.selectedItem as XML).copy();
	twReclamo.addEventListener("EventDelete",fncEliminarReclamo);
	PopUpManager.addPopUp(twReclamo,this,true);
	PopUpManager.centerPopUp(twReclamo);
}

public function fncResponder():void
{
	twReclamo = new reclamo;
	twReclamo.xmlReclamo3 =  (gridReclamos.selectedItem as XML).copy();
	twReclamo.addEventListener("EventResp",fncResponderReclamo);
	PopUpManager.addPopUp(twReclamo,this,true);
	PopUpManager.centerPopUp(twReclamo);
}

private function fncEditarReclamo(e:Event):void
{
	_xmlReclamos.reclamos[(gridReclamos.selectedItem as XML).childIndex()] = twReclamo.xmlReclamo;
	PopUpManager.removePopUp(e.target as reclamo);		
}

private function fncEliminarReclamo(e:Event):void
{
	delete _xmlReclamos.reclamos[(gridReclamos.selectedItem as XML).childIndex()];
	PopUpManager.removePopUp(e.target as reclamo);		
}

private function fncResponderReclamo(e:Event):void
{
	_xmlReclamos.reclamos[(gridReclamos.selectedItem as XML).childIndex()] = twReclamo.xmlReclamo;
	PopUpManager.removePopUp(e.target as reclamo);		
}

private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@descripcion;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}
