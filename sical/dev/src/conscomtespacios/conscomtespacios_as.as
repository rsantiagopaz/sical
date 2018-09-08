import abmtitulos.twtitulo;

import clases.HTTPServices;

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
private var _twTitulo:twtitulo = new twtitulo;
private var _area:String;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{
	if (parentApplication.orgAId != '6') {
		this.currentState = "juntas";
		_area = "juntas";
		rdbVigente.addEventListener("change",fncRefrescar);	
		rdbAnterior.addEventListener("change",fncRefrescar);
	} else {
		_area = "comision";
	}
	httpDatos.url = "conscomtespacios/conscomtespacios.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);
	httpDatos2.url = "conscomtespacios/conscomtespacios.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});			
	//preparo el autocomplete		
	acTituloA.addEventListener(ListEvent.CHANGE,ChangeAcTituloA);
	acTituloA.addEventListener("close",CloseAcTituloA);
	acTituloA.labelField = "@denominacion";		
	httpAcTituloA.url = "conscomtespacios/conscomtespacios.php";
	httpAcTituloA.addEventListener("acceso",acceso);
	httpAcTituloA.addEventListener(ResultEvent.RESULT,fncCargarAcTituloA);		
	httpEspaciosA.url = "conscomtespacios/conscomtespacios.php";
	httpEspaciosA.addEventListener("acceso",acceso);
	httpEspaciosA.addEventListener(ResultEvent.RESULT,fncCargarespaciosA);
	httpEspaciosD.url = "conscomtespacios/conscomtespacios.php";
	httpEspaciosD.addEventListener("acceso",acceso);
	httpEspaciosD.addEventListener(ResultEvent.RESULT,fncCargarespaciosD);		
	httpCodTituloA.url = "conscomtespacios/conscomtespacios.php";
	httpCodTituloA.addEventListener("acceso",acceso);
	httpCodTituloA.addEventListener(ResultEvent.RESULT,fncCargarTituloA);		
	btnGuardar.addEventListener("click",fncImprimir);
	txiCodigoTA.addEventListener("focusOut",fncBuscarTituloA);
	btnBuscar1.addEventListener("click",fncTraerTitulosBoton1);		
}

/*
* Función para ordenar los datos de la columna 'total' de manera numérica, no alfabética:
*/
public function numericSort(a:*,b:*):int
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

private function fncRefrescar(e:Event):void
{
	if (_area == "comision")
		httpEspaciosA.send({rutina:"traer_espacios",id_titulo:acTituloA.selectedItem.@id_titulo});
	else {		
		var opcion:String = (e.target.label.toString() == "Vigente") ? "V" : "A";
		httpEspaciosA.send({rutina:"traer_espacios",id_titulo:acTituloA.selectedItem.@id_titulo,opcion:opcion});
	}
}

private function fncTraerTitulosBoton1(e:Event):void
{
	_twTitulo = new twtitulo;		
	_twTitulo.addEventListener("EventConfirmarTitulo",fncGrabarTituloA);
	PopUpManager.addPopUp(_twTitulo,this,true);
	PopUpManager.centerPopUp(_twTitulo);
}

private function fncGrabarTituloA(e:Event):void
{
	var xmlTitulo:XML = _twTitulo.xmlTitulo;
	PopUpManager.removePopUp(e.target as twtitulo);
	txiCodigoTA.text = xmlTitulo.@codigo;
	httpCodTituloA.send({rutina:"buscar_titulo",codigo:txiCodigoTA.text});
	if (_area == "comision")
		httpEspaciosA.send({rutina:"traer_espacios",id_titulo:xmlTitulo.@id_titulo});
	else {		
		var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
		httpEspaciosA.send({rutina:"traer_espacios",id_titulo:xmlTitulo.@id_titulo,opcion:opcion});
	}	
}

private function fncBuscarTituloA(e:Event):void
{
	if (txiCodigoTA.text != "") {
		httpCodTituloA.send({rutina:"buscar_titulo",codigo:txiCodigoTA.text});
	}		
}		

private function fncCargarTituloA(e:Event):void{
	acTituloA.dataProvider = httpCodTituloA.lastResult.titulo;
	if (acTituloA.selectedIndex!=-1) {		
		if (_area == "comision")
			httpEspaciosA.send({rutina:"traer_espacios",id_titulo:acTituloA.selectedItem.@id_titulo});
		else {
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			httpEspaciosA.send({rutina:"traer_espacios",id_titulo:acTituloA.selectedItem.@id_titulo,opcion:opcion});
		}
	}	
}		

private function fncDatosResult(e:Event):void {
	_xmlEspaciosA = <espacios></espacios>;
	_xmlEspaciosD = <espacios></espacios>;
	_xmlEspaciosNuevos = <espacios></espacios>;
	txiCodigoTA.text = "";		
	acTituloA.text = "";
	acTituloA.typedText = "";
	acTituloA.selectedItem=null;		
	Alert.show("El alta de espacios para el titulo se ha realizado con éxito.");		
}

private function fncDatosResult2(e:Event):void {		
	_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncGuardar(e:Event):void
{		
	var error:String = '';
	
	if (_xmlEspaciosDE.espacios.length() > 0) {
		error += "El título seleccionado ya tiene espacios asignados previamente. Dirígase a la opción de 'Modificación de Espacios en Títulos' del Menú ";
		error += "para agregar o eliminar espacios asignados.\n";
	}
	if (error == '') {
		Alert.yesLabel = "Si";			 
										
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncImprimir(e:Event):void
{	
	if (acTituloA.selectedItem != null) {
		var url:String;
		
		var sortList:Array = getSortOrder(gridEspaciosA);
	
		if (rbHtml.selected == true)
			url = "conscomtespacios/listado_tomo_espacios.php?rutina=tomo_espacios&";
		else
			url = "conscomtespacios/listado_tomo_espacios_pdf.php?rutina=tomo_espacios&";
		
		//Creo los contenedores para enviar datos y recibir respuesta
		var enviar:URLRequest = new URLRequest(url);
		var recibir:URLLoader = new URLLoader();
	 		 
		//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
		var variables:URLVariables = new URLVariables();
		
		variables.id_titulo = acTituloA.selectedItem.@id_titulo;
		
		variables.status = sortList[0];
		variables.field = sortList[1];
		variables.order = sortList[2];
		
		if (_area == "juntas") {
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			variables.opcion = opcion;			
		}					
					
		//Indico que voy a enviar variables dentro de la petición
		enviar.data = variables;
		
		navigateToURL(enviar);	
	} else {
		Alert.show("Debe seleccionar un título\n","E R R O R");
	}
}

private function fncConfirmGuardar(e:CloseEvent):void
{
	if(e.detail==Alert.YES) 
	{
			
	}
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
		txiCodigoTA.text = acTituloA.selectedItem.@codigo;
		if (_area == "comision")
			httpEspaciosA.send({rutina:"traer_espacios",id_titulo:acTituloA.selectedItem.@id_titulo});
		else {		
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			httpEspaciosA.send({rutina:"traer_espacios",id_titulo:acTituloA.selectedItem.@id_titulo,opcion:opcion});
		}		
	}		
}		
	
private function fncCargarAcTituloA(e:Event):void{
	acTituloA.typedText = acTituloA.text;
	acTituloA.dataProvider = httpAcTituloA.lastResult.titulo;		
}				

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@denominacion;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}