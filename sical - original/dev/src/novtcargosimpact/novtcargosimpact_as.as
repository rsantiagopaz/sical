import abmtitulos.twtitulo;

import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
include "../asincludes/numericSort.as";

[Bindable] private var _xmlCargosA:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosEnviar:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosD:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosDE:XML = <cargos></cargos>;
[Bindable] private var _xmlCargosNuevos:XML = <cargos></cargos>;
[Bindable] private var _xmlTiposTitulos:XML = <tipostitulos></tipostitulos>;
[Bindable] private var _xmlTiposClasificacion:XML = <tiposclasificacion></tiposclasificacion>;
[Bindable] private var _xmlOpcEnt:XML = <tiposent>				
												<tiposent tipo="Título"/>													
												<tiposent tipo="Cargo"/>
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
private var httpCargosA:HTTPServices = new HTTPServices;
private var httpCargosD:HTTPServices = new HTTPServices;
private var httpCargoN:HTTPServices = new HTTPServices;	
private var httpAcTituloD:HTTPServices = new HTTPServices;
private var httpAcCarreraN:HTTPServices = new HTTPServices;
private var httpCodTituloA:HTTPServices = new HTTPServices;
private var httpCodTituloD:HTTPServices = new HTTPServices;
private var httpCodCargo:HTTPServices = new HTTPServices;
private var _twTitulo:twtitulo = new twtitulo;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{			
	httpDatos.url = "novtcargosimpact/novtcargosimpact.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatosD.url = "novtcargosimpact/novtcargosimpact.php";
	httpDatosD.addEventListener("acceso",acceso);
	httpDatosS.url = "novtcargosimpact/novtcargosimpact.php";
	httpDatosS.method = URLRequestMethod.POST;
	httpDatosS.addEventListener("acceso",acceso);
	_xmlUsuarios = <usuarios>
				   <usuarios SYSusuario="TODOS" SYSusuarionombre="TODOS"/>
				   </usuarios>;
	httpDatosU.url = "novtcargosimpact/novtcargosimpact.php";
	httpDatosU.method = URLRequestMethod.POST;
	httpDatosU.addEventListener("acceso",acceso);
	httpDatosU.addEventListener(ResultEvent.RESULT,fncDatosResultU);
	httpDatosU.send({rutina:"traer_usuarios"});
	_xmlOpcEnt = <tiposent>				
						<tiposent tipo="Título"/>													
						<tiposent tipo="Cargo"/>
				 </tiposent>;		
	httpNiveles.url = "novtcargosimpact/novtcargosimpact.php";
	httpNiveles.addEventListener("acceso",acceso);		
	httpNiveles.send({rutina:"traer_niveles"});
	httpDatos2.url = "conscomtcargos/conscomtcargos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});		
	httpAcCarreraN.url = "conscomtcargos/conscomtcargos.php";
	httpAcCarreraN.addEventListener("acceso",acceso);				
	httpCargosA.url = "novtcargosimpact/novtcargosimpact.php";
	httpCargosA.method = URLRequestMethod.POST;
	httpCargosA.addEventListener("acceso",acceso);		
	httpCargosA.addEventListener(ResultEvent.RESULT,fncCargarcargosA);
	httpCargosD.url = "conscomtcargos/conscomtcargos.php";
	httpCargosD.addEventListener("acceso",acceso);
	httpCargosD.addEventListener(ResultEvent.RESULT,fncCargarcargosD);		
	httpCodTituloA.url = "conscomtcargos/conscomtcargos.php";
	httpCodTituloA.addEventListener("acceso",acceso);
	//httpCargosA.send({rutina:"traer_cargos"});
	
	btnBuscar.addEventListener("click",fncTraerNovedadesBoton);
			
	txiCodigoT.text = '';
	txiCodigoC.text = '';
}

private function fncTraerNovedadesBoton(e:Event):void
{
	if (dfFechaInicio.selectedDate == null || dfFechaFin.selectedDate == null) {
		Alert.show("Debe ingresar las fechas entre las cuales realizar la búsqueda", "E R R O R");
	} else {
		if ((txiCodigoT.text != '') || (txiCodigoC.text != '') || (txtNombre.text != ''))
			httpCargosA.send({rutina:"traer_cargos_2",cod_titulo:txiCodigoT.text,cod_cargo:txiCodigoC.text,
				tipo:cboOpcEnt.text,nombre:txtNombre.text,fecha_inicio:dfFechaInicio.text,fecha_fin:dfFechaFin.text});
		else
			httpCargosA.send({rutina:"traer_cargos",fecha_inicio:dfFechaInicio.text,fecha_fin:dfFechaFin.text});	
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

private function fncCargarcargosA(e:Event):void {
	_xmlCargosA = <cargos></cargos>;
	_xmlCargosEnviar = <cargos></cargos>;
	_xmlCargosA.appendChild(httpCargosA.lastResult.cargos);		
}

private function fncCargarcargosD(e:Event):void {
	_xmlCargosDE = <cargos></cargos>;
	_xmlCargosEnviar = <cargos></cargos>;
	_xmlCargosDE.appendChild(httpCargosD.lastResult.cargos);		
}					

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
