import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlEscuela:XML = <escuelas id_escuela_cargo="" id_cargo="" cod_cargo="" denomcar="" id_escuela="" cod_escuela="" id_nivel="" nivel="" nombre="" origen=""/>;
[Bindable] private var _xmlEscuelas:XML = <escuelas></escuelas>;	
[Bindable] private var _xmlEscuelasDE:XML = <escuelas></escuelas>;
[Bindable] private var _xmlEscuelasNuevos:XML = <escuelas></escuelas>;
[Bindable] private var _xmlTiposEscuelas:XML = <tiposescuelas></tiposescuelas>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;	
private var httpDatos2:HTTPServices = new HTTPServices;
private var httpEscuelas:HTTPServices = new HTTPServices;	
private var httpAcCargo:HTTPServices = new HTTPServices;
private var httpAcEscuela:HTTPServices = new HTTPServices;	
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodCargo:HTTPServices = new HTTPServices;
private var httpCodEscuela:HTTPServices = new HTTPServices;

public function get xmlTiposEscuelas():XML{return _xmlTiposEscuelas.copy();}

public function fncInit():void
{				
	httpDatos2.url = "conscargosescuelas/conscargosescuelas.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	//httpDatos2.send({rutina:"traer_datos2"});
	//preparo el autocomplete				
	acEscuela.addEventListener(ListEvent.CHANGE,ChangeAcEscuela);
	acEscuela.addEventListener("close",CloseAcEscuela);	
	acEscuela.labelField = "@nombre";		
	httpAcEscuela.url = "conscargosescuelas/conscargosescuelas.php";
	httpAcEscuela.addEventListener("acceso",acceso);
	httpAcEscuela.addEventListener(ResultEvent.RESULT,fncCargarAcEscuela);				
	
	httpCodEscuela.url = "conscargosescuelas/conscargosescuelas.php";
	httpCodEscuela.addEventListener("acceso",acceso);
	httpCodEscuela.addEventListener(ResultEvent.RESULT,fncCargarEscuela);
			
	httpEscuelas.url = "conscargosescuelas/conscargosescuelas.php";
	httpEscuelas.addEventListener("acceso",acceso);
	httpEscuelas.addEventListener(ResultEvent.RESULT,fncCargarEscuelas);
	
	btnImprimir.addEventListener("click",fncImprimir);
			
	txiCodigoS.addEventListener("focusOut",fncBuscarEscuela);
}

private function fncImprimir(e:Event):void
{	
	if (acEscuela.selectedItem != null) {
		var url:String;
	
		if (rbHtml.selected == true)
			url = "conscargosescuelas/list_car_esc.php?rutina=list_car_esc&";
		else
			url = "conscargosescuelas/list_car_esc_pdf.php?rutina=list_car_esc&";
		
		//Creo los contenedores para enviar datos y recibir respuesta
		var enviar:URLRequest = new URLRequest(url);
		var recibir:URLLoader = new URLLoader();
	 		 
		//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
		var variables:URLVariables = new URLVariables();
		
		variables.id_escuela = acEscuela.selectedItem.@id_escuela;							
					
		//Indico que voy a enviar variables dentro de la petición
		enviar.data = variables;
		
		navigateToURL(enviar);	
	} else {
		Alert.show("Debe seleccionar una escuela\n","E R R O R");
	}
}

private function CloseAcEscuela(e:Event):void {
	if (acEscuela.selectedIndex!=-1) {
		httpEscuelas.send({rutina:"traer_cargos",id_escuela:acEscuela.selectedItem.@id_escuela});
	}		
}

private function fncCargarEscuela(e:Event):void{
	acEscuela.dataProvider = httpCodEscuela.lastResult.escuelas;
	if (acEscuela.selectedIndex!=-1) {
		httpEscuelas.send({rutina:"traer_cargos",id_escuela:acEscuela.selectedItem.@id_escuela});
	}
}

private function fncBuscarEscuela(e:Event):void
{
	if (txiCodigoS.text != "") {
		httpCodEscuela.send({rutina:"buscar_escuela",codigo:txiCodigoS.text});	
	}		
}		

private function fncDatosResult2(e:Event):void {		
	_xmlTiposEscuelas.appendChild(httpDatos2.lastResult.tiposescuelas);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}				

/*
* Función para ordenar los datos de la columna 'cod_cargo' de manera numérica, no alfabética:
*/
public function numericSort(a:*,b:*):int
{
	var nA:Number=Number(a.@cod_cargo);
    var nB:Number=Number(b.@cod_cargo);
    if (nA<nB){
     	return -1;
    }else if (nA>nB){
     	return 1;
    }else {
        return 0;
    }
}		

private function fncCargarAcEscuela(e:Event):void{
	acEscuela.typedText = acEscuela.text;
	acEscuela.dataProvider = httpAcEscuela.lastResult.escuelas;		
}

private function ChangeAcEscuela(e:Event):void{
	if (acEscuela.text.length==3){
		httpAcEscuela.send({rutina:"traer_escuelas_n",nombre:acEscuela.text});
	}
}				
	
private function fncCargarEscuelas(e:Event):void {
	_xmlEscuelas = <escuelas></escuelas>;
	_xmlEscuelas.appendChild(httpEscuelas.lastResult.escuelas);		
}