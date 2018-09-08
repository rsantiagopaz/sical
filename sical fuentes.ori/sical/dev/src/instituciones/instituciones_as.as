import clases.HTTPServices;

import instituciones.institucion;

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


include "../control_acceso.as";

[Bindable] private var _xmlInstituciones:XML = <instituciones></instituciones>;
[Bindable] private var _xmlProvincias:XML = <provincias></provincias>;	
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var twInstitucion:institucion;

public function get xmlProvincias():XML { return _xmlProvincias }	


public function fncInit():void
{		
	httpDatos.url = "instituciones/instituciones.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos)		
	httpDatos2.url = "instituciones/instituciones.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2)
	httpDatos2.send({rutina:"traer_datos2"});
	btnNuevaInstitucion.addEventListener("click" ,fncAgregarInstitucion);
	btnCerrar.addEventListener("click" ,fncCerrar);
	txtNombre.addEventListener("change",fncTraerInstituciones);
	btnBuscar.addEventListener("click",fncTraerInstitucionesBoton);
}

private function fncTraerInstituciones(e:Event):void{
	if (txtNombre.text.length==3){
		httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
	}
	if(txtNombre.text.length>3){
	
  		gridInstituciones.dataProvider.filterFunction = filtroTexto;
        gridInstituciones.dataProvider.refresh();			
	}
}

private function filtroTexto (item : Object) : Boolean
{
	return item.@denominacion.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
}

private function fncTraerInstitucionesBoton(e:Event):void{
	httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
}

private function fncCargarDatos(e:Event):void {
	_xmlInstituciones = <instituciones></instituciones>;
	_xmlInstituciones.appendChild(httpDatos.lastResult.instituciones);
	//_xmlProvincias.appendChild(httpDatos.lastResult.provincias);
	//_xmlLugares.appendChild(httpDatos.lastResult.departamento);
}

private function fncCargarDatos2(e:Event):void {
	//_xmlInstituciones.appendChild(httpDatos.lastResult.instituciones);
	_xmlProvincias.appendChild(httpDatos2.lastResult.provincias);
	//_xmlLugares.appendChild(httpDatos.lastResult.departamento);
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function fncAgregarInstitucion(e:Event):void
{
	twInstitucion = new institucion;
	twInstitucion.addEventListener("EventAlta",fncAltaInstituciones);
	PopUpManager.addPopUp(twInstitucion,this,true);
	PopUpManager.centerPopUp(twInstitucion);
}

private function fncAltaInstituciones(e:Event):void{
	_xmlInstituciones.appendChild(twInstitucion.xmlInstitucion);
	PopUpManager.removePopUp(e.target as institucion);
}

public function fncEditar():void
{
	twInstitucion = new institucion;
	twInstitucion.xmlInstitucion =  (gridInstituciones.selectedItem as XML).copy();
	twInstitucion.addEventListener("EventEdit",fncEditarInstitucion);
	PopUpManager.addPopUp(twInstitucion,this,true);
	PopUpManager.centerPopUp(twInstitucion);
}

public function fncEliminar():void
{
	twInstitucion = new institucion;
	twInstitucion.xmlInstitucion2 =  (gridInstituciones.selectedItem as XML).copy();
	twInstitucion.addEventListener("EventDelete",fncEliminarInstitucion);
	PopUpManager.addPopUp(twInstitucion,this,true);
	PopUpManager.centerPopUp(twInstitucion);
}

public function fncEditarInstitucion(e:Event):void
{
	_xmlInstituciones.instituciones[(gridInstituciones.selectedItem as XML).childIndex()] = twInstitucion.xmlInstitucion;
	PopUpManager.removePopUp(e.target as institucion);
}

public function fncEliminarInstitucion(e:Event):void
{
	delete _xmlInstituciones.instituciones[(gridInstituciones.selectedItem as XML).childIndex()];
	PopUpManager.removePopUp(e.target as institucion);
}

