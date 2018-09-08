// ActionScript file
	import clases.HTTPServices;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.validators.Validator;

	include "../control_acceso.as";
	
	[Bindable] private var _xmlEspacio : XML = <espacios  />;
	[Bindable] private var httpEspacio : HTTPServices = new HTTPServices;
	private var _accion : String;	
	
	
	public function get xmlEspacio():XML{return _xmlEspacio.copy();}
	public function set xmlEspacio(esp:XML):void{
		_xmlEspacio = esp;
		_accion = "editar";
	}
	public function set xmlEspacio2(esp:XML):void{
		_xmlEspacio = esp;
		_accion = "eliminar";
	}
	
	private function fncInit():void
	{
		//preparo el PopUp Para que se cierre con esc y marco el default button
		this.defaultButton = btnGrabar;
		this.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{if (e.keyCode==27) btnCancel.dispatchEvent(new MouseEvent(MouseEvent.CLICK))});		
		//preparo el httpservice
		httpEspacio.url = "espacios/espacios.php";
		httpEspacio.addEventListener("acceso",acceso);
		// escucho evento de los botones
		btnCancel.addEventListener("click",fncCerrar);
		if (_accion == "editar") {
			//txtCodigo.text = _xmlEspacio.@codigo;
			txtNombre.text = _xmlEspacio.@denominacion;
			btnGrabar.addEventListener("click",fncEdit);
		} else if (_accion == "eliminar") {
			this.currentState = "eliminar";
			//txtCodigo.text = _xmlEspacio.@codigo;
			txtNombre.text = _xmlEspacio.@denominacion;
			btnEliminar.addEventListener("click",fncDelete);
		} else
			btnGrabar.addEventListener("click",fncAdd);
		//pocisino el cursor
		txtNombre.setFocus();
	}
	
	private function fncDelete(e:Event):void
	{
		Alert.show("¿Realmente desea Eliminar el Espacio "+ _xmlEspacio.@denominacion+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarEspacio, null, Alert.OK);		
	}
	
	private function fncConfirmEliminarEspacio(e:CloseEvent):void
	{		
		if (e.detail==Alert.OK){
			httpEspacio.addEventListener(ResultEvent.RESULT,fncResultDelete);
			httpEspacio.send({rutina:"delete", xmlEspacio:_xmlEspacio.toXMLString()}); 
		}
	}
	
	private function fncResultDelete(e:Event):void{		
		Alert.show("La eliminación se registro con exito","espacio");
		dispatchEvent(new Event("EventDelete"));			
		httpEspacio.removeEventListener(ResultEvent.RESULT,fncResultDelete);
	}
	
	private function fncArmarxmlEspacio():void{
		_xmlEspacio.@denominacion=txtNombre.text;
		//_xmlEspacio.@codigo=txtCodigo.text;
		_xmlEspacio.@id_espacio="";			
	}
	
	private function fncCerrar(e:Event):void
	{
		PopUpManager.removePopUp(this)	
	}
	
	private function fncAdd(e:Event):void
	{
		if (fncValidar()) {
			fncArmarxmlEspacio();
			httpEspacio.addEventListener(ResultEvent.RESULT,fncResultAdd);
			httpEspacio.send({rutina:"insert", xmlEspacio:_xmlEspacio.toXMLString()});
		}
	}
	
	private function fncEdit(e:Event):void
	{
		if (fncValidar()) {
			_xmlEspacio.@denominacion=txtNombre.text;
			//_xmlEspacio.@codigo=txtCodigo.text;
			httpEspacio.addEventListener(ResultEvent.RESULT,fncResultEdit);
			httpEspacio.send({rutina:"update", xmlEspacio:_xmlEspacio.toXMLString()});
		}
	}
	
	private function fncResultAdd(e:Event):void{
		_xmlEspacio.@id_espacio = httpEspacio.lastResult.insert_id;
		_xmlEspacio.@codigo = httpEspacio.lastResult.codigos.@cc;
		
		Alert.show("El alta se registró con exito","espacio");
		dispatchEvent(new Event("EventAlta"));
		
		httpEspacio.removeEventListener(ResultEvent.RESULT,fncResultAdd);
	}
	
	private function fncResultEdit(e:Event):void{		
		var existe_codigo : String =  httpEspacio.lastResult.codigos.@cc;
		if (existe_codigo=="0"){
			Alert.show("La modificación se registró con exito","espacio");
			dispatchEvent(new Event("EventEdit"));	
		}else{
			Alert.show("El codigo de espacio ingresado ya existe","ERROR");	
		}
		httpEspacio.removeEventListener(ResultEvent.RESULT,fncResultEdit);
	}
	
	private function fncValidar():Boolean
	{
		var error:Array = Validator.validateAll([validNombre]);
		if (error.length>0) {
			((error[0] as ValidationResultEvent).target.source as UIComponent).setFocus();
			return false;
		}else{
			return true;	
		}	
	}