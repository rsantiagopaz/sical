import clases.HTTPServices;

import flash.events.Event;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;

include "../control_acceso.as";

private var httpDatos:HTTPServices = new HTTPServices;

private var _caso:String = "confirmar";
		
//inicializa las variales necesarias para el modulo
public function fncInit():void
{
	_caso = "confirmar";
	txaError.text = "";
	btnCancelar.addEventListener("click" ,fncCancelarInscripcion);
	
	httpDatos.url = "datosinscripcion/inscripcion.php";
	httpDatos.method = URLRequestMethod.POST;
	httpDatos.addEventListener("acceso",acceso);
	
	if (parentDocument.accion == 'B') {
		this.currentState = 'baja';
		httpDatos.removeEventListener(ResultEvent.RESULT,fncInformarInscripcion);
		httpDatos.addEventListener(ResultEvent.RESULT,fncBajaInscripcionResult);
		btnBaja.addEventListener("click" ,fncConfirmarBajaInscripcion);
	}else{
		this.currentState = '';
		httpDatos.removeEventListener(ResultEvent.RESULT,fncBajaInscripcionResult);
		this.defaultButton = btnGuardar;
		btnGuardar.addEventListener("click" ,fncConfirmarInscripcion);	
		httpDatos.addEventListener(ResultEvent.RESULT,fncInformarInscripcion);
	}			
}

/**
 * Función que aplica el tope correspondiente a cada grupo.
 * Los topes son por grupo, por lo tanto la cantidad para cada antecedente
 * del grupo, debe ser la mayor posible sin que se supere el tope; comenzando 
 * por aquellos antecedentes del grupo que aportan mayor cantidad de puntos
 */
private function fncAplicarTope(ant1:XML,fq:String):XML
{
	var ant:XML = ant1.copy();		
	var j:int;		
	var total:Number = 0;		
	var item:XML;
	var hasta:int;
	for each(item in ant.children()) {			
		if (item.@acum > 0) {				
			hasta = parseInt(item.@acum);								
			for (j = 1;j <= hasta;j++) {
				if (item.@tipo_tope=='P')
					total += 1 * Number(item.@puntos);
				else
					total += 1;
				// Es necesario redondear el total a dos decimales					
				total = Math.round(total*100)/100;					
				if (total > Number(item.@tope) * parseInt(fq)) {
					total -= 1 * Number(item.@puntos);
					item.@acum = j - 1;
					break;	
				}						
			}							
		}
	}
	return ant;
}

private function fncAplicarTopeUnico(ant1:XML,fq:String,codigo:String):XML
{
	var ant:XML = ant1.copy();		
	var j:int;		
	var total:Number = 0;		
	var item:XML;
	var hasta:int;
	for each(item in ant.children()) {			
		if (item.@acum > 0 && item.@codigo == codigo) {								
			hasta = parseInt(item.@acum);								
			for (j = 1;j <= hasta;j++) {
				if (item.@tipo_tope=='P')
					total += 1 * Number(item.@puntos);
				else
					total += 1;
				if (total > Number(item.@tope) * parseInt(fq)) {
					total -= 1 * Number(item.@puntos);
					item.@acum = j - 1;
					break;	
				}						
			}							
		}
	}
	return ant;
}

private function fncEncontrarDiferencias(ant1:XML,ant2:XML):Boolean
{
	var ant1c:XML = ant1.copy();
	var ant2c:XML = ant2.copy();
	var i:int;				
	var item:XML;
	var dif:Boolean = false;
	var xmlArray1:Array = new Array();
	var xmlArray2:Array = new Array();
	var acum:int;
	for each (item in ant1c.children()) {
		// Si no hay acumulado, el campo 'acum' puede estar vacío
		if (item.@acum == '')
			acum = 0;
		else {
			acum = parseInt(item.@acum);
			xmlArray1.push(acum);	
		}				
	}
	for each (item in ant2c.children()) {
		// Si no hay acumulado, el campo 'acum' puede estar vacío
		if (item.@acum == '')
			acum = 0;
		else {
			acum = parseInt(item.@acum);
			xmlArray2.push(acum);
		}			
	}
	for (i = 0;i < xmlArray1.length;i++) {				
		if (xmlArray1[i] !=  xmlArray2[i]) {
			dif = true;
			break;
		}			
	}
	return dif;
}

