import abmtitulos.twtitulo;

import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlEspaciosA:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosD:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosDE:XML = <espacios></espacios>;
[Bindable] private var _xmlEspaciosNuevos:XML = <espacios></espacios>;
[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
[Bindable] private var _xmlNomenc:XML = <tiposnomenc>				
												<tiposnomenc tipo="Títulos"/>
												<tiposnomenc tipo="Espacios"/>
												<tiposnomenc tipo="Cargos"/>
										</tiposnomenc>;	
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpEspaciosA:HTTPServices = new HTTPServices;
private var httpEspaciosD:HTTPServices = new HTTPServices;
private var httpEspacioN:HTTPServices = new HTTPServices;
private var httpAcTituloA:HTTPServices = new HTTPServices;
private var httpAcTituloD:HTTPServices = new HTTPServices;
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodTituloA:HTTPServices = new HTTPServices;
private var httpCodTituloD:HTTPServices = new HTTPServices;
private var httpCodEspacio:HTTPServices = new HTTPServices;
private var httpCodCarrera:HTTPServices = new HTTPServices;
private var _twTitulo:twtitulo = new twtitulo;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{		
	httpDatos2.url = "conscomtespacios/conscomtespacios.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});			
					
	httpEspaciosA.url = "conscomtespacios/conscomtespacios.php";
	httpEspaciosA.addEventListener("acceso",acceso);
	httpEspaciosA.addEventListener(ResultEvent.RESULT,fncCargarespaciosA);
	httpEspaciosD.url = "conscomtespacios/conscomtespacios.php";
	httpEspaciosD.addEventListener("acceso",acceso);
	httpEspaciosD.addEventListener(ResultEvent.RESULT,fncCargarespaciosD);		
			
	btnGuardar.addEventListener("click",fncImprimir);				
}		

private function fncDatosResult2(e:Event):void {		
	_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncImprimir(e:Event):void
{	
	var ordenar:String;
	var tipoinforme:String;
	var rutina:String;
	
	if (cboNomenc.text == "Títulos")
		rutina = "titulos";
	else if (cboNomenc.text == "Espacios")
		rutina = "espacios";
	else
		rutina = "cargos";
	if (rbCodigo.selected == true)
		ordenar = "codigo";		
	else
		ordenar = "denominacion";
	
	if (rbHtml.selected == true)
		tipoinforme = "html";
	else
		tipoinforme = "pdf";
		
	//Creo los contenedores para enviar datos y recibir respuesta
	var url:String;
	if (tipoinforme == "html")
		url = "nomencladores/nomencladores.php";
	else {
		if (rutina=="cargos")
			url = "nomencladores/nomenccargos.php";
		else if (rutina=="espacios")
			url = "nomencladores/nomencespacios.php";
		else
			url = "nomencladores/nomenctitulos.php";
	}
	var enviar:URLRequest = new URLRequest(url);
	var recibir:URLLoader = new URLLoader();
 		 
	//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
	var variables:URLVariables = new URLVariables();
	
	variables.rutina = rutina;
	variables.orden = ordenar;
	variables.tipoinforme = tipoinforme;				
				
	//Indico que voy a enviar variables dentro de la petición
	enviar.data = variables;
	
	navigateToURL(enviar);
}				

private function fncCargarespaciosA(e:Event):void {
	_xmlEspaciosA = <espacios></espacios>;
	_xmlEspaciosA.appendChild(httpEspaciosA.lastResult.espacios);		
}

private function fncCargarespaciosD(e:Event):void {
	_xmlEspaciosDE = <espacios></espacios>;
	_xmlEspaciosDE.appendChild(httpEspaciosD.lastResult.espacios);		
}						

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
