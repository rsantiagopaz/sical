import clases.HTTPServices;

import escuelas.escuela;

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


include "../control_acceso.as";

[Bindable] private var _xmlEscuelas:XML = <escuelas></escuelas>;
[Bindable] private var _xmlNiveles:XML = <niveles></niveles>;
[Bindable] private var _xmlLugares:XML = <lugares></lugares>;
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var twEscuela:escuela;

public function get xmlNiveles():XML { return _xmlNiveles }
public function get xmlLugares():XML { return _xmlLugares }


public function fncInit():void
{
	_xmlLugares.appendChild(parentApplication.xmlLugares.departamento);
	httpDatos.url = "escuelas/escuelas.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);		
	httpDatos2.url = "escuelas/escuelas.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2)
	httpDatos2.send({rutina:"traer_datos2"});
	btnNuevaEscuela.addEventListener("click" ,fncAgregarEscuela);
	btnCerrar.addEventListener("click" ,fncCerrar);
	txtNombre.addEventListener("change",fncTraerEscuelas);
	btnBuscar.addEventListener("click",fncTraerEscuelasBoton);
	btnImprimir.addEventListener("click",fncImprimir);
}

private function fncImprimir(e:Event):void
{			
	var url:String;

	if (rbHtml.selected == true)
		url = "escuelas/list_escuelas.php";
	else
		url = "escuelas/list_escuelas_pdf.php";
	
	//Creo los contenedores para enviar datos y recibir respuesta
	var enviar:URLRequest = new URLRequest(url);
	var recibir:URLLoader = new URLLoader();
 		 
	//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
	var variables:URLVariables = new URLVariables();
	
	variables.rutina = "escuelas";
	variables.nombre = txtNombre.text;						
				
	//Indico que voy a enviar variables dentro de la petición
	enviar.data = variables;
	
	navigateToURL(enviar);		
}

private function fncTraerEscuelas(e:Event):void{
	if (txtNombre.text.length==3){
		httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
	}
	if(txtNombre.text.length>3){
	
  		gridEscuelas.dataProvider.filterFunction = filtroTexto;
        gridEscuelas.dataProvider.refresh();			
	}
}

private function filtroTexto (item : Object) : Boolean
{
	return item.@nombre.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
}

private function fncTraerEscuelasBoton(e:Event):void{
	httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
}

private function fncCargarDatos(e:Event):void {
	_xmlEscuelas = <escuelas></escuelas>;
	_xmlEscuelas.appendChild(httpDatos.lastResult.escuelas);	
}

private function fncCargarDatos2(e:Event):void {	
	_xmlNiveles.appendChild(httpDatos2.lastResult.niveles);	
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}

private function fncAgregarEscuela(e:Event):void
{
	twEscuela = new escuela;
	twEscuela.addEventListener("EventAlta",fncAltaEscuelas);
	PopUpManager.addPopUp(twEscuela,this,true);
	PopUpManager.centerPopUp(twEscuela);
}

private function fncAltaEscuelas(e:Event):void{
	_xmlEscuelas.appendChild(twEscuela.xmlEscuela);
	PopUpManager.removePopUp(e.target as escuela);
}

public function fncEditar():void
{
	twEscuela = new escuela;
	twEscuela.xmlEscuela =  (gridEscuelas.selectedItem as XML).copy();
	twEscuela.addEventListener("EventEdit",fncEditarEscuela);
	PopUpManager.addPopUp(twEscuela,this,true);
	PopUpManager.centerPopUp(twEscuela);
}

public function fncEliminar():void
{
	twEscuela = new escuela;
	twEscuela.xmlEscuela2 =  (gridEscuelas.selectedItem as XML).copy();
	twEscuela.addEventListener("EventDelete",fncEliminarEscuela);
	PopUpManager.addPopUp(twEscuela,this,true);
	PopUpManager.centerPopUp(twEscuela);
}

public function fncEditarEscuela(e:Event):void
{
	_xmlEscuelas.escuelas[(gridEscuelas.selectedItem as XML).childIndex()] = twEscuela.xmlEscuela;
	PopUpManager.removePopUp(e.target as escuela);
}

public function fncEliminarEscuela(e:Event):void
{
	delete _xmlEscuelas.escuelas[(gridEscuelas.selectedItem as XML).childIndex()];
	PopUpManager.removePopUp(e.target as escuela);
}

