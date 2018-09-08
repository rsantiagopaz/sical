import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import secundario.twdocentesec;

include "../control_acceso.as";
	
[Bindable] private var httpDatos:HTTPServices = new HTTPServices;
private var _id_docente_llamado:String;
private var twDoc : twdocentesec;
	
public function fncInit():void
{
	txiNroDoc.text = '';
	txiApellido.text = '';
	txiNombres.text = '';
	txiTipoDoc.text = '';
	this.defaultButton = btnGuardar;
	btnGuardar.enabled = false;
	btnGuardar.addEventListener("click" ,fncGuardar);
	btnCancelar.addEventListener("click" ,fncCerrar);
	
	twDoc = new twdocentesec;
	PopUpManager.addPopUp(twDoc,this,true);
    PopUpManager.centerPopUp(twDoc);
    twDoc.addEventListener("verDocente",fncVerDocente);
    twDoc.addEventListener("Close",fncCerrarPopUp);		
    
    httpDatos.url = "secundario/docentesec.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncGuardarResult);
}		
		
private function fncVerDocente(e:Event):void
{
	var xmlDatos : XML = twDoc.xmlDatos;
	_id_docente_llamado = xmlDatos.llamadodocente.@id_docente_llamado;
	txiNroDoc.text = xmlDatos.llamadodocente.@nro_doc;
	txiApellido.text = xmlDatos.llamadodocente.@apellido;
	txiNombres.text = xmlDatos.llamadodocente.@nombres;
	txiTipoDoc.text = xmlDatos.llamadodocente.@tipo_doc;
	btnGuardar.enabled = true;
	PopUpManager.removePopUp(e.target as twdocentesec)
}		

private function fncGuardar(e:Event):void
{
	httpDatos.send({rutina:"importar_inscripcion", id_docente_llamado:_id_docente_llamado});
}

private function fncGuardarResult(e:Event):void
{
	Alert.show("La inscripción fue importada");
	dispatchEvent(new Event("SelectPrincipal"));	
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("SelectPrincipal"));
}

private function fncCerrarPopUp(e:Event):void
{	
	PopUpManager.removePopUp(e.target as twdocentesec)
	dispatchEvent(new Event("SelectPrincipal"));
}