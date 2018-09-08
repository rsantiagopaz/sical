import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlEscuela:XML = <escuelas id_escuela_carrera_espacio="" id_carrera="" cod_carrera="" id_espacio="" cod_espacio="" denomcar="" id_escuela="" cod_escuela="" id_nivel="" nombre="" origen=""/>;
[Bindable] private var _xmlEscuelas:XML = <escuelas></escuelas>;	
[Bindable] private var _xmlEscuelasDE:XML = <escuelas></escuelas>;
[Bindable] private var _xmlEscuelasNuevos:XML = <escuelas></escuelas>;
[Bindable] private var _xmlTiposEscuelas:XML = <tiposescuelas></tiposescuelas>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatosD:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpEscuelas:HTTPServices = new HTTPServices;	
private var httpAcEspacio:HTTPServices = new HTTPServices;
private var httpAcEscuela:HTTPServices = new HTTPServices;	
private var httpAcCarrera:HTTPServices = new HTTPServices;
private var httpCodEspacio:HTTPServices = new HTTPServices;
private var httpCodCarrera:HTTPServices = new HTTPServices;
private var httpCodEscuela:HTTPServices = new HTTPServices;

public function get xmlTiposEscuelas():XML{return _xmlTiposEscuelas.copy();}

public function fncInit():void
{
	httpDatos.url = "escuelascarreras/escuelascarreras.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatosD.url = "escuelascarreras/escuelascarreras.php";
	httpDatosD.addEventListener("acceso",acceso);
	httpDatos2.url = "escuelascarreras/escuelascarreras.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);	
	//preparo el autocomplete				
	acEscuela.addEventListener(ListEvent.CHANGE,ChangeAcEscuela);
	acEscuela.addEventListener("close",CloseAcEscuela);		
	acEscuela.labelField = "@nombre";		
	httpAcEscuela.url = "escuelascarreras/escuelascarreras.php";
	httpAcEscuela.addEventListener("acceso",acceso);
	httpAcEscuela.addEventListener(ResultEvent.RESULT,fncCargarAcEscuela);
	//preparo el autocomplete		
	acEspacio.addEventListener(ListEvent.CHANGE,ChangeAcEspacio);
	acEspacio.addEventListener("close",CloseAcEspacio);
	acEspacio.labelField = "@denominacion";
	//preparo el autocomplete		
	acCarrera.addEventListener(ListEvent.CHANGE,ChangeAcCarrera);
	acCarrera.addEventListener("close",CloseAcCarrera);
	acCarrera.labelField = "@nombre";
	
	httpCodEspacio.url = "escuelascarreras/escuelascarreras.php";
	httpCodEspacio.addEventListener("acceso",acceso);
	httpCodEspacio.addEventListener(ResultEvent.RESULT,fncCargarEspacio);
	httpCodCarrera.url = "escuelascarreras/escuelascarreras.php";
	httpCodCarrera.addEventListener("acceso",acceso);
	httpCodCarrera.addEventListener(ResultEvent.RESULT,fncCargarCarrera);
	
	httpCodEscuela.url = "escuelascarreras/escuelascarreras.php";
	httpCodEscuela.addEventListener("acceso",acceso);
	httpCodEscuela.addEventListener(ResultEvent.RESULT,fncCargarEscuela);
	
	httpAcEspacio.url = "escuelascarreras/escuelascarreras.php";
	httpAcEspacio.addEventListener("acceso",acceso);
	httpAcEspacio.addEventListener(ResultEvent.RESULT,fncCargarAcEspacio);
	httpAcCarrera.url = "escuelascarreras/escuelascarreras.php";
	httpAcCarrera.addEventListener("acceso",acceso);
	httpAcCarrera.addEventListener(ResultEvent.RESULT,fncCargarAcCarrera);
	httpEscuelas.url = "escuelascarreras/escuelascarreras.php";
	httpEscuelas.addEventListener("acceso",acceso);
	httpEscuelas.addEventListener(ResultEvent.RESULT,fncCargarEscuelas);
	btnAgregar.addEventListener("click",fncAgregar);
	btnBuscar.addEventListener("click",fncBuscar);
	
	txiCodigoE.addEventListener("focusOut",fncBuscarEspacio);
	txiCodigoC.addEventListener("focusOut",fncBuscarCarrera);
	txiCodigoS.addEventListener("focusOut",fncBuscarEscuela);
}

private function fncCargarEspacio(e:Event):void{
	acEspacio.dataProvider = httpCodEspacio.lastResult.espacio;		
}

private function fncCargarCarrera(e:Event):void{
	acCarrera.dataProvider = httpCodCarrera.lastResult.carrera;		
}

