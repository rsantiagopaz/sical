// ActionScript file
	import abmtitulos.twtitulo;
	
	import clases.HTTPServices;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	include "../control_acceso.as";
	
	[Bindable] private var _xmlespaciosA:XML = <espacios></espacios>;
	[Bindable] private var _xmlespaciosD:XML = <espacios></espacios>;
	[Bindable] private var _xmlespaciosEnviar:XML = <espacios></espacios>;
	[Bindable] private var _xmlespaciosDE:XML = <espacios></espacios>;
	[Bindable] private var _xmlespaciosNuevos:XML = <espacios></espacios>;
	[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
	[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
	[Bindable] private var _xmlOpcEnt:XML = <tiposent>				
													<tiposent tipo="Título"/>													
													<tiposent tipo="Espacio"/>
											</tiposent>;	
	[Bindable] private var _xmlUsuarios:XML = <usuarios>
								   			  <usuarios SYSusuario="TODOS" SYSusuarionombre="TODOS"/>
								   			  </usuarios>;
	private var httpDatos:HTTPServices = new HTTPServices;
	private var httpDatosD:HTTPServices = new HTTPServices;
	private var httpDatosS:HTTPServices = new HTTPServices;
	private var httpDatos2:HTTPServices = new HTTPServices;
	[Bindable] private var httpNiveles:HTTPServices = new HTTPServices;
	[Bindable] private var httpDatosU:HTTPServices = new HTTPServices;
	private var httpespaciosA:HTTPServices = new HTTPServices;
	private var httpespaciosD:HTTPServices = new HTTPServices;
	private var httpespacioN:HTTPServices = new HTTPServices;	
	private var httpAcTituloD:HTTPServices = new HTTPServices;
	private var httpAcCarreraN:HTTPServices = new HTTPServices;
	private var httpCodTituloA:HTTPServices = new HTTPServices;
	private var httpCodTituloD:HTTPServices = new HTTPServices;
	private var httpCodespacio:HTTPServices = new HTTPServices;
	private var _twTitulo:twtitulo = new twtitulo;		
	
	public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}
	
	public function fncInit():void
	{		
		httpDatos.url = "novtespaciosimpact/novtespaciosimpact.php";
		httpDatos.addEventListener("acceso",acceso);
		httpDatosD.url = "novtespaciosimpact/novtespaciosimpact.php";
		httpDatosD.addEventListener("acceso",acceso);
		httpDatosS.url = "novtespaciosimpact/novtespaciosimpact.php";
		httpDatosS.method = URLRequestMethod.POST;
		httpDatosS.addEventListener("acceso",acceso);
		_xmlUsuarios = <usuarios>
					   <usuarios SYSusuario="TODOS" SYSusuarionombre="TODOS"/>
					   </usuarios>;
		httpDatosU.url = "novtomocargos/novtomocargos.php";
		httpDatosU.method = URLRequestMethod.POST;
		httpDatosU.addEventListener("acceso",acceso);
		httpDatosU.addEventListener(ResultEvent.RESULT,fncDatosResultU);
		httpDatosU.send({rutina:"traer_usuarios"});
		_xmlOpcEnt = <tiposent>				
							<tiposent tipo="Título"/>													
							<tiposent tipo="Espacio"/>
					 </tiposent>;
		httpNiveles.url = "novtomocargos/novtomocargos.php";
		httpNiveles.addEventListener("acceso",acceso);		
		httpNiveles.send({rutina:"traer_niveles"});
		httpDatos2.url = "conscomtespacios/conscomtespacios.php";
		httpDatos2.addEventListener("acceso",acceso);
		httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
		httpDatos2.send({rutina:"traer_datos2"});		
		httpAcCarreraN.url = "conscomtespacios/conscomtespacios.php";
		httpAcCarreraN.addEventListener("acceso",acceso);			
		httpespaciosA.url = "novtespaciosimpact/novtespaciosimpact.php";
		httpespaciosA.addEventListener("acceso",acceso);
		httpespaciosA.method = URLRequestMethod.POST;
		httpespaciosA.addEventListener(ResultEvent.RESULT,fncCargarespaciosA);
		httpespaciosD.url = "conscomtespacios/conscomtespacios.php";
		httpespaciosD.addEventListener("acceso",acceso);
		httpespaciosD.addEventListener(ResultEvent.RESULT,fncCargarespaciosD);		
		httpCodTituloA.url = "conscomtespacios/conscomtespacios.php";
		httpCodTituloA.addEventListener("acceso",acceso);
		//httpespaciosA.send({rutina:"traer_espacios"});
		
		btnBuscar.addEventListener("click",fncTraerNovedadesBoton);
				
		txiCodigoT.text = '';
		txiCodigoE.text = '';
	}
	
	private function fncTraerNovedadesBoton(e:Event):void
	{
		if (dfFechaInicio.selectedDate == null || dfFechaFin.selectedDate == null) {
			Alert.show("Debe ingresar las fechas entre las cuales realizar la búsqueda", "E R R O R");
		} else {
			if ((txiCodigoT.text != '') || (txiCodigoE.text != '') || (txtNombre.text != ''))
				httpespaciosA.send({rutina:"traer_espacios_2",cod_titulo:txiCodigoT.text,cod_espacio:txiCodigoE.text,
					tipo:cboOpcEnt.text,nombre:txtNombre.text,fecha_inicio:dfFechaInicio.text,fecha_fin:dfFechaFin.text});
			else
				httpespaciosA.send({rutina:"traer_espacios",fecha_inicio:dfFechaInicio.text,fecha_fin:dfFechaFin.text});
		}		
	}	
	
	/*
	* Función para ordenar los datos de la columna 'total' de manera numérica, no alfabética:
	*/
    public function numericSort(a:*,b:*):int
    {
    	var nA:Number=Number(a.@cod_carrera);
        var nB:Number=Number(b.@cod_carrera);
        if (nA<nB){
         	return -1;
        }else if (nA>nB){
         	return 1;
        }else {
            return 0;
        }
    }
	
	private function fncTraerTitulosBoton1(e:Event):void
	{
		_twTitulo = new twtitulo;		
		PopUpManager.addPopUp(_twTitulo,this,true);
		PopUpManager.centerPopUp(_twTitulo);
	}		
	
	private function fncDatosResult2(e:Event):void {		
		_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
		_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
	}
	
	private function fncDatosResultU(e:Event):void {		
		_xmlUsuarios.appendChild(httpDatosU.lastResult.usuarios);				
	}						
	
	private function fncCargarespaciosA(e:Event):void {
		_xmlespaciosA = <espacios></espacios>;
		_xmlespaciosEnviar = <espacios></espacios>;
		_xmlespaciosA.appendChild(httpespaciosA.lastResult.espacios);		
	}
	
	private function fncCargarespaciosD(e:Event):void {
		_xmlespaciosDE = <espacios></espacios>;
		_xmlespaciosEnviar = <espacios></espacios>;
		_xmlespaciosDE.appendChild(httpespaciosD.lastResult.espacios);		
	}					
	
	private function fncCerrar(e:Event):void{
		dispatchEvent(new Event("eventClose"));
	}
	