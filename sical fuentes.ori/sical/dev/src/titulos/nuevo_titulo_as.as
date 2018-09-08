import clases.HTTPServices;

import flash.events.Event;

import mx.core.UIComponent;
import mx.events.ListEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import mx.controls.Alert;	

include "../control_acceso.as";

[Bindable] private var httpDatos : HTTPServices = new HTTPServices;	
[Bindable] private var httpAcTitulos : HTTPServices = new HTTPServices;
[Bindable] private var _xmlTitulo : XML = <titulo id_titulo="0" codigo="0" denominacion="" promedio="0" a31="0" a41="0" a42="0" a43="0" a44="0" a45="0" k71="0" k72="0" observacion="" />;
private var _accion : String;

public function get xmlTitulo():XML
{
	return _xmlTitulo.copy();
}

public function set xmlTitulo(ant:XML):void
{
	_xmlTitulo = ant;
	_accion = "editar";
}
	
//inicializa las variales necesarias para el modulo
public function fncInit():void
{	
	//preparo el PopUp Para que se cierre con esc y marco el default button
	this.defaultButton = btnGrabar;
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});
	//preparo el autocomplete		
	acTitulo.addEventListener(ListEvent.CHANGE,ChangeacTitulo);
	acTitulo.addEventListener("close",CloseacTitulo);
	acTitulo.labelField = "@denominacion";
	//acTitulo.setFocus();
	//preparo el httpservice necesario para el autocomplete
	httpAcTitulos.url = "titulos/nuevo_titulo.php";
	httpAcTitulos.addEventListener("acceso",acceso);
	httpAcTitulos.addEventListener(ResultEvent.RESULT,fncCargaracTitulo);
	httpDatos.url = "titulos/nuevo_titulo.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarTitulo);
	// escucho evento de los botones
	btnCancel.addEventListener("click",fncCerrar);
	btnGrabar.addEventListener("click",fncConfirmar);
	// si se trata de una edicion cargo el valor a editar
	if (_accion == "editar"){
		acTitulo.typedText = _xmlTitulo.@antecedente;			
		_xmlTitulo.@accion = 'Modificación';		
	} else {
		_xmlTitulo.@accion = 'Alta';
	}
	txiCodigo.addEventListener("focusOut",fncBuscarTit);
	txiCodigo.setFocus();	
}

private function fncBuscarTit(e:Event):void
{
	if (txiCodigo.text != "") {
		httpDatos.send({rutina:"buscar_tit",codigo:txiCodigo.text});	
	}		
}

private function ChangeacTitulo(e:Event):void{
	if (acTitulo.text.length==3){
		httpAcTitulos.send({rutina:"traer_antecedentes",titulo:acTitulo.text});
	}
}

private function CloseacTitulo(e:Event):void {
	if (acTitulo.selectedIndex!=-1) {
		txiCodigo.text = acTitulo.selectedItem.@codigo;
	}		
}
	
private function fncCargaracTitulo(e:Event):void{
	acTitulo.typedText = acTitulo.text;
	acTitulo.dataProvider = httpAcTitulos.lastResult.titulo;		
}

private function fncCargarTitulo(e:Event):void{		
	acTitulo.dataProvider = httpDatos.lastResult.titulo;		
}

private function fncCerrar(e:Event):void
{
	PopUpManager.removePopUp(this)	
}

private function fncConfirmar(e:Event):void
{
	var error:Array = new Array();
	if (error.length>0) {
		((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
	} else if (acTitulo.selectedItem==null) {
		acTitulo.errorString='Debe seleccionar un antecedente válido';
		acTitulo.setFocus();
	}else {
		if (acTitulo.selectedIndex!=-1){
			_xmlTitulo.@denominacion = acTitulo.text;
			_xmlTitulo.@id_titulo = acTitulo.selectedItem.@id;				
			_xmlTitulo.@denominacion= acTitulo.selectedItem.@denominacion;
			_xmlTitulo.@codigo= acTitulo.selectedItem.@codigo;
		}			
		dispatchEvent(new Event("EventConfirmarAntecedente"));
	}	
}

private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@denominacion;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}