import clases.HTTPServices;

import flash.events.Event;		

import mx.core.UIComponent;
import mx.events.ListEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;	

include "../control_acceso.as";

[Bindable] private var httpDatos : HTTPServices = new HTTPServices;		
[Bindable] private var httpAcEstablecimientos : HTTPServices = new HTTPServices;
[Bindable] private var _xmlEstablecimiento : XML = <establecimiento id_escuela="0" codigo="0" nombre="" id_localidad="0" nivel="0" />;
private var _accion : String;
private var _idNivel : String;

public function get xmlEstablecimiento():XML
{
	return _xmlEstablecimiento.copy();
}

public function set xmlEstablecimiento(ant:XML):void
{
	_xmlEstablecimiento = ant;
	_accion = "editar";
}

public function set idNivel(idNivel:String):void
{
	_idNivel = idNivel;
}
	
//inicializa las variales necesarias para el modulo
public function fncInit():void
{	
	//preparo el PopUp Para que se cierre con esc y marco el default button
	this.defaultButton = btnGrabar;
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});
	//preparo el autocomplete		
	acEstablecimiento.addEventListener(ListEvent.CHANGE,ChangeacEstablecimiento);		
	acEstablecimiento.addEventListener("close",CloseacEstablecimiento);
	acEstablecimiento.labelField = "@nombre";
	//acEstablecimiento.setFocus();
	//preparo el httpservice necesario para el autocomplete
	httpAcEstablecimientos.url = "datosgenerales/nuevo_establecimiento.php";
	httpAcEstablecimientos.addEventListener("acceso",acceso);
	httpAcEstablecimientos.addEventListener(ResultEvent.RESULT,fncCargaracEstablecimiento);
	httpDatos.url = "datosgenerales/nuevo_establecimiento.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarEstablecimiento);
	// escucho evento de los botones*/
	btnCancel.addEventListener("click",fncCerrar);
	btnGrabar.addEventListener("click",fncConfirmar);
	// si se trata de una edicion cargo el valor a editar
	if (_accion == "editar"){
		acEstablecimiento.typedText = _xmlEstablecimiento.@nombre;			
		_xmlEstablecimiento.@accion = 'Modificación';		
	} else {
		_xmlEstablecimiento.@accion = 'Alta';
	}		
	txiCodigo.addEventListener("focusOut",fncBuscarEst);
	txiCodigo.setFocus();		
}

private function fncBuscarEst(e:Event):void
{
	if (txiCodigo.text != "") {
		httpDatos.send({rutina:"buscar_est",codigo:txiCodigo.text,idNivel:_idNivel});	
	}		
}

private function ChangeacEstablecimiento(e:Event):void{
	if (acEstablecimiento.text.length==3){
		httpAcEstablecimientos.send({rutina:"traer_establecimientos",nombre:acEstablecimiento.text,idNivel:_idNivel});		
	}
}

private function CloseacEstablecimiento(e:Event):void {
	if (acEstablecimiento.selectedIndex!=-1) {
		txiCodigo.text = acEstablecimiento.selectedItem.@codigo;
	}		
}
	
private function fncCargaracEstablecimiento(e:Event):void{
	acEstablecimiento.typedText = acEstablecimiento.text;
	acEstablecimiento.dataProvider = httpAcEstablecimientos.lastResult.establecimiento;		
}

private function fncCargarEstablecimiento(e:Event):void{		
	acEstablecimiento.dataProvider = httpDatos.lastResult.establecimiento;		
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
	} else if (acEstablecimiento.selectedItem==null) {
		acEstablecimiento.errorString='Debe seleccionar un antecedente válido';
		acEstablecimiento.setFocus();
	}else {
		if (acEstablecimiento.selectedIndex!=-1){
			_xmlEstablecimiento.@nombre = acEstablecimiento.text;
			_xmlEstablecimiento.@id_escuela = acEstablecimiento.selectedItem.@id_escuela;				
			_xmlEstablecimiento.@nombre= acEstablecimiento.selectedItem.@nombre;
			_xmlEstablecimiento.@codigo= acEstablecimiento.selectedItem.@codigo;
		}			
		dispatchEvent(new Event("EventConfirmarAntecedente"));
	}	
}
	
private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@nombre;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}