private function fncConfirmarBajaInscripcion(e:Event):void
{
	Alert.yesLabel = "Si";			 
	Alert.show("¿Confirma dar de Baja la Inscripción del docente?","Confirmación Baja", Alert.YES | Alert.NO,null,fncBajaInscripcion);
}

private function fncBajaInscripcion(e:CloseEvent):void
{
	if(e.detail==Alert.YES) 
	{
		var id_docente_llamado:String = parentDocument.id_docente_llamado;
		httpDatos.send({rutina:"baja_inscripcion", id_docente_llamado:id_docente_llamado});	
	}
}
private function fncBajaInscripcionResult(e:Event):void{
	Alert.show("La Baja se Registro Exitosamente","Inscripcion");
	dispatchEvent(new Event("eventClose"));	
}

private function fncConfirmarInscripcion(e:Event):void
{
	Alert.yesLabel = "Si";			 
	Alert.show("¿Confirma los datos de Inscripción del docente?","Confirmación", Alert.YES | Alert.NO,null,fncConfirmDatos);
}

private function fncCancelarInscripcion(e:Event):void
{
	Alert.yesLabel = "Si";			 
	Alert.show("¿Realmente desea cancelar la inscripción del docente "+parentDocument.ModDatosGenerales.apellido+", "+parentDocument.ModDatosGenerales.nombres+"?","Confirmación", Alert.YES | Alert.NO,null,fncCancelDatos);
}

private function fncCancelDatos(e:CloseEvent):void
{
	if(e.detail==Alert.YES) {
		_caso = "cancelar";
		if (parentDocument.accion == 'A') {
			var id_docente_llamado:String = parentDocument.id_docente_llamado;
			httpDatos.send({rutina:"cancelar_inscripcion", id_docente_llamado:id_docente_llamado});	
		} else
			dispatchEvent(new Event("eventClose"));			
	}				
}
	
