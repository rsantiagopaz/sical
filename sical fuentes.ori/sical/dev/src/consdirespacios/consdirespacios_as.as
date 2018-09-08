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
include "../asincludes/numericSort.as";

[Bindable] private var _xmlTitulo:XML = <titulos id_tomo_espacio="" id_espacio="" cod_espacio="" denomtit="" id_tipo_titulo="" cod_tipo_titulo="" tipo="" id_tipo_clasificacion="" denomcar="" denomclas="" cod_tipo_clasificacion="" cod_nivel="" origen=""/>;
[Bindable] private var _xmlTitulos:XML = <titulos></titulos>;	
[Bindable] private var _xmlTitulosDE:XML = <titulos></titulos>;
[Bindable] private var _xmlTitulosNuevos:XML = <titulos></titulos>;
[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpTitulos:HTTPServices = new HTTPServices;	
private var httpAcEspacio:HTTPServices = new HTTPServices;
private var httpAcTitulo:HTTPServices = new HTTPServices;
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodTitulo:HTTPServices = new HTTPServices;
private var httpCodEspacio:HTTPServices = new HTTPServices;
private var httpCodCarrera:HTTPServices = new HTTPServices;
private var _twEspacio:twespacio = new twespacio;
private var _twCarrera:twcarrera = new twcarrera;
private var _area:String;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{
	if (parentApplication.orgAId == '1' || parentApplication.orgAId == '2' || 
		parentApplication.orgAId == '3' || parentApplication.orgAId == '4' ||
		parentApplication.orgAId == '11') {
		this.currentState = "juntas";
		_area = "juntas";
		rdbVigente.addEventListener("change",fncRefrescar);	
		rdbAnterior.addEventListener("change",fncRefrescar);
	} else {
		_area = "direccion";
	}
	httpDatos.url = "consdirespacios/consdirespacios.php";
	httpDatos.addEventListener("acceso",acceso);		
	httpDatos2.url = "consdirespacios/consdirespacios.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});				
	httpAcTitulo.url = "consdirespacios/consdirespacios.php";
	httpAcTitulo.addEventListener("acceso",acceso);
	//preparo el autocomplete		
	acCarreraN.addEventListener(ListEvent.CHANGE,ChangeAcCarreraN);
	acCarreraN.addEventListener(ListEvent.CHANGE,CloseAcCarreraN);
	acCarreraN.labelField = "@nombre";
	//preparo el autocomplete		
	acEspacio.addEventListener(ListEvent.CHANGE,ChangeAcEspacio);
	acEspacio.addEventListener("close",CloseAcEspacio);
	acEspacio.labelField = "@denominacion";
	httpAcEspacio.url = "consdirespacios/consdirespacios.php";
	httpAcEspacio.addEventListener("acceso",acceso);
	httpAcEspacio.addEventListener(ResultEvent.RESULT,fncCargarAcEspacio);
	
	httpAcCarreraN.url = "espaciosentitulos/espaciosentitulos.php";
	httpAcCarreraN.addEventListener("acceso",acceso);
	httpAcCarreraN.addEventListener(ResultEvent.RESULT,fncCargarAcCarreraN);
	
	httpTitulos.url = "consdirespacios/consdirespacios.php";
	httpTitulos.addEventListener("acceso",acceso);
	httpTitulos.addEventListener(ResultEvent.RESULT,fncCargarTitulos);
	
	httpCodTitulo.url = "consdirespacios/consdirespacios.php";
	httpCodTitulo.addEventListener("acceso",acceso);
	
	httpCodEspacio.url = "consdirespacios/consdirespacios.php";
	httpCodEspacio.addEventListener("acceso",acceso);
	httpCodEspacio.addEventListener(ResultEvent.RESULT,fncCargarEspacio);
	
	httpCodCarrera.url = "espaciosentitulos/espaciosentitulos.php";
	httpCodCarrera.addEventListener("acceso",acceso);
	httpCodCarrera.addEventListener(ResultEvent.RESULT,fncCargarCarrera);
			
	txiCodigoC.addEventListener("focusOut",fncBuscarEspacio);
	txiCodigoCa.addEventListener("focusOut",fncBuscarCarrera);
	btnImprimir.addEventListener("click",fncImprimir);
	//btnGuardar.addEventListener("click",fncGuardar);
	btnBuscar3.addEventListener("click",fncTraerEspaciosBoton);
	btnBuscar4.addEventListener("click",fncTraerCarrerasBoton);
}

private function fncRefrescar(e:Event):void
{
	var haycarrera:String = 'N';
	var id_carrera:String = '';
	if (acCarreraN.selectedIndex!=-1) {
		haycarrera = 'S';
		id_carrera = acCarreraN.selectedItem.@id_carrera;			
	}
	if (_area == "direccion")
		httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:haycarrera,id_carrera:id_carrera});
	else {
		var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
		httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:haycarrera,id_carrera:id_carrera,opcion:opcion});
	}
}

