import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.ListEvent;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var httpDatos:HTTPServices = new HTTPServices;
[Bindable] private var httpLlamado:HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
[Bindable] private var httpAcLlamados : HTTPServices = new HTTPServices;
[Bindable] public var idLlamadoDocente : String;
private var _accion : String;
private var _xmlDatos : XML;

public function get xmlDatos():XML{return _xmlDatos;}

public function set accion(acc:String):void{_accion = acc;}

public function fncInit():void
{	
	_xmlDatos = <xml></xml>;
	//preparo el PopUp Para que se cierre con esc		
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btncancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});
	//preparo el autocomplete		
	acLlamado.addEventListener(ListEvent.CHANGE,ChangeAcLlamado);
	acLlamado.addEventListener("close",CloseAcLlamado);
	acLlamado.labelField = "@descripcion";
	
	//preparo el httpservice necesario para el autocomplete
	httpAcLlamados.url = "separarllamado/separarllamado.php";
	httpAcLlamados.addEventListener("acceso",acceso);
	httpAcLlamados.addEventListener(ResultEvent.RESULT,fncCargarAcLlamado);
	
	idLlamadoDocente = '';			
	httpDatos.url = "separarllamado/separarllamado.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);
	
	httpLlamado.url = "separarllamado/separarllamado.php";
	httpLlamado.addEventListener("acceso",acceso);
	httpLlamado.addEventListener(ResultEvent.RESULT,fncCargarLlamado);
	
	httpCombos.url = "separarllamado/separarllamado.php";
	httpCombos.addEventListener("acceso",acceso);
	httpCombos.send({rutina:"traer_datos"});
	
	txiNroLlamado.addEventListener("focusOut",fncBuscarLlamado);
	
	btnMostrar.addEventListener("click",fncIniciarBusqueda);	
	btncancel.addEventListener("click",fncCerrar);	
}		
	

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));		
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

private function fncIniciarBusqueda(e:Event):void
{
	if (acLlamado.selectedItem!=null) {
		Alert.yesLabel = "Si";			 
		Alert.show("Las fichas de inscripción de docentes para dicho llamado serán separadas en dos llamados para docentes con cargo y sin cargo respectivamente. No se eliminará el llamado original ¿Confirma la Separación del Llamado?","Confirmación Cierre", Alert.YES | Alert.NO,null,fncCierreLlamado);	
	}					
}

private function fncCierreLlamado(e:CloseEvent):void
{
	if (e.detail==Alert.YES) {		
		httpDatos.send({rutina:"separar_llamado", id_llamado:acLlamado.selectedItem.@id_llamado, accion:_accion});
	}
}

private function fncCargarDatos(e:Event):void
{		
	Alert.show("Se han creado los llamados: CON CARGO NRO: " + httpDatos.lastResult.nro_llamado_con_cargo + ", SIN CARGO NRO: " + httpDatos.lastResult.nro_llamado_sin_cargo,"CIERRE");				
}

private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@descripcion;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}