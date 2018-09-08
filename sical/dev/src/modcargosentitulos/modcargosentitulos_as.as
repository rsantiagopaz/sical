import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlCargoN:XML = <cargos id_tomo_cargo="" id_cargo="" cod_cargo="" id_tipo_titulo="" cod_tipo_titulo="" tipo="" id_tipo_clasificacion="" denomcar="" denomclas="" cod_tipo_clasificacion="" cod_nivel="" origen=""/>;
[Bindable] private var _xmlCargosA:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosD:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosDE:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosNuevos:XML = <cargos></cargos>;
[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatosD:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpCargosA:HTTPServices = new HTTPServices;
private var httpCargosD:HTTPServices = new HTTPServices;
private var httpCargoN:HTTPServices = new HTTPServices;
private var httpAcTituloA:HTTPServices = new HTTPServices;
private var httpAcTituloD:HTTPServices = new HTTPServices;
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodTitulo:HTTPServices = new HTTPServices;
private var httpCodCargo:HTTPServices = new HTTPServices;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{
	httpDatos.url = "modcargosentitulos/modcargosentitulos.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatosD.url = "modcargosentitulos/modcargosentitulos.php";
	httpDatosD.addEventListener("acceso",acceso);
	httpDatos2.url = "modcargosentitulos/modcargosentitulos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});
	//preparo el autocomplete		
	//acCarreraN.addEventListener(ListEvent.CHANGE,ChangeAcCarreraN);		
	//acCarreraN.labelField = "@nombre";
	httpAcCarreraN.url = "modcargosentitulos/modcargosentitulos.php";
	httpAcCarreraN.addEventListener("acceso",acceso);
	//httpAcCarreraN.addEventListener(ResultEvent.RESULT,fncCargarAcCarreraN);	
	//preparo el autocomplete		
	acTituloA.addEventListener(ListEvent.CHANGE,ChangeAcTituloA);
	acTituloA.addEventListener("close",CloseAcTituloA);
	acTituloA.labelField = "@denominacion";		
	httpAcTituloA.url = "modcargosentitulos/modcargosentitulos.php";
	httpAcTituloA.addEventListener("acceso",acceso);
	httpAcTituloA.addEventListener(ResultEvent.RESULT,fncCargarAcTituloA);		
	httpCargosA.url = "modcargosentitulos/modcargosentitulos.php";
	httpCargosA.addEventListener("acceso",acceso);
	httpCargosA.addEventListener(ResultEvent.RESULT,fncCargarcargosA);
	httpCargosD.url = "modcargosentitulos/modcargosentitulos.php";
	httpCargosD.addEventListener("acceso",acceso);
	httpCargosD.addEventListener(ResultEvent.RESULT,fncCargarcargosD);
	
	httpCodTitulo.url = "modcargosentitulos/modcargosentitulos.php";
	httpCodTitulo.addEventListener("acceso",acceso);
	httpCodTitulo.addEventListener(ResultEvent.RESULT,fncCargarTitulo);
	
	httpCodCargo.url = "modcargosentitulos/modcargosentitulos.php";
	httpCodCargo.addEventListener("acceso",acceso);
	httpCodCargo.addEventListener(ResultEvent.RESULT,fncCargarCargo);
	
	//preparo el autocomplete		
	acCargoN.addEventListener(ListEvent.CHANGE,ChangeacCargoN);
	acCargoN.addEventListener("close",CloseAcCargoN);
	acCargoN.labelField = "@denominacion";
	httpCargoN.url = "modcargosentitulos/modcargosentitulos.php";
	httpCargoN.addEventListener("acceso",acceso);
	httpCargoN.addEventListener(ResultEvent.RESULT,fncCargarcargoN);		
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
	acTituloA.dataProvider = httpCodTitulo.lastResult.titulo;
	if (acTituloA.selectedIndex!=-1) {
		httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo});
	}	
}

private function fncCargarCargo(e:Event):void{
	acCargoN.dataProvider = httpCodCargo.lastResult.cargos;		
}

private function fncDatosResult(e:Event):void {
	_xmlCargosA = <cargos></cargos>;
	_xmlCargosD = <cargos></cargos>;
	_xmlCargosNuevos = <cargos></cargos>;
	Alert.show("El alta de cargos para el titulo se ha realizado con éxito.");		
}

