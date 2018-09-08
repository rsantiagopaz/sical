import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ListEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.validators.Validator;

include "../control_acceso.as";

[Bindable] private var _xmlLlamado : XML = <llamados  />;
[Bindable] private var httpLlamado : HTTPServices = new HTTPServices;
[Bindable] private var httpLlamado2 : HTTPServices = new HTTPServices;
[Bindable] private var httpNroLlamado : HTTPServices = new HTTPServices;
[Bindable] private var httpAcLlamados : HTTPServices = new HTTPServices;
private var _accion : String;


public function get xmlLlamado():XML{return _xmlLlamado.copy();}
public function set xmlLlamado(car:XML):void{
	_xmlLlamado = car;
	_accion = "editar";
}
public function set xmlLlamado2(car:XML):void{
	_xmlLlamado = car;
	_accion = "eliminar";
}
public function modificar():void{
	
}	
private function fncInit():void
{
	var i:int;
	//preparo el PopUp Para que se cierre con esc y marco el default button
	this.defaultButton = btnGrabar;
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});
	
	//preparo el autocomplete		
	acLlamado.addEventListener(ListEvent.CHANGE,ChangeAcLlamado);
	acLlamado.addEventListener("close",CloseAcLlamado);
	acLlamado.labelField = "@descripcion";
	
	//preparo el httpservice necesario para el autocomplete
	httpAcLlamados.url = "twdocente/twdocente.php";
	httpAcLlamados.addEventListener("acceso",acceso);
	httpAcLlamados.addEventListener(ResultEvent.RESULT,fncCargarAcLlamado);
	
	//cargo los data providers de los combos
	cmbNivel.dataProvider = (parentApplication.ABMLLAMADOS.xmlNiveles.niveles);
	cmbTipoLlamado.dataProvider = (parentApplication.ABMLLAMADOS.xmlTiposLlamados.tiposllamados);
	cmbLlamado.dataProvider = (parentApplication.ABMLLAMADOS.xmlLlamadosAc.llamados);		
	//preparo el httpservice
	httpLlamado.url = "abmllamados/abmllamados.php";
	httpLlamado.addEventListener("acceso",acceso);
	
	httpLlamado2.url = "twdocente/twdocente.php";
	httpLlamado2.addEventListener("acceso",acceso);
	httpLlamado2.addEventListener(ResultEvent.RESULT,fncCargarLlamado);
	
	httpNroLlamado.url = "abmllamados/abmllamados.php";
	httpNroLlamado.addEventListener("acceso",acceso);
	httpNroLlamado.addEventListener(ResultEvent.RESULT,fncResultNroLlamado);
	// escucho evento de los botones
	btnCancel.addEventListener("click",fncCerrar);
	if (_accion == "editar") {
		if (_xmlLlamado.@id_nivel == '2') {
			this.currentState = "iniprim";
		} else if (_xmlLlamado.@id_nivel == '5') {
			this.currentState = "especadult";
		} else {
			this.currentState = "base";
		}
		fncEditarEliminar();		
		
		for (i = 0;i < parentApplication.ABMLLAMADOS.xmlTiposLlamados.tiposllamados.length();i++) {
			if (parentApplication.ABMLLAMADOS.xmlTiposLlamados.tiposllamados[i].@id_subtipo_clasificacion == _xmlLlamado.@id_subtipo_clasificacion) {
				cmbTipoLlamado.selectedIndex = i;
				break;	
			}					
		}
		txiCodigo.text = _xmlLlamado.@nro_llamado;			
		txtNombre.text = _xmlLlamado.@descripcion;
		dfFechaInicio.text = _xmlLlamado.@fecha_desde;
		dfFechaFin.text = _xmlLlamado.@fecha_hasta;			
					
		btnGrabar.addEventListener("click",fncEdit);
	} else if (_accion == "eliminar") {
		this.currentState = "eliminar";			
		txtNombre.text = _xmlLlamado.@descripcion;
		fncEditarEliminar();		
		
		txiCodigo.text = _xmlLlamado.@nro_llamado;
		dfFechaInicio.text = _xmlLlamado.@fecha_desde;
		dfFechaFin.text = _xmlLlamado.@fecha_hasta;			
		
		btnEliminar.addEventListener("click",fncDelete);
	} else {			
		httpNroLlamado.send({rutina:"obtener_numero_llamado"});
		if (cmbNivel.selectedItem.@id_nivel == '2') {
			this.currentState = "iniprim";
		} else if (cmbNivel.selectedItem.@id_nivel == '5') {
			this.currentState = "especadult";
		} else {
			this.currentState = "base";				
		}			
		btnGrabar.addEventListener("click",fncAdd);
	}			
	cmbNivel.addEventListener("change",fncChangeState);
	//posiciono el cursor
	txtNombre.setFocus();
	txiNroLlamado.addEventListener("focusOut",fncBuscarLlamado);
}

