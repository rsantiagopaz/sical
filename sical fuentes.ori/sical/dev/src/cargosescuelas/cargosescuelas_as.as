import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlEscuela:XML = <escuelas id_escuela_cargo="" id_cargo="" cod_cargo="" denomcar="" id_escuela="" cod_escuela="" id_nivel="" nivel="" nombre="" origen=""/>;
[Bindable] private var _xmlEscuelas:XML = <escuelas></escuelas>;	
[Bindable] private var _xmlEscuelasDE:XML = <escuelas></escuelas>;
[Bindable] private var _xmlEscuelasNuevos:XML = <escuelas></escuelas>;
[Bindable] private var _xmlTiposEscuelas:XML = <tiposescuelas></tiposescuelas>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatosD:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpEscuelas:HTTPServices = new HTTPServices;	
private var httpAcCargo:HTTPServices = new HTTPServices;
private var httpAcEscuela:HTTPServices = new HTTPServices;	
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodCargo:HTTPServices = new HTTPServices;
private var httpCodEscuela:HTTPServices = new HTTPServices;

public function get xmlTiposEscuelas():XML{return _xmlTiposEscuelas.copy();}

public function fncInit():void
{
	httpDatos.url = "cargosescuelas/cargosescuelas.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatosD.url = "cargosescuelas/cargosescuelas.php";
	httpDatosD.addEventListener("acceso",acceso);		
	httpDatos2.url = "cargosescuelas/cargosescuelas.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	//httpDatos2.send({rutina:"traer_datos2"});
	//preparo el autocomplete				
	acEscuela.addEventListener(ListEvent.CHANGE,ChangeAcEscuela);
	acEscuela.addEventListener("close",CloseAcEscuela);		
	acEscuela.labelField = "@nombre";		
	httpAcEscuela.url = "cargosescuelas/cargosescuelas.php";
	httpAcEscuela.addEventListener("acceso",acceso);
	httpAcEscuela.addEventListener(ResultEvent.RESULT,fncCargarAcEscuela);			
	//preparo el autocomplete		
	acCargo.addEventListener(ListEvent.CHANGE,ChangeAcCargo);
	acCargo.addEventListener("close",CloseAcCargo);
	acCargo.labelField = "@denominacion";
	
	httpCodCargo.url = "cargosescuelas/cargosescuelas.php";
	httpCodCargo.addEventListener("acceso",acceso);
	httpCodCargo.addEventListener(ResultEvent.RESULT,fncCargarCargo);
	
	httpCodEscuela.url = "cargosescuelas/cargosescuelas.php";
	httpCodEscuela.addEventListener("acceso",acceso);
	httpCodEscuela.addEventListener(ResultEvent.RESULT,fncCargarEscuela);
	
	httpAcCargo.url = "cargosescuelas/cargosescuelas.php";
	httpAcCargo.addEventListener("acceso",acceso);
	httpAcCargo.addEventListener(ResultEvent.RESULT,fncCargarAcCargo);
	httpEscuelas.url = "cargosescuelas/cargosescuelas.php";
	httpEscuelas.addEventListener("acceso",acceso);
	httpEscuelas.addEventListener(ResultEvent.RESULT,fncCargarEscuelas);
	btnAgregar.addEventListener("click",fncAgregar);
	//btnGuardar.addEventListener("click",fncGuardar);
	
	txiCodigoC.addEventListener("focusOut",fncBuscarCargo);
	txiCodigoS.addEventListener("focusOut",fncBuscarEscuela);
}

private function fncCargarEscuela(e:Event):void{
	acEscuela.dataProvider = httpCodEscuela.lastResult.escuelas;
	if (acEscuela.selectedIndex!=-1) {
		httpEscuelas.send({rutina:"traer_cargos",id_escuela:acEscuela.selectedItem.@id_escuela});
	}
}

private function fncBuscarEscuela(e:Event):void
{
	if (txiCodigoS.text != "") {
		httpCodEscuela.send({rutina:"buscar_escuela",codigo:txiCodigoS.text});	
	}		
}

private function fncCargarCargo(e:Event):void{
	acCargo.dataProvider = httpCodCargo.lastResult.cargos;
	/*if (acCargo.selectedIndex!=-1) {
		httpEscuelas.send({rutina:"traer_escuelas",id_cargo:acCargo.selectedItem.@id_cargo});
	}*/	
}

private function fncBuscarCargo(e:Event):void
{
	if (txiCodigoC.text != "") {
		httpCodCargo.send({rutina:"buscar_cargo",codigo:txiCodigoC.text});	
	}		
}

private function fncDatosResult(e:Event):void {
	_xmlEscuelas = <escuelas></escuelas>;		
	_xmlEscuelasNuevos = <escuelas></escuelas>;
	Alert.show("El alta de escuelas para el cargo se ha realizado con éxito.");		
}

