import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

import mx.managers.PopUpManager;

import consesccarresp.carrera;

include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlEscuela:XML = <escuelas id_escuela_carrera_espacio="" id_carrera="" cod_carrera="" id_espacio="" cod_espacio="" denomcar="" id_escuela="" cod_escuela="" id_nivel="" nombre="" origen=""/>;
[Bindable] private var _xmlEscuelas:XML = <escuelas></escuelas>;	
[Bindable] private var _xmlEscuelasDE:XML = <escuelas></escuelas>;
[Bindable] private var _xmlEscuelasNuevos:XML = <escuelas></escuelas>;
[Bindable] private var _xmlTiposEscuelas:XML = <tiposescuelas></tiposescuelas>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
[Bindable] private var _xmlCarreras:XML = <carreras></carreras>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpEscuelas:HTTPServices = new HTTPServices;	
private var httpAcEspacio:HTTPServices = new HTTPServices;
private var httpAcEscuela:HTTPServices = new HTTPServices;	
private var httpAcCarrera:HTTPServices = new HTTPServices;
private var httpCodEspacio:HTTPServices = new HTTPServices;
private var httpCodCarrera:HTTPServices = new HTTPServices;
private var httpCodEscuela:HTTPServices = new HTTPServices;
private var twCarrera:carrera;

public function get xmlTiposEscuelas():XML{return _xmlTiposEscuelas.copy();}

public function get xmlCarreras():XML { return _xmlCarreras }

public function fncInit():void
{
	httpDatos.url = "consesccarresp/consesccarresp.php";
	httpDatos.addEventListener("acceso",acceso);		
	httpDatos2.url = "consesccarresp/consesccarresp.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	//httpDatos2.send({rutina:"traer_datos2"});
	//preparo el autocomplete				
	acEscuela.addEventListener(ListEvent.CHANGE,ChangeAcEscuela);
	acEscuela.addEventListener("close",CloseAcEscuela);		
	acEscuela.labelField = "@nombre";		
	httpAcEscuela.url = "consesccarresp/consesccarresp.php";
	httpAcEscuela.addEventListener("acceso",acceso);
	httpAcEscuela.addEventListener(ResultEvent.RESULT,fncCargarAcEscuela);				
	
	httpCodEscuela.url = "consesccarresp/consesccarresp.php";
	httpCodEscuela.addEventListener("acceso",acceso);
	httpCodEscuela.addEventListener(ResultEvent.RESULT,fncCargarEscuela);
			
	httpEscuelas.url = "consesccarresp/consesccarresp.php";
	httpEscuelas.addEventListener("acceso",acceso);
	httpEscuelas.addEventListener(ResultEvent.RESULT,fncCargarEscuelas);		
	btnBuscar.addEventListener("click",fncBuscar);
	
	btnImprimir.addEventListener("click",fncImprimir);
	
	txiCodigoS.addEventListener("focusOut",fncBuscarEscuela);
}

private function fncImprimir(e:Event):void
{	
	if (acEscuela.selectedItem != null) {
		var url:String;
	
		if (rbHtml.selected == true)
			url = "consesccarresp/list_carr_esp.php?rutina=list_carr_esp&"
		else
			url = "consesccarresp/list_carr_esp_pdf.php?rutina=list_carr_esp&"
		
		//Creo los contenedores para enviar datos y recibir respuesta
		var enviar:URLRequest = new URLRequest(url);
		var recibir:URLLoader = new URLLoader();
	 		 
		//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
		var variables:URLVariables = new URLVariables();
		
		variables.id_escuela = acEscuela.selectedItem.@id_escuela;							
					
		//Indico que voy a enviar variables dentro de la petición
		enviar.data = variables;
		
		navigateToURL(enviar);	
	} else {
		Alert.show("Debe seleccionar una escuela\n","E R R O R");
	}
}

private function fncCargarEscuela(e:Event):void{
	acEscuela.dataProvider = httpCodEscuela.lastResult.escuela;		
}		

private function fncBuscarEscuela(e:Event):void
{
	if (txiCodigoS.text != "") {
		httpCodEscuela.send({rutina:"buscar_escuela",codigo:txiCodigoS.text});	
	}		
}

private function fncDatosResult(e:Event):void {
	_xmlEscuelas = <escuelas></escuelas>;		
	_xmlEscuelasNuevos = <escuelas></escuelas>;
	Alert.show("El alta de escuelas para la carrera y el espacio se ha realizado con éxito.");		
}

private function fncDatosResult2(e:Event):void {		
	_xmlTiposEscuelas.appendChild(httpDatos2.lastResult.tiposescuelas);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncBuscar(e:Event):void {
	if (acEscuela.selectedIndex!=-1) {
		httpEscuelas.send({rutina:"traer_carreras_espacios",id_escuela:acEscuela.selectedItem.@id_escuela});
	}						
}		

private function fncResultAdd(e:Event):void{
	_xmlEscuela.@id_escuela_carrera_espacio = httpDatos.lastResult.insert_id;
	var existe_codigo : String =  httpDatos.lastResult.codigos.@cc;
	var tomo_espacios : String =  httpDatos.lastResult.tomoespacios.@cc1;
	if (existe_codigo=="0"){
		if (tomo_espacios!="0") {
			_xmlEscuelas.appendChild(_xmlEscuela.copy());
			Alert.show("El alta se registro con éxito","Carreras y Espacios por Escuela");					
		} else
			Alert.show("La carrera y espacio seleccionados no tienen títulos categorizados aún","Escuelas por Carrera y Espacio");
	}else{
		Alert.show("La Carrera y Espacio seleccionados ya han sido asignados a la escuela","ERROR");	
	}				
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}		

private function fncCargarAcEscuela(e:Event):void{
	acEscuela.typedText = acEscuela.text;
	acEscuela.dataProvider = httpAcEscuela.lastResult.escuela;		
}

private function ChangeAcEscuela(e:Event):void{
	if (acEscuela.text.length==3){
		httpAcEscuela.send({rutina:"traer_escuelas_n",nombre:acEscuela.text});
	}
}

private function CloseAcEscuela(e:Event):void {
	if (acEscuela.selectedIndex!=-1) {
		txiCodigoS.text = acEscuela.selectedItem.@codigo;			
	}		
}			
	
private function fncCargarEscuelas(e:Event):void {
	_xmlCarreras = <carreras></carreras>;
	_xmlCarreras.appendChild(httpEscuelas.lastResult.carrera);			
}

public function fncEditar():void
{
	twCarrera = new carrera;
	twCarrera.xmlCarrera =  (gridCarreras.selectedItem as XML).copy();		
	PopUpManager.addPopUp(twCarrera,this,true);
	PopUpManager.centerPopUp(twCarrera);
}	
