import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlEspacioN:XML = <espacios id_carrera_espacio="" id_espacio="" codigo="" denominacion="" origen=""/>;
[Bindable] private var _xmlEspaciosA:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosD:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosDE:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosNuevos:XML = <espacios></espacios>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatosD:HTTPServices = new HTTPServices;
private var httpEspaciosA:HTTPServices = new HTTPServices;
private var httpEspaciosD:HTTPServices = new HTTPServices;
private var httpEspacioN:HTTPServices = new HTTPServices;
private var httpAcCarreraA:HTTPServices = new HTTPServices;
private var httpAcCarreraD:HTTPServices = new HTTPServices;
private var httpCodCarreraA:HTTPServices = new HTTPServices;
private var httpCodEspacio:HTTPServices = new HTTPServices;

public function fncInit():void
{
	httpDatos.url = "modespaciosencarreras/modespaciosencarreras.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatosD.url = "modespaciosencarreras/modespaciosencarreras.php";
	httpDatosD.addEventListener("acceso",acceso);
	//preparo el autocomplete		
	acCarreraA.addEventListener(ListEvent.CHANGE,ChangeAcCarreraA);
	acCarreraA.addEventListener("close",CloseAcCarreraA);
	acCarreraA.labelField = "@nombre";		
	httpAcCarreraA.url = "modespaciosencarreras/modespaciosencarreras.php";
	httpAcCarreraA.addEventListener("acceso",acceso);
	httpAcCarreraA.addEventListener(ResultEvent.RESULT,fncCargarAcCarreraA);
	httpEspaciosA.url = "modespaciosencarreras/modespaciosencarreras.php";
	httpEspaciosA.addEventListener("acceso",acceso);
	httpEspaciosA.addEventListener(ResultEvent.RESULT,fncCargarespaciosA);
	httpEspaciosD.url = "modespaciosencarreras/modespaciosencarreras.php";
	httpEspaciosD.addEventListener("acceso",acceso);
	httpEspaciosD.addEventListener(ResultEvent.RESULT,fncCargarespaciosD);
	
	httpCodCarreraA.url = "espaciosencarreras/espaciosencarreras.php";
	httpCodCarreraA.addEventListener("acceso",acceso);
	httpCodCarreraA.addEventListener(ResultEvent.RESULT,fncCargarCarreraA);
	
	httpCodEspacio.url = "espaciosencarreras/espaciosencarreras.php";
	httpCodEspacio.addEventListener("acceso",acceso);
	httpCodEspacio.addEventListener(ResultEvent.RESULT,fncCargarEspacio);
	
	//preparo el autocomplete		
	acEspacioN.addEventListener(ListEvent.CHANGE,ChangeacEspacioN);
	acEspacioN.addEventListener("close",CloseacEspacioN);
	acEspacioN.labelField = "@denominacion";
	httpEspacioN.url = "modespaciosencarreras/modespaciosencarreras.php";
	httpEspacioN.addEventListener("acceso",acceso);
	httpEspacioN.addEventListener(ResultEvent.RESULT,fncCargarespacioN);
	btnAgregar.addEventListener("click",fncAgregar);		
	//btnGuardar.addEventListener("click",fncGuardar);
	txiCodigoCA.addEventListener("focusOut",fncBuscarCarreraA);
	txiCodigoE.addEventListener("focusOut",fncBuscarEspacio);
}

private function fncBuscarCarreraA(e:Event):void
{
	if (txiCodigoCA.text != "") {
		httpCodCarreraA.send({rutina:"buscar_carrera",codigo:txiCodigoCA.text});	
	}		
}

private function fncCargarCarreraA(e:Event):void{
	acCarreraA.dataProvider = httpCodCarreraA.lastResult.carrera;
	if (acCarreraA.selectedIndex!=-1) {
		httpEspaciosA.send({rutina:"traer_espacios",id_carrera:acCarreraA.selectedItem.@id_carrera});
	}	
}

private function fncBuscarEspacio(e:Event):void
{
	if (txiCodigoE.text != "") {
		httpCodEspacio.send({rutina:"buscar_espacio",codigo:txiCodigoE.text});	
	}		
}

private function fncCargarEspacio(e:Event):void{
	acEspacioN.dataProvider = httpCodEspacio.lastResult.espacio;						
}

private function fncDatosResult(e:Event):void {
	_xmlEspaciosA = <espacios></espacios>;
	_xmlEspaciosD = <espacios></espacios>;
	_xmlEspaciosNuevos = <espacios></espacios>;
	Alert.show("El alta de espacios para la carrera se ha realizado con éxito.");		
}

private function fncAgregar(e:Event):void
{	
	if (acEspacioN.selectedIndex!=-1) {
		var existente : Boolean = false;		
		for (var i:int = 0;i < _xmlEspaciosA.espacios.length();i++) {
			if (acEspacioN.selectedItem.@id_espacio == _xmlEspaciosA.espacios[i].@id_espacio) {
				existente = true;
			}
		}		
		if (existente == false) {			
			_xmlEspacioN.@id_espacio = acEspacioN.selectedItem.@id_espacio;
			_xmlEspacioN.@codigo = acEspacioN.selectedItem.@codigo;
			_xmlEspacioN.@denominacion = acEspacioN.selectedItem.@denominacion;
			_xmlEspacioN.@origen = acEspacioN.selectedItem.@origen;			
			httpDatos.addEventListener(ResultEvent.RESULT,fncResultAdd);
			httpDatos.send({rutina:"insert",xmlEspacio:_xmlEspacioN.toXMLString(),id_carrera:acCarreraA.selectedItem.@id_carrera,
				cod_carrera:acCarreraA.selectedItem.@codigo});
		} else {
			Alert.show("El espacio seleccionado ya ha sido asignado a la carrera","ERROR");	
		}	
	} else {
		Alert.show("Debe seleccionar un espacio válido","ERROR");
	}		
}

