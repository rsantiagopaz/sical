import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlTitulo:XML = <titulos id_tomo_espacio="" id_espacio="" cod_espacio="" cod_titulo="" denomtit="" id_tipo_titulo="" cod_tipo_titulo="" tipo="" id_tipo_clasificacion="" denomcar="" denomclas="" cod_tipo_clasificacion="" cod_nivel="" origen=""/>;
[Bindable] private var _xmlTitulos:XML = <titulos></titulos>;	
[Bindable] private var _xmlTitulosDE:XML = <titulos></titulos>;
[Bindable] private var _xmlTitulosNuevos:XML = <titulos></titulos>;
[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatosD:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpTitulos:HTTPServices = new HTTPServices;	
private var httpAcEspacio:HTTPServices = new HTTPServices;
private var httpAcTitulo:HTTPServices = new HTTPServices;	
private var httpAcCarrera:HTTPServices = new HTTPServices;
private var httpCodTitulo:HTTPServices = new HTTPServices;
private var httpCodEspacio:HTTPServices = new HTTPServices;
private var httpCodCarrera:HTTPServices = new HTTPServices;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{
	httpDatos.url = "incumbtitulosespacios/incumbtitulosespacios.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatosD.url = "incumbtitulosespacios/incumbtitulosespacios.php";
	httpDatosD.addEventListener("acceso",acceso);
	httpDatos2.url = "incumbtitulosespacios/incumbtitulosespacios.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});
	//preparo el autocomplete				
	acTitulo.addEventListener(ListEvent.CHANGE,ChangeAcTitulo);
	acTitulo.addEventListener("close",CloseAcTitulo);	
	acTitulo.labelField = "@denominacion";		
	httpAcTitulo.url = "incumbtitulosespacios/incumbtitulosespacios.php";
	httpAcTitulo.addEventListener("acceso",acceso);
	httpAcTitulo.addEventListener(ResultEvent.RESULT,fncCargarAcTitulo);			
	//preparo el autocomplete		
	acEspacio.addEventListener(ListEvent.CHANGE,ChangeAcEspacio);
	acEspacio.addEventListener("close",CloseAcEspacio);
	acEspacio.labelField = "@denominacion";
	//preparo el autocomplete		
	acCarrera.addEventListener(ListEvent.CHANGE,ChangeAcCarrera);
	acCarrera.addEventListener("close",CloseAcCarrera);
	acCarrera.labelField = "@nombre";
	httpAcEspacio.url = "incumbtitulosespacios/incumbtitulosespacios.php";
	httpAcEspacio.addEventListener("acceso",acceso);
	httpAcEspacio.addEventListener(ResultEvent.RESULT,fncCargarAcEspacio);
	httpAcCarrera.url = "incumbtitulosespacios/incumbtitulosespacios.php";
	httpAcCarrera.addEventListener("acceso",acceso);
	httpAcCarrera.addEventListener(ResultEvent.RESULT,fncCargarAcCarrera);
	httpTitulos.url = "incumbtitulosespacios/incumbtitulosespacios.php";
	httpTitulos.addEventListener("acceso",acceso);
	httpTitulos.addEventListener(ResultEvent.RESULT,fncCargarTitulos);
	
	httpCodTitulo.url = "incumbtitulosespacios/incumbtitulosespacios.php";
	httpCodTitulo.addEventListener("acceso",acceso);
	httpCodTitulo.addEventListener(ResultEvent.RESULT,fncCargarTitulo);
	
	httpCodEspacio.url = "incumbtitulosespacios/incumbtitulosespacios.php";
	httpCodEspacio.addEventListener("acceso",acceso);
	httpCodEspacio.addEventListener(ResultEvent.RESULT,fncCargarEspacio);
	httpCodCarrera.url = "incumbtitulosespacios/incumbtitulosespacios.php";
	httpCodCarrera.addEventListener("acceso",acceso);
	httpCodCarrera.addEventListener(ResultEvent.RESULT,fncCargarCarrera);
	
	btnAgregar.addEventListener("click",fncAgregar);
	btnBuscar.addEventListener("click",fncBuscar);
	
	txiCodigoT.addEventListener("focusOut",fncBuscarTitulo);		
	txiCodigoE.addEventListener("focusOut",fncBuscarEspacio);
	txiCodigoC.addEventListener("focusOut",fncBuscarCarrera);
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

private function CloseAcCarrera(e:Event):void {
	if (acCarrera.selectedIndex!=-1) {
		txiCodigoC.text = acCarrera.selectedItem.@codigo;			
	}		
}

private function CloseAcTitulo(e:Event):void {
	if (acTitulo.selectedIndex!=-1) {
		txiCodigoT.text = acTitulo.selectedItem.@codigo;			
	}		
}

private function CloseAcEspacio(e:Event):void {
	if (acEspacio.selectedIndex!=-1) {
		txiCodigoE.text = acEspacio.selectedItem.@codigo;			
	}		
}

private function fncBuscarCarrera(e:Event):void
{
	if (txiCodigoC.text != "") {
		httpCodCarrera.send({rutina:"buscar_carrera",codigo:txiCodigoC.text});	
	}		
}

private function fncCargarTitulo(e:Event):void{
	acTitulo.dataProvider = httpCodTitulo.lastResult.titulo;			
}

private function fncCargarEspacio(e:Event):void{
	acEspacio.dataProvider = httpCodEspacio.lastResult.espacio;		
}

private function fncCargarCarrera(e:Event):void{
	acCarrera.dataProvider = httpCodCarrera.lastResult.carrera;		
}

private function fncDatosResult(e:Event):void {
	_xmlTitulos = <titulos></titulos>;		
	_xmlTitulosNuevos = <titulos></titulos>;
	Alert.show("El alta de titulos para el espacio se ha realizado con éxito.");		
}

private function fncDatosResult2(e:Event):void {		
	_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncAgregar(e:Event):void
{		
	var error:String = '';
	if (acTitulo.selectedItem==null) {
		error += "Debe seleccionar un título.\n";
	}
	/*if (acCarreraN.selectedItem==null) {
		error += "Debe seleccionar una carrera.\n";
	}*/
	if (error == '') {			
		var existente : Boolean = false;
		for (var i:int = 0;i < _xmlTitulos.titulos.length();i++) {
			if (acTitulo.selectedItem.@id_titulo == _xmlTitulos.titulos[i].@id_titulo && 
				acEspacio.selectedItem.@id_espacio == _xmlTitulos.titulos[i].@id_espacio && 
				acCarrera.selectedItem.@id_carrera == _xmlTitulos.titulos[i].@id_carrera &&
				cmbTipoTitulo.selectedItem.@id_tipo_titulo == _xmlTitulos.titulos[i].@id_tipo_titulo) {
				existente = true;
			}
		}		
		if (existente == false) {				
			//xmlTituloA.@id_carrera = acCarreraN.selectedItem.@id_carrera;
			_xmlTitulo.@cod_carrera = acCarrera.selectedItem.@codigo;
			_xmlTitulo.@id_titulo = acTitulo.selectedItem.@id_titulo;
			_xmlTitulo.@id_espacio = acEspacio.selectedItem.@id_espacio;
			_xmlTitulo.@id_carrera = acCarrera.selectedItem.@id_carrera;
			_xmlTitulo.@cod_espacio = acEspacio.selectedItem.@codigo;
			_xmlTitulo.@id_tipo_titulo = cmbTipoTitulo.selectedItem.@id_tipo_titulo;
			_xmlTitulo.@cod_tipo_titulo = cmbTipoTitulo.selectedItem.@cod_tipo_titulo;
			_xmlTitulo.@id_tipo_clasificacion = cmbTipoClas.selectedItem.@id_tipo_clasificacion;
			_xmlTitulo.@tipo = cmbTipoTitulo.selectedItem.@tipo;
			_xmlTitulo.@cod_titulo = acTitulo.selectedItem.@codigo;
			//xmlTituloA.@nombre = acCarreraN.selectedItem.@nombre;
			_xmlTitulo.@denomtit = acTitulo.selectedItem.@denominacion;
			_xmlTitulo.@denomclas = cmbTipoClas.selectedItem.@denominacion;
			_xmlTitulo.@cod_tipo_clasificacion = cmbTipoClas.selectedItem.@codigo;
			_xmlTitulo.@origen = acTitulo.selectedItem.@origen;
			httpDatos.addEventListener(ResultEvent.RESULT,fncResultAdd);				
			httpDatos.send({rutina:"insert",xmlTitulo:_xmlTitulo.toXMLString(),id_espacio:acEspacio.selectedItem.@id_espacio,
				id_carrera:acCarrera.selectedItem.@id_carrera});								
		}
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncResultAdd(e:Event):void{
	_xmlTitulo.@id_tomo_espacio = httpDatos.lastResult.insert_id;
	var existe_codigo : String =  httpDatos.lastResult.codigos.@cc;
	var carrerasespacios : String =  httpDatos.lastResult.carrerasespacios.@cc1;
	if (existe_codigo=="0"){
		if (carrerasespacios!="0") {
			var existe_espacio : String = httpDatos.lastResult.espacios.@cc2;
			if (existe_espacio == "0") {
				_xmlTitulos.appendChild(_xmlTitulo.copy());
				Alert.show("El alta se registro con éxito","Espacios en Títulos");						
			} else {
				var existe_novedad : String =  httpDatos.lastResult.novedades.@cc3;
				if (existe_novedad!="0") {
					_xmlTitulos.appendChild(_xmlTitulo.copy());
					Alert.show("El alta se registro con éxito","Espacios en Títulos");
				} else {
					Alert.show("Se ha generado una novedad que estará pendiente de confirmación","NOVEDAD");
				}						
			}
		} else
			Alert.show("El espacio y la carrera seleccionados no están vinculados","Espacios en Títulos");						
	}else{
		Alert.show("El título seleccionado ya ha sido asignado al espacio","ERROR");	
	}				
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}		

private function fncCargarAcTitulo(e:Event):void{
	acTitulo.typedText = acTitulo.text;
	acTitulo.dataProvider = httpAcTitulo.lastResult.titulo;		
}

private function ChangeAcTitulo(e:Event):void{
	if (acTitulo.text.length==3){
		httpAcTitulo.send({rutina:"traer_titulos_n",denominacion:acTitulo.text});
	}
}

private function fncBuscar(e:Event):void {
	if (acEspacio.selectedIndex!=-1 && acCarrera.selectedIndex!=-1) {
		httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,id_carrera:acCarrera.selectedItem.@id_carrera});
	}						
}

public function fncEliminarTitulo():void
{
	var xmlTitulo:XML = (gridTitulos.selectedItem as XML).copy();
	Alert.show(xmlTitulo.toXMLString());
	Alert.show("¿Realmente desea Eliminar el Título "+ xmlTitulo.@denomtit+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarTitulo, null, Alert.OK);		
}

private function fncConfirmEliminarTitulo(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlTitulo:XML = (gridTitulos.selectedItem as XML).copy();
		httpDatosD.addEventListener(ResultEvent.RESULT,fncResultDel);
		httpDatosD.send({rutina:"delete",xmlTitulo:xmlTitulo.toXMLString(),id_espacio:acEspacio.selectedItem.@id_espacio,
				id_carrera:acCarrera.selectedItem.@id_carrera});
	}
}

private function fncResultDel(e:Event):void{		
	//Alert.show("La eliminación se registro con exito","título");
	var xmlTitulo:XML = (gridTitulos.selectedItem as XML).copy();
	xmlTitulo.@marcado = '1';
	_xmlTitulos.titulos[(gridTitulos.selectedItem as XML).childIndex()] = xmlTitulo;
	//httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,id_carrera:acCarrera.selectedItem.@id_carrera});
	Alert.show("Se ha generado una novedad que estará pendiente de confirmación","NOVEDAD");
	//delete _xmlTitulos.titulos[(gridTitulos.selectedItem as XML).childIndex()];					
	httpDatosD.removeEventListener(ResultEvent.RESULT,fncResultDel);
}		
	
private function fncCargarTitulos(e:Event):void {
	Alert.show((httpTitulos.lastResult.titulos as XMLList)[0].toXMLString()); 
	_xmlTitulos = <titulos></titulos>;
	_xmlTitulos.appendChild(httpTitulos.lastResult.titulos);		
}		

private function ChangeAcEspacio(e:Event):void{
	if (acEspacio.text.length==3){
		httpAcEspacio.send({rutina:"traer_espacios_n",denominacion:acEspacio.text});
	}
}		
	
private function fncCargarAcEspacio(e:Event):void{
	acEspacio.typedText = acEspacio.text;
	acEspacio.dataProvider = httpAcEspacio.lastResult.espacio;		
}

private function ChangeAcCarrera(e:Event):void{
	if (acCarrera.text.length==3){
		httpAcCarrera.send({rutina:"traer_carreras",nombre:acCarrera.text});
	}
}

private function fncCargarAcCarrera(e:Event):void{
	acCarrera.typedText = acCarrera.text;
	acCarrera.dataProvider = httpAcCarrera.lastResult.carrera;		
}		

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
