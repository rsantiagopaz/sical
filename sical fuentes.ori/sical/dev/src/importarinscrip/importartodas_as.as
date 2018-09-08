import clases.HTTPServices;
import mx.events.ListEvent;
import flash.events.Event;
import mx.rpc.events.ResultEvent;
import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
	
[Bindable] private var httpDatos:HTTPServices = new HTTPServices;
[Bindable] private var httpLlamadoOrigen:HTTPServices = new HTTPServices;
[Bindable] private var httpLlamadoDestino:HTTPServices = new HTTPServices;
[Bindable] private var httpAcLlamadosOrigen : HTTPServices = new HTTPServices;
[Bindable] private var httpAcLlamadosDestino : HTTPServices = new HTTPServices;
private var _id_docente_llamado:String;
private var _id_llamado:String;
	
public function fncInit():void
{	
	this.defaultButton = btnGuardar;	
	btnGuardar.addEventListener("click" ,fncGuardar);
	btnCancelar.addEventListener("click" ,fncCerrar);		
	
	//preparo el autocomplete		
	acLlamadoOrigen.addEventListener(ListEvent.CHANGE,ChangeAcLlamadoOrigen);
	acLlamadoOrigen.addEventListener("close",CloseAcLlamadoOrigen);
	acLlamadoOrigen.labelField = "@descripcion";
	
	acLlamadoDestino.addEventListener(ListEvent.CHANGE,ChangeAcLlamadoDestino);
	acLlamadoDestino.addEventListener("close",CloseAcLlamadoDestino);
	acLlamadoDestino.labelField = "@descripcion";
	
	//preparo el httpservice necesario para el autocomplete
	httpAcLlamadosOrigen.url = "twdocente/twdocente.php";
	httpAcLlamadosOrigen.addEventListener("acceso",acceso);
	httpAcLlamadosOrigen.addEventListener(ResultEvent.RESULT,fncCargarAcLlamadoOrigen);
	
	httpAcLlamadosDestino.url = "twdocente/twdocente.php";
	httpAcLlamadosDestino.addEventListener("acceso",acceso);
	httpAcLlamadosDestino.addEventListener(ResultEvent.RESULT,fncCargarAcLlamadoDestino);
	
	httpLlamadoOrigen.url = "twdocente/twdocente.php";
	httpLlamadoOrigen.addEventListener("acceso",acceso);
	httpLlamadoOrigen.addEventListener(ResultEvent.RESULT,fncCargarLlamadoOrigen);
	
	httpLlamadoDestino.url = "twdocente/twdocente.php";
	httpLlamadoDestino.addEventListener("acceso",acceso);
	httpLlamadoDestino.addEventListener(ResultEvent.RESULT,fncCargarLlamadoDestino);				
    
    httpDatos.url = "importarinscrip/importarinscripciones.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncGuardarResult);
	
	txiNroLlamadoOrigen.addEventListener("focusOut",fncBuscarLlamadoOrigen);
	txiNroLlamadoDestino.addEventListener("focusOut",fncBuscarLlamadoDestino);
}

private function ChangeAcLlamadoOrigen(e:Event):void{
	if (acLlamadoOrigen.text.length==3){
		httpAcLlamadosOrigen.send({rutina:"traer_llamados",descripcion:acLlamadoOrigen.text});
	}
}

private function fncCargarAcLlamadoOrigen(e:Event):void{
	acLlamadoOrigen.typedText = acLlamadoOrigen.text;
	acLlamadoOrigen.dataProvider = httpAcLlamadosOrigen.lastResult.llamados;		
}

private function ChangeAcLlamadoDestino(e:Event):void{
	if (acLlamadoDestino.text.length==3){
		httpAcLlamadosDestino.send({rutina:"traer_llamados",descripcion:acLlamadoDestino.text});
	}
}

private function fncCargarAcLlamadoDestino(e:Event):void{
	acLlamadoDestino.typedText = acLlamadoDestino.text;
	acLlamadoDestino.dataProvider = httpAcLlamadosDestino.lastResult.llamados;		
}

private function fncBuscarLlamadoOrigen(e:Event):void
{
	if (txiNroLlamadoOrigen.text != "") {
		httpLlamadoOrigen.send({rutina:"buscar_llamado",nro_llamado:txiNroLlamadoOrigen.text});	
	}		
}

private function fncCargarLlamadoOrigen(e:Event):void{		
	acLlamadoOrigen.dataProvider = httpLlamadoOrigen.lastResult.llamados;
}

private function CloseAcLlamadoOrigen(e:Event):void {
	if (acLlamadoOrigen.selectedIndex!=-1) {
		txiNroLlamadoOrigen.text = acLlamadoOrigen.selectedItem.@nro_llamado;
	}		
}

private function fncBuscarLlamadoDestino(e:Event):void
{
	if (txiNroLlamadoDestino.text != "") {
		httpLlamadoDestino.send({rutina:"buscar_llamado",nro_llamado:txiNroLlamadoDestino.text});	
	}		
}

private function fncCargarLlamadoDestino(e:Event):void{		
	acLlamadoDestino.dataProvider = httpLlamadoDestino.lastResult.llamados;
}

private function CloseAcLlamadoDestino(e:Event):void {
	if (acLlamadoDestino.selectedIndex!=-1) {
		txiNroLlamadoDestino.text = acLlamadoDestino.selectedItem.@nro_llamado;
	}		
}

private function fncGuardar(e:Event):void
{
	if (acLlamadoOrigen.selectedIndex != -1 && acLlamadoDestino.selectedIndex != -1) {
		if (acLlamadoOrigen.selectedItem.@id_llamado != acLlamadoDestino.selectedItem.@id_llamado)
			httpDatos.send({id_llamado_origen:acLlamadoOrigen.selectedItem.@id_llamado, id_llamado_destino:acLlamadoDestino.selectedItem.@id_llamado});
		else
			Alert.show("El llamado origen y el llamado destino deben ser distintos\n","E R R O R");	
	} else
		Alert.show("Debe seleccionar los llamados origen y destino\n","E R R O R");
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