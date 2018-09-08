import clases.HTTPServices;

import moddocentes.docente;

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


include "../control_acceso.as";

[Bindable] private var _xmlDocentes:XML = <docentes></docentes>;
[Bindable] private var _xmlNiveles:XML = <niveles></niveles>;
[Bindable] private var _xmlNivelesPara:XML = <niveles_para></niveles_para>;
[Bindable] private var _xmlGrados:XML = <grados></grados>;
[Bindable] private var _xmlLugares:XML = <lugares></lugares>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
private var twDocente:docente;

public function get xmlNiveles():XML { return _xmlNiveles }
public function get xmlNivelesPara():XML { return _xmlNivelesPara }
public function get xmlGrados():XML { return _xmlGrados }
public function get xmlLugares():XML { return _xmlLugares }


public function fncInit():void
{
	_xmlLugares.appendChild(parentApplication.xmlLugares.departamento);
	httpDatos.url = "moddocentes/moddocentes.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);
	httpDatos2.url = "moddocentes/moddocentes.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2);
	httpDatos2.send({rutina:"traer_datos2"});
	
	httpCombos.url = "moddocentes/moddocentes.php";
	httpCombos.addEventListener("acceso",acceso);
	httpCombos.send({rutina:"traer_datos_combos"});
	
	btnNuevoDocente.addEventListener("click" ,fncAgregarDocente);
	btnCerrar.addEventListener("click" ,fncCerrar);
	txtNombre.addEventListener("change",fncTraerDocentes);
	btnBuscar.addEventListener("click",fncTraerDocentesBoton);
}

private function fncTraerDocentes(e:Event):void{
	if (txtNombre.text.length==3){
		httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
	}
	if(txtNombre.text.length>3){
	
  		gridDocentes.dataProvider.filterFunction = filtroTexto;
        gridDocentes.dataProvider.refresh();			
	}
}

private function filtroTexto (item : Object) : Boolean
{
	return item.@nombre.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
}

private function fncTraerDocentesBoton(e:Event):void{
	httpDatos.send({rutina:"traer_datos",filter:txtNombre.text, tipo_doc:cmbTiposDoc.selectedItem.@id_tipo_doc, nro_doc:txtNroDoc.text});
}

private function fncCargarDatos(e:Event):void {
	_xmlDocentes = <docentes></docentes>;
	_xmlDocentes.appendChild(httpDatos.lastResult.docentes);		
}

private function fncCargarDatos2(e:Event):void {		
	_xmlNiveles.appendChild(httpDatos2.lastResult.niveles);
	_xmlNivelesPara.appendChild(httpDatos2.lastResult.niveles_para);
	_xmlGrados.appendChild(httpDatos2.lastResult.grados);		
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function fncAgregarDocente(e:Event):void
{
	twDocente = new docente;
	twDocente.addEventListener("EventAlta",fncAltaDocentes);
	PopUpManager.addPopUp(twDocente,this,true);
	PopUpManager.centerPopUp(twDocente);
}

private function fncAltaDocentes(e:Event):void{
	_xmlDocentes.appendChild(twDocente.xmlDocente);
	PopUpManager.removePopUp(e.target as docente);
}

public function fncEditar():void
{
	twDocente = new docente;
	twDocente.xmlDocente =  (gridDocentes.selectedItem as XML).copy();
	twDocente.addEventListener("EventEdit",fncEditarDocente);
	PopUpManager.addPopUp(twDocente,this,true);
	PopUpManager.centerPopUp(twDocente);
}

public function fncEliminar():void
{
	twDocente = new docente;
	twDocente.xmlDocente2 =  (gridDocentes.selectedItem as XML).copy();
	twDocente.addEventListener("EventDelete",fncEliminarDocente);
	PopUpManager.addPopUp(twDocente,this,true);
	PopUpManager.centerPopUp(twDocente);
}

public function fncEditarDocente(e:Event):void
{
	_xmlDocentes.docentes[(gridDocentes.selectedItem as XML).childIndex()] = twDocente.xmlDocente;
	PopUpManager.removePopUp(e.target as docente);
}

public function fncEliminarDocente(e:Event):void
{
	delete _xmlDocentes.docentes[(gridDocentes.selectedItem as XML).childIndex()];
	PopUpManager.removePopUp(e.target as docente);
}
