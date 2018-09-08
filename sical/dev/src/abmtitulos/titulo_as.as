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

[Bindable] private var _xmlTitulo : XML = <titulos  />;
[Bindable] private var httpTitulo : HTTPServices = new HTTPServices;
[Bindable] private var httpTituloNivelPara : HTTPServices = new HTTPServices;
private var httpAcInstitucion:HTTPServices = new HTTPServices;
[Bindable] private var xmlDepartamentos : XML = <departamentos></departamentos>;
[Bindable] private var _xmlTituloNivelPara : XML = <titnivelpara></titnivelpara>;
private var _accion : String;


public function get xmlTitulo():XML{return _xmlTitulo.copy();}
public function get accion():String{return _accion;}
public function set xmlTitulo(esc:XML):void{
	_xmlTitulo = esc;
	_accion = "editar";
}
public function set xmlTitulo2(esc:XML):void{
	_xmlTitulo = esc;
	_accion = "eliminar";
}

public function modificar():void{
	
}	
private function fncInit():void
{
	//preparo el autocomplete		
	acInstitucion.addEventListener(ListEvent.CHANGE,ChangeAcInstitucion);		
	acInstitucion.labelField = "@denominacion";
	httpAcInstitucion.url = "abmtitulos/abmtitulos.php";
	httpAcInstitucion.addEventListener("acceso",acceso);
	httpAcInstitucion.addEventListener(ResultEvent.RESULT,fncCargarAcInstitucion);
	httpTituloNivelPara.url = "abmtitulos/abmtitulos.php";
	httpTituloNivelPara.addEventListener("acceso",acceso);
	httpTituloNivelPara.addEventListener(ResultEvent.RESULT,fncCargarNivelPara);
	httpTituloNivelPara.send({rutina:"traer_titulo_nivel_para",id_titulo:_xmlTitulo.@id_titulo});
	//preparo el PopUp Para que se cierre con esc y marco el default button
	this.defaultButton = btnGrabar;
	this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});
	//cargo los data providers de los combos
	cmbNivel.dataProvider = (parentApplication.TITULOS.xmlNiveles.niveles);
	cmbNivelPara.dataProvider = (parentApplication.TITULOS.xmlNivelesPara.niveles_para);
	cmbGrado.dataProvider = (parentApplication.TITULOS.xmlGrados.grados);
	//preparo el httpservice
	httpTitulo.url = "abmtitulos/abmtitulos.php";
	httpTitulo.addEventListener("acceso",acceso);
	// escucho evento de los botones
	if (_accion == "editar") {
		AddDel();				
		//httpAcInstitucion.send({rutina:"traer_instituciones",denominacion:acInstitucion.text});
		btnGrabar.addEventListener("click",fncEdit);
		btnAddNivel.addEventListener("click",fncAddNivel);
	} else if (_accion == "eliminar") {
		this.currentState = "eliminar";
		AddDel();
		btnEliminar.addEventListener("click",fncDelete);
	} else			
		btnGrabar.addEventListener("click",fncAdd);
		btnAddNivel.addEventListener("click",fncAddNivel);
	btnCancel.addEventListener("click",fncCerrar);		
	//posiciono el cursor
	txtNombre.setFocus();
}

private function fncAddNivel(e:Event):void
{
	var xmlTitNivel:XML = <titulospara />;
	xmlTitNivel.@id_nivel_para = cmbNivelPara.selectedItem.@id_nivel_para;
	xmlTitNivel.@descripcion = cmbNivelPara.selectedItem.@descripcion;
	_xmlTituloNivelPara.appendChild(xmlTitNivel);
}

public function fncEliminar():void
{
	delete _xmlTituloNivelPara.titulospara[(gridNivelesPara.selectedItem as XML).childIndex()];		
}

private function fncCargarNivelPara(e:Event):void {
	_xmlTituloNivelPara.appendChild(httpTituloNivelPara.lastResult.titulospara);		
}

