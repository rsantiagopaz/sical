import abmtitulos.twtitulo;

import cargos.twcargo;

import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlCargosA:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosD:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosDE:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosNuevos:XML = <cargos></cargos>;
[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpCargosA:HTTPServices = new HTTPServices;
private var httpCargosD:HTTPServices = new HTTPServices;
private var httpCargoN:HTTPServices = new HTTPServices;
private var httpAcTituloA:HTTPServices = new HTTPServices;
private var httpAcTituloD:HTTPServices = new HTTPServices;
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodTituloA:HTTPServices = new HTTPServices;
private var httpCodTituloD:HTTPServices = new HTTPServices;
private var httpCodCargo:HTTPServices = new HTTPServices;
private var _twTitulo:twtitulo = new twtitulo;
private var _twCargo:twcargo = new twcargo;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{
	httpDatos.url = "cargosentitulos/cargosentitulos.php";
	httpDatos.method = URLRequestMethod.POST;
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);
	httpDatos2.url = "cargosentitulos/cargosentitulos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});
	//preparo el autocomplete		
	//acCarreraN.addEventListener(ListEvent.CHANGE,ChangeAcCarreraN);		
	//acCarreraN.labelField = "@nombre";
	httpAcCarreraN.url = "cargosentitulos/cargosentitulos.php";
	httpAcCarreraN.addEventListener("acceso",acceso);
	//httpAcCarreraN.addEventListener(ResultEvent.RESULT,fncCargarAcCarreraN);	
	//preparo el autocomplete		
	acTituloA.addEventListener(ListEvent.CHANGE,ChangeAcTituloA);
	acTituloA.addEventListener("close",CloseAcTituloA);
	acTituloA.labelField = "@denominacion";
	//preparo el autocomplete		
	acTituloD.addEventListener(ListEvent.CHANGE,ChangeAcTituloD);
	acTituloD.addEventListener("close",CloseAcTituloD);
	acTituloD.labelField = "@denominacion";
	httpAcTituloA.url = "cargosentitulos/cargosentitulos.php";
	httpAcTituloA.addEventListener("acceso",acceso);
	httpAcTituloA.addEventListener(ResultEvent.RESULT,fncCargarAcTituloA);
	httpAcTituloD.url = "cargosentitulos/cargosentitulos.php";
	httpAcTituloD.addEventListener("acceso",acceso);
	httpAcTituloD.addEventListener(ResultEvent.RESULT,fncCargarAcTituloD);
	httpCargosA.url = "cargosentitulos/cargosentitulos.php";
	httpCargosA.addEventListener("acceso",acceso);
	httpCargosA.addEventListener(ResultEvent.RESULT,fncCargarcargosA);
	httpCargosD.url = "cargosentitulos/cargosentitulos.php";
	httpCargosD.addEventListener("acceso",acceso);
	httpCargosD.addEventListener(ResultEvent.RESULT,fncCargarcargosD);
	
	httpCodTituloA.url = "cargosentitulos/cargosentitulos.php";
	httpCodTituloA.addEventListener("acceso",acceso);
	httpCodTituloA.addEventListener(ResultEvent.RESULT,fncCargarTituloA);
	httpCodTituloD.url = "cargosentitulos/cargosentitulos.php";
	httpCodTituloD.addEventListener("acceso",acceso);
	httpCodTituloD.addEventListener(ResultEvent.RESULT,fncCargarTituloD);
	
	httpCodCargo.url = "cargosentitulos/cargosentitulos.php";
	httpCodCargo.addEventListener("acceso",acceso);
	httpCodCargo.addEventListener(ResultEvent.RESULT,fncCargarCargo);
	
	//preparo el autocomplete		
	acCargoN.addEventListener(ListEvent.CHANGE,ChangeacCargoN);
	acCargoN.addEventListener("close",CloseAcCargoN);
	acCargoN.labelField = "@denominacion";
	httpCargoN.url = "cargosentitulos/cargosentitulos.php";
	httpCargoN.addEventListener("acceso",acceso);
	httpCargoN.addEventListener(ResultEvent.RESULT,fncCargarcargoN);
	btnAddUno.addEventListener("click",fncAddUno);
	btnAddTodos.addEventListener("click",fncAddTodos);
	btnDelUno.addEventListener("click",fncDelUno);
	btnDelTodos.addEventListener("click",fncDelTodos);
	btnDelUno.enabled = false;
	gridCargosD.addEventListener("change",fncChangecargosD);
	btnAgregar.addEventListener("click",fncAgregar);
	btnGuardar.addEventListener("click",fncGuardar);
	txiCodigoTA.addEventListener("focusOut",fncBuscarTituloA);
	txiCodigoTD.addEventListener("focusOut",fncBuscarTituloD);
	txiCodigoC.addEventListener("focusOut",fncBuscarCargo);
	btnBuscar1.addEventListener("click",fncTraerTitulosBoton1);
	btnBuscar2.addEventListener("click",fncTraerTitulosBoton2);
	btnBuscar3.addEventListener("click",fncTraerCargosBoton);
}