private function fncDatosResult2(e:Event):void {		
	_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncAgregar(e:Event):void
{		
	var error:String = '';
	if (acCargoN.selectedItem==null) {
		error += "Debe seleccionar un cargo.\n";
	}
	/*if (acCarreraN.selectedItem==null) {
		error += "Debe seleccionar una carrera.\n";
	}*/
	if (error == '') {			
		var existente : Boolean = false;
		for (var i:int = 0;i < _xmlCargosA.cargos.length();i++) {
			if (acCargoN.selectedItem.@id_cargo == _xmlCargosA.cargos[i].@id_cargo /*&& 
				cmbTipoTitulo.selectedItem.@id_tipo_titulo == _xmlCargosA.cargos[i].@id_tipo_titulo*/) {
				existente = true;
			}
		}		
		if (existente == false) {				
			//xmlCargoN.@id_carrera = acCarreraN.selectedItem.@id_carrera;
			//xmlCargoN.@cod_carrera = acCarreraN.selectedItem.@codigo;
			_xmlCargoN.@id_cargo = acCargoN.selectedItem.@id_cargo;
			_xmlCargoN.@cod_cargo = acCargoN.selectedItem.@codigo;
			_xmlCargoN.@id_tipo_titulo = cmbTipoTitulo.selectedItem.@id_tipo_titulo;
			_xmlCargoN.@cod_tipo_titulo = cmbTipoTitulo.selectedItem.@cod_tipo_titulo;
			_xmlCargoN.@id_tipo_clasificacion = cmbTipoClas.selectedItem.@id_tipo_clasificacion;
			_xmlCargoN.@tipo = cmbTipoTitulo.selectedItem.@tipo;
			_xmlCargoN.@codigo = acCargoN.selectedItem.@codigo;
			//xmlCargoN.@nombre = acCarreraN.selectedItem.@nombre;
			_xmlCargoN.@denomcar = acCargoN.selectedItem.@denominacion;
			_xmlCargoN.@denomclas = cmbTipoClas.selectedItem.@denominacion;
			_xmlCargoN.@cod_tipo_clasificacion = cmbTipoClas.selectedItem.@codigo;
			_xmlCargoN.@cod_nivel = acCargoN.selectedItem.@id_nivel;
			_xmlCargoN.@origen = acCargoN.selectedItem.@origen;						
			httpDatos.addEventListener(ResultEvent.RESULT,fncResultAdd);				
			httpDatos.send({rutina:"insert",xmlCargo:_xmlCargoN.toXMLString(),id_titulo:acTituloA.selectedItem.@id_titulo,
				cod_titulo:acTituloA.selectedItem.@codigo});									
		}else{
			Alert.show("El cargo seleccionado ya ha sido asignado al título","ERROR");	
		}
	} else {
		Alert.show(error,"E R R O R");
	}
}

private function fncResultAdd(e:Event):void{
	_xmlCargoN.@id_tomo_cargo = httpDatos.lastResult.insert_id;
	var existe_codigo : String =  httpDatos.lastResult.codigos.@cc;
	if (existe_codigo=="0"){
		var existe_cargo : String =  httpDatos.lastResult.cargos.@cc1;
		if (existe_cargo=="0") {
			_xmlCargosA.appendChild(_xmlCargoN.copy());
			Alert.show("El alta se registro con éxito","Cargos en Títulos");	
		} else {
			var existe_novedad : String =  httpDatos.lastResult.novedades.@cc2;
			if (existe_novedad!="0") {
				_xmlCargosA.appendChild(_xmlCargoN.copy());
				Alert.show("El alta se registro con éxito","Cargos en Títulos");
			} else {
				Alert.show("Se ha generado una novedad que estará pendiente de confirmación","NOVEDAD");	
			}				
		}						
	}else{
		Alert.show("El cargo seleccionado ya ha sido asignado al título","ERROR");	
	}				
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}		

private function fncCargarcargoN(e:Event):void{
	acCargoN.typedText = acCargoN.text;
	acCargoN.dataProvider = httpCargoN.lastResult.cargos;		
}

private function ChangeacCargoN(e:Event):void{
	if (acCargoN.text.length==3){
		httpCargoN.send({rutina:"traer_cargos_n",denominacion:acCargoN.text});
	}
}

private function CloseAcCargoN(e:Event):void {
	if (acCargoN.selectedIndex!=-1) {
		txiCodigoC.text = acCargoN.selectedItem.@codigo;			
	}		
}		

public function fncEliminarCargo():void
{
	var xmlCargo:XML = (gridCargosA.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Eliminar el Cargo "+ xmlCargo.@denomcar+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarCargo, null, Alert.OK);		
}

private function fncConfirmEliminarCargo(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlCargo:XML = (gridCargosA.selectedItem as XML).copy();
		httpDatosD.addEventListener(ResultEvent.RESULT,fncResultDel);
		httpDatosD.send({rutina:"delete",xmlCargo:xmlCargo.toXMLString(),id_titulo:acTituloA.selectedItem.@id_titulo,
				cod_titulo:acTituloA.selectedItem.@codigo});
	}
}

private function fncResultDel(e:Event):void{		
	//Alert.show("La eliminación se registro con exito","título");
	var xmlCargo:XML = (gridCargosA.selectedItem as XML).copy();
	xmlCargo.@marcado = '1';
	_xmlCargosA.cargos[(gridCargosA.selectedItem as XML).childIndex()] = xmlCargo;
	//httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo});
	Alert.show("Se ha generado una novedad que estará pendiente de confirmación","NOVEDAD");
	//delete _xmlCargosA.cargos[(gridCargosA.selectedItem as XML).childIndex()];					
	httpDatosD.removeEventListener(ResultEvent.RESULT,fncResultDel);
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
		txiCodigoT.text = acTituloA.selectedItem.@codigo;
		httpCargosA.send({rutina:"traer_cargos",id_titulo:acTituloA.selectedItem.@id_titulo});
	}		
}
	
private function fncCargarAcTituloA(e:Event):void{
	acTituloA.typedText = acTituloA.text;
	acTituloA.dataProvider = httpAcTituloA.lastResult.titulo;		
}				

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
