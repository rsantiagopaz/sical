import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlCargoN:XML = <cargos id_escuela_cargo="" id_cargo="" codigo="" denominacion="" origen=""/>;
[Bindable] private var _xmlCargosA:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosD:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosDE:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosNuevos:XML = <cargos></cargos>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpCargosA:HTTPServices = new HTTPServices;
private var httpCargosD:HTTPServices = new HTTPServices;
private var httpCargoN:HTTPServices = new HTTPServices;
private var httpAcEscuelaA:HTTPServices = new HTTPServices;
private var httpAcEscuelaD:HTTPServices = new HTTPServices;	

public function fncInit():void
{
	httpDatos.url = "modcargosenescuelas/modcargosenescuelas.php";
	httpDatos.addEventListener("acceso",acceso);		
	//preparo el autocomplete		
	acEscuelaA.addEventListener(ListEvent.CHANGE,ChangeAcEscuelaA);
	acEscuelaA.addEventListener("close",CloseAcEscuelaA);
	acEscuelaA.labelField = "@nombre";		
	httpAcEscuelaA.url = "modcargosenescuelas/modcargosenescuelas.php";
	httpAcEscuelaA.addEventListener("acceso",acceso);
	httpAcEscuelaA.addEventListener(ResultEvent.RESULT,fncCargarAcEscuelaA);		
	httpCargosA.url = "modcargosenescuelas/modcargosenescuelas.php";
	httpCargosA.addEventListener("acceso",acceso);
	httpCargosA.addEventListener(ResultEvent.RESULT,fncCargarcargosA);
	httpCargosD.url = "modcargosenescuelas/modcargosenescuelas.php";
	httpCargosD.addEventListener("acceso",acceso);
	httpCargosD.addEventListener(ResultEvent.RESULT,fncCargarcargosD);
	//preparo el autocomplete		
	acCargoN.addEventListener(ListEvent.CHANGE,ChangeacCargoN);
	acCargoN.addEventListener("close",CloseacCargoN);
	acCargoN.labelField = "@denominacion";
	httpCargoN.url = "modcargosenescuelas/modcargosenescuelas.php";
	httpCargoN.addEventListener("acceso",acceso);
	httpCargoN.addEventListener(ResultEvent.RESULT,fncCargarcargoN);		
	btnAgregar.addEventListener("click",fncAgregar);
	//btnGuardar.addEventListener("click",fncGuardar);	
}

private function fncDatosResult(e:Event):void {
	_xmlCargosA = <cargos></cargos>;
	_xmlCargosD = <cargos></cargos>;
	_xmlCargosNuevos = <cargos></cargos>;
	Alert.show("El alta de cargos para la escuela se ha realizado con éxito.");		
}

private function fncAgregar(e:Event):void
{			
	var existente : Boolean = false;
	for (var i:int = 0;i < _xmlCargosA.cargos.length();i++) {
		if (acCargoN.selectedItem.@id_cargo == _xmlCargosA.cargos[i].@id_cargo) {
			existente = true;
		}
	}		
	if (existente == false) {			
		_xmlCargoN.@id_cargo = acCargoN.selectedItem.@id_cargo;
		_xmlCargoN.@codigo = acCargoN.selectedItem.@codigo;
		_xmlCargoN.@denominacion = acCargoN.selectedItem.@denominacion;
		_xmlCargoN.@origen = acCargoN.selectedItem.@origen;
		httpDatos.addEventListener(ResultEvent.RESULT,fncResultAdd);
		httpDatos.send({rutina:"insert",xmlCargo:_xmlCargoN.toXMLString(),id_escuela:acEscuelaA.selectedItem.@id_escuela,
			cod_escuela:acEscuelaA.selectedItem.@codigo,id_nivel:acEscuelaA.selectedItem.@id_nivel});				
	} else {
		Alert.show("El cargo seleccionado ya ha sido asignado a la escuela","ERROR");	
	}
}

private function fncResultAdd(e:Event):void{
	_xmlCargoN.@id_escuela_cargo = httpDatos.lastResult.insert_id;
	var existe_codigo : String =  httpDatos.lastResult.codigos.@cc;
	if (existe_codigo=="0"){
		Alert.show("El alta se registro con éxito","Cargos en Escuelas");				
	}else{
		Alert.show("El codigo de título ingresado ya existe","ERROR");	
	}
	_xmlCargosA.appendChild(_xmlCargoN.copy());		
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}

