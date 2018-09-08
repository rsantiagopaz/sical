import abmllamados.llamado;
import clases.HTTPServices;
import flash.events.Event;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlLlamados:XML = <llamados></llamados>;
[Bindable] private var _xmlLlamadosAc:XML = <llamados></llamados>;
[Bindable] private var _xmlNiveles:XML = <niveles></niveles>;
[Bindable] private var _xmlTiposLlamados:XML = <tiposllamados></tiposllamados>;	
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpDatos3:HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
private var twLlamado:llamado;

public function get xmlNiveles():XML { return _xmlNiveles }
public function get xmlLlamadosAc():XML { return _xmlLlamadosAc }
public function get xmlTiposLlamados():XML { return _xmlTiposLlamados }

public function fncInit():void
{		
	httpDatos.url = "abmllamados/abmllamados.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);		
	httpDatos2.url = "abmllamados/abmllamados.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2);
	httpDatos2.send({rutina:"traer_datos2"});		
	httpCombos.url = "abmllamados/abmllamados.php";
	httpCombos.addEventListener("acceso",acceso);
	httpCombos.addEventListener(ResultEvent.RESULT,fncCargarDatos3);
	httpCombos.send({rutina:"traer_datos_llamados_acumulado"});
	httpDatos3.url = "abmllamados/abmllamados.php";
	httpDatos3.addEventListener("acceso",acceso);
	httpDatos3.addEventListener(ResultEvent.RESULT,fncCargarDatos4);
	httpDatos3.send({rutina:"traer_datos3"});
	btnNuevoCargo.addEventListener("click" ,fncAgregarCargo);
	btnCerrar.addEventListener("click" ,fncCerrar);
	txtNombre.addEventListener("change",fncTraerCargos);
	btnBuscar.addEventListener("click",fncTraerCargosBoton);
	btnImprimir.addEventListener("click",fncImprimir);	
}

private function fncImprimir(e:Event):void
{				
	//Creo los contenedores para enviar datos y recibir respuesta
	var enviar:URLRequest = new URLRequest("abmllamados/listado_llamados.php?rutina=llamados&");
	var recibir:URLLoader = new URLLoader();
 		 
	//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
	var variables:URLVariables = new URLVariables();
	
	variables.filter = txtNombre.text						
				
	//Indico que voy a enviar variables dentro de la petición
	enviar.data = variables;
	
	navigateToURL(enviar);
}

private function fncTraerCargos(e:Event):void{
	if (txtNombre.text.length==3){
		httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
	}
	if(txtNombre.text.length>3){
	
  		gridLlamados.dataProvider.filterFunction = filtroTexto;
        gridLlamados.dataProvider.refresh();			
	}
}

private function filtroTexto (item : Object) : Boolean
{
	return item.@denominacion.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
}

private function fncTraerCargosBoton(e:Event):void{
	httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
}

private function fncCargarDatos(e:Event):void {
	_xmlLlamados = <llamados></llamados>;
	_xmlLlamados.appendChild(httpDatos.lastResult.llamados);				
}

private function fncCargarDatos2(e:Event):void {		
	_xmlNiveles.appendChild(httpDatos2.lastResult.niveles);		
}

private function fncCargarDatos3(e:Event):void {		
	_xmlLlamadosAc = <llamados></llamados>;
	_xmlLlamadosAc.appendChild(httpCombos.lastResult.llamados);		
}

private function fncCargarDatos4(e:Event):void {		
	_xmlTiposLlamados.appendChild(httpDatos3.lastResult.tiposllamados);		
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function fncAgregarCargo(e:Event):void
{
	twLlamado = new llamado;
	twLlamado.addEventListener("EventAlta",fncAltaCargos);
	PopUpManager.addPopUp(twLlamado,this,true);
	PopUpManager.centerPopUp(twLlamado);
}

private function fncAltaCargos(e:Event):void{
	_xmlLlamados.appendChild(twLlamado.xmlLlamado);
	PopUpManager.removePopUp(e.target as llamado);
}

public function fncEditar():void
{
	twLlamado = new llamado;
	twLlamado.xmlLlamado =  (gridLlamados.selectedItem as XML).copy();
	twLlamado.addEventListener("EventEdit",fncEditarCargo);
	PopUpManager.addPopUp(twLlamado,this,true);
	PopUpManager.centerPopUp(twLlamado);
}

public function fncEliminar():void
{
	twLlamado = new llamado;
	twLlamado.xmlLlamado2 =  (gridLlamados.selectedItem as XML).copy();
	twLlamado.addEventListener("EventDelete",fncEliminarCargo);
	PopUpManager.addPopUp(twLlamado,this,true);
	PopUpManager.centerPopUp(twLlamado);
}

private function fncEditarCargo(e:Event):void
{
	_xmlLlamados.llamados[(gridLlamados.selectedItem as XML).childIndex()] = twLlamado.xmlLlamado;
	PopUpManager.removePopUp(e.target as llamado);		
}

private function fncEliminarCargo(e:Event):void
{
	delete _xmlLlamados.llamados[(gridLlamados.selectedItem as XML).childIndex()];
	PopUpManager.removePopUp(e.target as llamado);		
}