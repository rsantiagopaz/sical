// ActionScript file
	import postitulos.nuevo_postitulo;
	
	import mx.managers.PopUpManager;
	
	[Bindable] private var _xmlCobertura:XML = <coberturas></coberturas>;
	private var _xmlDatosPaciente:XML = <datospaciente></datospaciente>;
	//private var _twNuevosPostitulos:nuevo_postitulo;
	
	//inicializa las variales necesarias para el modulo
	public function fncInit():void
	{	
		
		/*_xmlCobertura = <coberturas></coberturas>;
		_xmlDatosPaciente = <datospaciente></datospaciente>;
		_xmlCobertura.appendChild(parentApplication.CONSULTA.xmlDatosPaciente.cobertura);
		_xmlDatosPaciente.appendChild(parentApplication.CONSULTA.xmlDatosPaciente.paciente);*/
		//btnNuevoPostitulo.addEventListener("click" ,fncAgregarPostitulo);
	}
	
	private function fncCerrar(e:Event):void{
		dispatchEvent(new Event("eventClose"));
	}
	
	private function fncVerHistorial(e:Event):void
	{
		
	}
	
	private function fncAgregarPostitulo(e:Event):void
	{
		/*_twNuevosPostitulos = new nuevo_postitulo;
		_twNuevosPostitulos.addEventListener("EventConfirmarAntecedente",fncGrabarNuevoPostitulo);
		PopUpManager.addPopUp(_twNuevosPostitulos,this,true);
		PopUpManager.centerPopUp(_twNuevosPostitulos);*/
	}
	
	private function fncGrabarNuevoPostitulo(e:Event):void
	{
			
	}
	