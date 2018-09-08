import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlEspacioN:XML = <espacios id_tomo_espacio="" id_carrera="" cod_carrera="" id_espacio="" cod_espacio="" 
			id_tipo_titulo="" cod_tipo_titulo="" tipo="" id_tipo_clasificacion="" codigo="" nombre="" 
			denomesp="" denomclas="" origen=""/>;
[Bindable] private var _xmlEspaciosA:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosD:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosDE:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosNuevos:XML = <espacios></espacios>;
[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatosD:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpEspaciosA:HTTPServices = new HTTPServices;
private var httpEspaciosD:HTTPServices = new HTTPServices;
private var httpEspacioN:HTTPServices = new HTTPServices;
private var httpAcTituloA:HTTPServices = new HTTPServices;
private var httpAcTituloD:HTTPServices = new HTTPServices;
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodTitulo:HTTPServices = new HTTPServices;
private var httpCodEspacio:HTTPServices = new HTTPServices;
private var httpCodCarrera:HTTPServices = new HTTPServices;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{
	httpDatos.url = "modespaciosentitulos/modespaciosentitulos.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatosD.url = "modespaciosentitulos/modespaciosentitulos.php";
	httpDatosD.addEventListener("acceso",acceso);
	httpDatos2.url = "modespaciosentitulos/modespaciosentitulos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});
	//preparo el autocomplete		
	acCarreraN.addEventListener(ListEvent.CHANGE,ChangeAcCarreraN);
	acCarreraN.addEventListener(ListEvent.CHANGE,CloseAcCarreraN);		
	acCarreraN.labelField = "@nombre";
	httpAcCarreraN.url = "modespaciosentitulos/modespaciosentitulos.php";
	httpAcCarreraN.addEventListener("acceso",acceso);
	httpAcCarreraN.addEventListener(ResultEvent.RESULT,fncCargarAcCarreraN);	
	//preparo el autocomplete		
	acTituloA.addEventListener(ListEvent.CHANGE,ChangeAcTituloA);
	acTituloA.addEventListener("close",CloseAcTituloA);
	acTituloA.labelField = "@denominacion";		
	httpAcTituloA.url = "modespaciosentitulos/modespaciosentitulos.php";
	httpAcTituloA.addEventListener("acceso",acceso);
	httpAcTituloA.addEventListener(ResultEvent.RESULT,fncCargarAcTituloA);		
	httpEspaciosA.url = "modespaciosentitulos/modespaciosentitulos.php";
	httpEspaciosA.addEventListener("acceso",acceso);
	httpEspaciosA.addEventListener(ResultEvent.RESULT,fncCargarespaciosA);
	httpEspaciosD.url = "modespaciosentitulos/modespaciosentitulos.php";
	httpEspaciosD.addEventListener("acceso",acceso);
	httpEspaciosD.addEventListener(ResultEvent.RESULT,fncCargarespaciosD);
	//preparo el autocomplete		
	acEspacioN.addEventListener(ListEvent.CHANGE,ChangeacEspacioN);
	acEspacioN.addEventListener("close",CloseAcEspacioN);
	acEspacioN.labelField = "@denominacion";
	httpEspacioN.url = "modespaciosentitulos/modespaciosentitulos.php";
	httpEspacioN.addEventListener("acceso",acceso);
	httpEspacioN.addEventListener(ResultEvent.RESULT,fncCargarespacioN);
	
	httpCodTitulo.url = "modespaciosentitulos/modespaciosentitulos.php";
	httpCodTitulo.addEventListener("acceso",acceso);
	httpCodTitulo.addEventListener(ResultEvent.RESULT,fncCargarTitulo);
	
	httpCodEspacio.url = "espaciosentitulos/espaciosentitulos.php";
	httpCodEspacio.addEventListener("acceso",acceso);
	httpCodEspacio.addEventListener(ResultEvent.RESULT,fncCargarEspacio);
	httpCodCarrera.url = "espaciosentitulos/espaciosentitulos.php";
	httpCodCarrera.addEventListener("acceso",acceso);
	httpCodCarrera.addEventListener(ResultEvent.RESULT,fncCargarCarrera);	
	btnAgregar.addEventListener("click",fncAgregar);
	
	txiCodigoT.addEventListener("focusOut",fncBuscarTitulo);		
	txiCodigoE.addEventListener("focusOut",fncBuscarEspacio);
	txiCodigoC.addEventListener("focusOut",fncBuscarCarrera);
	//btnGuardar.addEventListener("click",fncGuardar);	
}

private function calcRowColor(item:Object, rowIndex:int,
 dataIndex:int, color:uint):uint
 {
   if(item.@marcado == 1)
     return 0xFF8800;
   else
     return color;
 }

private function fncBuscarTitulo(e:Event):void
{
	if (txiCodigoT.text != "") {
		httpCodTitulo.send({rutina:"buscar_titulo",codigo:txiCodigoT.text});	
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

private function fncCargarTitulo(e:Event):void{
	acTituloA.dataProvider = httpCodTitulo.lastResult.titulo;
	if (acTituloA.selectedIndex!=-1) {
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
	acCarreraN.dataProvider = httpAcCarreraN.lastResult.carrera;		
}

private function fncDatosResult(e:Event):void {
	_xmlEspaciosA = <espacios></espacios>;
	_xmlEspaciosD = <espacios></espacios>;
	_xmlEspaciosNuevos = <espacios></espacios>;
	Alert.show("El alta de espacios para el titulo se ha realizado con éxito.");		
}

private function fncDatosResult2(e:Event):void {		
	_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncAgregar(e:Event):void
{		
	var error:String = '';
	if (acTituloA.selectedItem==null) {
		error += "Debe seleccionar el titulo para la cual se asignan los espacios.\n";
	}
	if (acEspacioN.selectedItem==null) {
		error += "Debe seleccionar un espacio.\n";
	}
	if (acCarreraN.selectedItem==null) {
		error += "Debe seleccionar una carrera.\n";
	}
	if (error == '') {			
		var existente : Boolean = false;
		for (var i:int = 0;i < _xmlEspaciosA.espacios.length();i++) {
			if (acEspacioN.selectedItem.@id_espacio == _xmlEspaciosA.espacios[i].@id_espacio && 
				acCarreraN.selectedItem.@id_carrera == _xmlEspaciosA.espacios[i].@id_carrera) {
				existente = true;
			}
		}		
		if (existente == false) {				
			_xmlEspacioN.@id_carrera = acCarreraN.selectedItem.@id_carrera;
			_xmlEspacioN.@cod_carrera = acCarreraN.selectedItem.@codigo;
			_xmlEspacioN.@id_espacio = acEspacioN.selectedItem.@id_espacio;
			_xmlEspacioN.@cod_espacio = acEspacioN.selectedItem.@codigo;
			_xmlEspacioN.@id_tipo_titulo = cmbTipoTitulo.selectedItem.@id_tipo_titulo;
			_xmlEspacioN.@cod_tipo_titulo = cmbTipoTitulo.selectedItem.@cod_tipo_titulo;
			_xmlEspacioN.@id_tipo_clasificacion = cmbTipoClas.selectedItem.@id_tipo_clasificacion;
			_xmlEspacioN.@tipo = cmbTipoTitulo.selectedItem.@tipo;
			_xmlEspacioN.@codigo = acEspacioN.selectedItem.@codigo;
			_xmlEspacioN.@nombre = acCarreraN.selectedItem.@nombre;
			_xmlEspacioN.@denomesp = acEspacioN.selectedItem.@denominacion;
			_xmlEspacioN.@denomclas = cmbTipoClas.selectedItem.@denominacion;
			_xmlEspacioN.@origen = acEspacioN.selectedItem.@origen;
			httpDatos.addEventListener(ResultEvent.RESULT,fncResultAdd);
			httpDatos.send({rutina:"insert",xmlEspacio:_xmlEspacioN.toXMLString(),id_titulo:acTituloA.selectedItem.@id_titulo,
				cod_titulo:acTituloA.selectedItem.@codigo});
		}else{
			Alert.show("El espacio seleccionado ya ha sido asignado al título","ERROR");
		}
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncResultAdd(e:Event):void{
	_xmlEspacioN.@id_tomo_espacio = httpDatos.lastResult.insert_id;
	var existe_codigo : String =  httpDatos.lastResult.codigos.@cc;
	var carrerasespacios : String =  httpDatos.lastResult.carrerasespacios.@cc1;
	if (existe_codigo=="0"){
		if (carrerasespacios!="0") {
			var existe_espacio : String = httpDatos.lastResult.espacios.@cc2;
			if (existe_espacio == "0") {
				_xmlEspaciosA.appendChild(_xmlEspacioN.copy());
				Alert.show("El alta se registro con éxito","Espacios en Títulos");	
			} else {
				var existe_novedad : String =  httpDatos.lastResult.novedades.@cc3;
				if (existe_novedad!="0") {
					_xmlEspaciosA.appendChild(_xmlEspacioN.copy());
					Alert.show("El alta se registro con éxito","Espacios en Títulos");
				} else {
					Alert.show("Se ha generado una novedad que estará pendiente de confirmación","NOVEDAD");	
				}						
			}				
		} else
			Alert.show("El espacio y la carrera seleccionados no están vinculados","Espacios en Títulos");					
	}else{
		Alert.show("El espacio seleccionado ya ha sido asignado al título","ERROR");	
	}				
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
	var xmlEspacioN:XML = <espacios id_espacio="" codigo="" denominacion="" origen=""/>;
	var existente : Boolean = false;
	for (var i:int = 0;i < _xmlEspaciosD.espacios.length();i++) {
		if (acEspacioN.selectedItem.@id_espacio == _xmlEspaciosD.espacios[i].@id_espacio) {
			existente = true;
		}
	}		
	if (existente == false) {			
		xmlEspacioN.@id_espacio = acEspacioN.selectedItem.@id_espacio;
		xmlEspacioN.@codigo = acEspacioN.selectedItem.@codigo;
		xmlEspacioN.@denominacion = acEspacioN.selectedItem.@denominacion;
		xmlEspacioN.@origen = acEspacioN.selectedItem.@origen;
		_xmlEspaciosD.appendChild(xmlEspacioN.copy());
		_xmlEspaciosNuevos.appendChild(xmlEspacioN.copy());	
	}				
}

public function fncEliminarEspacio():void
{
	var xmlEspacio:XML = (gridEspaciosA.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Eliminar el Espacio "+ xmlEspacio.@denomesp+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarEspacio, null, Alert.OK);		
}

private function fncConfirmEliminarEspacio(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlEspacio:XML = (gridEspaciosA.selectedItem as XML).copy();
		httpDatosD.addEventListener(ResultEvent.RESULT,fncResultDel);
		httpDatosD.send({rutina:"delete",xmlEspacio:xmlEspacio.toXMLString(),id_titulo:acTituloA.selectedItem.@id_titulo,
				cod_titulo:acTituloA.selectedItem.@codigo});
	}
}

private function fncResultDel(e:Event):void{
	var xmlEspacio:XML = (gridEspaciosA.selectedItem as XML).copy();
	xmlEspacio.@marcado = '1';
	_xmlEspaciosA.espacios[(gridEspaciosA.selectedItem as XML).childIndex()] = xmlEspacio;		
	//Alert.show("La eliminación se registro con exito","título");
	Alert.show("Se ha generado una novedad que estará pendiente de confirmación","NOVEDAD");
	//delete _xmlEspaciosA.espacios[(gridEspaciosA.selectedItem as XML).childIndex()];					
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
		txiCodigoT.text = acTituloA.selectedItem.@codigo;
		httpEspaciosA.send({rutina:"traer_espacios",id_titulo:acTituloA.selectedItem.@id_titulo});
	}		
}
	
private function fncCargarAcTituloA(e:Event):void{
	acTituloA.typedText = acTituloA.text;
	acTituloA.dataProvider = httpAcTituloA.lastResult.titulo;		
}				

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
