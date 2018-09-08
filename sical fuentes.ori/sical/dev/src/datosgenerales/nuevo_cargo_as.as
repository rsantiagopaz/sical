import clases.HTTPServices;

import flash.events.Event;

import mx.core.UIComponent;
import mx.events.ListEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;	

include "../control_acceso.as";

[Bindable] private var httpDatos : HTTPServices = new HTTPServices;		
[Bindable] private var httpAcCargos : HTTPServices = new HTTPServices;
[Bindable] private var _xmlCargo : XML = <cargo id_cargo="0" codigo="0" denominacion="" />;
private var _accion : String;
private var _jornada : String;
private var _subtipo : String;
private var _idNivel : String;

public function get xmlCargo():XML
{
	return _xmlCargo.copy();
}

public function set xmlCargo(ant:XML):void
{
	_xmlCargo = ant;
	_accion = "editar";
}

public function set jornada(j:String):void
{
	_jornada = j;
}

public function set subtipo(s:String):void
{
	_subtipo = s;
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
	acCargo.addEventListener(ListEvent.CHANGE,ChangeacCargo);		
	acCargo.addEventListener("close",CloseacCargo);
	acCargo.labelField = "@denominacion";
	//acCargo.setFocus();
	//preparo el httpservice necesario para el autocomplete
	httpAcCargos.url = "datosgenerales/nuevo_cargo.php";
	httpAcCargos.addEventListener("acceso",acceso);
	httpAcCargos.addEventListener(ResultEvent.RESULT,fncCargaracCargo);
	httpDatos.url = "datosgenerales/nuevo_cargo.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarCargo);
	// escucho evento de los botones*/
	btnCancel.addEventListener("click",fncCerrar);
	btnGrabar.addEventListener("click",fncConfirmar);
	// si se trata de una edicion cargo el valor a editar
	if (_accion == "editar"){
		acCargo.typedText = _xmlCargo.@nombre;			
		_xmlCargo.@accion = 'Modificación';		
	} else {
		_xmlCargo.@accion = 'Alta';
	}		
	txiCodigo.addEventListener("focusOut",fncBuscarCargo);
	txiCodigo.setFocus();		
}

private function fncBuscarCargo(e:Event):void
{
	if (txiCodigo.text != "") {
		httpDatos.send({rutina:"buscar_cargo",codigo:txiCodigo.text,jornada:_jornada,idNivel:_idNivel,subtipo:_subtipo});	
	}		
}

private function ChangeacCargo(e:Event):void{
	if (acCargo.text.length==3){
		httpAcCargos.send({rutina:"traer_cargos",denominacion:acCargo.text,jornada:_jornada,idNivel:_idNivel,subtipo:_subtipo});		
	}
}

private function CloseacCargo(e:Event):void {
	if (acCargo.selectedIndex!=-1) {
		txiCodigo.text = acCargo.selectedItem.@codigo;
	}		
}
	
private function fncCargaracCargo(e:Event):void{
	acCargo.typedText = acCargo.text;
	acCargo.dataProvider = httpAcCargos.lastResult.cargo;		
}

private function fncCargarCargo(e:Event):void{		
	acCargo.dataProvider = httpDatos.lastResult.cargo;		
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
	} else if (acCargo.selectedItem==null) {
		acCargo.errorString='Debe seleccionar un cargo válido';
		acCargo.setFocus();
	}else {
		if (acCargo.selectedIndex!=-1){
			_xmlCargo.@denominacion = acCargo.text;
			_xmlCargo.@id_cargo = acCargo.selectedItem.@id_cargo;				
			_xmlCargo.@denominacion= acCargo.selectedItem.@denominacion;
			_xmlCargo.@codigo= acCargo.selectedItem.@codigo;
		}			
		dispatchEvent(new Event("EventConfirmarCargo"));
	}	
}

private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@denominacion;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}