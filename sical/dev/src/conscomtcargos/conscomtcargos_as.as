import abmtitulos.twtitulo;

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
	httpDatos.url = "conscomtcargos/conscomtcargos.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);
	httpDatos2.url = "conscomtcargos/conscomtcargos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});		
	httpAcCarreraN.url = "conscomtcargos/conscomtcargos.php";
	httpAcCarreraN.addEventListener("acceso",acceso);			
	//preparo el autocomplete		
	acTituloA.addEventListener(ListEvent.CHANGE,ChangeAcTituloA);
	acTituloA.addEventListener("close",CloseAcTituloA);
	acTituloA.labelField = "@denominacion";		
	httpAcTituloA.url = "conscomtcargos/conscomtcargos.php";
	httpAcTituloA.addEventListener("acceso",acceso);
	httpAcTituloA.addEventListener(ResultEvent.RESULT,fncCargarAcTituloA);		
	httpCargosA.url = "conscomtcargos/conscomtcargos.php";
	httpCargosA.addEventListener("acceso",acceso);
	httpCargosA.addEventListener(ResultEvent.RESULT,fncCargarcargosA);
	httpCargosD.url = "conscomtcargos/conscomtcargos.php";
	httpCargosD.addEventListener("acceso",acceso);
	httpCargosD.addEventListener(ResultEvent.RESULT,fncCargarcargosD);		
	httpCodTituloA.url = "conscomtcargos/conscomtcargos.php";
	httpCodTituloA.addEventListener("acceso",acceso);
	httpCodTituloA.addEventListener(ResultEvent.RESULT,fncCargarTituloA);		
	btnGuardar.addEventListener("click",fncImprimir);
	txiCodigoTA.addEventListener("focusOut",fncBuscarTituloA);
	btnBuscar1.addEventListener("click",fncTraerTitulosBoton1);	
	txiCodigoTA.setFocus();
}

/*
* Función para ordenar los datos de la columna 'total' de manera numérica, no alfabética:
*/
public function numericSort(a:*,b:*):int
{
	var nA:Number=Number(a.@cod_cargo);
    var nB:Number=Number(b.@cod_cargo);
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
		httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo});
	else {		
		var opcion:String = (e.target.label.toString() == "Vigente") ? "V" : "A";
		httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo,opcion:opcion});
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
		httpCargosA.send({rutina:"traer_cargos",id_titulo:xmlTitulo.@id_titulo});
	else {
		var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
		httpCargosA.send({rutina:"traer_cargos",id_titulo:xmlTitulo.@id_titulo,opcion:opcion});
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
			httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo});
		else {
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo,opcion:opcion});
		}
	}	
}

private function fncDatosResult(e:Event):void {
	_xmlCargosA = <cargos></cargos>;
	_xmlCargosD = <cargos></cargos>;
	_xmlCargosNuevos = <cargos></cargos>;
	txiCodigoTA.text = "";		
	acTituloA.text = "";
	acTituloA.typedText = "";
	acTituloA.selectedItem=null;		
	Alert.show("El alta de cargos para el titulo se ha realizado con éxito.");		
}

private function fncDatosResult2(e:Event):void {		
	_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncGuardar(e:Event):void
{		
	var error:String = '';
	
	if (_xmlCargosDE.cargos.length() > 0) {
		error += "El título seleccionado ya tiene cargos asignados previamente. Dirígase a la opción de 'Modificación de Cargos en Títulos' del Menú ";
		error += "para agregar o eliminar cargos asignados.\n";
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
		
		var sortList:Array = getSortOrder(gridCargosA);
		
		if (rbHtml.selected == true)
			url = "conscomtcargos/listado_tomo_cargos.php?rutina=tomo_cargos&";
		else
			url = "conscomtcargos/listado_tomo_cargos_pdf.php?rutina=tomo_cargos&";
		
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

private function fncAgregar(e:Event):void
{		
	var error:String = '';
	
	/*if (acCarreraN.selectedItem==null) {
		error += "Debe seleccionar una carrera.\n";
	}*/
	if (error == '') {
		var xmlCargoN:XML = <cargos id_tomo_cargo="" id_cargo="" cod_cargo="" id_tipo_titulo="" cod_tipo_titulo="" tipo="" 
			id_tipo_clasificacion="" denomcar="" denomclas="" cod_tipo_clasificacion="" cod_nivel="" origen=""/>;
		var existente : Boolean = false;			
	} else {
		Alert.show(error,"E R R O R");
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

private function ChangeAcTituloA(e:Event):void{
	if (acTituloA.text.length==3){
		httpAcTituloA.send({rutina:"traer_titulos",denominacion:acTituloA.text});
	}
}

private function CloseAcTituloA(e:Event):void {
	if (acTituloA.selectedIndex!=-1) {
		txiCodigoTA.text = acTituloA.selectedItem.@codigo;		
		if (_area == "comision")
			httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo});
		else {
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo,opcion:opcion});
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
