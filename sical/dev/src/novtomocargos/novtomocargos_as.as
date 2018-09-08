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
[Bindable] private var _xmlNiveles:XML = <niveles>
				       <niveles id_nivel="" nivel="TODOS"/>
				       </niveles>;
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

[Bindable] private var _visualizacion:Boolean = true;

public function get xmlTiposTitulos():XML{return _xmlTiposTitulos.copy();}

public function fncInit():void
{		
	if (parentApplication.orgAId != '6') {
		this.currentState = "visualizacion";
		_visualizacion = false;	
	}			 
	httpDatos.url = "novtomocargos/novtomocargos.php";
	httpDatos.addEventListener("acceso",acceso);
	httpDatosD.url = "novtomocargos/novtomocargos.php";
	httpDatosD.addEventListener("acceso",acceso);
	httpDatosS.url = "novtomocargos/novtomocargos.php";
	httpDatosS.method = URLRequestMethod.POST;
	httpDatosS.addEventListener("acceso",acceso);
	_xmlUsuarios = <usuarios>
				   <usuarios SYSusuario="TODOS" SYSusuarionombre="TODOS"/>
				   </usuarios>;
	_xmlNiveles = <niveles>
				  <niveles id_nivel="" nivel="TODOS"/>
				  </niveles>;
	httpDatosU.url = "novtomocargos/novtomocargos.php";
	httpDatosU.method = URLRequestMethod.POST;
	httpDatosU.addEventListener("acceso",acceso);
	httpDatosU.addEventListener(ResultEvent.RESULT,fncDatosResultU);
	httpDatosU.send({rutina:"traer_usuarios"});
	_xmlOpcEnt = <tiposent>				
						<tiposent tipo="Título"/>													
						<tiposent tipo="Cargo"/>
				 </tiposent>;
	httpNiveles.url = "novtomocargos/novtomocargos.php";
	httpNiveles.addEventListener("acceso",acceso);
	httpNiveles.addEventListener(ResultEvent.RESULT,fncNivelesResult);
	httpNiveles.send({rutina:"traer_niveles"});
	httpDatos2.url = "conscomtcargos/conscomtcargos.php";
	httpDatos2.addEventListener("acceso",acceso);
	httpDatos2.addEventListener(ResultEvent.RESULT,fncDatosResult2);
	httpDatos2.send({rutina:"traer_datos2"});		
	httpAcCarreraN.url = "conscomtcargos/conscomtcargos.php";
	httpAcCarreraN.addEventListener("acceso",acceso);				
	httpCargosA.url = "novtomocargos/novtomocargos.php";
	httpCargosA.method = URLRequestMethod.POST;
	httpCargosA.addEventListener("acceso",acceso);		
	httpCargosA.addEventListener(ResultEvent.RESULT,fncCargarcargosA);
	httpCargosD.url = "conscomtcargos/conscomtcargos.php";
	httpCargosD.addEventListener("acceso",acceso);
	httpCargosD.addEventListener(ResultEvent.RESULT,fncCargarcargosD);		
	httpCodTituloA.url = "conscomtcargos/conscomtcargos.php";
	httpCodTituloA.addEventListener("acceso",acceso);
	httpCargosA.send({rutina:"traer_cargos"});
	
	btnBuscar.addEventListener("click",fncTraerNovedadesBoton);
	
	btnImpactarTodas.addEventListener("click",fncImpactarTodas);		
	btnImpactarSeleccionadas.addEventListener("click",fncImpactarSeleccionadas);
	btnImpactarNivelSeleccionado.addEventListener("click",fncImpactarNivelSeleccionado);
	txiCodigoT.text = '';
	txiCodigoC.text = '';
}

private function fncTraerNovedadesBoton(e:Event):void
{
	if ((txiCodigoT.text != '') || (txiCodigoC.text != '') || (txtNombre.text != '') || (cboUsuario.text != 'TODOS') || (cboNivel.text != 'TODOS'))
		httpCargosA.send({rutina:"traer_cargos_2",cod_titulo:txiCodigoT.text,cod_cargo:txiCodigoC.text,
			tipo:cboOpcEnt.text,nombre:txtNombre.text,usuario:cboUsuario.selectedItem.@SYSusuario,id_nivel:cboNivel.selectedItem.@id_nivel});
	else
		httpCargosA.send({rutina:"traer_cargos"});
}

public function fncEliminarNovedad():void
{
	var xmlTitulo:XML = (gridCargosA.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Eliminar la Novedad?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarNovedad, null, Alert.OK);		
}

private function fncConfirmEliminarNovedad(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlTitulo:XML = (gridCargosA.selectedItem as XML).copy();
		var id_nov_tomo_cargos:String = xmlTitulo.@id_nov_tomo_cargos;
		var id_tomo_cargo:String = xmlTitulo.@id_tomo_cargo;
		httpDatos.addEventListener(ResultEvent.RESULT,fncResultDel);
		httpDatos.send({rutina:"delete",id_nov_tomo_cargos:id_nov_tomo_cargos,id_tomo_cargo:id_tomo_cargo});
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
	Alert.show("¿Realmente desea Impactar TODAS las Novedades del Nivel Seleccionado (Cargos)? La acción no podrá deshacerse", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmImpactarNivelSeleccionado, null, Alert.OK);		
}

