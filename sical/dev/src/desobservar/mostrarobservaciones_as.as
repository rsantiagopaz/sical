// ActionScript file
	import clases.HTTPServices;
	
	import desobservar.desobservar;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	include "../control_acceso.as";
		
	[Bindable] private var httpDatos:HTTPServices = new HTTPServices;
	[Bindable] private var httpCombos:HTTPServices = new HTTPServices;
	private var _id_docente_llamado:String;
	private var _id_llamado:String;
	private var twDoc : desobservar;
	[Bindable] private var xmlObs : XML;
		
	public function fncInit():void
	{
		txiNroDoc.text = '';
		txiApellido.text = '';
		txiNombres.text = '';
		txiTipoDoc.text = '';
		this.defaultButton = btnGuardar;
		btnGuardar.enabled = false;
		btnGuardar.addEventListener("click" ,fncGuardar);
		btnCancelar.addEventListener("click" ,fncCerrar);
		
		httpCombos.url = "importarinscrip/twdocentesec2.php";
		httpCombos.addEventListener("acceso",acceso);
		httpCombos.send({rutina:"traer_datos"});
		
		twDoc = new desobservar;
		PopUpManager.addPopUp(twDoc,this,true);
        PopUpManager.centerPopUp(twDoc);
        twDoc.addEventListener("verDocente",fncVerDocente);
        twDoc.addEventListener("Close",fncCerrarPopUp);		
        
        httpDatos.url = "desobservar/desobservar.php";
		httpDatos.addEventListener("acceso",acceso);
		httpDatos.addEventListener(ResultEvent.RESULT,fncGuardarResult);
	}		
			
	private function fncVerDocente(e:Event):void
	{
		var xmlDatos : XML = twDoc.xmlDatos;
		xmlObs = twDoc.xmlObs;		
		_id_docente_llamado = xmlDatos.llamadodocente.@id_docente_llamado;
		_id_llamado = xmlDatos.llamadodocente.@id_llamado;
		txiNroDoc.text = xmlDatos.llamadodocente.@nro_doc;
		txiApellido.text = xmlDatos.llamadodocente.@apellido;
		txiNombres.text = xmlDatos.llamadodocente.@nombres;
		txiTipoDoc.text = xmlDatos.llamadodocente.@tipo_doc;
		txiDescripcion.text = xmlDatos.llamadodocente.@descripcion;
		btnGuardar.enabled = true;
		PopUpManager.removePopUp(e.target as desobservar);
	}		
	
	private function fncGuardar(e:Event):void
	{		
		httpDatos.send({rutina:"quitar_observaciones", id_docente_llamado:_id_docente_llamado});		
	}
	
	private function fncGuardarResult(e:Event):void
	{
		Alert.show("La inscripción ha sido desobservada");
		dispatchEvent(new Event("SelectPrincipal"));	
	}
	
	private function fncCerrar(e:Event):void{
		dispatchEvent(new Event("SelectPrincipal"));
	}
	
	private function fncCerrarPopUp(e:Event):void
	{	
		PopUpManager.removePopUp(e.target as desobservar)
		dispatchEvent(new Event("SelectPrincipal"));
	}