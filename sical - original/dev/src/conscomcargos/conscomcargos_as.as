import clases.HTTPServices;		

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlCargos:XML = <cargos></cargos>;
[Bindable] private var _xmlNiveles:XML = <niveles></niveles>;	
private var httpDatos:HTTPServices = new HTTPServices;
private var httpDatos2:HTTPServices = new HTTPServices;	

public function get xmlNiveles():XML { return _xmlNiveles }	


public function fncInit():void
{		
	httpDatos.url = "conscomcargos/conscomcargos.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos)		
	httpDatos2.url = "conscomcargos/conscomcargos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2)
	httpDatos2.send({rutina:"traer_datos2"});		
	btnCerrar.addEventListener("click" ,fncCerrar);
	txtNombre.addEventListener("change",fncTraerCargos);
	btnBuscar.addEventListener("click",fncTraerCargosBoton);
}

private function fncTraerCargos(e:Event):void{
	if (chkComodin.selected == false) {
		if (txtNombre.text.length==3){
			httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
		}
		if(txtNombre.text.length>3){
		
	  		gridCargos.dataProvider.filterFunction = filtroTexto;
            gridCargos.dataProvider.refresh();			
		}
	}		
}

private function filtroTexto (item : Object) : Boolean
{
	return item.@denominacion.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
}

private function fncTraerCargosBoton(e:Event):void{
	if (chkComodin.selected == false)
		httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
	else
		httpDatos.send({rutina:"buscar_cargo",filter:txtNombre.text,caso:"1"});
}

private function fncCargarDatos(e:Event):void {
	_xmlCargos = <cargos></cargos>;
	_xmlCargos.appendChild(httpDatos.lastResult.cargos);				
}

private function fncCargarDatos2(e:Event):void {		
	_xmlNiveles.appendChild(httpDatos2.lastResult.niveles);		
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}