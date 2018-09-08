import abmtitulos.twtitulo;

import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";
include "../asincludes/numericSort.as";

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
[Bindable] private var _xmlNiveles:XML = <niveles>
				       <niveles id_nivel="" nivel="TODOS"/>
				       </niveles>;
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

[Bindable] private var _visualizacion:Boolean = true;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{
	if (parentApplication.orgAId != '6') {
		this.currentState = "visualizacion";
		_visualizacion = false;	
	}
	httpDatos.url = "novtomoespacios/novtomoespacios.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatosD.url = "novtomoespacios/novtomoespacios.php";
	httpDatosD.addEventListener("acceso",acceso);
	httpDatosS.url = "novtomoespacios/novtomoespacios.php";
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
	httpNiveles.addEventListener(ResultEvent.RESULT,fncNivelesResult);
	httpNiveles.send({rutina:"traer_niveles"});
	httpDatos2.url = "conscomtespacios/conscomtespacios.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});		
	httpAcCarreraN.url = "conscomtespacios/conscomtespacios.php";
	httpAcCarreraN.addEventListener("acceso",acceso);			
	httpespaciosA.url = "novtomoespacios/novtomoespacios.php";
	httpespaciosA.addEventListener("acceso",acceso);
	httpespaciosA.method = URLRequestMethod.POST;
	httpespaciosA.addEventListener(ResultEvent.RESULT,fncCargarespaciosA);
	httpespaciosD.url = "conscomtespacios/conscomtespacios.php";
	httpespaciosD.addEventListener("acceso",acceso);
	httpespaciosD.addEventListener(ResultEvent.RESULT,fncCargarespaciosD);		
	httpCodTituloA.url = "conscomtespacios/conscomtespacios.php";
	httpCodTituloA.addEventListener("acceso",acceso);
	httpespaciosA.send({rutina:"traer_espacios"});
	
	btnBuscar.addEventListener("click",fncTraerNovedadesBoton);
	
	btnImpactarTodas.addEventListener("click",fncImpactarTodas);
	btnImpactarSeleccionadas.addEventListener("click",fncImpactarSeleccionadas);
	btnImpactarNivelSeleccionado.addEventListener("click",fncImpactarNivelSeleccionado);
	txiCodigoT.text = '';
	txiCodigoE.text = '';
}

private function fncTraerNovedadesBoton(e:Event):void
{
	if ((txiCodigoT.text != '') || (txiCodigoE.text != '') || (txtNombre.text != '') || (cboUsuario.text != 'TODOS') || (cboNivel.text != 'TODOS'))
		httpespaciosA.send({rutina:"traer_espacios_2",cod_titulo:txiCodigoT.text,cod_espacio:txiCodigoE.text,
			tipo:cboOpcEnt.text,nombre:txtNombre.text,usuario:cboUsuario.selectedItem.@SYSusuario,id_nivel:cboNivel.selectedItem.@id_nivel});
	else
		httpespaciosA.send({rutina:"traer_espacios"});
}

public function fncEliminarNovedad():void
{
	var xmlTitulo:XML = (gridespaciosA.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Eliminar la Novedad?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarNovedad, null, Alert.OK);		
}

private function fncConfirmEliminarNovedad(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlTitulo:XML = (gridespaciosA.selectedItem as XML).copy();
		var id_nov_tomo_espacios:String = xmlTitulo.@id_nov_tomo_espacios;
		var id_tomo_espacio:String = xmlTitulo.@id_tomo_espacio;
		httpDatos.addEventListener(ResultEvent.RESULT,fncResultDel);
		httpDatos.send({rutina:"delete",id_nov_tomo_espacios:id_nov_tomo_espacios,id_tomo_espacio:id_tomo_espacio});
	}
}

public function fncImpactarTodas(e:Event):void
{		
	Alert.show("¿Realmente desea Impactar TODAS las Novedades? La acción no podrá deshacerse", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmImpactarTodas, null, Alert.OK);		
}

private function fncConfirmImpactarTodas(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){			
		httpDatosD.addEventListener(ResultEvent.RESULT,fncResultImpTodas);
		httpDatosD.send({rutina:"impactar_todas"});
	}
}

public function fncImpactarNivelSeleccionado(e:Event):void
{		
	Alert.show("¿Realmente desea Impactar TODAS las Novedades del Nivel Seleccionado (Carreras)? La acción no podrá deshacerse", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmImpactarNivelSeleccionado, null, Alert.OK);		
}

private function fncConfirmImpactarNivelSeleccionado(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){			
		httpDatosD.addEventListener(ResultEvent.RESULT,fncResultImpTodas);
		httpDatosD.send({rutina:"impactar_todas",id_nivel:cboNivel.selectedItem.@id_nivel});
	}
}