private function fncDatosResult2(e:Event):void {		
	_xmlTiposEscuelas.appendChild(httpDatos2.lastResult.tiposescuelas);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncGuardar(e:Event):void
{		
	/*var error:String = '';
	if (acEscuelaD.selectedItem==null) {
		error += "Debe seleccionar la escuela para la cual se asignan los cargos.\n";
	}
	if (_xmlEscuelasDE.cargos.length() > 0) {
		error += "El título seleccionado ya tiene cargos asignados previamente. Dirígase a la opción de 'Modificación de Escuelas por Cargo' del Menú ";
		error += "para agregar o eliminar cargos asignados.\n";
	}
	if (error == '') {
		Alert.yesLabel = "Si";			 
		Alert.show("Está a punto de incluir los cargos seleccionados en el escuela " + acEscuelaD.selectedItem.@nombre + " ¿Confirmar?","Confirmación", Alert.YES | Alert.NO,null,fncConfirmGuardar);								
	} else {
		Alert.show(error,"E R R O R");
	}*/
}

private function fncAgregar(e:Event):void
{		
	var error:String = '';
	if (acCargo.selectedItem==null) {
		error += "Debe seleccionar un cargo.\n";
	}
	if (acEscuela.selectedItem==null) {
		error += "Debe seleccionar una escuela.\n";
	}
	if (error == '') {			
		var existente : Boolean = false;
		for (var i:int = 0;i < _xmlEscuelas.escuelas.length();i++) {
			if (acCargo.selectedItem.@id_cargo == _xmlEscuelas.escuelas[i].@id_cargo) {
				existente = true;
			}
		}		
		if (existente == false) {				
			_xmlEscuela.@id_cargo = acCargo.selectedItem.@id_cargo;
			_xmlEscuela.@cod_cargo = acCargo.selectedItem.@codigo;
			_xmlEscuela.@denomcar = acCargo.selectedItem.@denominacion;				
			_xmlEscuela.@codigo = acEscuela.selectedItem.@codigo;
			_xmlEscuela.@id_nivel = acCargo.selectedItem.@id_nivel;				
			_xmlEscuela.@nivel = acCargo.selectedItem.@nivel;
			_xmlEscuela.@nombre = acEscuela.selectedItem.@nombre;				
			_xmlEscuela.@origen = acEscuela.selectedItem.@origen;						
			httpDatos.addEventListener(ResultEvent.RESULT,fncResultAdd);				
			httpDatos.send({rutina:"insert",xmlEscuela:_xmlEscuela.toXMLString(),id_escuela:acEscuela.selectedItem.@id_escuela});									
		}
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncResultAdd(e:Event):void{
	_xmlEscuela.@id_escuela_cargo = httpDatos.lastResult.insert_id;
	var existe_codigo : String =  httpDatos.lastResult.codigos.@cc;
	var tomo_cargos : String =  httpDatos.lastResult.tomocargos.@cc1;
	if (existe_codigo=="0"){
		if (tomo_cargos!="0") {
			_xmlEscuelas.appendChild(_xmlEscuela.copy());
			Alert.show("El alta se registro con éxito","Cargos por Escuela");					
		} else
			Alert.show("El cargo seleccionado no tiene títulos categorizados aún","Cargos por Escuela");
	}else{
		Alert.show("El Cargo seleccionado ya ha sido asignado a la escuela","ERROR");	
	}				
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}

private function fncConfirmGuardar(e:CloseEvent):void
{
	/*if(e.detail==Alert.YES) 
	{
		httpDatos.send({rutina:"dar_alta",xmlEscuelas:_xmlEscuelasD,id_escuela:acEscuelaD.selectedItem.@id_escuela,
			cod_escuela:acEscuelaD.selectedItem.@codigo});	
	}*/
}

/*
* Función para ordenar los datos de la columna 'cod_cargo' de manera numérica, no alfabética:
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

private function fncCargarAcEscuela(e:Event):void{
	acEscuela.typedText = acEscuela.text;
	acEscuela.dataProvider = httpAcEscuela.lastResult.escuelas;		
}

private function ChangeAcEscuela(e:Event):void{
	if (acEscuela.text.length==3){
		httpAcEscuela.send({rutina:"traer_escuelas_n",nombre:acEscuela.text});
	}
}

private function CloseAcCargo(e:Event):void {
	if (acCargo.selectedIndex!=-1) {
		httpEscuelas.send({rutina:"traer_escuelas",id_cargo:acCargo.selectedItem.@id_cargo});
	}						
}

private function CloseAcEscuela(e:Event):void {
	if (acEscuela.selectedIndex!=-1) {
		txiCodigoS.text = acEscuela.selectedItem.@codigo;		
		httpEscuelas.send({rutina:"traer_cargos",id_escuela:acEscuela.selectedItem.@id_escuela});
	}						
}

public function fncEliminarEscuela():void
{
	var xmlEscuela:XML = (gridEscuelas.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Eliminar el Cargo "+ xmlEscuela.@denomcar+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarEscuela, null, Alert.OK);		
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
	Alert.show("La eliminación se registro con exito","título");
	delete _xmlEscuelas.escuelas[(gridEscuelas.selectedItem as XML).childIndex()];					
	httpDatosD.removeEventListener(ResultEvent.RESULT,fncResultDel);
}		
	
private function fncCargarEscuelas(e:Event):void {
	_xmlEscuelas = <escuelas></escuelas>;
	_xmlEscuelas.appendChild(httpEscuelas.lastResult.escuelas);		
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
