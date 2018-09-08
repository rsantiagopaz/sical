import clases.HTTPServices;		
import flash.events.Event;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

[Bindable] private var _xmlEspacios:XML = <espacios></espacios>;	
private var httpDatos:HTTPServices = new HTTPServices;	
private var _xmlEspacio:XML;

public function get xmlEspacio():XML { return _xmlEspacio }		

public function fncInit():void
{		
	httpDatos.url = "espacios/espacios.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);		
	btnCerrar.addEventListener("click" ,fncCerrar);	
	btnBuscar.addEventListener("click",fncTraerEspaciosBoton);
	txtNombre.setFocus();
}

private function fncTraerEspaciosBoton(e:Event):void{
	httpDatos.send({rutina:"buscar_espacio",filter:txtNombre.text});
}

private function fncCargarDatos(e:Event):void {
	_xmlEspacios = <espacios></espacios>;
	_xmlEspacios.appendChild(httpDatos.lastResult.espacios);		
}

private function fncCerrar(e:Event):void{
	PopUpManager.removePopUp(this);
}		

public function fncSeleccionar():void
{
	_xmlEspacio =  (gridEspacios.selectedItem as XML).copy();
	dispatchEvent(new Event("EventConfirmarEspacio"));
}