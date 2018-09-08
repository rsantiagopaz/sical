import abmtitulos.twtitulo;

import carreras.twcarrera;

import clases.HTTPServices;

import espacios.twespacio;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlEspaciosA:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosD:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosDE:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosNuevos:XML = <espacios></espacios>;
[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpEspaciosA:HTTPServices = new HTTPServices;
private var httpEspaciosD:HTTPServices = new HTTPServices;
private var httpEspacioN:HTTPServices = new HTTPServices;
private var httpAcTituloA:HTTPServices = new HTTPServices;
private var httpAcTituloD:HTTPServices = new HTTPServices;
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodTituloA:HTTPServices = new HTTPServices;
private var httpCodTituloD:HTTPServices = new HTTPServices;
private var httpCodEspacio:HTTPServices = new HTTPServices;
private var httpCodCarrera:HTTPServices = new HTTPServices;
private var httpControl:HTTPServices = new HTTPServices;
private var _twTitulo:twtitulo = new twtitulo;
private var _twEspacio:twespacio = new twespacio;
private var _twCarrera:twcarrera = new twcarrera;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{
	httpDatos.url = "espaciosentitulos/espaciosentitulos.php";
	httpDatos.method = URLRequestMethod.POST;
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);
	httpDatos2.url = "espaciosentitulos/espaciosentitulos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});
	//preparo el autocomplete		
	acCarreraN.addEventListener(ListEvent.CHANGE,ChangeAcCarreraN);
	acCarreraN.addEventListener(ListEvent.CHANGE,CloseAcCarreraN);
	acCarreraN.labelField = "@nombre";
	httpAcCarreraN.url = "espaciosentitulos/espaciosentitulos.php";
	httpAcCarreraN.addEventListener("acceso",acceso);
	httpAcCarreraN.addEventListener(ResultEvent.RESULT,fncCargarAcCarreraN);	
	//preparo el autocomplete		
	acTituloA.addEventListener(ListEvent.CHANGE,ChangeAcTituloA);
	acTituloA.addEventListener("close",CloseAcTituloA);
	acTituloA.labelField = "@denominacion";
	//preparo el autocomplete		
	acTituloD.addEventListener(ListEvent.CHANGE,ChangeAcTituloD);
	acTituloD.addEventListener("close",CloseAcTituloD);
	acTituloD.labelField = "@denominacion";
	httpAcTituloA.url = "espaciosentitulos/espaciosentitulos.php";
	httpAcTituloA.addEventListener("acceso",acceso);
	httpAcTituloA.addEventListener(ResultEvent.RESULT,fncCargarAcTituloA);
	httpAcTituloD.url = "espaciosentitulos/espaciosentitulos.php";
	httpAcTituloD.addEventListener("acceso",acceso);
	httpAcTituloD.addEventListener(ResultEvent.RESULT,fncCargarAcTituloD);
	httpEspaciosA.url = "espaciosentitulos/espaciosentitulos.php";
	httpEspaciosA.addEventListener("acceso",acceso);
	httpEspaciosA.addEventListener(ResultEvent.RESULT,fncCargarespaciosA);
	httpEspaciosD.url = "espaciosentitulos/espaciosentitulos.php";
	httpEspaciosD.addEventListener("acceso",acceso);
	httpEspaciosD.addEventListener(ResultEvent.RESULT,fncCargarespaciosD);		
	httpCodTituloA.url = "espaciosentitulos/espaciosentitulos.php";
	httpCodTituloA.addEventListener("acceso",acceso);
	httpCodTituloA.addEventListener(ResultEvent.RESULT,fncCargarTituloA);
	httpCodTituloD.url = "espaciosentitulos/espaciosentitulos.php";
	httpCodTituloD.addEventListener("acceso",acceso);
	httpCodTituloD.addEventListener(ResultEvent.RESULT,fncCargarTituloD);		
	//preparo el autocomplete		
	acEspacioN.addEventListener(ListEvent.CHANGE,ChangeacEspacioN);
	acEspacioN.addEventListener("close",CloseAcEspacioN);
	acEspacioN.labelField = "@denominacion";
	httpEspacioN.url = "espaciosentitulos/espaciosentitulos.php";
	httpEspacioN.addEventListener("acceso",acceso);
	httpEspacioN.addEventListener(ResultEvent.RESULT,fncCargarespacioN);		
	httpCodEspacio.url = "espaciosentitulos/espaciosentitulos.php";
	httpCodEspacio.addEventListener("acceso",acceso);
	httpCodEspacio.addEventListener(ResultEvent.RESULT,fncCargarEspacio);
	httpCodCarrera.url = "espaciosentitulos/espaciosentitulos.php";
	httpCodCarrera.addEventListener("acceso",acceso);
	httpCodCarrera.addEventListener(ResultEvent.RESULT,fncCargarCarrera);
	
	httpControl.url = "espaciosentitulos/espaciosentitulos.php";
	httpControl.addEventListener("acceso",acceso);
	httpControl.addEventListener(ResultEvent.RESULT,fncControlValido);
	
	btnAddUno.addEventListener("click",fncAddUno);
	btnAddTodos.addEventListener("click",fncAddTodos);
	btnDelUno.addEventListener("click",fncDelUno);
	btnDelTodos.addEventListener("click",fncDelTodos);
	btnDelUno.enabled = false;
	gridEspaciosD.addEventListener("change",fncChangeespaciosD);
	btnAgregar.addEventListener("click",fncAgregar);
	btnGuardar.addEventListener("click",fncGuardar);
	txiCodigoTA.addEventListener("focusOut",fncBuscarTituloA);
	txiCodigoTD.addEventListener("focusOut",fncBuscarTituloD);
	txiCodigoE.addEventListener("focusOut",fncBuscarEspacio);
	txiCodigoC.addEventListener("focusOut",fncBuscarCarrera);
	btnBuscar1.addEventListener("click",fncTraerTitulosBoton1);
	btnBuscar2.addEventListener("click",fncTraerTitulosBoton2);
	btnBuscar3.addEventListener("click",fncTraerEspaciosBoton);
	btnBuscar4.addEventListener("click",fncTraerCarrerasBoton);
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

private function fncTraerEspaciosBoton(e:Event):void
{
	_twEspacio = new twespacio;
	_twEspacio.addEventListener("EventConfirmarEspacio",fncGrabarEspacio);
	PopUpManager.addPopUp(_twEspacio,this,true);
	PopUpManager.centerPopUp(_twEspacio);
}

private function fncTraerCarrerasBoton(e:Event):void
{
	_twCarrera = new twcarrera;
	_twCarrera.todos = 1;
	_twCarrera.addEventListener("EventConfirmarCarrera",fncGrabarCarrera);
	PopUpManager.addPopUp(_twCarrera,this,true);
	PopUpManager.centerPopUp(_twCarrera);
}

private function fncGrabarTituloA(e:Event):void
{
	var xmlTitulo:XML = _twTitulo.xmlTitulo;
	PopUpManager.removePopUp(e.target as twtitulo);
	txiCodigoTA.text = xmlTitulo.@codigo;
	httpCodTituloA.send({rutina:"buscar_titulo",codigo:txiCodigoTA.text});
	httpEspaciosA.send({rutina:"traer_espacios",id_titulo:xmlTitulo.@id_titulo});
}

private function fncGrabarTituloD(e:Event):void
{
	var xmlTitulo:XML = _twTitulo.xmlTitulo;
	PopUpManager.removePopUp(e.target as twtitulo);
	txiCodigoTD.text = xmlTitulo.@codigo;
	httpCodTituloD.send({rutina:"buscar_titulo",codigo:txiCodigoTD.text});
	httpEspaciosD.send({rutina:"traer_espacios",id_titulo:xmlTitulo.@id_titulo});
}

private function fncGrabarEspacio(e:Event):void
{
	var xmlEspacio:XML = _twEspacio.xmlEspacio;
	PopUpManager.removePopUp(e.target as twespacio);
	txiCodigoE.text = xmlEspacio.@codigo;
	httpCodEspacio.send({rutina:"buscar_espacio",codigo:txiCodigoE.text});		
}

private function fncGrabarCarrera(e:Event):void
{
	var xmlCarrera:XML = _twCarrera.xmlCarrera;
	PopUpManager.removePopUp(e.target as twcarrera);
	txiCodigoC.text = xmlCarrera.@codigo;
	httpCodCarrera.send({rutina:"buscar_carrera",codigo:txiCodigoC.text});		
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

private function fncBuscarEspacio(e:Event):void
{
	if (txiCodigoE.text != "") {
		httpCodEspacio.send({rutina:"buscar_espacio",codigo:txiCodigoE.text});	
	}		
}

private function fncBuscarCarrera(e:Event):void
{
	if (txiCodigoC.text != "") {
		httpCodCarrera.send({rutina:"buscar_carrera",codigo:txiCodigoC.text});	
	}		
}

private function fncCargarTituloA(e:Event):void{
	acTituloA.dataProvider = httpCodTituloA.lastResult.titulo;
	if (acTituloA.selectedIndex!=-1) {
		httpEspaciosA.send({rutina:"traer_espacios",id_titulo:acTituloA.selectedItem.@id_titulo});
	}	
}

private function fncCargarTituloD(e:Event):void{
	acTituloD.dataProvider = httpCodTituloD.lastResult.titulo;
	if (acTituloD.selectedIndex!=-1) {
		httpEspaciosD.send({rutina:"traer_espacios",id_titulo:acTituloD.selectedItem.@id_titulo});
	}		
}

private function fncCargarEspacio(e:Event):void{
	acEspacioN.dataProvider = httpCodEspacio.lastResult.espacios;		
}

private function fncCargarCarrera(e:Event):void{
	acCarreraN.dataProvider = httpCodCarrera.lastResult.carreras;		
}

private function ChangeAcCarreraN(e:Event):void{
	if (acCarreraN.text.length==3){
		httpAcCarreraN.send({rutina:"traer_carreras",nombre:acCarreraN.text});
	}
}

private function fncCargarAcCarreraN(e:Event):void{
	acCarreraN.typedText = acCarreraN.text;
	acCarreraN.dataProvider = httpAcCarreraN.lastResult.carreras;		
}

private function fncDatosResult(e:Event):void {
	_xmlEspaciosA = <espacios></espacios>;
	_xmlEspaciosD = <espacios></espacios>;
	_xmlEspaciosNuevos = <espacios></espacios>;
	txiCodigoTA.text = "";
	txiCodigoTD.text = "";
	acTituloA.text = "";
	acTituloA.typedText = "";
	acTituloA.selectedItem=null;
	acTituloD.text = "";
	acTituloD.typedText = "";
	acTituloD.selectedItem=null;
	Alert.show("El alta de espacios para el titulo se ha realizado con éxito.");		
}

private function fncDatosResult2(e:Event):void {		
	_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncGuardar(e:Event):void
{		
	var error:String = '';
	if (acTituloD.selectedItem==null) {
		error += "Debe seleccionar el titulo para el cual se asignan los espacios.\n";
	}
	if (_xmlEspaciosDE.espacios.length() > 0) {
		error += "El título seleccionado ya tiene espacios asignados previamente. Dirígase a la opción de 'Modificación de Espacios en Títulos' del Menú ";
		error += "para agregar o eliminar espacios asignados.\n";
	}
	if (error == '') {
		Alert.yesLabel = "Si";			 
		Alert.show("Está a punto de incluir los espacios seleccionados en el titulo " + acTituloD.selectedItem.@nombre + " ¿Confirmar?","Confirmación", Alert.YES | Alert.NO,null,fncConfirmGuardar);								
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncAgregar(e:Event):void
{			
	var error:String = '';
	if (_xmlEspaciosDE.espacios.length() > 0) {
		error += "El título seleccionado ya tiene espacios asignados previamente. Dirígase a la opción de 'Modificación de Espacios en Títulos' del Menú ";
		error += "para agregar o eliminar espacios asignados.\n";
	}
	if (acEspacioN.selectedItem==null) {
		error += "Debe seleccionar un espacio.\n";
	}
	if (acCarreraN.selectedItem==null) {
		error += "Debe seleccionar una carrera.\n";
	}
	if (error == '') {			
		var existente : Boolean = false;
		for (var i:int = 0;i < _xmlEspaciosD.espacios.length();i++) {
			if (acEspacioN.selectedItem.@id_espacio == _xmlEspaciosD.espacios[i].@id_espacio) {
				existente = true;
			}
		}		
		if (existente == false) {
			httpControl.send({rutina:"controlar_carrera_espacio",id_carrera:acCarreraN.selectedItem.@id_carrera,id_espacio:acEspacioN.selectedItem.@id_espacio});					
		}
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncControlValido(e:Event):void
{
	var carrera_espacio : String =  httpControl.lastResult.carreraespacio.@cc1;
	if (carrera_espacio != '0') {
		var xmlEspacioN:XML = <espacios id_tomo_espacio="" id_carrera="" cod_carrera="" id_espacio="" cod_espacio="" 
			id_tipo_titulo="" cod_tipo_titulo="" tipo="" id_tipo_clasificacion="" codigo="" nombre="" 
			denomesp="" denomclas="" origen=""/>;
		xmlEspacioN.@id_carrera = acCarreraN.selectedItem.@id_carrera;
		xmlEspacioN.@cod_carrera = acCarreraN.selectedItem.@codigo;
		xmlEspacioN.@id_espacio = acEspacioN.selectedItem.@id_espacio;
		xmlEspacioN.@cod_espacio = acEspacioN.selectedItem.@codigo;
		xmlEspacioN.@id_tipo_titulo = cmbTipoTitulo.selectedItem.@id_tipo_titulo;
		xmlEspacioN.@cod_tipo_titulo = cmbTipoTitulo.selectedItem.@cod_tipo_titulo;
		xmlEspacioN.@id_tipo_clasificacion = cmbTipoClas.selectedItem.@id_tipo_clasificacion;
		xmlEspacioN.@tipo = cmbTipoTitulo.selectedItem.@tipo;
		xmlEspacioN.@codigo = acEspacioN.selectedItem.@codigo;
		xmlEspacioN.@nombre = acCarreraN.selectedItem.@nombre;
		xmlEspacioN.@denomesp = acEspacioN.selectedItem.@denominacion;
		xmlEspacioN.@denomclas = cmbTipoClas.selectedItem.@denominacion;
		xmlEspacioN.@origen = acEspacioN.selectedItem.@origen;
		_xmlEspaciosD.appendChild(xmlEspacioN.copy());
		_xmlEspaciosNuevos.appendChild(xmlEspacioN.copy());	
	} else {
		Alert.show("La carrera y espacio seleccionados no han sido vinculados aún","ERROR");
	}		
}

private function fncConfirmGuardar(e:CloseEvent):void
{
	if(e.detail==Alert.YES) 
	{
		httpDatos.send({rutina:"dar_alta",xmlEspacios:_xmlEspaciosD,id_titulo:acTituloD.selectedItem.@id_titulo,
			cod_titulo:acTituloD.selectedItem.@codigo});	
	}
}

private function fncChangeespaciosD(obj:Event):void
{		
	if (gridEspaciosD.selectedIndex >= 0) {
		var xmlEspacio:XML = (gridEspaciosD.selectedItem as XML).copy();			
		if (xmlEspacio.@origen == 'A') 			
			btnDelUno.enabled = true;
		else
			btnDelUno.enabled = false;
	}			
}

private function fncCargarespacioN(e:Event):void{
	acEspacioN.typedText = acEspacioN.text;
	acEspacioN.dataProvider = httpEspacioN.lastResult.espacios;		
}

private function ChangeacEspacioN(e:Event):void{
	if (acEspacioN.text.length==3){
		httpEspacioN.send({rutina:"traer_espacios_n",denominacion:acEspacioN.text});
	}
}	

public function fncEliminarEspacio():void
{
	var xmlEspacio:XML = (gridEspaciosD.selectedItem as XML).copy();
	var index:int;
	delete _xmlEspaciosD.espacios[(gridEspaciosD.selectedItem as XML).childIndex()];		
	for (var i:int = 0;i < _xmlEspaciosNuevos.espacios.length();i++) {
		if (xmlEspacio.@id_espacio == _xmlEspaciosNuevos.espacios[i].@id_espacio) {
			index = i;
			break;
		}
	}
	delete _xmlEspaciosNuevos.espacios[index];
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
	var xmlEspacio:XML = (gridEspaciosD.selectedItem as XML).copy();
	_xmlEspaciosA.appendChild(xmlEspacio);		
	delete _xmlEspaciosD.espacios[(gridEspaciosD.selectedItem as XML).childIndex()];	
}

private function fncCargarespaciosA(e:Event):void {
	_xmlEspaciosA = <espacios></espacios>;
	_xmlEspaciosA.appendChild(httpEspaciosA.lastResult.espacios);		
}

private function fncCargarespaciosD(e:Event):void {
	_xmlEspaciosDE = <espacios></espacios>;
	_xmlEspaciosDE.appendChild(httpEspaciosD.lastResult.espacios);		
}

private function ChangeAcTituloA(e:Event):void{
	if (acTituloA.text.length==3){
		httpAcTituloA.send({rutina:"traer_titulos",denominacion:acTituloA.text});
	}
}

private function CloseAcTituloA(e:Event):void {
	if (acTituloA.selectedIndex!=-1) {
		txiCodigoTA.text = acTituloA.selectedItem.@codigo;
		httpEspaciosA.send({rutina:"traer_espacios",id_titulo:acTituloA.selectedItem.@id_titulo});
	}		
}

private function CloseAcCarreraN(e:Event):void {
	if (acCarreraN.selectedIndex!=-1) {
		txiCodigoC.text = acCarreraN.selectedItem.@codigo;			
	}		
}

private function CloseAcEspacioN(e:Event):void {
	if (acEspacioN.selectedIndex!=-1) {
		txiCodigoE.text = acEspacioN.selectedItem.@codigo;			
	}		
}
	
private function fncCargarAcTituloA(e:Event):void{
	acTituloA.typedText = acTituloA.text;
	acTituloA.dataProvider = httpAcTituloA.lastResult.titulo;		
}

private function ChangeAcTituloD(e:Event):void{
	if (acTituloD.text.length==3){
		httpAcTituloD.send({rutina:"traer_titulos",denominacion:acTituloD.text});
	}
}

private function CloseAcTituloD(e:Event):void {
	if (acTituloD.selectedIndex!=-1) {
		txiCodigoTD.text = acTituloD.selectedItem.@codigo;
		httpEspaciosD.send({rutina:"traer_espacios",id_titulo:acTituloD.selectedItem.@id_titulo});
	}		
}
	
private function fncCargarAcTituloD(e:Event):void{
	acTituloD.typedText = acTituloD.text;
	acTituloD.dataProvider = httpAcTituloD.lastResult.titulo;		
}		

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