public function fncSeleccionar(id_nov_tomo_espacios:String,seleccionado:int):void
{
	var xmlEspacio:XML = <espacios id_nov_tomo_espacios={id_nov_tomo_espacios} fecha_novedad="" id_tomo_espacio="" id_espacio="" cod_carrera="" cod_espacio="" id_titulo="" cod_titulo="" id_tipo_titulo="" cod_tipo_titulo="" tipo="" id_tipo_clasificacion="" denomcar="" denomesp="" denomtit="" denomclas="" cod_tipo_clasificacion="" cod_nivel="" nivel="" origen="" tipo_novedad=""/>;
	if (seleccionado == 1) {			
		_xmlespaciosEnviar.appendChild(xmlEspacio);			
	} else {
		var arrayLength:int = _xmlespaciosEnviar.espacios.length();
		for (var i:int = 0;i<arrayLength;i++) {
			if (_xmlespaciosEnviar.espacios[i].@id_nov_tomo_espacios == xmlEspacio.@id_nov_tomo_espacios) {
				delete _xmlespaciosEnviar.espacios[i];						
			}
		}
	}
}

private function fncResultImpTodas(e:Event):void
{		
	Alert.show("Las novedades se impactaron con éxito","novedad");							
	httpDatosD.removeEventListener(ResultEvent.RESULT,fncResultImpTodas);
	httpespaciosA.send({rutina:"traer_espacios"});
}

private function fncConfirmImpactarSeleccionadas(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){			
		httpDatosS.addEventListener(ResultEvent.RESULT,fncResultImpSelec);
		//Alert.show(_xmlespaciosEnviar);
		httpDatosS.send({rutina:"impactar_seleccionadas",xmlNovedades:_xmlespaciosEnviar});
	}
}

private function fncResultImpSelec(e:Event):void
{		
	Alert.show("Las novedades seleccionadas se impactaron con éxito","novedad");							
	httpDatosS.removeEventListener(ResultEvent.RESULT,fncResultImpSelec);
	httpespaciosA.send({rutina:"traer_espacios"});
}

public function fncImpactarSeleccionadas(e:Event):void
{	
	if (_xmlespaciosEnviar.espacios.length() > 0)
		Alert.show("¿Realmente desea Impactar las Novedades Seleccionadas? La acción no podrá deshacerse", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmImpactarSeleccionadas, null, Alert.OK);
	else
		Alert.show("No ha seleccionado novedades para ser impactadas.\nPara seleccionar/deseleccionar una o más novedades, marque/desmarque la casilla de verificación de la columna izquierda.\n");		
}

public function fncImpactarNovedad():void
{
	var xmlTitulo:XML = (gridespaciosA.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Impactar la Novedad?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmImpactarNovedad, null, Alert.OK);		
}

private function fncConfirmImpactarNovedad(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlTitulo:XML = (gridespaciosA.selectedItem as XML).copy();
		var id_nov_tomo_espacios:String = xmlTitulo.@id_nov_tomo_espacios;
		var id_tomo_espacio:String = xmlTitulo.@id_tomo_espacio;
		httpDatos.addEventListener(ResultEvent.RESULT,fncResultImp);
		httpDatos.send({rutina:"impactar",id_nov_tomo_espacios:id_nov_tomo_espacios,id_tomo_espacio:id_tomo_espacio});
	}
}

private function fncResultDel(e:Event):void
{		
	Alert.show("La eliminación se registro con éxito","novedad");		
	delete _xmlespaciosA.espacios[(gridespaciosA.selectedItem as XML).childIndex()];					
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultDel);
}

private function fncResultImp(e:Event):void
{		
	Alert.show("La novedad se impactó con éxito","novedad");		
	delete _xmlespaciosA.espacios[(gridespaciosA.selectedItem as XML).childIndex()];					
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultImp);
}

private function fncTraerTitulosBoton1(e:Event):void
{
	_twTitulo = new twtitulo;		
	PopUpManager.addPopUp(_twTitulo,this,true);
	PopUpManager.centerPopUp(_twTitulo);
}		

private function fncDatosResult2(e:Event):void 
{		
	_xmlTiposTitulos.appendChild(httpDatos2.lastResult.tipostitulos);
	_xmlTiposClasificacion.appendChild(httpDatos2.lastResult.tiposclasificacion);
}

private function fncNivelesResult(e:Event):void 
{		
	_xmlNiveles.appendChild(httpNiveles.lastResult.niveles);		
}

private function fncDatosResultU(e:Event):void 
{		
	_xmlUsuarios.appendChild(httpDatosU.lastResult.usuarios);				
}						

private function fncCargarespaciosA(e:Event):void 
{
	_xmlespaciosA = <espacios></espacios>;
	_xmlespaciosEnviar = <espacios></espacios>;
	_xmlespaciosA.appendChild(httpespaciosA.lastResult.espacios);		
}

private function fncCargarespaciosD(e:Event):void 
{
	_xmlespaciosDE = <espacios></espacios>;
	_xmlespaciosEnviar = <espacios></espacios>;
	_xmlespaciosDE.appendChild(httpespaciosD.lastResult.espacios);		
}					

private function fncCerrar(e:Event):void
{
	dispatchEvent(new Event("eventClose"));
}
