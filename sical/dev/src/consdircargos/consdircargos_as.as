import cargos.twcargo;

import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlTitulo:XML = <titulos id_tomo_cargo="" id_cargo="" cod_cargo="" denomtit="" id_tipo_titulo="" cod_tipo_titulo="" tipo="" id_tipo_clasificacion="" denomcar="" denomclas="" cod_tipo_clasificacion="" cod_nivel="" origen=""/>;
[Bindable] private var _xmlTitulos:XML = <titulos></titulos>;	
[Bindable] private var _xmlTitulosDE:XML = <titulos></titulos>;
[Bindable] private var _xmlTitulosNuevos:XML = <titulos></titulos>;
[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpTitulos:HTTPServices = new HTTPServices;	
private var httpAcCargo:HTTPServices = new HTTPServices;
private var httpAcTitulo:HTTPServices = new HTTPServices;
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodTitulo:HTTPServices = new HTTPServices;
private var httpCodCargo:HTTPServices = new HTTPServices;
private var _twCargo:twcargo = new twcargo;
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
	httpDatos.url = "consdircargos/consdircargos.php";
	httpDatos.addEventListener("acceso",acceso);		
	httpDatos2.url = "consdircargos/consdircargos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});				
	httpAcTitulo.url = "consdircargos/consdircargos.php";
	httpAcTitulo.addEventListener("acceso",acceso);			
	//preparo el autocomplete		
	acCargo.addEventListener(ListEvent.CHANGE,ChangeAcCargo);
	acCargo.addEventListener("close",CloseAcCargo);
	acCargo.labelField = "@denominacion";
	httpAcCargo.url = "consdircargos/consdircargos.php";
	httpAcCargo.addEventListener("acceso",acceso);
	httpAcCargo.addEventListener(ResultEvent.RESULT,fncCargarAcCargo);
	httpTitulos.url = "consdircargos/consdircargos.php";
	httpTitulos.addEventListener("acceso",acceso);
	httpTitulos.addEventListener(ResultEvent.RESULT,fncCargarTitulos);
	
	httpCodTitulo.url = "consdircargos/consdircargos.php";
	httpCodTitulo.addEventListener("acceso",acceso);
	
	httpCodCargo.url = "consdircargos/consdircargos.php";
	httpCodCargo.addEventListener("acceso",acceso);
	httpCodCargo.addEventListener(ResultEvent.RESULT,fncCargarCargo);
			
	txiCodigoC.addEventListener("focusOut",fncBuscarCargo);
	btnImprimir.addEventListener("click",fncImprimir);
	btnBuscar3.addEventListener("click",fncTraerCargosBoton);			
}

/*
* Función para ordenar los datos de la columna 'codtit' de manera numérica, no alfabética:
*/
public function numericSort(a:*,b:*):int
{
	var nA:Number=Number(a.@codtit);
    var nB:Number=Number(b.@codtit);
    if (nA<nB){
     	return -1;
    }else if (nA>nB){
     	return 1;
    }else {
        return 0;
    }
}

private function fncTraerCargosBoton(e:Event):void
{
	_twCargo = new twcargo;
	_twCargo.todos = 0;	
	_twCargo.addEventListener("EventConfirmarCargo",fncGrabarCargo);
	PopUpManager.addPopUp(_twCargo,this,true);
	PopUpManager.centerPopUp(_twCargo);
}

private function fncRefrescar(e:Event):void
{
	if (_area == "direccion")
		httpTitulos.send({rutina:"traer_titulos",id_cargo:acCargo.selectedItem.@id_cargo});
	else {
		var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
		httpTitulos.send({rutina:"traer_titulos",id_cargo:acCargo.selectedItem.@id_cargo,opcion:opcion});
	}
}

private function fncGrabarCargo(e:Event):void
{
	var xmlCargo:XML = _twCargo.xmlCargo;
	PopUpManager.removePopUp(e.target as twcargo);
	txiCodigoC.text = xmlCargo.@codigo;
	httpCodCargo.send({rutina:"buscar_cargo",codigo:txiCodigoC.text});
	httpTitulos.send({rutina:"traer_titulos",id_cargo:xmlCargo.@id_cargo});		
}

private function fncImprimir(e:Event):void
{			
	var sortList:Array = getSortOrder(gridTitulos);	
     
	//Creo los contenedores para enviar datos y recibir respuesta
	var enviar:URLRequest = new URLRequest("consdircargos/listado_titulos_por_cargo.php?rutina=listado_titulos&");
	var recibir:URLLoader = new URLLoader();
 		 
	//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
	var variables:URLVariables = new URLVariables();
	
	variables.id_cargo = acCargo.selectedItem.@id_cargo;
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
}

private function fncBuscarCargo(e:Event):void
{
	if (txiCodigoC.text != "") {
		httpCodCargo.send({rutina:"buscar_cargo",codigo:txiCodigoC.text});	
	}		
}		

private function fncCargarCargo(e:Event):void{
	acCargo.dataProvider = httpCodCargo.lastResult.cargos;
	if (acCargo.selectedIndex!=-1) {
		if (_area == "direccion")
			httpTitulos.send({rutina:"traer_titulos",id_cargo:acCargo.selectedItem.@id_cargo});
		else {
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			httpTitulos.send({rutina:"traer_titulos",id_cargo:acCargo.selectedItem.@id_cargo,opcion:opcion});
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
	_xmlTitulo.@id_tomo_cargo = httpDatos.lastResult.insert_id;
	var existe_codigo : String =  httpDatos.lastResult.codigos.@cc;
	if (existe_codigo=="0"){
		Alert.show("El alta se registro con éxito","Cargos en Títulos");				
	}else{
		Alert.show("El título seleccionado ya ha sido asignado al cargo","ERROR");	
	}
	_xmlTitulos.appendChild(_xmlTitulo.copy());		
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}		

private function CloseAcCargo(e:Event):void {
	if (acCargo.selectedIndex!=-1) {
		txiCodigoC.text = acCargo.selectedItem.@codigo;			
		if (_area == "direccion")
			httpTitulos.send({rutina:"traer_titulos",id_cargo:acCargo.selectedItem.@id_cargo});
		else {
			var opcion:String = (rdbVigente.selected == true) ? "V" : "A";
			httpTitulos.send({rutina:"traer_titulos",id_cargo:acCargo.selectedItem.@id_cargo,opcion:opcion});
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

private function ChangeAcCargo(e:Event):void{
	if (acCargo.text.length==3){
		httpAcCargo.send({rutina:"traer_cargos_n",denominacion:acCargo.text});
	}
}		
	
private function fncCargarAcCargo(e:Event):void{
	acCargo.typedText = acCargo.text;
	acCargo.dataProvider = httpAcCargo.lastResult.cargos;		
}				

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