private function fncCargarcargoN(e:Event):void{
	acCargoN.typedText = acCargoN.text;
	acCargoN.dataProvider = httpCargoN.lastResult.cargo;		
}

private function ChangeacCargoN(e:Event):void{
	if (acCargoN.text.length==3){
		httpCargoN.send({rutina:"traer_cargos_n",denominacion:acCargoN.text});
	}
}

private function CloseacCargoN(e:Event):void {
	var xmlCargoN:XML = <cargos id_cargo="" codigo="" denominacion="" origen=""/>;
	var existente : Boolean = false;
	for (var i:int = 0;i < _xmlCargosD.cargos.length();i++) {
		if (acCargoN.selectedItem.@id_cargo == _xmlCargosD.cargos[i].@id_cargo) {
			existente = true;
		}
	}		
	if (existente == false) {			
		xmlCargoN.@id_cargo = acCargoN.selectedItem.@id_cargo;
		xmlCargoN.@codigo = acCargoN.selectedItem.@codigo;
		xmlCargoN.@denominacion = acCargoN.selectedItem.@denominacion;
		xmlCargoN.@origen = acCargoN.selectedItem.@origen;
		_xmlCargosD.appendChild(xmlCargoN.copy());
		_xmlCargosNuevos.appendChild(xmlCargoN.copy());	
	}				
}

public function fncEliminarCargo():void
{
	var xmlCargo:XML = (gridCargosA.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Eliminar el Cargo "+ xmlCargo.@denominacion+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarCargo, null, Alert.OK);						
}

private function fncConfirmEliminarCargo(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlCargo:XML = (gridCargosA.selectedItem as XML).copy();
		httpDatos.addEventListener(ResultEvent.RESULT,fncResultDel);
		httpDatos.send({rutina:"delete",xmlCargo:xmlCargo.toXMLString(),id_escuela:acEscuelaA.selectedItem.@id_escuela});
	}
}

private function fncResultDel(e:Event):void{		
	Alert.show("La eliminación se registro con exito","título");
	delete _xmlCargosA.cargos[(gridCargosA.selectedItem as XML).childIndex()];					
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultDel);
}

private function fncAddUno(e:Event):void
{
	var xmlCargo:XML = (gridCargosA.selectedItem as XML).copy();
	_xmlCargosD.appendChild(xmlCargo);
	delete _xmlCargosA.cargos[(gridCargosA.selectedItem as XML).childIndex()];	
}

private function fncAddTodos(e:Event):void
{
	for (var i:int = 0;i < _xmlCargosA.cargos.length();i++) {
		var xmlCargo:XML = _xmlCargosA.cargos[i];
		_xmlCargosD.appendChild(xmlCargo);
	}
	_xmlCargosA = <cargos></cargos>;			
}

private function fncDelTodos(e:Event):void
{		
	for (var i:int = 0;i < _xmlCargosD.cargos.length();i++) {
		var xmlCargo:XML = _xmlCargosD.cargos[i];
		if (_xmlCargosD.cargos[i].@origen == 'A') {
			_xmlCargosA.appendChild(xmlCargo);				
		}		
	}
	_xmlCargosD = _xmlCargosNuevos.copy();
}		

private function fncCargarcargosA(e:Event):void {
	_xmlCargosA = <cargos></cargos>;
	_xmlCargosA.appendChild(httpCargosA.lastResult.cargos);		
}

private function fncCargarcargosD(e:Event):void {
	_xmlCargosDE = <cargos></cargos>;
	_xmlCargosDE.appendChild(httpCargosD.lastResult.cargos);		
}

private function ChangeAcEscuelaA(e:Event):void{
	if (acEscuelaA.text.length==3){
		httpAcEscuelaA.send({rutina:"traer_escuelas",nombre:acEscuelaA.text});
	}
}

private function CloseAcEscuelaA(e:Event):void {
	if (acEscuelaA.selectedIndex!=-1) {
		httpCargosA.send({rutina:"traer_cargos",id_escuela:acEscuelaA.selectedItem.@id_escuela});
	}		
}
	
private function fncCargarAcEscuelaA(e:Event):void{
	acEscuelaA.typedText = acEscuelaA.text;
	acEscuelaA.dataProvider = httpAcEscuelaA.lastResult.escuela;		
}				

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