private function fncTraerTitulosBoton1(e:Event):void
{
	_twTitulo = new twtitulo;		
	_twTitulo.addEventListener("EventConfirmarTitulo",fncGrabarTituloA);
	PopUpManager.addPopUp(_twTitulo,this,true);
	PopUpManager.centerPopUp(_twTitulo);
}

private function fncTraerTitulosBoton2(e:Event):void
{
	_twTitulo = new twtitulo;		
	_twTitulo.addEventListener("EventConfirmarTitulo",fncGrabarTituloD);
	PopUpManager.addPopUp(_twTitulo,this,true);
	PopUpManager.centerPopUp(_twTitulo);
}

private function fncTraerCargosBoton(e:Event):void
{
	_twCargo = new twcargo;
	_twCargo.todos = 1;	
	_twCargo.addEventListener("EventConfirmarCargo",fncGrabarCargo);
	PopUpManager.addPopUp(_twCargo,this,true);
	PopUpManager.centerPopUp(_twCargo);
}

private function fncGrabarTituloA(e:Event):void
{
	var xmlTitulo:XML = _twTitulo.xmlTitulo;
	PopUpManager.removePopUp(e.target as twtitulo);
	txiCodigoTA.text = xmlTitulo.@codigo;
	httpCodTituloA.send({rutina:"buscar_titulo",codigo:txiCodigoTA.text});
	httpCargosA.send({rutina:"traer_cargos",id_titulo:xmlTitulo.@id_titulo});
}

private function fncGrabarTituloD(e:Event):void
{
	var xmlTitulo:XML = _twTitulo.xmlTitulo;
	PopUpManager.removePopUp(e.target as twtitulo);
	txiCodigoTD.text = xmlTitulo.@codigo;
	httpCodTituloD.send({rutina:"buscar_titulo",codigo:txiCodigoTD.text});
	httpCargosD.send({rutina:"traer_cargos",id_titulo:xmlTitulo.@id_titulo});
}

private function fncGrabarCargo(e:Event):void
{
	var xmlCargo:XML = _twCargo.xmlCargo;
	PopUpManager.removePopUp(e.target as twcargo);
	txiCodigoC.text = xmlCargo.@codigo;
	httpCodCargo.send({rutina:"buscar_cargo",codigo:txiCodigoC.text});		
}

private function fncBuscarCargo(e:Event):void
{
	if (txiCodigoC.text != "") {
		httpCodCargo.send({rutina:"buscar_cargo",codigo:txiCodigoC.text});	
	}		
}

private function fncBuscarTituloA(e:Event):void
{
	if (txiCodigoTA.text != "") {
		httpCodTituloA.send({rutina:"buscar_titulo",codigo:txiCodigoTA.text});	
	}		
}

private function fncBuscarTituloD(e:Event):void
{
	if (txiCodigoTD.text != "") {
		httpCodTituloD.send({rutina:"buscar_titulo",codigo:txiCodigoTD.text});	
	}		
}

private function fncCargarTituloA(e:Event):void{
	acTituloA.dataProvider = httpCodTituloA.lastResult.titulo;
	if (acTituloA.selectedIndex!=-1) {
		httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo});
	}	
}

private function fncCargarTituloD(e:Event):void{
	acTituloD.dataProvider = httpCodTituloD.lastResult.titulo;
	if (acTituloD.selectedIndex!=-1) {			
		httpCargosD.send({rutina:"traer_cargos",id_titulo:acTituloD.selectedItem.@id_titulo});
	}
}

private function fncCargarCargo(e:Event):void{
	acCargoN.dataProvider = httpCodCargo.lastResult.cargos;		
}		

private function fncDatosResult(e:Event):void {
	_xmlCargosA = <cargos></cargos>;
	_xmlCargosD = <cargos></cargos>;
	_xmlCargosNuevos = <cargos></cargos>;
	txiCodigoTA.text = "";
	txiCodigoTD.text = "";
	acTituloA.text = "";
	acTituloA.typedText = "";
	acTituloA.selectedItem=null;
	acTituloD.text = "";
	acTituloD.typedText = "";
	acTituloD.selectedItem=null;
	Alert.show("El alta de cargos para el titulo se ha realizado con éxito.");		
}

