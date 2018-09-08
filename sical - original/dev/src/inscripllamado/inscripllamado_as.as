import clases.HTTPServices;

import flash.events.Event;

import llamados.listallamados;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import twdocente.twDocente;

include "../control_acceso.as";

[Bindable] private var httpDatos : HTTPServices = new HTTPServices;
[Bindable] private var httpLlam : HTTPServices = new HTTPServices;
[Bindable] private var httpInscrip : HTTPServices = new HTTPServices;
[Bindable] private var httpObs : HTTPServices = new HTTPServices;
private var _idIngresoMovimiento:String;
[Bindable] private var xmlDepartamento:XMLList;
[Bindable] private var id_departamento:String;
[Bindable] private var _idDocente:String;
[Bindable] private var _id_docente_llamado:String;
[Bindable] private var _idLlamado:String = "";
[Bindable] private var _idNivel:String = "";
[Bindable] private var _id_tipo_clasificacion:String = "";
[Bindable] private var _id_subtipo_clasificacion:String = "";
[Bindable] private var _tipoDoc:String;
[Bindable] private var _nroDoc:String;
[Bindable] private var _apellidoDocente:String;
[Bindable] private var _nombresDocente:String;
[Bindable] private var _domicilioDocente:String;
[Bindable] private var _xmlObs:XML = <observaciones></observaciones>;
[Bindable] private var _nro_llamado_conflictivo:String;
private var twLlamados:listallamados;
private var clasifica:String;

private var twDoc : twDocente;
private var xmlDatos : XML;

public function set idDocente(id:String):void { _idDocente = id; }

public function get idDocente():String { return _idDocente; }

public function get id_docente_llamado():String { return _id_docente_llamado; }

public function get idLlamado():String { return _idLlamado; }

public function get idNivel():String { return _idNivel; }

public function get idTipoClasif():String { return _id_tipo_clasificacion; }

public function get idTipoLlamado():String { return _id_subtipo_clasificacion; }

public function set tipoDoc(tipod:String):void { _tipoDoc = tipod; }
	
public function set nroDoc(nrod:String):void { _nroDoc = nrod;	}

public function set apellidoDocente(ape:String):void { _apellidoDocente = ape; }

public function set nombresDocente(nom:String):void { _nombresDocente = nom; }

public function set domicilioDocente(dom:String):void { _domicilioDocente = dom; }

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("SelectPrincipal"));
}

public function fncInit():void
{	
	datosdocente.fncInit();	
	_idDocente = "";
	_id_docente_llamado = "";
	_idLlamado = "";
	_idNivel = "";
	_id_tipo_clasificacion = "";
	_id_subtipo_clasificacion = "";
	lblDescripcion.text = "";
	txiNroFolios.text = "";
	_xmlObs = <observaciones></observaciones>;
	_nro_llamado_conflictivo = "",
	txaComentarios.text = "";
	httpObs.url = "inscripllamado/inscripllamado.php";		
	chkNoClasifica.selected = false;
	httpObs.addEventListener("acceso",acceso);
	httpObs.addEventListener(ResultEvent.RESULT,fncObsResult);		
	httpObs.send({rutina:"traer_observaciones"});		
	httpDatos.url = "inscripllamado/inscripllamado.php";
	httpDatos.method = URLRequestMethod.POST;				
	httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);
	httpDatos.addEventListener("acceso",acceso);
	httpInscrip.url = "inscripllamado/inscripllamado.php";
	httpInscrip.method = URLRequestMethod.POST;				
	httpInscrip.addEventListener(ResultEvent.RESULT,fncInscripResult);
	httpInscrip.addEventListener("acceso",acceso);
	httpLlam.url = "inscripllamado/inscripllamado.php";				
	httpLlam.addEventListener(ResultEvent.RESULT,fncLlamadosResult);
	httpLlam.addEventListener("acceso",acceso);
	btnGuardar.addEventListener("click" ,fncGuardar);
	btnAgregar.addEventListener("click" ,fncAgregar);
	btnVerLlamados.addEventListener("click" ,fncVerLlamados);
	txiNroLlamado.addEventListener("focusOut",fncBuscarLlamado);
	txiNroLlamado.setFocus();			
}


public function fncModificar():void
{	
	twDoc = new twDocente();
	twDoc.accion = "M";
	PopUpManager.addPopUp(twDoc,this,true);
    PopUpManager.centerPopUp(twDoc);
    twDoc.addEventListener("verInscripcion",fncRecibirDatosMod);
    twDoc.addEventListener("Close",fncCerrarPopUp);	
}

