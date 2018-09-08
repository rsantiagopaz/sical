import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.validators.Validator;

include "../control_acceso.as";

[Bindable] private var httpDatos:HTTPServices = new HTTPServices;
[Bindable] private var httpLlamadoUno:HTTPServices = new HTTPServices;
[Bindable] private var httpLlamadoDos:HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
[Bindable] private var httpAcLlamadosUno : HTTPServices = new HTTPServices;
[Bindable] private var httpAcLlamadosDos : HTTPServices = new HTTPServices;
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
	acLlamadoUno.addEventListener(ListEvent.CHANGE,ChangeAcLlamadoUno);
	acLlamadoUno.addEventListener("close",CloseAcLlamadoUno);
	acLlamadoUno.labelField = "@descripcion";
	
	acLlamadoDos.addEventListener(ListEvent.CHANGE,ChangeAcLlamadoDos);
	acLlamadoDos.addEventListener("close",CloseAcLlamadoDos);
	acLlamadoDos.labelField = "@descripcion";
	
	//preparo el httpservice necesario para el autocomplete
	httpAcLlamadosUno.url = "twdocente/twdocente.php";
	httpAcLlamadosUno.addEventListener("acceso",acceso);
	httpAcLlamadosUno.addEventListener(ResultEvent.RESULT,fncCargarAcLlamadoUno);
	
	httpAcLlamadosDos.url = "twdocente/twdocente.php";
	httpAcLlamadosDos.addEventListener("acceso",acceso);
	httpAcLlamadosDos.addEventListener(ResultEvent.RESULT,fncCargarAcLlamadoDos);
	
	idLlamadoDocente = '';			
	httpDatos.url = "unificarllamados/unificarllamados.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);
	
	httpLlamadoUno.url = "twdocente/twdocente.php";
	httpLlamadoUno.addEventListener("acceso",acceso);
	httpLlamadoUno.addEventListener(ResultEvent.RESULT,fncCargarLlamadoUno);
	
	httpLlamadoDos.url = "twdocente/twdocente.php";
	httpLlamadoDos.addEventListener("acceso",acceso);
	httpLlamadoDos.addEventListener(ResultEvent.RESULT,fncCargarLlamadoDos);		
	
	txiNroLlamadoUno.addEventListener("focusOut",fncBuscarLlamadoUno);
	txiNroLlamadoDos.addEventListener("focusOut",fncBuscarLlamadoDos);
	
	btnMostrar.addEventListener("click",fncIniciarBusqueda);	
	btncancel.addEventListener("click",fncCerrar);	
}		

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));		
}

private function fncCargarAcLlamadoUno(e:Event):void{
	acLlamadoUno.typedText = acLlamadoUno.text;
	acLlamadoUno.dataProvider = httpAcLlamadosUno.lastResult.llamados;		
}

private function fncCargarAcLlamadoDos(e:Event):void{
	acLlamadoDos.typedText = acLlamadoDos.text;
	acLlamadoDos.dataProvider = httpAcLlamadosDos.lastResult.llamados;		
}

private function fncBuscarLlamadoUno(e:Event):void
{
	if (txiNroLlamadoUno.text != "") {
		httpLlamadoUno.send({rutina:"buscar_llamado",nro_llamado:txiNroLlamadoUno.text});	
	}		
}

private function fncBuscarLlamadoDos(e:Event):void
{
	if (txiNroLlamadoDos.text != "") {
		httpLlamadoDos.send({rutina:"buscar_llamado",nro_llamado:txiNroLlamadoDos.text});	
	}		
}

private function fncCargarLlamadoUno(e:Event):void{		
	acLlamadoUno.dataProvider = httpLlamadoUno.lastResult.llamados;		
}

private function fncCargarLlamadoDos(e:Event):void{		
	acLlamadoDos.dataProvider = httpLlamadoDos.lastResult.llamados;		
}

private function ChangeAcLlamadoUno(e:Event):void{
	if (acLlamadoUno.text.length==3){
		httpAcLlamadosUno.send({rutina:"traer_llamados",descripcion:acLlamadoUno.text});
	}
}

private function ChangeAcLlamadoDos(e:Event):void{
	if (acLlamadoDos.text.length==3){
		httpAcLlamadosDos.send({rutina:"traer_llamados",descripcion:acLlamadoDos.text});
	}
}

private function CloseAcLlamadoUno(e:Event):void {
	if (acLlamadoUno.selectedIndex!=-1) {
		txiNroLlamadoUno.text = acLlamadoUno.selectedItem.@nro_llamado;
	}		
}

private function CloseAcLlamadoDos(e:Event):void {
	if (acLlamadoDos.selectedIndex!=-1) {
		txiNroLlamadoDos.text = acLlamadoDos.selectedItem.@nro_llamado;
	}		
}

private function fncValidar():Boolean
{			
	if (acLlamadoUno.selectedItem==null || acLlamadoDos.selectedItem==null) {
		Alert.show("Debe seleccionar los llamados a consultar\n","ERROR");
		return false;
	} else {
		if (acLlamadoUno.selectedItem.@id_llamado == acLlamadoDos.selectedItem.@id_llamado) {
			Alert.show("Los llamados deben ser distintos\n","ERROR");
			return false;
		} else
			return true;
	}
}

private function fncIniciarBusqueda(e:Event):void
{
	if (fncValidar()){		
		httpDatos.send({rutina:"consultar_doble_inscripcion", id_llamado_origen_uno:acLlamadoUno.selectedItem.@id_llamado, 
			id_llamado_origen_dos:acLlamadoDos.selectedItem.@id_llamado});
	}	
}

private function fncCargarDatos(e:Event):void
{
	var ok:String = httpDatos.lastResult.ok;
	if (ok == "1") {
		Alert.show("No existen docentes con doble inscripción\n");
		dispatchEvent(new Event("SelectPrincipal"));	
	} else {
		Alert.show("Existen docentes con doble inscripción " + 
				   	"¿Desea ver el listado de docentes inscriptos en ambos llamados?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmListar, null, Alert.OK);			
	}
}

private function fncConfirmListar(e:CloseEvent):void
{
	if (e.detail==Alert.OK){
		//Creo los contenedores para enviar datos y recibir respuesta
		var enviar:URLRequest = new URLRequest("unificarllamados/unificarllamados.php?rutina=listar_docentes_ambos_llamados&");
		var recibir:URLLoader = new URLLoader();
	 		 
		//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
		var variables:URLVariables = new URLVariables();
		
		variables.id_llamado_origen_uno = acLlamadoUno.selectedItem.@id_llamado;
		variables.id_llamado_origen_dos = acLlamadoDos.selectedItem.@id_llamado;				
					
		//Indico que voy a enviar variables dentro de la petición
		enviar.data = variables;
		
		navigateToURL(enviar);				
	}		
}