private function AddDel():void {		
	txtNombre.text = _xmlTitulo.@nombre;
	var i:int;
	for (i = 0;i < parentApplication.TITULOS.xmlNiveles.niveles.length();i++) {
		if (parentApplication.TITULOS.xmlNiveles.niveles[i].@id_nivel_otorga == _xmlTitulo.@id_nivel_otorga) {
			cmbNivel.selectedIndex = i;
			break;	
		}					
	}
	for (i = 0;i < parentApplication.TITULOS.xmlGrados.grados.length();i++) {
		if (parentApplication.TITULOS.xmlGrados.grados[i].@id_grado_titulo == _xmlTitulo.@id_grado_titulo) {
			cmbGrado.selectedIndex = i;
			break;	
		}					
	}
	if (_xmlTitulo.@disciplina_unica == '1')
		chkUnica.selected = true;
	if (_xmlTitulo.@especifico == 'S')
		rdbEspecSi.selected = true;
	else
		rdbEspecNo.selected = true;
	acInstitucion.typedText = _xmlTitulo.@denominacion;
	acInstitucion.text = _xmlTitulo.@denominacion;							
	txtNorma.text = _xmlTitulo.@norma_creacion;
	txaRequisitos.text = _xmlTitulo.@requisitos_ingreso;
	if (_xmlTitulo.@modalidad_cursado == 'P')
		rdbPresencial.selected = true;
	else if (_xmlTitulo.@modalidad_cursado == 'S')
		rdbSemip.selected = true;
	else if (_xmlTitulo.@modalidad_cursado == 'D')
		rdbDistancia.selected = true;
	txtDuracion.text = _xmlTitulo.@anios_duracion;
	txtHoraria.text = _xmlTitulo.@carga_horaria;
}

private function ChangeAcInstitucion(e:Event):void {
	if (acInstitucion.text.length==3){
		httpAcInstitucion.send({rutina:"traer_instituciones",denominacion:acInstitucion.text});
	}
}

private function fncCargarAcInstitucion(e:Event):void{
	acInstitucion.typedText = acInstitucion.text;
	acInstitucion.dataProvider = httpAcInstitucion.lastResult.institucion;						
}

private function fncEdit(e:Event):void
{		
	if (fncValidar()) {
		fncArmarXmlTitulo();			
		httpTitulo.addEventListener(ResultEvent.RESULT,fncResultEdit);
		httpTitulo.send({rutina:"update", xmlTitulo:_xmlTitulo.toXMLString(), xmlTitNivel:_xmlTituloNivelPara.toXMLString()});
	}
}

private function fncResultEdit(e:Event):void{		
	var existe_codigo : String =  httpTitulo.lastResult.codigos.@cc;
	if (existe_codigo=="0"){
		Alert.show("La modificación se registró con exito","título");
		dispatchEvent(new Event("EventEdit"));	
	}else{
		Alert.show("El codigo de espacio ingresado ya existe","ERROR");	
	}
	httpTitulo.removeEventListener(ResultEvent.RESULT,fncResultEdit);
}

private function fncDelete(e:Event):void
{
	Alert.show("¿Realmente desea Eliminar el Titulo "+ _xmlTitulo.@nombre+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarTitulo, null, Alert.OK);		
}

private function fncConfirmEliminarTitulo(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		httpTitulo.addEventListener(ResultEvent.RESULT,fncResultDelete);
		httpTitulo.send({rutina:"delete", xmlTitulo:_xmlTitulo.toXMLString()});
	}
}

private function fncResultDelete(e:Event):void{		
	Alert.show("La eliminación se registro con exito","título");
	dispatchEvent(new Event("EventDelete"));			
	httpTitulo.removeEventListener(ResultEvent.RESULT,fncResultDelete);
}