private function fncConfirmImpactarNivelSeleccionado(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){			
		httpDatosD.addEventListener(ResultEvent.RESULT,fncResultImpTodas);
		httpDatosD.send({rutina:"impactar_todas",id_nivel:cboNivel.selectedItem.@id_nivel});
	}
}

public function fncSeleccionar(id_nov_tomo_cargos:String,seleccionado:int):void
{			
	var xmlCargo:XML = <cargos id_nov_tomo_cargos={id_nov_tomo_cargos} fecha_novedad="" id_tomo_cargo="" id_cargo="" cod_cargo="" id_titulo="" cod_titulo="" id_tipo_titulo="" cod_tipo_titulo="" tipo="" id_tipo_clasificacion="" denomcar="" denomtit="" denomclas="" cod_tipo_clasificacion="" cod_nivel="" nivel="" origen="" tipo_novedad=""/>;
	if (seleccionado == 1) {			
		_xmlCargosEnviar.appendChild(xmlCargo);			
	} else {
		var arrayLength:int = _xmlCargosEnviar.cargos.length();
		for (var i:int = 0;i<arrayLength;i++) {
			if (_xmlCargosEnviar.cargos[i].@id_nov_tomo_cargos == xmlCargo.@id_nov_tomo_cargos) {
				delete _xmlCargosEnviar.cargos[i];						
			}
		}
	}
}

private function fncConfirmImpactarSeleccionadas(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){			
		httpDatosS.addEventListener(ResultEvent.RESULT,fncResultImpSelec);
		//Alert.show(_xmlCargosEnviar);
		httpDatosS.send({rutina:"impactar_seleccionadas",xmlNovedades:_xmlCargosEnviar});
	}
}

private function fncResultImpSelec(e:Event):void{		
	Alert.show("Las novedades seleccionadas se impactaron con éxito","novedad");							
	httpDatosS.removeEventListener(ResultEvent.RESULT,fncResultImpSelec);
	httpCargosA.send({rutina:"traer_cargos"});
}

public function fncImpactarSeleccionadas(e:Event):void
{	
	if (_xmlCargosEnviar.cargos.length() > 0)
		Alert.show("¿Realmente desea Impactar las Novedades Seleccionadas? La acción no podrá deshacerse", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmImpactarSeleccionadas, null, Alert.OK);
	else
		Alert.show("No ha seleccionado novedades para ser impactadas.\nPara seleccionar/deseleccionar una o más novedades, marque/desmarque la casilla de verificación de la columna izquierda.\n");		
}

private function fncResultImpTodas(e:Event):void{		
	Alert.show("Las novedades se impactaron con éxito","novedad");							
	httpDatosD.removeEventListener(ResultEvent.RESULT,fncResultImpTodas);
	httpCargosA.send({rutina:"traer_cargos"});
}

public function fncImpactarNovedad():void
{
	var xmlTitulo:XML = (gridCargosA.selectedItem as XML).copy();
	Alert.show("¿Realmente desea Impactar la Novedad?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmImpactarNovedad, null, Alert.OK);		
}

private function fncConfirmImpactarNovedad(e:CloseEvent):void
{		
	if (e.detail==Alert.OK){
		var xmlTitulo:XML = (gridCargosA.selectedItem as XML).copy();
		var id_nov_tomo_cargos:String = xmlTitulo.@id_nov_tomo_cargos;
		var id_tomo_cargo:String = xmlTitulo.@id_tomo_cargo;
		httpDatos.addEventListener(ResultEvent.RESULT,fncResultImp);
		httpDatos.send({rutina:"impactar",id_nov_tomo_cargos:id_nov_tomo_cargos,id_tomo_cargo:id_tomo_cargo});
	}
}

private function fncResultDel(e:Event):void{		
	Alert.show("La eliminación se registro con éxito","novedad");		
	delete _xmlCargosA.cargos[(gridCargosA.selectedItem as XML).childIndex()];					
	httpDatos.removeEventListener(ResultEvent.RESULT,fncResultDel);
}

private function fncResultImp(e:Event):void{		
	Alert.show("La novedad se impactó con éxito","novedad");		
	delete _xmlCargosA.cargos[(gridCargosA.selectedItem as XML).childIndex()];					
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

private function fncCargarcargosA(e:Event):void 
{
	_xmlCargosA = <cargos></cargos>;
	_xmlCargosEnviar = <cargos></cargos>;
	_xmlCargosA.appendChild(httpCargosA.lastResult.cargos);		
}

private function fncCargarcargosD(e:Event):void 
{
	_xmlCargosDE = <cargos></cargos>;
	_xmlCargosEnviar = <cargos></cargos>;
	_xmlCargosDE.appendChild(httpCargosD.lastResult.cargos);		
}					

private function fncCerrar(e:Event):void
{
	dispatchEvent(new Event("eventClose"));
}