private function fncEditarEliminar():void
{
	if (_xmlLlamado.@ordinario == 'S')
		chkAcum.selected = true;
	else
		chkAcum.selected = false;
	if (_xmlLlamado.@oculto == 'N')
		rbVisibleSi.selected = true;
	else
		rbVisibleNo.selected = true;
	var arrayLengthLlamado:int = parentApplication.ABMLLAMADOS.xmlLlamadosAc.llamados.length();
	var arrayLengthNiveles:int = parentApplication.ABMLLAMADOS.xmlNiveles.niveles.length();
	var i:int;
	for (i = 0;i<arrayLengthNiveles;i++) {
		if (parentApplication.ABMLLAMADOS.xmlNiveles.niveles[i].@id_nivel == _xmlLlamado.@id_nivel) {
			cmbNivel.selectedIndex = i;
			break;	
		}					
	}
	for (i = 0;i<arrayLengthLlamado;i++) {
		if (parentApplication.ABMLLAMADOS.xmlLlamadosAc.llamados[i].@id_llamado == _xmlLlamado.@id_llam_ant_acum) {
			cmbLlamado.selectedIndex = i;
			break;	
		}					
	}
	if (_xmlLlamado.@id_llamado_conflictivo != "") {
		 chkControlarLlamadoConflictivo.selected = true;
		 if (_accion == "eliminar") {
		 	txiNroLlamado.editable = false;
		 	acLlamado.enabled = false;
		 	txiNroLlamado.text = _xmlLlamado.@nro_llamado_conflictivo;
		 	acLlamado.text = _xmlLlamado.@descripcion_llamado_conflictivo;
		 	acLlamado.typedText = _xmlLlamado.@descripcion_llamado_conflictivo;
		 }
		 if (_accion == "editar") {
		 	txiNroLlamado.text = _xmlLlamado.@nro_llamado_conflictivo;
		 	httpLlamado2.send({rutina:"buscar_llamado",nro_llamado:_xmlLlamado.@nro_llamado_conflictivo});
		 }
	} else {				
		chkControlarLlamadoConflictivo.selected = false;
	}
}

private function fncBuscarLlamado(e:Event):void
{
	if (txiNroLlamado.text != "") {
		httpLlamado2.send({rutina:"buscar_llamado",nro_llamado:txiNroLlamado.text});	
	}		
}

private function fncCargarLlamado(e:Event):void{		
	acLlamado.dataProvider = httpLlamado2.lastResult.llamados;
}

private function fncCargarAcLlamado(e:Event):void
{
	acLlamado.typedText = acLlamado.text;
	acLlamado.dataProvider = httpAcLlamados.lastResult.llamados;		
}

private function ChangeAcLlamado(e:Event):void
{
	if (acLlamado.text.length==3){
		httpAcLlamados.send({rutina:"traer_llamados",descripcion:acLlamado.text});
	}
}

private function CloseAcLlamado(e:Event):void 
{
	if (acLlamado.selectedIndex!=-1) {
		txiNroLlamado.text = acLlamado.selectedItem.@nro_llamado;
	}		
}

private function fncResultNroLlamado(e:Event):void
{
	txiCodigo.text = httpNroLlamado.lastResult.nrollamado;						
}

