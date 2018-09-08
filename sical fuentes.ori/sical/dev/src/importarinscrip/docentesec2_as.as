import clases.HTTPServices;
import mx.events.ListEvent;
import flash.events.Event;
import mx.rpc.events.ResultEvent;
import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import importarinscrip.twdocentesec2;

include "../control_acceso.as";
	
[Bindable] private var httpDatos:HTTPServices = new HTTPServices;
[Bindable] private var httpLlamado:HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
[Bindable] private var httpAcLlamados : HTTPServices = new HTTPServices;
private var _id_docente_llamado:String;
private var _id_llamado:String;
private var twDoc : twdocentesec2;
	
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
	
	httpCombos.url = "importarinscrip/twdocentesec2.php";
	httpCombos.addEventListener("acceso",acceso);
	httpCombos.send({rutina:"traer_datos"});
	
	//preparo el autocomplete		
	acLlamado.addEventListener(ListEvent.CHANGE,ChangeAcLlamado);
	acLlamado.addEventListener("close",CloseAcLlamado);
	acLlamado.labelField = "@descripcion";
	
	//preparo el httpservice necesario para el autocomplete
	httpAcLlamados.url = "twdocente/twdocente.php";
	httpAcLlamados.addEventListener("acceso",acceso);
	httpAcLlamados.addEventListener(ResultEvent.RESULT,fncCargarAcLlamado);
	
	httpLlamado.url = "twdocente/twdocente.php";
	httpLlamado.addEventListener("acceso",acceso);
	httpLlamado.addEventListener(ResultEvent.RESULT,fncCargarLlamado);
	
	twDoc = new twdocentesec2;
	PopUpManager.addPopUp(twDoc,this,true);
    PopUpManager.centerPopUp(twDoc);
    twDoc.addEventListener("verDocente",fncVerDocente);
    twDoc.addEventListener("Close",fncCerrarPopUp);		
    
    httpDatos.url = "importarinscrip/docentesec2.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncGuardarResult);
	
	txiNroLlamado.addEventListener("focusOut",fncBuscarLlamado);
}		
		
private function fncVerDocente(e:Event):void
{
	var xmlDatos : XML = twDoc.xmlDatos;
	_id_docente_llamado = xmlDatos.llamadodocente.@id_docente_llamado;
	_id_llamado = xmlDatos.llamadodocente.@id_llamado;
	txiNroDoc.text = xmlDatos.llamadodocente.@nro_doc;
	txiApellido.text = xmlDatos.llamadodocente.@apellido;
	txiNombres.text = xmlDatos.llamadodocente.@nombres;
	txiTipoDoc.text = xmlDatos.llamadodocente.@tipo_doc;
	btnGuardar.enabled = true;
	PopUpManager.removePopUp(e.target as twdocentesec2)
}

private function ChangeAcLlamado(e:Event):void{
	if (acLlamado.text.length==3){
		httpAcLlamados.send({rutina:"traer_llamados",descripcion:acLlamado.text});
	}
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

private function CloseAcLlamado(e:Event):void {
	if (acLlamado.selectedIndex!=-1) {
		txiNroLlamado.text = acLlamado.selectedItem.@nro_llamado;
	}		
}

private function fncGuardar(e:Event):void
{
	if (acLlamado.selectedIndex != -1) {
		if (acLlamado.selectedItem.@id_llamado != _id_llamado)
			httpDatos.send({rutina:"importar_inscripcion", id_docente_llamado:_id_docente_llamado, id_llamado:acLlamado.selectedItem.@id_llamado});
		else
			Alert.show("El llamado seleccionado debe ser diferente al llamado de origen\n","E R R O R");	
	} else
		Alert.show("Debe seleccionar el llamado de destino\n","E R R O R");
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
	PopUpManager.removePopUp(e.target as twdocentesec2)
	dispatchEvent(new Event("SelectPrincipal"));
}