public function fncBaja():void
{	
	twDoc = new twDocente();
	twDoc.accion = "B";
	PopUpManager.addPopUp(twDoc,this,true);
    PopUpManager.centerPopUp(twDoc);
    twDoc.addEventListener("verInscripcion",fncRecibirDatosDel);
    twDoc.addEventListener("Close",fncCerrarPopUp);
}

private function fncRecibirDatosDel(e:Event):void{
	var xmlDatos : XML = twDoc.xmlDatos;
	_idNivel = xmlDatos.llamadodocente.@id_nivel;
	_id_tipo_clasificacion = xmlDatos.llamadodocente.@id_tipo_clasificacion;
	_id_docente_llamado = xmlDatos.llamadodocente.@id_docente_llamado;
	PopUpManager.removePopUp(e.target as twDocente)
	dispatchEvent(new Event("EventBaja"));
}	

private function fncRecibirDatosMod(e:Event):void{
	var xmlDatos : XML = twDoc.xmlDatos;
	_idNivel = xmlDatos.llamadodocente.@id_nivel;
	_id_tipo_clasificacion = xmlDatos.llamadodocente.@id_tipo_clasificacion;
	_id_subtipo_clasificacion = xmlDatos.llamadodocente.@id_subtipo_clasificacion;
	_id_docente_llamado = xmlDatos.llamadodocente.@id_docente_llamado;
	PopUpManager.removePopUp(e.target as twDocente)
	dispatchEvent(new Event("EventModificar"));
}	

private function fncCerrarPopUp(e:Event):void
{	
	PopUpManager.removePopUp(e.target as twDocente)
	dispatchEvent(new Event("SelectPrincipal"));
}


private function fncBuscarLlamado(e:Event):void
{
	if (txiNroLlamado.text != "") {			
		httpLlam.send({rutina:"buscar_llamado",nro_llamado:txiNroLlamado.text})
	}
}

private function fncLlamadosResult(e:ResultEvent):void
{
	if (httpLlam.lastResult.id_llamado != "") {
		_idLlamado = httpLlam.lastResult.id_llamado;
		_idNivel = httpLlam.lastResult.id_nivel;
		_id_tipo_clasificacion = httpLlam.lastResult.id_tipo_clasificacion;		
		lblDescripcion.text = httpLlam.lastResult.descripcion;
	} else {
		lblDescripcion.text = "Nro de llamado inexistente";
	}
}
			
private function fncGuardar(e:Event):void
{
	var error:String = "";
	clasifica = "si";
	if (_idLlamado == "") {
		error += "No ha ingresado el llamado o el llamado indicado es inexistente\n";
	}
	if (_idDocente == "") {
		error += "No ha seleccionado al docente que desea inscribir\n"
	}
	if (txiNroFolios.text == "") {
		error += "No ha ingresado la cantidad de folios\n";
	}
	if (chkNoClasifica.selected == true) {
		clasifica = "no";
		if (_xmlObs.observacion.length() == 0) {
			error += "Debe indicar las observaciones por las que el docente no clasifica\n";	
		}
	}
	if (error == "") {		
		httpInscrip.send({rutina:"verificar_doble_inscripcion", id_docente:_idDocente, id_llamado:_idLlamado});
	} else {
		Alert.show(error, "E R R O R");
	}	
}

private function fncVerLlamados(e:Event):void
{
	twLlamados = new listallamados;
	twLlamados.addEventListener("EventSeleccionar",fncMostrarLlamado);
	PopUpManager.addPopUp(twLlamados,this,true);
	PopUpManager.centerPopUp(twLlamados);
}

private function fncAgregar(e:Event):void
{
	var errores:String = '';
	var obs:String = httpObs.lastResult.observaciones.observacion[cmbObservaciones.selectedIndex].descripcion;
	var id_obs:String = httpObs.lastResult.observaciones.observacion[cmbObservaciones.selectedIndex].id_observacion;
	var existente : Boolean = false;
	for (var i:int = 0;i < _xmlObs.observacion.length();i++) {
		if (id_obs == _xmlObs.observacion[i].id_observacion) {
			existente = true;
		}
	}
	if (existente == false) {
		var xmlItemObs:XML = <observacion>
							 	<id_observacion></id_observacion>
						 		<descripcion></descripcion>
						 		<comentarios></comentarios>
					         </observacion>;
		xmlItemObs.descripcion = obs;
		xmlItemObs.id_observacion = id_obs;
		if (id_obs == '19') {
			if (txaComentarios.text == '')
				errores += "Al elegir la Observación 'NO CUMPLE CON LOS REQUISITOS EXIGIDOS', debe especificar el motivo\n";
			xmlItemObs.comentarios = txaComentarios.text;	
		}
		if (errores == '')
			_xmlObs.appendChild(xmlItemObs);
		else
			Alert.show(errores,"E R R O R");
	} else 
		Alert.show("La Observación ya ha sido agregada\n","E R R O R");
}

