import clases.HTTPServices;
import flash.events.Event;
import importarinscrip.twdocentesec2;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
	
[Bindable] private var httpDatos:HTTPServices = new HTTPServices;
[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
[Bindable] private var httpInscripciones:HTTPServices = new HTTPServices;
[Bindable] private var _xmlInscripciones:XML = <inscripciones></inscripciones>;
[Bindable] private var _xmlInscripcionesExcluidas:XML = <inscripciones></inscripciones>;
	
public function fncInit():void
{		
	this.defaultButton = btnGuardar;		
	btnGuardar.addEventListener("click" ,fncGuardar);
	btnCancelar.addEventListener("click" ,fncCerrar);
	
	httpCombos.url = "unificarllamados/unificarllamados.php";
	httpCombos.addEventListener("acceso",acceso);
	httpCombos.send({rutina:"traer_datos"});						
    
    httpDatos.url = "unificarllamados/unificarllamados.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatos.addEventListener(ResultEvent.RESULT,fncGuardarResult);
	
	httpInscripciones.url = "unificarllamados/unificarllamados.php";
	httpInscripciones.addEventListener("acceso",acceso);
	httpInscripciones.addEventListener(ResultEvent.RESULT,fncCargarInscripciones);
	
	btnBuscar.addEventListener("click",fncBuscarDobleInscripcion);
	btnAddUno.addEventListener("click",fncAddUno);
	btnDelUno.addEventListener("click",fncDelUno);
	btnGuardar.enabled = false;
	btnCancelar.enabled = false;
}

private function fncLimpiarCampos():void
{
	_xmlInscripciones = <inscripciones></inscripciones>;
	_xmlInscripcionesExcluidas = <inscripciones></inscripciones>;
	btnGuardar.enabled = false;
	btnCancelar.enabled = false;
}

private function fncVerificarConflictos():Boolean
{
	var conflicto:Boolean = false;
	//Guardar el tamaño del arreglo, esto se ejecuta más rapido que en los ciclos
	var arrayLength:int = _xmlInscripciones.inscripciones.length();
	if (arrayLength == 0) return false;
	for (var i:int=0;i<arrayLength-1;i++) {
		if (conflicto == true) break;
		for (var j:int=i+1;j<arrayLength;j++) {
			if (_xmlInscripciones.inscripciones[i].@id_docente == _xmlInscripciones.inscripciones[j].@id_docente) {
				conflicto = true;
				break;	
			}
		}
	}
	return conflicto;
}

private function fncAddUno(e:Event):void
{
	var xmlInscripcion:XML = (gridInscripciones.selectedItem as XML).copy();
	_xmlInscripcionesExcluidas.appendChild(xmlInscripcion);
	delete _xmlInscripciones.inscripciones[(gridInscripciones.selectedItem as XML).childIndex()];	
}

private function fncDelUno(e:Event):void
{
	var xmlInscripcion:XML = (gridInscripcionesExcluidas.selectedItem as XML).copy();
	_xmlInscripciones.appendChild(xmlInscripcion);
	delete _xmlInscripcionesExcluidas.inscripciones[(gridInscripcionesExcluidas.selectedItem as XML).childIndex()];	
}

private function fncBuscarDobleInscripcion(e:Event):void
{
	httpInscripciones.send({rutina:"buscar_inscripciones_conflictivas",id_llamado_origen_uno:cmbLlamadoOrigenUno.selectedItem.id_llamado, 
			id_llamado_origen_dos:cmbLlamadoOrigenDos.selectedItem.id_llamado});
}

private function fncCargarInscripciones(e:Event):void
{
	_xmlInscripciones = <inscripciones></inscripciones>;
	_xmlInscripcionesExcluidas = <inscripciones></inscripciones>;
	_xmlInscripciones.appendChild(httpInscripciones.lastResult.inscripciones);
	btnGuardar.enabled = true;
	btnCancelar.enabled = true;
}

private function fncGuardar(e:Event):void
{
	if (cmbLlamadoOrigenUno.selectedItem.id_llamado != cmbLlamadoOrigenDos.selectedItem.id_llamado && 
		cmbLlamadoOrigenUno.selectedItem.id_llamado != cmbLlamadoDestino.selectedItem.id_llamado && 
		cmbLlamadoOrigenDos.selectedItem.id_llamado != cmbLlamadoDestino.selectedItem.id_llamado) {
		if (fncVerificarConflictos() == false)
			Alert.show("¿Realmente desea Unificar los Llamados? Una vez realizada la operación NO podrá deshacerse", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmUnificar, null, Alert.OK);
		else
			Alert.show("Aún no se han excluido todas las inscripciones conflictivas","E R R O R");		
	} else
		Alert.show("El llamado de origen uno, el llamado de origen dos, y el llamado de destino deben ser diferentes\n","E R R O R");
}

private function fncConfirmUnificar(e:CloseEvent):void
{
	if (e.detail==Alert.OK){
		httpDatos.send({rutina:"unificar_llamados_dos", id_llamado_origen_uno:cmbLlamadoOrigenUno.selectedItem.id_llamado, 
			id_llamado_origen_dos:cmbLlamadoOrigenDos.selectedItem.id_llamado, id_llamado_destino:cmbLlamadoDestino.selectedItem.id_llamado,
			xmlInscripciones:_xmlInscripciones});	
	}		
}

private function fncGuardarResult(e:Event):void
{
	var ok:String = httpDatos.lastResult.ok;
	if (ok == "1") {
		Alert.show("La unificación fue realizada exitósamente");
		fncLimpiarCampos();
		dispatchEvent(new Event("SelectPrincipal"));	
	} else {
		Alert.show("La Unificación de Llamados no puede realizarse ya que existen docentes inscriptos simultáneamente en ambos llamados " + 
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
		
		variables.id_llamado_origen_uno = cmbLlamadoOrigenUno.selectedItem.id_llamado;
		variables.id_llamado_origen_dos = cmbLlamadoOrigenDos.selectedItem.id_llamado;				
					
		//Indico que voy a enviar variables dentro de la petición
		enviar.data = variables;
		
		navigateToURL(enviar);				
	}		
}

private function fncCerrar(e:Event):void
{
	fncLimpiarCampos();
	dispatchEvent(new Event("SelectPrincipal"));
}

private function fncCerrarPopUp(e:Event):void
{	
	PopUpManager.removePopUp(e.target as twdocentesec2)
	dispatchEvent(new Event("SelectPrincipal"));
}