private function fncDatosResult2(e:Event):void {		
	_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncGuardar(e:Event):void
{		
	var error:String = '';
	if (acTituloD.selectedItem==null) {
		error += "Debe seleccionar el titulo para el cual se asignan los cargos.\n";
	}
	if (_xmlCargosDE.cargos.length() > 0) {
		error += "El título seleccionado ya tiene cargos asignados previamente. Dirígase a la opción de 'Modificación de Cargos en Títulos' del Menú ";
		error += "para agregar o eliminar cargos asignados.\n";
	}
	if (error == '') {
		Alert.yesLabel = "Si";			 
		Alert.show("Está a punto de incluir los cargos seleccionados en el titulo " + acTituloD.selectedItem.@nombre + " ¿Confirmar?","Confirmación", Alert.YES | Alert.NO,null,fncConfirmGuardar);								
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncAgregar(e:Event):void
{		
	var error:String = '';
	if (acCargoN.selectedItem==null) {
		error += "Debe seleccionar un cargo.\n";
	}		
	if (error == '') {
		var xmlCargoN:XML = <cargos id_tomo_cargo="" id_cargo="" cod_cargo="" id_tipo_titulo="" cod_tipo_titulo="" tipo="" 
			id_tipo_clasificacion="" denomcar="" denomclas="" cod_tipo_clasificacion="" cod_nivel="" origen=""/>;
		var existente : Boolean = false;
		for (var i:int = 0;i < _xmlCargosD.cargos.length();i++) {
			if (acCargoN.selectedItem.@id_cargo == _xmlCargosD.cargos[i].@id_cargo) {
				existente = true;
			}
		}		
		if (existente == false) {				
			xmlCargoN.@id_cargo = acCargoN.selectedItem.@id_cargo;
			xmlCargoN.@cod_cargo = acCargoN.selectedItem.@codigo;
			xmlCargoN.@id_tipo_titulo = cmbTipoTitulo.selectedItem.@id_tipo_titulo;
			xmlCargoN.@cod_tipo_titulo = cmbTipoTitulo.selectedItem.@cod_tipo_titulo;
			xmlCargoN.@id_tipo_clasificacion = cmbTipoClas.selectedItem.@id_tipo_clasificacion;
			xmlCargoN.@tipo = cmbTipoTitulo.selectedItem.@tipo;
			xmlCargoN.@codigo = acCargoN.selectedItem.@codigo;				
			xmlCargoN.@denomcar = acCargoN.selectedItem.@denominacion;
			xmlCargoN.@denomclas = cmbTipoClas.selectedItem.@denominacion;
			xmlCargoN.@cod_tipo_clasificacion = cmbTipoClas.selectedItem.@codigo;
			xmlCargoN.@cod_nivel = acCargoN.selectedItem.@id_nivel;
			xmlCargoN.@origen = acCargoN.selectedItem.@origen;
			_xmlCargosD.appendChild(xmlCargoN.copy());
			_xmlCargosNuevos.appendChild(xmlCargoN.copy());	
		}
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncConfirmGuardar(e:CloseEvent):void
{
	if(e.detail==Alert.YES) 
	{
		httpDatos.send({rutina:"dar_alta",xmlCargos:_xmlCargosD,id_titulo:acTituloD.selectedItem.@id_titulo,
			cod_titulo:acTituloD.selectedItem.@codigo});	
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

public function fncEliminarCargo():void
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

private function ChangeAcTituloA(e:Event):void{
	if (acTituloA.text.length==3){
		httpAcTituloA.send({rutina:"traer_titulos",denominacion:acTituloA.text});
	}
}

private function CloseAcTituloA(e:Event):void {
	if (acTituloA.selectedIndex!=-1) {
		txiCodigoTA.text = acTituloA.selectedItem.@codigo;
		httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo});
	}		
}
	
private function fncCargarAcTituloA(e:Event):void{
	acTituloA.typedText = acTituloA.text;
	acTituloA.dataProvider = httpAcTituloA.lastResult.titulo;	
}

private function CloseAcCargoN(e:Event):void {
	if (acCargoN.selectedIndex!=-1) {
		txiCodigoC.text = acCargoN.selectedItem.@codigo;			
	}		
}

private function ChangeAcTituloD(e:Event):void{
	if (acTituloD.text.length==3){
		httpAcTituloD.send({rutina:"traer_titulos",denominacion:acTituloD.text});
	}
}

private function CloseAcTituloD(e:Event):void {
	if (acTituloD.selectedIndex!=-1) {
		txiCodigoTD.text = acTituloD.selectedItem.@codigo;
		httpCargosD.send({rutina:"traer_cargos",id_titulo:acTituloD.selectedItem.@id_titulo});
	}		
}
	
private function fncCargarAcTituloD(e:Event):void{
	acTituloD.typedText = acTituloD.text;
	acTituloD.dataProvider = httpAcTituloD.lastResult.titulo;		
}		

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@descripcion;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}