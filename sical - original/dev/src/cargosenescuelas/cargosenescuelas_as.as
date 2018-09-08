import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
include "../asincludes/numericSort.as";

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
	httpDatos.url = "cargosenescuelas/cargosenescuelas.php";
	httpDatos.method = URLRequestMethod.POST;
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);
	//preparo el autocomplete		
	acEscuelaA.addEventListener(ListEvent.CHANGE,ChangeAcEscuelaA);
	acEscuelaA.addEventListener("close",CloseAcEscuelaA);
	acEscuelaA.labelField = "@nombre";
	//preparo el autocomplete		
	acEscuelaD.addEventListener(ListEvent.CHANGE,ChangeAcEscuelaD);
	acEscuelaD.addEventListener("close",CloseAcEscuelaD);
	acEscuelaD.labelField = "@nombre";
	httpAcEscuelaA.url = "cargosenescuelas/cargosenescuelas.php";
	httpAcEscuelaA.addEventListener("acceso",acceso);
	httpAcEscuelaA.addEventListener(ResultEvent.RESULT,fncCargarAcEscuelaA);
	httpAcEscuelaD.url = "cargosenescuelas/cargosenescuelas.php";
	httpAcEscuelaD.addEventListener("acceso",acceso);
	httpAcEscuelaD.addEventListener(ResultEvent.RESULT,fncCargarAcEscuelaD);
	httpCargosA.url = "cargosenescuelas/cargosenescuelas.php";
	httpCargosA.addEventListener("acceso",acceso);
	httpCargosA.addEventListener(ResultEvent.RESULT,fncCargarcargosA);
	httpCargosD.url = "cargosenescuelas/cargosenescuelas.php";
	httpCargosD.addEventListener("acceso",acceso);
	httpCargosD.addEventListener(ResultEvent.RESULT,fncCargarcargosD);
	//preparo el autocomplete		
	acCargoN.addEventListener(ListEvent.CHANGE,ChangeacCargoN);
	acCargoN.addEventListener("close",CloseacCargoN);
	acCargoN.labelField = "@denominacion";
	httpCargoN.url = "cargosenescuelas/cargosenescuelas.php";
	httpCargoN.addEventListener("acceso",acceso);
	httpCargoN.addEventListener(ResultEvent.RESULT,fncCargarcargoN);
	btnAddUno.addEventListener("click",fncAddUno);
	btnAddTodos.addEventListener("click",fncAddTodos);
	btnDelUno.addEventListener("click",fncDelUno);
	btnDelTodos.addEventListener("click",fncDelTodos);
	btnDelUno.enabled = false;
	gridCargosD.addEventListener("change",fncChangecargosD);
	btnGuardar.addEventListener("click",fncGuardar);	
}

private function fncDatosResult(e:Event):void {
	_xmlCargosA = <cargos></cargos>;
	_xmlCargosD = <cargos></cargos>;
	_xmlCargosNuevos = <cargos></cargos>;
	Alert.show("El alta de cargos para la escuela se ha realizado con éxito.");		
}

private function fncGuardar(e:Event):void
{		
	var error:String = '';
	if (acEscuelaD.selectedItem==null) {
		error += "Debe seleccionar la escuela para la cual se asignan los cargos.\n";
	}
	if (_xmlCargosDE.cargos.length() > 0) {
		error += "La escuela seleccionada ya tiene cargos asignados previamente. Dirígase a la opción de 'Modificación de Cargos en Escuelas' del Menú ";
		error += "para agregar o eliminar cargos asignados.\n";
	}
	if (error == '') {
		Alert.yesLabel = "Si";			 
		Alert.show("Está a punto de incluir los cargos seleccionados en la escuela " + acEscuelaD.selectedItem.@nombre + " ¿Confirmar?","Confirmación", Alert.YES | Alert.NO,null,fncConfirmGuardar);					
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncConfirmGuardar(e:CloseEvent):void
{
	if(e.detail==Alert.YES) 
	{
		httpDatos.send({rutina:"dar_alta",xmlCargos:_xmlCargosD,id_escuela:acEscuelaD.selectedItem.@id_escuela,
			cod_escuela:acEscuelaD.selectedItem.@codigo,id_nivel:acEscuelaD.selectedItem.@id_nivel});	
	}
}

private function fncChangecargosD(obj:Event):void
{		
	if (gridCargosD.selectedIndex >= 0) {
		var xmlCargo:XML = (gridCargosD.selectedItem as XML).copy();			
		if (xmlCargo.@origen == 'A') 			
			btnDelUno.enabled = true;
		else
			btnDelUno.enabled = false;
	}			
}

private function fncCargarcargoN(e:Event):void{
	acCargoN.typedText = acCargoN.text;
	acCargoN.dataProvider = httpCargoN.lastResult.cargos;		
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

public function fncEliminarEspacio():void
{
	var xmlCargo:XML = (gridCargosD.selectedItem as XML).copy();
	var index:int;
	delete _xmlCargosD.cargos[(gridCargosD.selectedItem as XML).childIndex()];		
	for (var i:int = 0;i < _xmlCargosNuevos.cargos.length();i++) {
		if (xmlCargo.@id_cargo == _xmlCargosNuevos.cargos[i].@id_cargo) {
			index = i;
			break;
		}
	}
	delete _xmlCargosNuevos.cargos[index];
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

private function fncDelUno(e:Event):void
{
	var xmlCargo:XML = (gridCargosD.selectedItem as XML).copy();
	_xmlCargosA.appendChild(xmlCargo);		
	delete _xmlCargosD.cargos[(gridCargosD.selectedItem as XML).childIndex()];	
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
	acEscuelaA.dataProvider = httpAcEscuelaA.lastResult.escuelas;		
}

private function ChangeAcEscuelaD(e:Event):void{
	if (acEscuelaD.text.length==3){
		httpAcEscuelaD.send({rutina:"traer_escuelas",nombre:acEscuelaD.text});
	}
}

private function CloseAcEscuelaD(e:Event):void {
	if (acEscuelaD.selectedIndex!=-1) {
		httpCargosD.send({rutina:"traer_cargos",id_escuela:acEscuelaD.selectedItem.@id_escuela});
	}		
}
	
private function fncCargarAcEscuelaD(e:Event):void{
	acEscuelaD.typedText = acEscuelaD.text;
	acEscuelaD.dataProvider = httpAcEscuelaD.lastResult.escuelas;		
}		

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@descripcion;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}