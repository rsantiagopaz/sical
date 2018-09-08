// ActionScript file
	import clases.HTTPServices;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.ValidationResultEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.validators.Validator;

	include "../control_acceso.as";
	
	[Bindable] private var _xmlEscuela : XML = <escuelas  />;
	[Bindable] private var httpEscuela : HTTPServices = new HTTPServices;
	[Bindable] private var _xmlLugares:XML = <lugares></lugares>;
	[Bindable] private var xmlDepartamentos : XML = <departamentos></departamentos>;
	private var _accion : String;
	
	
	public function get xmlEscuela():XML{return _xmlEscuela.copy();}
	public function set xmlEscuela(esc:XML):void{
		_xmlEscuela = esc;
		_accion = "editar";
	}
	public function set xmlEscuela2(esc:XML):void{
		_xmlEscuela = esc;
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
		//cargo los data providers de los combos
		cmbNivel.dataProvider = (parentApplication.ESCUELAS.xmlNiveles.niveles);
		_xmlLugares.appendChild(parentApplication.xmlLugares.departamento);
		xmlDepartamentos.appendChild(_xmlLugares.departamento);
		//preparo el httpservice
		httpEscuela.url = "escuelas/escuelas.php";
		httpEscuela.addEventListener("acceso",acceso);
		// escucho evento de los botones
		if (_accion == "editar") {			
			txtNombre.text = _xmlEscuela.@nombre;
			for (i = 0;i < parentApplication.ESCUELAS.xmlNiveles.niveles.length();i++) {
				if (parentApplication.ESCUELAS.xmlNiveles.niveles[i].@id_nivel == _xmlEscuela.@id_nivel) {
					cmbNivel.selectedIndex = i;
					break;	
				}					
			}
			for (i = 0;i < xmlDepartamentos.departamento.length();i++) {
				if (xmlDepartamentos.departamento[i].@denom == _xmlEscuela.@departamento) {
					cmbDepartamento.selectedIndex = i;
					break;	
				}
			}			
			for (i = 0;i < xmlDepartamentos.departamento.(@id_departamento==cmbDepartamento.selectedItem.@id_departamento).localidad.length();i++) {
				if (xmlDepartamentos.departamento.(@id_departamento==cmbDepartamento.selectedItem.@id_departamento).localidad[i].@denom == _xmlEscuela.@localidad) {
					cmbLocalidad.selectedIndex = i;
					break;	
				}					
			}
			btnGrabar.addEventListener("click",fncEdit);
		} else if (_accion == "eliminar") {
			this.currentState = "eliminar";			
			txtNombre.text = _xmlEscuela.@nombre;
			for (i = 0;i < parentApplication.ESCUELAS.xmlNiveles.niveles.length();i++) {
				if (parentApplication.ESCUELAS.xmlNiveles.niveles[i].@id_nivel == _xmlEscuela.@id_nivel) {
					cmbNivel.selectedIndex = i;
					break;	
				}					
			}
			for (i = 0;i < xmlDepartamentos.departamento.length();i++) {
				if (xmlDepartamentos.departamento[i].@denom == _xmlEscuela.@departamento) {
					cmbDepartamento.selectedIndex = i;
					break;	
				}
			}			
			for (i = 0;i < xmlDepartamentos.departamento.(@id_departamento==cmbDepartamento.selectedItem.@id_departamento).localidad.length();i++) {
				if (xmlDepartamentos.departamento.(@id_departamento==cmbDepartamento.selectedItem.@id_departamento).localidad[i].@denom == _xmlEscuela.@localidad) {
					cmbLocalidad.selectedIndex = i;
					break;	
				}					
			}
			btnEliminar.addEventListener("click",fncDelete);
		} else
			btnGrabar.addEventListener("click",fncAdd);
		btnCancel.addEventListener("click",fncCerrar);
		//posiciono el cursor
		txtNombre.setFocus();
	}
	
	private function fncEdit(e:Event):void
	{
		if (fncValidar()) {
			fncArmarXmlEscuela();			
			httpEscuela.addEventListener(ResultEvent.RESULT,fncResultEdit);
			httpEscuela.send({rutina:"update", xmlEscuela:_xmlEscuela.toXMLString()});
		}
	}
	
	private function fncResultEdit(e:Event):void{		
		var existe_codigo : String =  httpEscuela.lastResult.codigos.@cc;
		if (existe_codigo=="0"){
			Alert.show("La modificación se registró con exito","escuela");
			dispatchEvent(new Event("EventEdit"));	
		}else{
			Alert.show("El codigo de espacio ingresado ya existe","ERROR");	
		}
		httpEscuela.removeEventListener(ResultEvent.RESULT,fncResultEdit);
	}
	
	private function fncDelete(e:Event):void
	{
		Alert.show("¿Realmente desea Eliminar la Escuela "+ _xmlEscuela.@nombre+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarEscuela, null, Alert.OK);		
	}
	
	private function fncConfirmEliminarEscuela(e:CloseEvent):void
	{		
		if (e.detail==Alert.OK){
			httpEscuela.addEventListener(ResultEvent.RESULT,fncResultDelete);
			httpEscuela.send({rutina:"delete", xmlEscuela:_xmlEscuela.toXMLString()});
		}
	}
	
	private function fncResultDelete(e:Event):void{		
		Alert.show("La eliminación se registro con exito","escuela");
		dispatchEvent(new Event("EventDelete"));			
		httpEscuela.removeEventListener(ResultEvent.RESULT,fncResultDelete);
	}
	
	private function fncArmarXmlEscuela():void{
		_xmlEscuela.@nombre=txtNombre.text;		
		if (_accion != "editar")
			_xmlEscuela.@id_escuela="";
		_xmlEscuela.@id_nivel=cmbNivel.selectedItem.@id_nivel
		_xmlEscuela.@nivel=cmbNivel.selectedItem.@nivel; 
		_xmlEscuela.@departemento=cmbDepartamento.selectedItem.@departamento;
		_xmlEscuela.@id_departamento=cmbDepartamento.selectedItem.@id_departamento;
		_xmlEscuela.@localidad=cmbLocalidad.selectedItem.@denom;
		_xmlEscuela.@id_localidad=cmbLocalidad.selectedItem.@id_localidad;	
	}
	
	private function fncCerrar(e:Event):void
	{
		PopUpManager.removePopUp(this)	
	}
	
	private function fncAdd(e:Event):void
	{
		if (fncValidar()) {
			fncArmarXmlEscuela();
			httpEscuela.addEventListener(ResultEvent.RESULT,fncResultAdd);
			httpEscuela.send({rutina:"insert", xmlEscuela:_xmlEscuela.toXMLString()});
		}
	}
	
	private function fncResultAdd(e:Event):void{
		_xmlEscuela.@id_escuela = httpEscuela.lastResult.insert_id;
		_xmlEscuela.@codigo = httpEscuela.lastResult.codigos.@cc;
		
		Alert.show("El alta se registro con exito","Escuela");
		dispatchEvent(new Event("EventAlta"));
		
		httpEscuela.removeEventListener(ResultEvent.RESULT,fncResultAdd);
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