private function fncCargarEscuela(e:Event):void{
	acEscuela.dataProvider = httpCodEscuela.lastResult.escuela;
	if (acEscuela.selectedIndex!=-1) {
		httpEscuelas.send({rutina:"traer_carreras_espacios",id_escuela:acEscuela.selectedItem.@id_escuela});
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

private function fncAgregar(e:Event):void
{		
	var error:String = '';
	if (acEscuela.selectedItem==null) {
		error += "Debe seleccionar una escuela.\n";
	}
	if (acEspacio.selectedItem==null) {
		error += "Debe seleccionar un espacio.\n";
	}
	if (acCarrera.selectedItem==null) {
		error += "Debe seleccionar una carrera.\n";
	}
	if (error == '') {			
		var existente : Boolean = false;
		for (var i:int = 0;i < _xmlEscuelas.escuelas.length();i++) {
			if (acEscuela.selectedItem.@id_escuela == _xmlEscuelas.escuelas[i].@id_escuela && 
				acCarrera.selectedItem.@id_carrera == _xmlEscuelas.escuelas[i].@id_carrera && 
				acEscuela.selectedItem.@id_espacio == _xmlEscuelas.escuelas[i].@id_espacio) {
				existente = true;
			}
		}		
		if (existente == false) {				
			_xmlEscuela.@id_carrera = acCarrera.selectedItem.@id_carrera;
			_xmlEscuela.@cod_carrera = acCarrera.selectedItem.@codigo;
			_xmlEscuela.@id_espacio = acEspacio.selectedItem.@id_espacio;
			_xmlEscuela.@cod_espacio = acEspacio.selectedItem.@codigo;
			_xmlEscuela.@id_escuela = acEscuela.selectedItem.@id_escuela;
			_xmlEscuela.@cod_escuela = acEscuela.selectedItem.@codigo;				
			_xmlEscuela.@codigo = acEscuela.selectedItem.@codigo;
			//xmlEscuelaA.@nombre = acCarreraN.selectedItem.@nombre;
			_xmlEscuela.@nombre = acCarrera.selectedItem.@nombre;
			_xmlEscuela.@denominacion = acEspacio.selectedItem.@denominacion;
			_xmlEscuela.@origen = acEscuela.selectedItem.@origen;						
			httpDatos.addEventListener(ResultEvent.RESULT,fncResultAdd);				
			httpDatos.send({rutina:"insert",xmlEscuela:_xmlEscuela.toXMLString(),id_espacio:acEspacio.selectedItem.@id_espacio,
				id_carrera:acCarrera.selectedItem.@id_carrera});									
		}
	} else {
		Alert.show(error,"E R R O R");
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

/*
* Función para ordenar los datos de la columna 'cod_carrera' de manera numérica, no alfabética:
*/        
public function numericSortCarr(a:*,b:*):int
{
	var nA:Number=Number(a.@cod_carrera);
    var nB:Number=Number(b.@cod_carrera);
    if (nA<nB){
     	return -1;
    }else if (nA>nB){
     	return 1;
    }else {
        return 0;
    }
}

/*
* Función para ordenar los datos de la columna 'cod_espacio' de manera numérica, no alfabética:
*/
public function numericSortEsp(a:*,b:*):int
{
	var nA:Number=Number(a.@cod_espacio);
    var nB:Number=Number(b.@cod_espacio);
    if (nA<nB){
     	return -1;
    }else if (nA>nB){
     	return 1;
    }else {
        return 0;
    }
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
		httpEscuelas.send({rutina:"traer_carreras_espacios",id_escuela:acEscuela.selectedItem.@id_escuela});				
	}		
}

private function CloseAcCarrera(e:Event):void {
	if (acCarrera.selectedIndex!=-1) {
		txiCodigoC.text = acCarrera.selectedItem.@codigo;			
	}		
}

private function CloseAcEspacio(e:Event):void {
	if (acEspacio.selectedIndex!=-1) {
		txiCodigoE.text = acEspacio.selectedItem.@codigo;			
	}		
}

public function fncEliminarEscuela():void
{
	var xmlEscuela:XML = (gridEscuelas.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Eliminar el Espacio "+ xmlEscuela.@denominacion+" de la Carrera "+ xmlEscuela.@nombre +"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarEscuela, null, Alert.OK);		
}

private function fncConfirmEliminarEscuela(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlEscuela:XML = (gridEscuelas.selectedItem as XML).copy();
		httpDatosD.addEventListener(ResultEvent.RESULT,fncResultDel);
		httpDatosD.send({rutina:"delete",xmlEscuela:xmlEscuela.toXMLString()});
	}
}

private function fncResultDel(e:Event):void{		
	Alert.show("La eliminación se registro con exito","escuela");
	delete _xmlEscuelas.escuelas[(gridEscuelas.selectedItem as XML).childIndex()];					
	httpDatosD.removeEventListener(ResultEvent.RESULT,fncResultDel);
}		
	
private function fncCargarEscuelas(e:Event):void {
	_xmlEscuelas = <escuelas></escuelas>;
	_xmlEscuelas.appendChild(httpEscuelas.lastResult.escuelas);		
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

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
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