private function fncTraerCarrerasBoton(e:Event):void
{
	_twCarrera = new twcarrera;
	_twCarrera.todos = 1;
	_twCarrera.addEventListener("EventConfirmarCarrera",fncGrabarCarrera);
	PopUpManager.addPopUp(_twCarrera,this,true);
	PopUpManager.centerPopUp(_twCarrera);
}

private function fncGrabarCarrera(e:Event):void
{
	var xmlCarrera:XML = _twCarrera.xmlCarrera;
	PopUpManager.removePopUp(e.target as twcarrera);
	txiCodigoCa.text = xmlCarrera.@codigo;
	httpCodCarrera.send({rutina:"buscar_carrera",codigo:txiCodigoCa.text});		
}

private function fncCargarAcCarreraN(e:Event):void{
	acCarreraN.typedText = acCarreraN.text;
	acCarreraN.dataProvider = httpAcCarreraN.lastResult.carreras;		
}

private function fncBuscarCarrera(e:Event):void
{
	if (txiCodigoCa.text != "") {
		httpCodCarrera.send({rutina:"buscar_carrera",codigo:txiCodigoCa.text});	
	} else {
		acCarreraN.text = "";
		acCarreraN.typedText = "";
		acCarreraN.selectedIndex = -1;
		if (_area == "direccion")
			httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:'N',id_carrera:''});
		else {
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:'N',id_carrera:'',opcion:opcion});
		}
	}		
}

private function fncCargarCarrera(e:Event):void{
	acCarreraN.dataProvider = httpCodCarrera.lastResult.carreras;
	if (acEspacio.selectedIndex!=-1) {
		if (_area == "direccion")			
			httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:'S',id_carrera:acCarreraN.selectedItem.@id_carrera});
		else {
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:'S',id_carrera:acCarreraN.selectedItem.@id_carrera,opcion:opcion});
		}
	}
}

private function ChangeAcCarreraN(e:Event):void{
	if (acCarreraN.text.length==3){
		httpAcCarreraN.send({rutina:"traer_carreras",nombre:acCarreraN.text});
	}
}

private function fncTraerEspaciosBoton(e:Event):void
{
	_twEspacio = new twespacio;
	_twEspacio.addEventListener("EventConfirmarEspacio",fncGrabarEspacio);
	PopUpManager.addPopUp(_twEspacio,this,true);
	PopUpManager.centerPopUp(_twEspacio);
}

private function fncGrabarEspacio(e:Event):void
{
	var xmlEspacio:XML = _twEspacio.xmlEspacio;
	PopUpManager.removePopUp(e.target as twespacio);
	txiCodigoC.text = xmlEspacio.@codigo;
	httpCodEspacio.send({rutina:"buscar_espacio",codigo:txiCodigoC.text});
	httpTitulos.send({rutina:"traer_titulos",id_espacio:xmlEspacio.@id_espacio});	
}

private function fncImprimir(e:Event):void
{	
	var haycarrera:String = 'N';
	var id_carrera:String = '';
	
	var sortList:Array = getSortOrder(gridTitulos);
	
	//Creo los contenedores para enviar datos y recibir respuesta
	var enviar:URLRequest = new URLRequest("consdirespacios/listado_titulos_por_espacio.php?rutina=listado_titulos&");
	var recibir:URLLoader = new URLLoader();
 		 
	//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
	var variables:URLVariables = new URLVariables();
	
	variables.id_espacio = acEspacio.selectedItem.@id_espacio;
	variables.status = sortList[0];
	variables.field = sortList[1];
	variables.order = sortList[2];
	
	if (acCarreraN.selectedIndex!=-1) {
		haycarrera = 'S';
		id_carrera = acCarreraN.selectedItem.@id_carrera;			
	}
	
	variables.haycarrera = haycarrera;
	variables.id_carrera = id_carrera;
	
	if (_area == "juntas") {
		var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
		variables.opcion = opcion;			
	}
				
	//Indico que voy a enviar variables dentro de la petición
	enviar.data = variables;
	
	navigateToURL(enviar);
}

