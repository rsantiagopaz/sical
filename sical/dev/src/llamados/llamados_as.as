import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.events.FaultEvent;
import mx.events.ValidationResultEvent;
import mx.validators.Validator;
import mx.rpc.http.mxml.HTTPService;

include "../control_acceso.as";

[Bindable] private var httpDatos : HTTPService = new HTTPService;
[Bindable] private var httpNiveles : HTTPServices = new HTTPServices;
private var _idIngresoMovimiento:String;	
[Bindable] private var id_departamento:String;
[Bindable] private var _xmlTipoNiveles : XML = <niveles></niveles>;

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("SelectPrincipal"));
}

public function fncInit():void
{
	_xmlTipoNiveles = <niveles></niveles>;		
	httpDatos.url = "llamados/llamados.php";
	httpDatos.method = URLRequestMethod.POST;
	httpDatos.useProxy = false;
	httpDatos.resultFormat = "e4x";
	httpDatos.showBusyCursor = true;
	//httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);
	httpDatos.addEventListener(FaultEvent.FAULT,fncDatosFault);
	btnGuardar.addEventListener("click" ,fncGuardar);
	//preparo el httpservice que trae la info de los combos
	httpNiveles.url = "llamados/llamados.php";
	httpNiveles.addEventListener("acceso",acceso);
	httpNiveles.addEventListener(ResultEvent.RESULT,fncCargarDatos);
	httpNiveles.send({rutina:"traer_niveles"});
	init();	
}

private function init():void
{
	txiCodigo.text = '';
	txiDescripcion.text = '';
	dfFechaInicio.selectedDate = null;
	dfFechaFin.selectedDate = null;
}
		
private function fncGuardar(e:Event):void
{
	Alert.yesLabel = "Si";			 
	Alert.show("¿Confirma el Alta del llamado?","Confirmación", Alert.YES | Alert.NO,null,fncConfirmLlamado);
}

private function fncConfirmLlamado(e:CloseEvent):void
{
	if(e.detail==Alert.YES) 
	{
		var error:Array = Validator.validateAll([validCodigo,validDescripcion]);			
		if (error.length>0) {
			((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
		} else {
			var XMLllamado:XML = <llamados>
											<id_llamado></id_llamado>
											<nro_llamado>{txiCodigo.text}</nro_llamado>
											<descripcion>{txiDescripcion.text}</descripcion>												
											<fecha_desde>{dfFechaInicio.text}</fecha_desde>
											<fecha_hasta>{dfFechaFin.text}</fecha_hasta>
											<id_nivel>{cboNivel.selectedItem.@id_nivel}</id_nivel>
											<estado>A</estado>
										 </llamados>;											 				
								
			httpDatos.send({rutina:"alta_modificacion", llamado:XMLllamado});
		}	        	
	}
}

private function fncDatosResult(e:ResultEvent):void
{
	init();
}

private function fncDatosFault(e:FaultEvent):void
{
	Alert.show(e.fault.faultString, "Error");
}

private function fncCargarDatos(e:Event):void
{
	_xmlTipoNiveles.appendChild(httpNiveles.lastResult.nivel);
}