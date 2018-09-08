import clases.HTTPServices;

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


include "../control_acceso.as";

[Bindable] private var _xmlTitulos:XML = <titulos></titulos>;
[Bindable] private var _xmlNiveles:XML = <niveles></niveles>;
[Bindable] private var _xmlNivelesPara:XML = <niveles_para></niveles_para>;
[Bindable] private var _xmlGrados:XML = <grados></grados>;
[Bindable] private var _xmlLugares:XML = <lugares></lugares>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;	
private var _xmlTitulo:XML;

public function get xmlNiveles():XML { return _xmlNiveles }
public function get xmlNivelesPara():XML { return _xmlNivelesPara }
public function get xmlGrados():XML { return _xmlGrados }
public function get xmlLugares():XML { return _xmlLugares }
public function get xmlTitulo():XML { return _xmlTitulo }


public function fncInit():void
{
	_xmlLugares.appendChild(parentApplication.xmlLugares.departamento);
	httpDatos.url = "abmtitulos/abmtitulos.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);
	httpDatos2.url = "abmtitulos/abmtitulos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2);
	httpDatos2.send({rutina:"traer_datos2"});
	//btnNuevoTitulo.addEventListener("click" ,fncAgregarTitulo);
	btnCerrar.addEventListener("click" ,fncCerrar);
	//txtNombre.addEventListener("change",fncTraerTitulos);
	btnBuscar.addEventListener("click",fncTraerTitulosBoton);
	txtNombre.setFocus();
}

private function fncTraerTitulos(e:Event):void{
	if (txtNombre.text.length==3){
		httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
	}
	if(txtNombre.text.length>3){
	
  		gridTitulos.dataProvider.filterFunction = filtroTexto;
        gridTitulos.dataProvider.refresh();			
	}
}

private function filtroTexto (item : Object) : Boolean
{
	return item.@nombre.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
}

private function fncTraerTitulosBoton(e:Event):void{
	httpDatos.send({rutina:"buscar_titulo",filter:txtNombre.text});
}

private function fncCargarDatos(e:Event):void {
	_xmlTitulos = <titulos></titulos>;
	_xmlTitulos.appendChild(httpDatos.lastResult.titulos);		
}

private function fncCargarDatos2(e:Event):void {		
	_xmlNiveles.appendChild(httpDatos2.lastResult.niveles);
	_xmlNivelesPara.appendChild(httpDatos2.lastResult.niveles_para);
	_xmlGrados.appendChild(httpDatos2.lastResult.grados);		
}

private function fncCerrar(e:Event):void{
	PopUpManager.removePopUp(this);
}		

public function fncSeleccionar():void
{		
	_xmlTitulo =  (gridTitulos.selectedItem as XML).copy();
	dispatchEvent(new Event("EventConfirmarTitulo"));
}		

public function fncEliminarTitulo(e:Event):void
{
	delete _xmlTitulos.titulos[(gridTitulos.selectedItem as XML).childIndex()];
	PopUpManager.removePopUp(e.target as titulo);
}	