private function fncBuscarEspacio(e:Event):void
{
	if (txiCodigoC.text != "") {		
		httpCodEspacio.send({rutina:"buscar_espacio",codigo:txiCodigoC.text});	
	}		
}		

private function fncCargarEspacio(e:Event):void{
	acEspacio.dataProvider = httpCodEspacio.lastResult.espacios;	
	var haycarrera:String = 'N';
	var id_carrera:String = '';
	if (acEspacio.selectedIndex!=-1) {		
		if (acCarreraN.selectedIndex!=-1) {
			haycarrera = 'S';
			id_carrera = acCarreraN.selectedItem.@id_carrera;
		}
		if (_area == "direccion")
			httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:haycarrera,id_carrera:id_carrera});
		else {
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:haycarrera,id_carrera:id_carrera,opcion:opcion});
		}
	}		
}	

private function fncDatosResult(e:Event):void {
	_xmlTitulos = <titulos></titulos>;		
	_xmlTitulosNuevos = <titulos></titulos>;
	Alert.show("El alta de titulos para la titulo se ha realizado con éxito.");		
}

private function fncDatosResult2(e:Event):void {		
	_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}		

private function fncResultAdd(e:Event):void{
	_xmlTitulo.@id_tomo_espacio = httpDatos.lastResult.insert_id;
	var existe_codigo : String =  httpDatos.lastResult.codigos.@cc;
	if (existe_codigo=="0"){
		Alert.show("El alta se registro con éxito","Espacios en Títulos");				
	}else{
		Alert.show("El título seleccionado ya ha sido asignado al espacio","ERROR");	
	}
	_xmlTitulos.appendChild(_xmlTitulo.copy());		
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}

private function CloseAcCarreraN(e:Event):void {
	if (acCarreraN.selectedIndex!=-1) {
		txiCodigoCa.text = acCarreraN.selectedItem.@codigo;
		if (acEspacio.selectedIndex!=-1) {
			if (_area == "direccion")				
				httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:'S',id_carrera:acCarreraN.selectedItem.@id_carrera});
			else {
				var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
				httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:'S',id_carrera:acCarreraN.selectedItem.@id_carrera,opcion:opcion});
			}
		}			
	}		
}

private function CloseAcEspacio(e:Event):void {
	var haycarrera:String = 'N';
	var id_carrera:String = '';
	if (acEspacio.selectedIndex!=-1) {
		if (acCarreraN.selectedIndex!=-1) {
			haycarrera = 'S';
			id_carrera = acCarreraN.selectedItem.@id_carrera;
		}
		txiCodigoC.text = acEspacio.selectedItem.@codigo;
		if (_area == "direccion")
			httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:haycarrera,id_carrera:id_carrera});
		else {
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			httpTitulos.send({rutina:"traer_titulos",id_espacio:acEspacio.selectedItem.@id_espacio,haycarrera:haycarrera,id_carrera:id_carrera,opcion:opcion});
		}
	}
}

public function fncEliminarTitulo():void
{
	var xmlTitulo:XML = (gridTitulos.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Eliminar el Título "+ xmlTitulo.@denomtit+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarTitulo, null, Alert.OK);		
}

private function fncConfirmEliminarTitulo(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlTitulo:XML = (gridTitulos.selectedItem as XML).copy();
		httpDatos.addEventListener(ResultEvent.RESULT,fncResultDel);
		httpDatos.send({rutina:"delete",xmlTitulo:xmlTitulo.toXMLString()});
	}
}

private function fncResultDel(e:Event):void{		
	Alert.show("La eliminación se registro con exito","título");
	delete _xmlTitulos.titulos[(gridTitulos.selectedItem as XML).childIndex()];					
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultDel);
}		
	
private function fncCargarTitulos(e:Event):void {
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
	acEspacio.dataProvider = httpAcEspacio.lastResult.espacios;	
}				

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
