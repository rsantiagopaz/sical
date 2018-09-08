import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlTitulo:XML = <titulos id_tomo_cargo="" id_cargo="" cod_cargo="" cod_titulo="" denomtit="" id_tipo_titulo="" cod_tipo_titulo="" tipo="" id_tipo_clasificacion="" denomcar="" denomclas="" cod_tipo_clasificacion="" cod_nivel="" origen=""/>;
[Bindable] private var _xmlTitulos:XML = <titulos></titulos>;	
[Bindable] private var _xmlTitulosDE:XML = <titulos></titulos>;
[Bindable] private var _xmlTitulosNuevos:XML = <titulos></titulos>;
[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatosD:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpTitulos:HTTPServices = new HTTPServices;	
private var httpAcCargo:HTTPServices = new HTTPServices;
private var httpAcTitulo:HTTPServices = new HTTPServices;
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodTitulo:HTTPServices = new HTTPServices;
private var httpCodCargo:HTTPServices = new HTTPServices;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{
	httpDatos.url = "incumbtituloscargos/incumbtituloscargos.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatosD.url = "incumbtituloscargos/incumbtituloscargos.php";
	httpDatosD.addEventListener("acceso",acceso);
	httpDatos2.url = "incumbtituloscargos/incumbtituloscargos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});
	//preparo el autocomplete				
	acTitulo.addEventListener(ListEvent.CHANGE,ChangeAcTitulo);
	acTitulo.addEventListener("close",CloseAcTitulo);
	acTitulo.labelField = "@denominacion";		
	httpAcTitulo.url = "incumbtituloscargos/incumbtituloscargos.php";
	httpAcTitulo.addEventListener("acceso",acceso);
	httpAcTitulo.addEventListener(ResultEvent.RESULT,fncCargarAcTitulo);			
	//preparo el autocomplete		
	acCargo.addEventListener(ListEvent.CHANGE,ChangeAcCargo);
	acCargo.addEventListener("close",CloseAcCargo);
	acCargo.labelField = "@denominacion";
	httpAcCargo.url = "incumbtituloscargos/incumbtituloscargos.php";
	httpAcCargo.addEventListener("acceso",acceso);
	httpAcCargo.addEventListener(ResultEvent.RESULT,fncCargarAcCargo);
	httpTitulos.url = "incumbtituloscargos/incumbtituloscargos.php";
	httpTitulos.addEventListener("acceso",acceso);
	httpTitulos.addEventListener(ResultEvent.RESULT,fncCargarTitulos);
	
	httpCodTitulo.url = "incumbtituloscargos/incumbtituloscargos.php";
	httpCodTitulo.addEventListener("acceso",acceso);
	httpCodTitulo.addEventListener(ResultEvent.RESULT,fncCargarTitulo);
	
	httpCodCargo.url = "incumbtituloscargos/incumbtituloscargos.php";
	httpCodCargo.addEventListener("acceso",acceso);
	httpCodCargo.addEventListener(ResultEvent.RESULT,fncCargarCargo);
	
	btnAgregar.addEventListener("click",fncAgregar);
	txiCodigoT.addEventListener("focusOut",fncBuscarTitulo);
	txiCodigoC.addEventListener("focusOut",fncBuscarCargo);
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

private function fncBuscarCargo(e:Event):void
{
	if (txiCodigoC.text != "") {
		httpCodCargo.send({rutina:"buscar_cargo",codigo:txiCodigoC.text});	
	}		
}

private function fncBuscarTitulo(e:Event):void
{
	if (txiCodigoT.text != "") {
		httpCodTitulo.send({rutina:"buscar_titulo",codigo:txiCodigoT.text});	
	}		
}

private function fncCargarTitulo(e:Event):void{
	acTitulo.dataProvider = httpCodTitulo.lastResult.titulo;			
}

private function fncCargarCargo(e:Event):void{
	acCargo.dataProvider = httpCodCargo.lastResult.cargo;
	if (acCargo.selectedIndex!=-1) {
		httpTitulos.send({rutina:"traer_titulos",id_cargo:acCargo.selectedItem.@id_cargo});
	}		
}	

private function fncDatosResult(e:Event):void {
	_xmlTitulos = <titulos></titulos>;		
	_xmlTitulosNuevos = <titulos></titulos>;
	Alert.show("El alta de titulos para el cargo se ha realizado con éxito.");		
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
			if (acTitulo.selectedItem.@id_titulo == _xmlTitulos.titulos[i].@id_titulo) {
				existente = true;
			}
		}		
		if (existente == false) {				
			//xmlTituloA.@id_carrera = acCarreraN.selectedItem.@id_carrera;
			//xmlTituloA.@cod_carrera = acCarreraN.selectedItem.@codigo;
			_xmlTitulo.@id_titulo = acTitulo.selectedItem.@id_titulo;
			_xmlTitulo.@cod_cargo = acCargo.selectedItem.@codigo;
			_xmlTitulo.@id_tipo_titulo = cmbTipoTitulo.selectedItem.@id_tipo_titulo;
			_xmlTitulo.@cod_tipo_titulo = cmbTipoTitulo.selectedItem.@cod_tipo_titulo;
			_xmlTitulo.@id_tipo_clasificacion = cmbTipoClas.selectedItem.@id_tipo_clasificacion;
			_xmlTitulo.@tipo = cmbTipoTitulo.selectedItem.@tipo;
			_xmlTitulo.@cod_titulo = acTitulo.selectedItem.@codigo;
			//xmlTituloA.@nombre = acCarreraN.selectedItem.@nombre;
			_xmlTitulo.@denomtit = acTitulo.selectedItem.@denominacion;
			_xmlTitulo.@denomclas = cmbTipoClas.selectedItem.@denominacion;
			_xmlTitulo.@cod_tipo_clasificacion = cmbTipoClas.selectedItem.@codigo;
			_xmlTitulo.@cod_nivel = acCargo.selectedItem.@id_nivel;
			_xmlTitulo.@origen = acTitulo.selectedItem.@origen;						
			httpDatos.addEventListener(ResultEvent.RESULT,fncResultAdd);				
			httpDatos.send({rutina:"insert",xmlTitulo:_xmlTitulo.toXMLString(),id_cargo:acCargo.selectedItem.@id_cargo});									
		}
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncResultAdd(e:Event):void{
	_xmlTitulo.@id_tomo_cargo = httpDatos.lastResult.insert_id;
	var existe_codigo : String =  httpDatos.lastResult.codigos.@cc;
	if (existe_codigo=="0"){
		var existe_cargo : String =  httpDatos.lastResult.cargos.@cc1;
		if (existe_cargo=="0") {
			_xmlTitulos.appendChild(_xmlTitulo.copy());
			Alert.show("El alta se registro con éxito","Cargos en Títulos");	
		} else {
			var existe_novedad : String =  httpDatos.lastResult.novedades.@cc2;
			if (existe_novedad!="0") {
				_xmlTitulos.appendChild(_xmlTitulo.copy());
				Alert.show("El alta se registro con éxito","Cargos en Títulos");
			} else {
				Alert.show("Se ha generado una novedad que estará pendiente de confirmación","NOVEDAD");	
			}				
		}
	}else{
		Alert.show("El título seleccionado ya ha sido asignado al cargo","ERROR");	
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

private function CloseAcTitulo(e:Event):void {
	if (acTitulo.selectedIndex!=-1) {
		txiCodigoT.text = acTitulo.selectedItem.@codigo;			
	}		
}

private function CloseAcCargo(e:Event):void {
	if (acCargo.selectedIndex!=-1) {
		txiCodigoC.text = acCargo.selectedItem.@codigo;
		httpTitulos.send({rutina:"traer_titulos",id_cargo:acCargo.selectedItem.@id_cargo});
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
		httpDatosD.addEventListener(ResultEvent.RESULT,fncResultDel);
		httpDatosD.send({rutina:"delete",xmlTitulo:xmlTitulo.toXMLString(),id_cargo:acCargo.selectedItem.@id_cargo});
	}
}

private function fncResultDel(e:Event):void{		
	//Alert.show("La eliminación se registro con exito","título");
	var xmlTitulo:XML = (gridTitulos.selectedItem as XML).copy();
	xmlTitulo.@marcado = '1';
	_xmlTitulos.titulos[(gridTitulos.selectedItem as XML).childIndex()] = xmlTitulo;		
	Alert.show("Se ha generado una novedad que estará pendiente de confirmación","NOVEDAD");
	//delete _xmlTitulos.titulos[(gridTitulos.selectedItem as XML).childIndex()];					
	httpDatosD.removeEventListener(ResultEvent.RESULT,fncResultDel);
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
	acCargo.dataProvider = httpAcCargo.lastResult.cargo;		
}				

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