private function fncMostrarLlamado(e:Event):void
{
	_idLlamado = twLlamados.idLlamado;
	_idNivel = twLlamados.idNivel;
	_id_tipo_clasificacion = twLlamados.idTipoClasif;
	txiNroLlamado.text = twLlamados.nroLlamado;
	lblDescripcion.text = twLlamados.descripcion;
	PopUpManager.removePopUp(twLlamados);
}

public function fncEliminarObs():void
{		
	delete _xmlObs.observacion[(gridObservaciones.selectedItem as XML).childIndex()];		
}

private function fncConfirmInscripcion(e:CloseEvent):void
{
	if(e.detail==Alert.YES) 
	{						
		var XMLinscripcion:XML = <inscripcion>
									 <id_docente>{_idDocente}</id_docente>
									 <id_llamado>{_idLlamado}</id_llamado>
									 <folios>{txiNroFolios.text}</folios>
									 <selecciona_cargo></selecciona_cargo>
									 <ruralidad></ruralidad>										 										 										 
							 	 </inscripcion>;
																																	
		httpDatos.send({rutina:"realizar_inscripcion", inscripcion:XMLinscripcion, clasifica:clasifica, observaciones:_xmlObs});		        	
	}
}

private function fncConfirmInscripcion2(e:CloseEvent):void
{
	if(e.detail==Alert.YES) 
	{	
		clasifica = "no";
		var xmlItemObs:XML = <observacion>
							 	<id_observacion></id_observacion>
						 		<descripcion></descripcion>
						 		<comentarios></comentarios>
					         </observacion>;
		xmlItemObs.descripcion = 'NO CUMPLE CON LOS REQUISITOS EXIGIDOS';
		xmlItemObs.id_observacion = '19';		
		xmlItemObs.comentarios = 'INSCRIPCIÓN EN LLAMADO CONFLICTIVO (N° '+_nro_llamado_conflictivo+')';		
		
		_xmlObs.appendChild(xmlItemObs);
			
		var XMLinscripcion:XML = <inscripcion>
									 <id_docente>{_idDocente}</id_docente>
									 <id_llamado>{_idLlamado}</id_llamado>
									 <folios>{txiNroFolios.text}</folios>
									 <selecciona_cargo></selecciona_cargo>
									 <ruralidad></ruralidad>										 										 										 
							 	 </inscripcion>;
																																	
		httpDatos.send({rutina:"realizar_inscripcion", inscripcion:XMLinscripcion, clasifica:clasifica, observaciones:_xmlObs});		        	
	}
}

private function fncDatosResult(e:ResultEvent):void
{	
	if (clasifica == "no") {
		fncInit();
		Alert.show("La inscripción ha sido registrada exitosamente");	
	} else {
		_id_docente_llamado = httpDatos.lastResult.id_docente_llamado;
		dispatchEvent(new Event("EventConfirmarInscripcion"));
	}	 				
}

private function fncInscripResult(e:ResultEvent):void
{
	var estado:String = httpInscrip.lastResult.estado;
	switch (estado) {
		case "0":
			Alert.yesLabel = "Si";			 
			Alert.show("¿Confirma la inscripción al llamado de: '" + _apellidoDocente + ", " + _nombresDocente + "'?","Confirmación", Alert.YES | Alert.NO,null,fncConfirmInscripcion);
			break;
		case "1":
			Alert.show("El docente seleccionado ya ha sido inscripto en el llamado indicado\n","E R R O R");
			break;
		case "2":
			_nro_llamado_conflictivo = httpInscrip.lastResult.nro_llamado;
			Alert.yesLabel = "Si";			 
			Alert.show("El docente se encuentra inscripto en un llamado conflictivo (N° "+_nro_llamado_conflictivo+"), " + 
					   "si continúa la inscripción será observada ¿Confirma la inscripción al llamado de: '" + _apellidoDocente + ", " + _nombresDocente + "'?","Confirmación", Alert.YES | Alert.NO,null,fncConfirmInscripcion2);
			break;
	}
}
		
private function fncObsResult(e:Event) : void 			
{	    	 	
	cmbObservaciones.dataProvider = httpObs.lastResult.observaciones.observacion.descripcion;	 	
}