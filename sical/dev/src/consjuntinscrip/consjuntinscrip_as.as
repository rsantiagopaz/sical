import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.ListEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.validators.Validator;	

include "../control_acceso.as";

[Bindable] private var _xmlReclamos:XML = <reclamos></reclamos>;
[Bindable] private var _xmlMotivos:XML = <motivos></motivos>;
[Bindable] private var _xmlRespuestas:XML = <respuestas></respuestas>;
private var httpDatos:HTTPServices = new HTTPServices;	
private var httpDatos2:HTTPServices = new HTTPServices;
[Bindable] private var httpLlamado:HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
[Bindable] private var httpAcLlamados : HTTPServices = new HTTPServices;
[Bindable] public var idDocente : String;
[Bindable] public var idLlamadoDocente : String;	

public function get xmlMotivos():XML { return _xmlMotivos }

public function get xmlRespuestas():XML { return _xmlRespuestas }

public function get id_docente_llamado():String { return idLlamadoDocente }	


public function fncInit():void
{	
	//preparo el autocomplete		
	acLlamado.addEventListener(ListEvent.CHANGE,ChangeAcLlamado);
	acLlamado.addEventListener("close",CloseAcLlamado);
	acLlamado.labelField = "@descripcion";
	
	//preparo el httpservice necesario para el autocomplete
	httpAcLlamados.url = "twdocente/twdocente.php";
	httpAcLlamados.addEventListener("acceso",acceso);
	httpAcLlamados.addEventListener(ResultEvent.RESULT,fncCargarAcLlamado);
	
	idLlamadoDocente = '';
	idDocente = '';
	
	httpDatos.url = "consjuntinscrip/consjuntinscrip.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);
	
	httpLlamado.url = "twdocente/twdocente.php";
	httpLlamado.addEventListener("acceso",acceso);
	httpLlamado.addEventListener(ResultEvent.RESULT,fncCargarLlamado);
	
	httpCombos.url = "consjuntinscrip/consjuntinscrip.php";
	httpCombos.addEventListener("acceso",acceso);
	httpCombos.send({rutina:"traer_datos_combos"});
	
	txiNroLlamado.addEventListener("focusOut",fncBuscarLlamado);	
			
	btnCerrar.addEventListener("click" ,fncCerrar);		
	
	btnBuscar.addEventListener("click",fncIniciarBusqueda);
	btnImprimir.addEventListener("click",fncImprimir);
}

private function fncCargarAcLlamado(e:Event):void{
	acLlamado.typedText = acLlamado.text;
	acLlamado.dataProvider = httpAcLlamados.lastResult.llamados;		
}

private function fncBuscarLlamado(e:Event):void
{
	if (txiNroLlamado.text != "") {
		httpLlamado.send({rutina:"buscar_llamado",nro_llamado:txiNroLlamado.text});	
	}		
}

private function fncCargarLlamado(e:Event):void{		
	acLlamado.dataProvider = httpLlamado.lastResult.llamados;		
}

private function ChangeAcLlamado(e:Event):void{
	if (acLlamado.text.length==3){
		httpAcLlamados.send({rutina:"traer_llamados",descripcion:acLlamado.text});
	}
}

private function CloseAcLlamado(e:Event):void {
	if (acLlamado.selectedIndex!=-1) {
		txiNroLlamado.text = acLlamado.selectedItem.@nro_llamado;
	}		
}

private function fncImprimir(e:Event):void
{		
	//Creo los contenedores para enviar datos y recibir respuesta
	var enviar:URLRequest = new URLRequest("confirmacion/listado_de_antecedentes.php?rutina=reporte_antecedentes_docente&");
	var recibir:URLLoader = new URLLoader();
 		 
	//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
	var variables:URLVariables = new URLVariables();
	
	variables.id_docente_llamado = idLlamadoDocente;
	//variables.idNivel = cmbLlamado.selectedItem.id_nivel;
	variables.idNivel = acLlamado.selectedItem.@id_nivel;			
				
	//Indico que voy a enviar variables dentro de la petición
	enviar.data = variables;
	
	navigateToURL(enviar);
}

private function fncIniciarBusqueda(e:Event):void
{
	if (fncValidar()){
		//httpDatos.send({rutina:"buscar_docente_llamado", tipo_doc:cmbTiposDoc.selectedItem.@id_tipo_doc, nro_doc:txtNroDoc.text,id_llamado:cmbLlamado.selectedItem.id_llamado});
		httpDatos.send({rutina:"buscar_docente_llamado", tipo_doc:cmbTiposDoc.selectedItem.@id_tipo_doc, nro_doc:txtNroDoc.text, id_llamado:acLlamado.selectedItem.@id_llamado});
	}	
}

private function fncValidar():Boolean
{
	var error:Array = Validator.validateAll([validNDOC]);
	if (error.length>0) {
		((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
		return false;
	}else{
		if (acLlamado.selectedItem==null) {
			return false;
		} else {
			return true;
		}	
	}			
}

private function fncCargarDatos(e:Event):void
{
	idDocente = httpDatos.lastResult.docente.@id_docente;
	if (idDocente != '0' && idDocente) {
		txiNombre.text = httpDatos.lastResult.docente.@apellido + ', ' + httpDatos.lastResult.docente.@nombres;
		idLlamadoDocente = httpDatos.lastResult.llamadodocente.@id_docente_llamado;
		if (idLlamadoDocente != '0' && idLlamadoDocente){			
			if (httpDatos.lastResult.obsllamado.@cantobs != "0") {
				idLlamadoDocente = '';
				Alert.show("La inscripción del Docente al Llamado Seleccionado se encuentra observada. Para eliminar la/s observación/es y completar la ficha debe dar de baja la inscripción","ERROR");
			}			
		}else{
			_xmlReclamos = <consjuntinscrip></consjuntinscrip>;
			Alert.show("El Docente ingresado no se encuentra Inscripto en el Llamado Seleccionado","ERROR");		
		}	
	} else {
		txiNombre.text = '';
		idLlamadoDocente = '';
		_xmlReclamos = <consjuntinscrip></consjuntinscrip>;
		Alert.show("El Docente ingresado no se encuentra registrado","ERROR");
	}
}		

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}			