private function fncArmarXmlTitulo():void {				
	_xmlTitulo.@nombre=txtNombre.text;		
	if (_accion != "editar")
		_xmlTitulo.@id_titulo="";		
	_xmlTitulo.@nivel=cmbNivel.selectedItem.@descripcion;		
	_xmlTitulo.@id_grado_titulo=cmbGrado.selectedItem.@id_grado_titulo;		
	if (_accion == "editar") {
		if (_xmlTitulo.@id_institucion.toString() == "0") {
			if (acInstitucion.selectedIndex != -1) {
				_xmlTitulo.@id_institucion=acInstitucion.selectedItem.@id_institucion;
				_xmlTitulo.@denominacion=acInstitucion.selectedItem.@denominacion;	
			}					
		} else {
			if (acInstitucion.selectedIndex != -1) {
				_xmlTitulo.@id_institucion=acInstitucion.selectedItem.@id_institucion;
				_xmlTitulo.@denominacion=acInstitucion.selectedItem.@denominacion;
			}
		}
	} else {
		if (acInstitucion.selectedItem != null) {
			_xmlTitulo.@id_institucion=acInstitucion.selectedItem.@id_institucion;
			_xmlTitulo.@denominacion=acInstitucion.selectedItem.@denominacion;	
		}			
	}			
	_xmlTitulo.@norma_creacion=txtNorma.text;
	if (chkUnica.selected == true)
		_xmlTitulo.@disciplina_unica = '1';
	else
		_xmlTitulo.@disciplina_unica = '0';
	_xmlTitulo.@id_nivel_otorga=cmbNivel.selectedItem.@id_nivel_otorga;
	_xmlTitulo.@requisitos_ingreso=txaRequisitos.text;
	if (rdbPresencial.selected == true)
		_xmlTitulo.@modalidad_cursado='P';
	else if (rdbSemip.selected == true)
		_xmlTitulo.@modalidad_cursado='S';
	else if (rdbDistancia.selected == true)
		_xmlTitulo.@modalidad_cursado='D';
	if (rdbEspecSi.selected == true)
		_xmlTitulo.@especifico = 'S';
	else
		_xmlTitulo.@especifico = 'N';
	_xmlTitulo.@anios_duracion=txtDuracion.text;
	_xmlTitulo.@carga_horaria=txtHoraria.text;
}

private function fncCerrar(e:Event):void
{
	PopUpManager.removePopUp(this)	
}

private function fncAdd(e:Event):void
{		
	if (fncValidar()) {
		fncArmarXmlTitulo();
		httpTitulo.addEventListener(ResultEvent.RESULT,fncResultAdd);
		httpTitulo.send({rutina:"insert", xmlTitulo:_xmlTitulo.toXMLString(), xmlTitNivel:_xmlTituloNivelPara.toXMLString()});
	}
}

private function fncResultAdd(e:Event):void{
	_xmlTitulo.@id_titulo = httpTitulo.lastResult.insert_id;
	_xmlTitulo.@codigo =  httpTitulo.lastResult.codigos.@cc;
	
	Alert.show("El alta se registro con exito","titulo");
	dispatchEvent(new Event("EventAlta"));
	
	httpTitulo.removeEventListener(ResultEvent.RESULT,fncResultAdd);
}

private function fncValidar():Boolean
{
	var error:Array = Validator.validateAll([validNombre]);
	if (error.length>0) {
		((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
		return false;
	}else{
		if (_accion == "editar") {
			/*if (_xmlTitulo.@id_institucion.toString() == "0") {
				if (acInstitucion.selectedIndex == -1) {
					acInstitucion.errorString='Debe seleccionar una institución válida';
					acInstitucion.setFocus();
					return false;
				}
			} else {
				if (acInstitucion.selectedItem == null) {
					acInstitucion.errorString='Debe seleccionar una institución válida';
					acInstitucion.setFocus();
					return false;	
				}					
			}
		} else {
			if (acInstitucion.selectedItem == null) {
				acInstitucion.errorString='Debe seleccionar una institución válida';
				acInstitucion.setFocus();
				return false;
			}*/	
		}
		if (txtDuracion.text == '' && txtHoraria.text == '') {
			//Alert.show("Debe indicar la duración y/o carga horaria\n");
			return true;				
		} /*else if (_xmlTituloNivelPara.titulospara.length() == 0) {
			Alert.show("Debe indicar al menos un nivel para el que habilita el título\n");
			return false;
		}*/ else		
			return true;	
	}	
}

private function customFilterFunction(element:*, text:String):Boolean 
{	
    var label:String = element.@denominacion;    
    return (label.toLowerCase().indexOf(text.toLowerCase()) != -1);
}