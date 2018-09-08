import clases.HTTPServices;
import flash.events.Event;
import mx.controls.Alert;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
	
private var httpDatos:HTTPServices = new HTTPServices;
[Bindable] private var httpTiposDoc : HTTPServices = new HTTPServices;
private var _idIngresoMovimiento:String;
[Bindable] private var xmlDepartamentos : XML = <departamentos></departamentos>;
[Bindable] private var _xmlLugares:XML = <lugares></lugares>;
[Bindable] private var id_departamento:String;
[Bindable] private var localidad_id:String;

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("SelectPrincipal"));
}

public function fncInit():void
{
	txiNroDoc.text = '';
	txiApellido.text = '';
	txiNombres.text = '';
	txiDomicilio.text = '';
	cmbDepartamento.selectedIndex = 0;
	cmbLocalidad.selectedIndex = 0;
	this.defaultButton = btnGuardar;
	_xmlLugares.appendChild(parentApplication.xmlLugares.departamento);
	xmlDepartamentos.appendChild(_xmlLugares.departamento);			
	httpTiposDoc.url = "inscripllamado/datosdocente.php";		
	httpTiposDoc.addEventListener(ResultEvent.RESULT,fncTiposDocResult);		
	httpTiposDoc.send({rutina:"traer_documentos"});
	btnGuardar.addEventListener("click" ,fncGuardar);
	//cmbTiposDoc.addEventListener("change",fncEveOutCmbTiposDoc);
	txiNroDoc.addEventListener("focusOut",fncEveOutTxiNroDoc);			
}

private function fncEveOutCmbTiposDoc(e:Event):void
{	
	if (txiNroDoc.text != '') {
		txiApellido.text = '';
		txiNombres.text = '';
		txiDomicilio.text = '';
		cmbDepartamento.selectedIndex = 0;
		cmbLocalidad.selectedIndex = 0;		
		httpDatos.url = "inscripllamado/datosdocente.php";		
		httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);
		httpDatos.send({rutina:"consulta",tipo_doc:httpTiposDoc.lastResult.documentos.documento[cmbTiposDoc.selectedIndex].id_tipo_doc,nro_doc:txiNroDoc.text});	
	}				
}

private function fncEveOutTxiNroDoc(e:Event):void
{			
	txiApellido.text = '';
	txiNombres.text = '';
	txiDomicilio.text = '';
	cmbDepartamento.selectedIndex = 0;
	cmbLocalidad.selectedIndex = 0;		
	httpDatos.url = "inscripllamado/datosdocente.php";		
	httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);
	httpDatos.send({rutina:"consulta",tipo_doc:httpTiposDoc.lastResult.documentos.documento[cmbTiposDoc.selectedIndex].id_tipo_doc,nro_doc:txiNroDoc.text});		
}
		
private function fncGuardar(e:Event):void
{
	var error:String = "";
	if (cmbTiposDoc.selectedIndex == 0)
		error += "No ha ingresado el tipo de documento del docente\n";
	if (txiNroDoc.text == "")
		error += "No ha ingresado el nro de documento del docente\n";
	if (txiApellido.text == "")
		error += "No ha ingresado el apellido del docente\n";
	if (txiNombres.text == "")
		error += "No ha ingresado el nombre del docente\n";
	if (error == "") {
		Alert.yesLabel = "Si";			 
		Alert.show("¿Confirma el Alta de: '" + txiApellido.text + ', ' + txiNombres.text + "'?","Confirmación", Alert.YES | Alert.NO,null,fncConfirmDocente);	
	} else {
		Alert.show(error,"E R R O R");
	}	
}

private function fncConfirmDocente(e:CloseEvent):void
{
	if(e.detail==Alert.YES) 
	{
		var XMLdocente:XML = <docentes>
								<id_tipo_doc>{httpTiposDoc.lastResult.documentos.documento[cmbTiposDoc.selectedIndex].id_tipo_doc.toString()}</id_tipo_doc>
								<apellido>{txiApellido.text}</apellido>
								<nro_doc>{txiNroDoc.text}</nro_doc>
								<domicilio>{txiDomicilio.text}</domicilio>
								<nombres>{txiNombres.text}</nombres>
								<id_localidad>{cmbLocalidad.selectedItem.@id_localidad}</id_localidad>										
							 </docentes>;
		
		httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);																		
		httpDatos.send({rutina:"dar_ingreso", docente:XMLdocente});    	
	}
}

private function fncTiposDocFault(error:String) : void	
{
 	Alert.show("Error en la comunicación con el servidor: " + error,"E R R O R");	 	
}
 
private function fncTiposDocResult(e:Event) : void 
{  	 	 
	cmbTiposDoc.enabled = true;
	cmbTiposDoc.dataProvider = httpTiposDoc.lastResult.documentos.documento.documento;
}

private function fncDatosResult(e:ResultEvent):void
{		
 	if (httpDatos.lastResult.docente.apellido != '') {
 		txiApellido.text = httpDatos.lastResult.docente.apellido;
		txiNombres.text = httpDatos.lastResult.docente.nombres;
		txiDomicilio.text = httpDatos.lastResult.docente.domicilio;
		var i:int;
		if (httpDatos.lastResult.docente.departamento != "" && httpDatos.lastResult.docente.departamento) {
			for (i = 0;i < xmlDepartamentos.departamento.length();i++) {
				if (xmlDepartamentos.departamento[i].@denom == httpDatos.lastResult.docente.departamento) {
					cmbDepartamento.selectedIndex = i;
					break;	
				}
			}			
			for (i = 0;i < xmlDepartamentos.departamento.(@id_departamento==cmbDepartamento.selectedItem.@id_departamento).localidad.length();i++) {
				if (xmlDepartamentos.departamento.(@id_departamento==cmbDepartamento.selectedItem.@id_departamento).localidad[i].@denom == httpDatos.lastResult.docente.localidad) {
					cmbLocalidad.selectedIndex = i;
					break;	
				}					
			}
		}
		parentDocument.idDocente = httpDatos.lastResult.docente.id_docente;
		parentDocument.tipoDoc = cmbTiposDoc.text;
		parentDocument.nroDoc = txiNroDoc.text;
		parentDocument.apellidoDocente = httpDatos.lastResult.docente.apellido;
		parentDocument.nombresDocente = httpDatos.lastResult.docente.nombres;
		txiApellido.editable = false;
 		txiNombres.editable = false;
 		txiDomicilio.editable = false;
 		cmbDepartamento.enabled = false;
 		cmbLocalidad.enabled = false;
 		btnGuardar.enabled = false;
 	} else {
 		parentDocument.idDocente = "";
 		txiApellido.editable = true;
 		txiNombres.editable = true;
 		txiDomicilio.editable = true;
 		cmbDepartamento.enabled = true;
 		cmbLocalidad.enabled = true;
 		btnGuardar.enabled = true;
 	}
 	httpDatos.removeEventListener(ResultEvent.RESULT,fncDatosResult);
}

private function fncCargarDatos(e:Event):void
{		
	_xmlLugares.appendChild(httpDatos.lastResult.departamento);
	xmlDepartamentos.appendChild(_xmlLugares.departamento);
}