private function fncConfirmDatos(e:CloseEvent):void
{
	if(e.detail==Alert.YES) 
	{	
		var error:String = "";
		var fq:String = parentDocument.ModDatosGenerales.fq;
		var antiguedad:XML = parentDocument.ModDatosGenerales.xmlAntig;
		var antiguedadc5:XML = parentDocument.ModDatosGenerales.xmlAntigC5;
		var cargossimp:XML = parentDocument.ModDatosGenerales.xmlCargosSimple;
		var cargoscomp:XML = parentDocument.ModDatosGenerales.xmlCargosCompleta;
		var cargosc:XML = parentDocument.ModDatosGenerales.xmlCargosC;
		var cargosa:XML = parentDocument.ModDatosGenerales.xmlCargosA;
		var cargose:XML = parentDocument.ModDatosGenerales.xmlCargosE;
		var cargosp:XML = parentDocument.ModDatosGenerales.xmlCargosP;
		var establecimientos:XML = parentDocument.ModDatosGenerales.xmlEstablecimientos;
		var idNivel:String = parentDocument.ModDatosGenerales.idNivel;
		var idTipoClasif:String = parentDocument.ModDatosGenerales.idTipoClasif;
		var titulosd:XML = parentDocument.ModTitulos.xmlTitulos;
		var postitulos:XML = parentDocument.ModPostitulos.xmlPostitulos;									
		//var postitulos:XML = XMLUtils.sortXMLByAttribute(parentDocument.ModPostitulos.xmlPostitulos,'puntos',Array.NUMERIC | Array.DESCENDING,true);						
		var posgrados:XML = parentDocument.ModPostitulos.xmlPosgrados;
		var cursosap:XML = parentDocument.ModCursos.xmlCursosAprobados;						
		//var cursosap:XML = XMLUtils.sortXMLByAttribute(parentDocument.ModCursos.xmlCursosAprobados,'puntos',Array.NUMERIC | Array.DESCENDING,true);						
		var cursosad:XML = parentDocument.ModCursos.xmlCursosAdHonorem;
		var cursoscost:XML = parentDocument.ModCursos.xmlCursosCosteados;
		//var cursoscost:XML = XMLUtils.sortXMLByAttribute(parentDocument.ModCursos.xmlCursosCosteados,'puntos',Array.NUMERIC | Array.DESCENDING,true);
		var cursossr:XML = parentDocument.ModCursos.xmlCursosSinResolucion;			
		//var cursossr:XML = XMLUtils.sortXMLByAttribute(parentDocument.ModCursos.xmlCursosSinResolucion,'puntos',Array.NUMERIC | Array.DESCENDING,true);
		var cursoscr:XML = parentDocument.ModCursos.xmlCursosConResolucion;			
		//var cursoscr:XML = XMLUtils.sortXMLByAttribute(parentDocument.ModCursos.xmlCursosConResolucion,'puntos',Array.NUMERIC | Array.DESCENDING,true);
		var congresoexp:XML = parentDocument.ModCongresos.xmlExpositor;
		//var congresoexp:XML = XMLUtils.sortXMLByAttribute(parentDocument.ModCongresos.xmlExpositor,'puntos',Array.NUMERIC | Array.DESCENDING,true);
		var congresopart:XML = parentDocument.ModCongresos.xmlParticipante;
		//var congresopart:XML = XMLUtils.sortXMLByAttribute(parentDocument.ModCongresos.xmlParticipante,'puntos',Array.NUMERIC | Array.DESCENDING,true);
		var congresoasist:XML = parentDocument.ModCongresos.xmlAsistente;
		//var congresoasist:XML = XMLUtils.sortXMLByAttribute(parentDocument.ModCongresos.xmlAsistente,'puntos',Array.NUMERIC | Array.DESCENDING,true);
		var capacitaciones:XML = parentDocument.ModCapacitacion.xmlCapacitaciones;
		var publicaciones:XML = parentDocument.ModCapacitacion.xmlPublicaciones;
		//var publicaciones:XML = XMLUtils.sortXMLByAttribute(parentDocument.ModCapacitacion.xmlPublicaciones,'puntos',Array.NUMERIC | Array.DESCENDING,true);
		var producciones:XML = parentDocument.ModCapacitacion.xmlProducciones;
		var premiosic:XML = parentDocument.ModCapacitacion.xmlPremiosIC;
		var premiosp:XML = parentDocument.ModCapacitacion.xmlPremiosP;
		var concursostit:XML = parentDocument.ModCapacitacion.xmlConcursosTitulo;
		var concursosant:XML = parentDocument.ModCapacitacion.xmlConcAnteced;
		var concursosop:XML = parentDocument.ModCapacitacion.xmlConcOpos;			
		var participacion:XML = parentDocument.ModEventos.xmlParticipacion;
		var desempenio:XML = parentDocument.ModEventos.xmlDesempenio;
		var lenguasnat:XML = parentDocument.ModEventos.xmlCertificadoLenguasNativas;
		var desempenioent:XML = parentDocument.ModEventos.xmlDesempenioEnt;
		var lenguasext:XML = parentDocument.ModEventos.xmlCertificadoLenguasExtranjeras;
		var deducciones:XML = parentDocument.ModEventos.xmlDeducciones;
		var jurado:XML = parentDocument.ModEventos.xmlMiembroJurado;
		
		var id_docente:String = parentDocument.idDocente;
		var id_docente_llamado:String = parentDocument.id_docente_llamado;
		var id_llamado:String = parentDocument.idLlamado;
		var nroRegion:String;
		var sitRevista:String;
		var antiguedades:Object = new Object();
		var antiguedadesC5:Object = new Object();
		var a:XML;
		
		var sumaC4:int = 0;
		var sumaC2:int = 0;
		var sumaC3:int = 0;
		var sumaC6C7:int = 0;
		for each (a in antiguedad.antiguedad)
		{	
			if (a.@cantidad.toString() != "")
		    	antiguedades[a.@codigo.toString()] = parseInt(a.@cantidad.toString());
		    else
		    	antiguedades[a.@codigo.toString()] = 0;		    		    		  
		}
		sumaC4 += antiguedades["C4A"] + antiguedades["C4B"] + antiguedades["C4C"] + antiguedades["C4D"];
		sumaC2 += antiguedades["C2A"] + antiguedades["C2B"] + antiguedades["C2C"] + antiguedades["C2D"];
		sumaC3 += antiguedades["C3A"] + antiguedades["C3B"];
		sumaC6C7 += antiguedades["C6"] + antiguedades["C7"];
		
		var sumaC5:int = 0;
		for each (a in antiguedadc5.antiguedad)
		{
			if (a.@cantidad.toString() != "") {
				antiguedadesC5[a.@codigo] = parseInt(a.@cantidad.toString());
		    	sumaC5 += parseInt(a.@cantidad.toString());	
			} else {
				antiguedadesC5[a.@codigo] = 0;
			}	    
		}
		
		if (antiguedades["C1A"] > 0 && antiguedades["C1B"] > 0) {
			// Solo provisionalmente, no aplicamos para Inicial
			if (idNivel != '1') {
				error += "C1A y C1B son excluyentes\n";	
			}			
		} else if (antiguedades["C1A"] == 0 && antiguedades["C1B"] == 0) {
			if (sumaC2 + sumaC3 + sumaC4 + sumaC5 + sumaC6C7 > 0) {
				error += "No puede informar C2, C3, C4, C5, C6, o C7 si no informa C1A o C1B\n";
			}
		} else if (antiguedades["C1A"] > 0) {
			// Aplicamos sólo para Primario
			if (idNivel == '2') {
				if (antiguedades["C1A"] > 45) {
					error += "La antiguedad declarada en C1A no puede ser mayor a 45\n";	
				}									
							
				if (sumaC4 > antiguedades["C1A"] + 2)
					error += "La suma de valores de C4 no puede ser mayor a C1A + 2\n";					
				
				if (sumaC5 > antiguedades["C1A"] + 1)
					error += "La suma de valores de C5 no puede ser mayor a C1A + 1\n";	
			}			
		} else if (antiguedades["C1B"] > 0) {
			// Solo provisionalmente, no aplicamos para Inicial
			if (idNivel != '1') {
				if (antiguedades["C1B"] > 1) {
					error += "C1B no puede ser mayor a 1\n";
				}
				
				var topeC1B:int = 1;			
							
				if (sumaC4 > topeC1B)
					error += "La suma de valores de C4 no puede ser mayor a 1(uno) cuando se informa C1B\n";					
				
				if (sumaC5 > topeC1B)
					error += "La suma de valores de C5 no puede ser mayor a 1(uno) cuando se informa C1B\n";	
			}			
		}							
										
		if (idNivel == '1' || idNivel == '2') {
			nroRegion = parentDocument.ModDatosGenerales.nroRegion;
			var tipoJornada:String = parentDocument.ModDatosGenerales.jornada;
			if (nroRegion == '' && tipoJornada != 'CC' && tipoJornada != 'DP')
				error += "No ha informado el número de región en la solapa 'Datos Generales'\n";
			// Verificar que se haya inormado al menos un cargo de jornada completa
			if (tipoJornada == 'CC' && cargoscomp.cargo.length() == 0)
				error += "Debe informar al menos un cargo en la solapa 'Datos Generales'\n";
			// Verificar que se haya inormado al menos un cargo de jornada simple
			if (tipoJornada == 'SS' && cargossimp.cargo.length() == 0)
				error += "Debe informar al menos un cargo en la solapa 'Datos Generales'\n";
			// Verificar que se haya inormado al menos un cargo de jornada simple o completa
			if (tipoJornada == 'SC' && cargoscomp.cargo.length() == 0 && cargossimp.cargo.length() == 0)
				error += "Debe informar al menos un cargo en la solapa 'Datos Generales'\n";
			// Verificar que se haya inormado al menos un cargo de dirección de psicología
			if (tipoJornada == 'DP' && cargosa.cargo.length() == 0 && cargose.cargo.length() == 0 && cargosp.cargo.length() == 0)
				error += "Debe informar al menos un cargo en la solapa 'Datos Generales'\n";
		} else {
			nroRegion = '';				
		}			
		if ((idTipoClasif == '1' && (idNivel == '2' || idNivel == '5')) || idTipoClasif == '2' || idTipoClasif == '5') {					
			sitRevista = parentDocument.ModDatosGenerales.sit_revista;			
			if (sitRevista == '0')
				error += "Debe seleccionar la situación de revista en la solapa 'Datos Generales'\n";	
		}
		var deptoAplicacionInicial:int;
		var deptoAplicacionPrimario:int;
		var selecCargo:int;
		var ruralidad:int;
		if (idNivel == '3' || idNivel == '4') {
			selecCargo = parentDocument.ModDatosGenerales.selecCargo;
			ruralidad = parentDocument.ModDatosGenerales.ruralidad;				
			if (idNivel == '4') {
				deptoAplicacionInicial = parentDocument.ModDatosGenerales.deptoAplicacionInicial;
				deptoAplicacionPrimario = parentDocument.ModDatosGenerales.deptoAplicacionPrimario;
			} else {
				deptoAplicacionInicial = 0;
				deptoAplicacionPrimario = 0;	
			}					
		} else {
			selecCargo = 0;
			ruralidad = 0;
			deptoAplicacionInicial = 0;
			deptoAplicacionPrimario = 0;
		}
		if (idNivel == '5' && cargosc.cargo.length() == 0 && cargosa.cargo.length() == 0 && cargose.cargo.length() == 0) {
			error += "Debe informar al menos un cargo en la solapa 'Datos Generales'\n";
		}
		if (titulosd.titulo.length() == 0)
			error += "No ha ingresado ningún título en la solapa 'Títulos'\n";
			
		var er:Boolean =false;
		for each (var t:XML in titulosd.titulo)
		{
		    var p:Number = Number(t.@promedio);
		    if (p>10){er = true; }
		}
		if (er){
			error += "El Promedio en todos los títulos debe ser un valor entre 0 y 10\n";
		}			
					
		if (error == "") {		
			var XMLinscripcion:XML = <inscripcion>
									{antiguedad}
									{antiguedadc5}
									{cargossimp}
									{cargoscomp}
									{cargosc}
									{cargosa}
									{cargose}
									{cargosp}
								 	{establecimientos}
								 	{titulosd}
								 	{postitulos}
								 	{posgrados}
								 	{cursosap}
								 	{cursosad}
								 	{cursoscost}
								 	{cursossr}
								 	{cursoscr}
								 	{congresoexp}
								 	{congresopart}
								 	{congresoasist}
								 	{capacitaciones}
								 	{publicaciones}
								 	{producciones}
								 	{premiosic}
								 	{premiosp}
								 	{concursostit}
								 	{concursosant}
								 	{concursosop}
								 	{participacion}
								 	{desempenio}
								 	{lenguasnat}
								 	{desempenioent}
								 	{lenguasext}
								 	{deducciones}
								 	{jurado}									 	
							     </inscripcion>;								     			
																												
			httpDatos.send({rutina:"realizar_inscripcion", inscripcion:XMLinscripcion.toXMLString(), 
				id_docente:id_docente, id_docente_llamado:id_docente_llamado, id_llamado:id_llamado, nro_region:nroRegion, 
				depto_aplicacion_inicial:deptoAplicacionInicial, depto_aplicacion_primario:deptoAplicacionPrimario, 
				selecciona_cargo:selecCargo, ruralidad:ruralidad, tipo_jornada:tipoJornada, situacion_revista:sitRevista});	
		} else {
			txaError.text = "E R R O R E S\n" + error;
		}					        	
	}
}		

private function fncInformarInscripcion(e:Event):void 
{
	if (_caso == "confirmar") {
		var id_docente_llamado:String = parentDocument.id_docente_llamado;			
		
		//Creo los contenedores para enviar datos y recibir respuesta
		var enviar:URLRequest = new URLRequest("confirmacion/listado_de_antecedentes.php?rutina=reporte_antecedentes_docente&");
		var recibir:URLLoader = new URLLoader();
	 		 
		//Creo la variable que va a ir dentro de enviar, con los campos que tiene que recibir el PHP.
		var variables:URLVariables = new URLVariables();
		
		variables.id_docente_llamado = id_docente_llamado;
		variables.idNivel = parentDocument.ModDatosGenerales.idNivel;			
					
		//Indico que voy a enviar variables dentro de la petición
		enviar.data = variables;
		
		navigateToURL(enviar);
		Alert.show("La inscripción se ha realizado exitosamente","Inscripción");
	}		
	else
		Alert.show("La inscripción se ha cancelado exitosamente","Inscripción");
	dispatchEvent(new Event("eventClose"));
}