private function fncArmarXmlCargo():void
{
	_xmlLlamado.@nro_llamado=txiCodigo.text;
	_xmlLlamado.@descripcion=txtNombre.text;		
	if (_accion != "editar") _xmlLlamado.@id_llamado="";
	_xmlLlamado.@id_nivel=cmbNivel.selectedItem.@id_nivel
	_xmlLlamado.@nivel=cmbNivel.selectedItem.@nivel;
	_xmlLlamado.@fecha_desde = dfFechaInicio.text;
	_xmlLlamado.@fecha_hasta = dfFechaFin.text;
	_xmlLlamado.@tipo_clasificacion = cmbTipoLlamado.selectedItem.@id_tipo_clasificacion;
	_xmlLlamado.@id_subtipo_clasificacion = cmbTipoLlamado.selectedItem.@id_subtipo_clasificacion;	
	_xmlLlamado.@ordinario = (chkAcum.selected == true) ? 'S' : 'N';		
	_xmlLlamado.@id_llam_ant_acum = (cmbLlamado.selectedIndex >= 0) ? cmbLlamado.selectedItem.@id_llamado : '0';	
	_xmlLlamado.@oculto = (rbVisibleSi.selected == true) ? 'N' : 'S';	
	_xmlLlamado.@id_llamado_conflictivo = (chkControlarLlamadoConflictivo.selected == true) ? acLlamado.selectedItem.@id_llamado : '';	
}

private function fncChangeState(e:Event):void
{
	if (cmbNivel.selectedItem.@id_nivel == '2') {
		this.currentState = "iniprim";
	} else if (cmbNivel.selectedItem.@id_nivel == '5') {
		this.currentState = "especadult";
	} else {
		this.currentState = "base";
	}
}

private function fncCerrar(e:Event):void
{
	PopUpManager.removePopUp(this)	
}

private function fncAdd(e:Event):void
{
	if (fncValidar()) {
		fncArmarXmlCargo();			
		httpLlamado.addEventListener(ResultEvent.RESULT,fncResultAdd);
		httpLlamado.send({rutina:"insert", xmlLlamado:_xmlLlamado.toXMLString()});
	}
}

private function fncResultAdd(e:Event):void
{
	_xmlLlamado.@id_llamado = httpLlamado.lastResult.insert_id;		
			
	Alert.show("El alta se registro con exito","cargo");
	dispatchEvent(new Event("EventAlta"));	
	
	httpLlamado.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}

private function fncResultEdit(e:Event):void
{			
	Alert.show("La modificación se registró con exito","espacio");
	dispatchEvent(new Event("EventEdit"));
	
	httpLlamado.removeEventListener(ResultEvent.RESULT,fncResultEdit);
}

private function fncResultDelete(e:Event):void
{		
	Alert.show("La eliminación se registro con exito","cargo");
	dispatchEvent(new Event("EventDelete"));			
	httpLlamado.removeEventListener(ResultEvent.RESULT,fncResultDelete);
}

private function fncEdit(e:Event):void
{
	if (fncValidar()) {
		fncArmarXmlCargo();
		httpLlamado.addEventListener(ResultEvent.RESULT,fncResultEdit);
		httpLlamado.send({rutina:"update", xmlLlamado:_xmlLlamado.toXMLString()});
	}
}

private function fncDelete(e:Event):void
{
	Alert.show("¿Realmente desea Eliminar el Llamado "+ _xmlLlamado.@descripcion+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarCargo, null, Alert.OK);		
}

private function fncConfirmEliminarCargo(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		httpLlamado.addEventListener(ResultEvent.RESULT,fncResultDelete);
		httpLlamado.send({rutina:"delete", xmlLlamado:_xmlLlamado.toXMLString()});
	}
}

private function fncValidar():Boolean
{
	var error:Array = Validator.validateAll([validNombre]);
	var mensajeError:String = "";
	if (error.length>0) {
		((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
		return false;
	} else {
		if (chkAcum.selected == true) {
			if (cmbLlamado.selectedIndex <= 0)
				mensajeError += "Debe seleccionar el llamado del cual tomar el aculumado\n";
		}
		if (chkControlarLlamadoConflictivo.selected == true) {
			if (acLlamado.selectedItem == null || acLlamado.selectedIndex == -1)
				mensajeError += "Debe seleccionar el llamado para el cual controlar inscripción previa\n";
		}
		if (mensajeError != "") {
			Alert.show(mensajeError,"E R R O R");
			return false;
		} else {
			return true;	
		}				
	}	
}

private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@descripcion;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}