private function fncResultAdd(e:Event):void{
	_xmlEspacioN.@id_carrera_espacio = httpDatos.lastResult.insert_id;
	var existe_codigo : String =  httpDatos.lastResult.codigos.@cc;
	if (existe_codigo=="0"){
		Alert.show("El alta se registro con éxito","Espacios en Carreras");				
	}else{
		Alert.show("El codigo de título ingresado ya existe","ERROR");	
	}
	_xmlEspaciosA.appendChild(_xmlEspacioN.copy());		
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}

private function fncCargarespacioN(e:Event):void{
	acEspacioN.typedText = acEspacioN.text;
	acEspacioN.dataProvider = httpEspacioN.lastResult.espacio;		
}

private function ChangeacEspacioN(e:Event):void{
	if (acEspacioN.text.length==3){
		httpEspacioN.send({rutina:"traer_espacios_n",denominacion:acEspacioN.text});
	}
}

private function CloseacEspacioN(e:Event):void {	
	if (acEspacioN.selectedIndex!=-1) {
		txiCodigoE.text = acEspacioN.selectedItem.@codigo;			
	}				
}

public function fncEliminarEspacio():void
{
	var xmlEspacio:XML = (gridEspaciosA.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Eliminar el Espacio "+ xmlEspacio.@denominacion+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarEspacio, null, Alert.OK);						
}

private function fncConfirmEliminarEspacio(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlEspacio:XML = (gridEspaciosA.selectedItem as XML).copy();
		httpDatosD.addEventListener(ResultEvent.RESULT,fncResultDel);
		httpDatosD.send({rutina:"delete",xmlEspacio:xmlEspacio.toXMLString(),id_carrera:acCarreraA.selectedItem.@id_carrera});
	}
}

private function fncResultDel(e:Event):void{		
	Alert.show("La eliminación se registro con exito","espacio");
	delete _xmlEspaciosA.espacios[(gridEspaciosA.selectedItem as XML).childIndex()];					
	httpDatosD.removeEventListener(ResultEvent.RESULT,fncResultDel);
}

private function fncAddUno(e:Event):void
{
	var xmlEspacio:XML = (gridEspaciosA.selectedItem as XML).copy();
	_xmlEspaciosD.appendChild(xmlEspacio);
	delete _xmlEspaciosA.espacios[(gridEspaciosA.selectedItem as XML).childIndex()];	
}

private function fncAddTodos(e:Event):void
{
	for (var i:int = 0;i < _xmlEspaciosA.espacios.length();i++) {
		var xmlEspacio:XML = _xmlEspaciosA.espacios[i];
		_xmlEspaciosD.appendChild(xmlEspacio);
	}
	_xmlEspaciosA = <espacios></espacios>;			
}

private function fncDelTodos(e:Event):void
{		
	for (var i:int = 0;i < _xmlEspaciosD.espacios.length();i++) {
		var xmlEspacio:XML = _xmlEspaciosD.espacios[i];
		if (_xmlEspaciosD.espacios[i].@origen == 'A') {
			_xmlEspaciosA.appendChild(xmlEspacio);				
		}		
	}
	_xmlEspaciosD = _xmlEspaciosNuevos.copy();
}

private function fncDelUno(e:Event):void
{
	var xmlEspacio:XML = (gridEspaciosA.selectedItem as XML).copy();
	_xmlEspaciosA.appendChild(xmlEspacio);		
	delete _xmlEspaciosA.espacios[(gridEspaciosA.selectedItem as XML).childIndex()];	
}

private function fncCargarespaciosA(e:Event):void {
	_xmlEspaciosA = <espacios></espacios>;
	_xmlEspaciosA.appendChild(httpEspaciosA.lastResult.espacios);		
}

private function fncCargarespaciosD(e:Event):void {
	_xmlEspaciosDE = <espacios></espacios>;
	_xmlEspaciosDE.appendChild(httpEspaciosD.lastResult.espacios);		
}

private function ChangeAcCarreraA(e:Event):void{
	if (acCarreraA.text.length==3){
		httpAcCarreraA.send({rutina:"traer_carreras",nombre:acCarreraA.text});
	}
}

private function CloseAcCarreraA(e:Event):void {
	if (acCarreraA.selectedIndex!=-1) {
		txiCodigoCA.text = acCarreraA.selectedItem.@codigo;
		httpEspaciosA.send({rutina:"traer_espacios",id_carrera:acCarreraA.selectedItem.@id_carrera});
	}
}
	
private function fncCargarAcCarreraA(e:Event):void{
	acCarreraA.typedText = acCarreraA.text;
	acCarreraA.dataProvider = httpAcCarreraA.lastResult.carrera;		
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
