import datosgenerales.nuevo_cargo;
import datosgenerales.nuevo_establecimiento;

import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;

[Bindable] private var _xmlEstablecimientos:XML = <establecimientos></establecimientos>;
[Bindable] private var _xmlCargosSimple:XML = <cargossimp></cargossimp>;
[Bindable] private var _xmlCargosCompleta:XML = <cargoscomp></cargoscomp>;
[Bindable] private var _xmlCargosC:XML = <cargosc></cargosc>;
[Bindable] private var _xmlCargosA:XML = <cargosa></cargosa>;
[Bindable] private var _xmlCargosE:XML = <cargose></cargose>;
[Bindable] private var _xmlCargosP:XML = <cargosp></cargosp>;	
[Bindable] private var _xmlInstancias:XML = <instancias></instancias>;	
private var _twNuevosEstablecimientos:nuevo_establecimiento;
private var _twNuevosCargos:nuevo_cargo;
private var _xmlDatosDocente:XML = <datosdocente></datosdocente>;
private var _idNivel:String;
[Bindable] private var _id_tipo_clasificacion:String;
[Bindable] private var _id_tipo_llamado:String;

/**
 * Función que retorna los establecimientos seleccionados para inscribirse (secundario y superior)
 */
public function get xmlEstablecimientos():XML{
	var xmlEstablecimiento : XML;
	if (_idNivel == '3') {
		if (chkRuralidad.selected == true) {
			var existente : Boolean = false;
			var i:int;
			for (i = 0;i < _xmlEstablecimientos.establecimiento.length();i++) {
				if (_xmlEstablecimientos.establecimiento[i].@codigo == "2000") {
					existente = true;
				}
			}
			if (existente == false) {
				xmlEstablecimiento = <establecimiento id_escuela="146" codigo="2000" nombre="" id_localidad="0" nivel="0" />;
				_xmlEstablecimientos.appendChild(xmlEstablecimiento);	
			}
			existente = false;
			for (i = 0;i < _xmlEstablecimientos.establecimiento.length();i++) {
				if (_xmlEstablecimientos.establecimiento[i].@codigo == "2001") {
					existente = true;
				}
			}
			if (existente == false) {
				xmlEstablecimiento = <establecimiento id_escuela="202" codigo="2001" nombre="" id_localidad="0" nivel="0" />;
				_xmlEstablecimientos.appendChild(xmlEstablecimiento);	
			}
		}		
	}	
	return _xmlEstablecimientos.copy();
}

public function get xmlCargosSimple():XML{return _xmlCargosSimple.copy();}
public function get xmlCargosCompleta():XML{return _xmlCargosCompleta.copy();}
public function get xmlCargosC():XML{return _xmlCargosC.copy();}
public function get xmlCargosA():XML{return _xmlCargosA.copy();}
public function get xmlCargosE():XML{return _xmlCargosE.copy();}
public function get xmlCargosP():XML{return _xmlCargosP.copy();}
public function get xmlAntig():XML
{		
	var xmlAntig:XML =
	<antiguedades>
		<antiguedad codigo="C1A" cantidad={txiC1A.text} />		
		<antiguedad codigo="C1B" cantidad={txiC1B.text} />
		<antiguedad codigo="C4D" cantidad={txiC4A.text} />
		<antiguedad codigo="C4C" cantidad={txiC4B.text} />
		<antiguedad codigo="C4B" cantidad={txiC4C.text} />
		<antiguedad codigo="C4A" cantidad={txiC4D.text} />			
		<antiguedad codigo="C2A" cantidad={txiC2A.text} />
		<antiguedad codigo="C2B" cantidad={txiC2B.text} />
		<antiguedad codigo="C2C" cantidad={txiC2C.text} />
		<antiguedad codigo="C2D" cantidad={txiC2D.text} />
		<antiguedad codigo="C3A" cantidad={txiC3A.text} />
		<antiguedad codigo="C3B" cantidad={txiC3B.text} />
		<antiguedad codigo="C6" cantidad={txiC6.text} />
		<antiguedad codigo="C7" cantidad={txiC7.text} />
	</antiguedades>;
	return xmlAntig.copy();
}
public function get xmlAntigC5():XML
{
	var xmlAntigC5:XML = 
	<antiguedadesc5>
		<antiguedad codigo="C5" id_antecedente="32" cantidad={txiC5i.text} />
		<antiguedad codigo="C5" id_antecedente="108" cantidad={txiC5p.text} />
		<antiguedad codigo="C5" id_antecedente="109" cantidad={txiC5se.text} />
		<antiguedad codigo="C5" id_antecedente="110" cantidad={txiC5su.text} />
	</antiguedadesc5>;
	return xmlAntigC5.copy();
}
public function get apellido():String{return txiApenom.text;}
public function get nombres():String{return txiNombre.text;}
public function get idNivel():String{return _idNivel}
public function get idTipoClasif():String{return _id_tipo_clasificacion}
public function get nroRegion():String{return txiNroRegion.text}
public function get deptoAplicacionInicial():int
{
	if (chkAplicInicial.selected == true)
		return 1;
	else
		return 0;
}
public function get deptoAplicacionPrimario():int
{
	if (chkAplicPrimario.selected == true)
		return 1;
	else
		return 0;
}
public function get selecCargo():int
{
	if (rbEmbSi.selected == true)
		return 1;
	else
		return 0;
}
public function get ruralidad():int
{
	if (chkRuralidad.selected == true)
		return 1;
	else
		return 0;
}

/**
 * Devuelve el tipo de jornada seleccionado (inicial y primario)
 */
public function get jornada():String
{
	var tipo_jornada:String = '';
	if (rbCompNo.selected == true)
		tipo_jornada = 'SS';
	else if (rbCompSi.selected == true)
		tipo_jornada = 'CC';
	else if (rbSimpComp.selected == true)
		tipo_jornada = 'SC';
	else
		tipo_jornada = 'DP';
	return tipo_jornada;
}

public function get sit_revista():String
{
	var situacion_revista:String = '';
	if ((_id_tipo_clasificacion == '1' && (_idNivel == '2' || _idNivel == '5')) || _id_tipo_clasificacion == '2' || _id_tipo_clasificacion == '5')
		situacion_revista = cmbInstancias.selectedItem.@orden;		
	return situacion_revista;			
}		

public function get fq():String
{
	var fq:String = this.parentDocument.xmlDatosDocente.quinquenio[0].@fq;
	return fq;		
}

/**
 * @param idNivel: nivel del usuario que está realizando las inscripción (inicial, primario, secundario, superior)
 * @param id_tipo_clasificacion: tipo de clasificación a la que corresponde el llamado
 * @id_tipo_llamado: tipo de llamado al que corresponde la inscripción
 * 
 * Función que pone en blanco todos los campos de la pestaña datos generales
 */
private function initValues(idNivel:String,id_tipo_clasificacion:String,id_tipo_llamado:String):void
{
	_idNivel = idNivel;
	_id_tipo_clasificacion = id_tipo_clasificacion;
	_id_tipo_llamado = id_tipo_llamado;
	// limpiar los xml que contienen establecimientos y cargos ***************************
	_xmlEstablecimientos = <establecimientos></establecimientos>;
	_xmlEstablecimientos.appendChild(this.parentDocument.xmlDatosDocente.establecimiento);
	_xmlCargosSimple = <cargossimp></cargossimp>;							
	_xmlDatosDocente = <datosdocente></datosdocente>;
	_xmlCargosCompleta = <cargoscomp></cargoscomp>;
	_xmlCargosC = <cargosc></cargosc>;		
	_xmlCargosA = <cargosa></cargosa>;	
	_xmlCargosE = <cargose></cargose>;		
	_xmlCargosP = <cargosp></cargosp>;
	// ***********************************************************************************
	
	// Anexar los datos correspondientes al docente_llamado ******************************
	_xmlDatosDocente.appendChild(this.parentDocument.xmlDatosDocente.docente);
	// ***********************************************************************************
	
	// limpiar cajas de texto *******************************
	txiTipoDoc.text = _xmlDatosDocente.docente.@tipo_doc;
	txiNroDoc.text = _xmlDatosDocente.docente.@nro_doc;
	txiApenom.text = _xmlDatosDocente.docente.@apellido
	txiNombre.text = _xmlDatosDocente.docente.@nombres;
	txiDomicilio.text = _xmlDatosDocente.docente.@domicilio;
	txiLocalidad.text = _xmlDatosDocente.docente.@localidad;
	txiC1A.text = '';
	txiC1B.text = '';
	txiC4A.text = '';
	txiC4B.text = '';
	txiC4C.text = '';
	txiC4D.text = '';
	txiC2A.text = '';
	txiC2B.text = '';
	txiC2C.text = '';
	txiC2D.text = '';
	txiC3A.text = '';
	txiC3B.text = '';
	txiC6.text = '';
	txiC7.text = '';
	txiC5i.text = '';
	txiC5p.text = '';
	txiC5se.text = '';
	txiC5su.text = '';
	// *****************************************************
	
	// limpiar el xml que contiene las instancias que corresponden al tipo de 
	// clasificación del llamado, y luego anexar dichas instancias ************
	_xmlInstancias = <instancias></instancias>;	
	_xmlInstancias.appendChild(this.parentDocument.xmlDatosDocente.instancias);
	// ************************************************************************
	
	// recuperar los valores de las unidades del docente_llamado (en caso de un alta, 
	// el valor es vacío) ****************************************************************
	var i:int;
	for (i = 0;i < this.parentDocument.xmlDatosDocente.antecedente.length();i++) {
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C1A') {
			txiC1A.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C1B') {
			txiC1B.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C4D') {
			txiC4A.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C4C') {
			txiC4B.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C4B') {
			txiC4C.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C4A') {
			txiC4D.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C2A') {
			txiC2A.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C2B') {
			txiC2B.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C2C') {
			txiC2C.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C2D') {
			txiC2D.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C3A') {
			txiC3A.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C3B') {
			txiC3B.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C6') {
			txiC6.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'C7') {
			txiC7.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@id_antecedente == '32') {
			txiC5i.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@id_antecedente == '108') {
			txiC5p.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@id_antecedente == '109') {
			txiC5se.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@id_antecedente == '110') {
			txiC5su.text = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades
		}
	}
	// ***********************************************************************************
}

/**
 * Función que se llama en caso de una baja de inscripción
 */
private function bajaIniPrim():void
{
	// Setear el estado correspondiente
	this.currentState = 'iniprimbaja';
	var i:int = 0;
	txiNroRegion.text = '';
	// remover los observadores de eventos
	rbCompNo.removeEventListener("click" ,fncCompletaNo);
	rbCompSi.removeEventListener("click" ,fncCompletaSi);
	rbSimpComp.removeEventListener("click" ,fncSimpComp);
	rbDirPsic.removeEventListener("click" ,fncDirPsicSi);
	if (this.parentDocument.xmlDatosDocente.docentellamado.@id_region != '0' && this.parentDocument.xmlDatosDocente.docentellamado.@id_region != '') {
		txiNroRegion.text = this.parentDocument.xmlDatosDocente.docentellamado.@id_region;				
	}											
	if ((_id_tipo_clasificacion == '1' && _idNivel == '2') || _id_tipo_clasificacion == '2' || _id_tipo_clasificacion == '5') {
		for (i = 0;i < this.parentDocument.xmlDatosDocente.instancias.length();i++) {
			if (this.parentDocument.xmlDatosDocente.instancias[i].@orden == this.parentDocument.xmlDatosDocente.docentellamado.@orden) {
				cmbInstancias.selectedIndex = i;
				break;	
			}
		}
	}
	
	initCargos();
	initTipoJornada();
}

private function altamodIniPrim():void
{
	this.currentState = "iniprim";
	rbCompNo.addEventListener("click" ,fncCompletaNo);
	rbCompSi.addEventListener("click" ,fncCompletaSi);
	rbSimpComp.addEventListener("click" ,fncSimpComp);
	rbDirPsic.addEventListener("click" ,fncDirPsicSi);
	if (parentDocument.accion == 'A') {
		rbCompNo.selected = true;
		btnAgregarSimple.enabled = true;
		gridPsico0.visible = false;
		btnAgregarP0.visible = false;					
		if ((_id_tipo_clasificacion == '1' && _idNivel == '2') || _id_tipo_clasificacion == '2' || _id_tipo_clasificacion == '5') {							
			cmbInstancias.enabled = true;							
		} else {
			cmbInstancias.selectedIndex = 0;
			cmbInstancias.enabled = false;							
		}
	}
	btnAgregarSimple.addEventListener("click" ,fncAgregarCargoSimple);
	btnAgregarCompleta.addEventListener("click" ,fncAgregarCargoCompleta);
	txiNroRegion.text = '';				
	cmbInstancias.selectedIndex = 0;	
}

private function initTipoJornada():void
{		
	switch(this.parentDocument.xmlDatosDocente.docentellamado.@tipo_jornada.toString()) {
		case 'SS': {
			rbCompNo.selected = true;
			if (_xmlCargosSimple.cargo.length() < 3) btnAgregarSimple.enabled = true;
			gridPsico0.visible = false;
			btnAgregarP0.visible = false;
			break;
		}
		case 'CC': {
			rbCompSi.selected = true;				
			if (_xmlCargosCompleta.cargo.length() < 3) btnAgregarCompleta.enabled = true;
			gridPsico0.visible = false;
			btnAgregarP0.visible = false;
			break;
		}
		case 'SC': {
			rbSimpComp.selected = true;
			if (_xmlCargosSimple.cargo.length() < 3) btnAgregarSimple.enabled = true;
			if (_xmlCargosCompleta.cargo.length() < 3) btnAgregarCompleta.enabled = true;
			gridPsico0.visible = false;
			btnAgregarP0.visible = false;
			break;
		}
		case 'DP': {
			rbDirPsic.selected = true;
			if (_xmlCargosCompleta.cargo.length() > 0 && _xmlCargosCompleta.cargo.length() < 3) {
				gridPsico0.visible = false;
				btnAgregarP0.visible = false;				
				btnAgregarCompleta.enabled = true;
			} else if (_xmlCargosCompleta.cargo.length() == 3) {
				gridPsico0.visible = false;
				btnAgregarP0.visible = false;				
			} else if (_xmlCargosP.cargo.length() > 0 && _xmlCargosP.cargo.length() < 2) {				
				gridPsico0.visible = true;
				btnAgregarP0.visible = true;
				btnAgregarP0.enabled = true;
				btnAgregarP0.addEventListener("click" ,fncAgregarCargoP0);
			} else if (_xmlCargosP.cargo.length() == 2) {				
				gridPsico0.visible = true;
				btnAgregarP0.visible = true;
				btnAgregarP0.enabled = false;
			} else if (this.parentDocument.xmlDatosDocente.docentellamado.@id_region == '') {
				gridPsico0.visible = false;
				btnAgregarP0.visible = false;				
			}
			break;
		}
	}
}

private function initCargos():void
{
	var i:int = 0;
	for (i = 0;i < this.parentDocument.xmlDatosDocente.cargo.length();i++) {			
		var _xmlCargo : XML = <cargo id_cargo="0" codigo="0" denominacion="" />;
		_xmlCargo.@id_cargo = this.parentDocument.xmlDatosDocente.cargo[i].@id_cargo;
		_xmlCargo.@codigo = this.parentDocument.xmlDatosDocente.cargo[i].@codigo;
		if (this.parentDocument.xmlDatosDocente.cargo[i].@id_nivel == '1' || this.parentDocument.xmlDatosDocente.cargo[i].@id_nivel == '2') {
			if (this.parentDocument.xmlDatosDocente.cargo[i].@jornada_completa == '0' && this.parentDocument.xmlDatosDocente.cargo[i].@subtipo != 'P') {
				_xmlCargosSimple.appendChild(_xmlCargo);
				if (_xmlCargosSimple.cargo.length() == 3)
					btnAgregarSimple.enabled = false;
			} else if (this.parentDocument.xmlDatosDocente.cargo[i].@subtipo != 'P') {					
				_xmlCargosCompleta.appendChild(_xmlCargo);
				if (_xmlCargosCompleta.cargo.length() == 3)
					btnAgregarCompleta.enabled = false;
			} else if (this.parentDocument.xmlDatosDocente.cargo[i].@subtipo == 'P') {
				_xmlCargosP.appendChild(_xmlCargo);					
			}
		}
		if (this.parentDocument.xmlDatosDocente.cargo[i].@id_nivel == '5') {
			if (this.parentDocument.xmlDatosDocente.cargo[i].@subtipo == 'C') {
				_xmlCargosC.appendChild(_xmlCargo);
				if (_xmlCargosC.cargo.length() == 2)
					btnAgregarC.enabled = false;
			}
			if (this.parentDocument.xmlDatosDocente.cargo[i].@subtipo == 'A') {
				_xmlCargosA.appendChild(_xmlCargo);
				if (_xmlCargosA.cargo.length() == 2)
					btnAgregarA.enabled = false; 
			}
			if (this.parentDocument.xmlDatosDocente.cargo[i].@subtipo == 'E') {
				_xmlCargosE.appendChild(_xmlCargo);
				if (_xmlCargosE.cargo.length() == 2)
					btnAgregarE.enabled = false;
			}
		}
		if (this.parentDocument.xmlDatosDocente.cargo[i].@id_nivel == '6') {
			_xmlCargosP.appendChild(_xmlCargo);
			if (_xmlCargosP.cargo.length() == 2)
				btnAgregarP.enabled = false;
		}
	}
}

private function modIniPrim():void
{
	var i:int = 0;				
	
	if (this.parentDocument.xmlDatosDocente.docentellamado.@id_region != '0' && this.parentDocument.xmlDatosDocente.docentellamado.@id_region != '') {
		txiNroRegion.text = this.parentDocument.xmlDatosDocente.docentellamado.@id_region;				
	}					
	if ((_id_tipo_clasificacion == '1' && _idNivel == '2') || _id_tipo_clasificacion == '2' || _id_tipo_clasificacion == '5') {							
		cmbInstancias.enabled = true;
		if ((_id_tipo_clasificacion == '1' && _idNivel == '2')) {
			var orden:String;
			for (i = 0;i < this.parentDocument.xmlDatosDocente.instancias.length();i++) {
				if (this.parentDocument.xmlDatosDocente.docentellamado.@con_cargo == '1')
					orden = '1';
				else
					orden = '2';
				if (this.parentDocument.xmlDatosDocente.instancias[i].@orden == orden) {
					cmbInstancias.selectedIndex = i;
					break;
				}
			}
		} else {
			for (i = 0;i < this.parentDocument.xmlDatosDocente.instancias.length();i++) {
				if (this.parentDocument.xmlDatosDocente.instancias[i].@orden == this.parentDocument.xmlDatosDocente.docentellamado.@orden) {
					cmbInstancias.selectedIndex = i;
					break;
				}
			}	
		}		
	} else {
		cmbInstancias.selectedIndex = 0;
		cmbInstancias.enabled = false;							
	}
	
	initCargos();
	initTipoJornada();		
}

private function iniprim():void
{
	var i:int = 0;
	switch (parentDocument.accion) {
		case 'A': {
			altamodIniPrim();
			break;
		}
		case 'B': {
			bajaIniPrim();				
			break;
		}
		case 'M': {
			altamodIniPrim();
			modIniPrim();
			break;
		}
	}		
}

private function secsup():void
{
	var i:int = 0;
	if (parentDocument.accion == 'B') {
		this.currentState = 'secsupbaja';
		if (_id_tipo_clasificacion == '2' || _id_tipo_clasificacion == '5') {
			for (i = 0;i < this.parentDocument.xmlDatosDocente.instancias.length();i++) {
				if (this.parentDocument.xmlDatosDocente.instancias[i].@orden == this.parentDocument.xmlDatosDocente.docentellamado.@orden) {
					cmbInstancias.selectedIndex = i;
					break;	
				}
			}
		}			
	} else {
		this.currentState = "secsup";
		if (parentDocument.accion == 'M') {
			if (_id_tipo_clasificacion == '2' || _id_tipo_clasificacion == '5') {
				for (i = 0;i < this.parentDocument.xmlDatosDocente.instancias.length();i++) {
					if (this.parentDocument.xmlDatosDocente.instancias[i].@orden == this.parentDocument.xmlDatosDocente.docentellamado.@orden) {
						cmbInstancias.selectedIndex = i;
						break;	
					}
				}
			} else {
				cmbInstancias.selectedIndex = 0;
				cmbInstancias.enabled = false;
			}				
		} else {
			if (_id_tipo_clasificacion == '2' || _id_tipo_clasificacion == '5') {							
				cmbInstancias.enabled = true;							
			} else {
				cmbInstancias.selectedIndex = 0;
				cmbInstancias.enabled = false;							
			}
		}
	}					
	
	if (_idNivel == '3') {
		formiteminic.visible = false;
		formitemprim.visible = false;
		// Para secundario, se selecciona automáticamente la opción a cargos
		rbEmbSi.selected = true;
		rbEmbSi.enabled = false;
		rbEmbNo.enabled = false;
		// Para secundario, se selecciona automáticamente la opción a ruralidad
		chkRuralidad.selected = true;
		chkRuralidad.enabled = false;				
	} else {
		formiteminic.visible = true;
		formitemprim.visible = true;
		chkAplicInicial.selected = false;
		chkAplicPrimario.selected = false;
		if (this.parentDocument.xmlDatosDocente.docentellamado.@depto_inicial == '1')
			chkAplicInicial.selected = true;
		if (this.parentDocument.xmlDatosDocente.docentellamado.@depto_primario == '1')
			chkAplicPrimario.selected = true;
		chkAplicPrimario.setFocus();
		rbEmbSi.selected = false;
		rbEmbNo.selected = false;
		if (this.parentDocument.xmlDatosDocente.docentellamado.@selecciona_cargo == '1')
			rbEmbSi.selected = true;
		chkRuralidad.selected = false;
		if (this.parentDocument.xmlDatosDocente.docentellamado.@ruralidad == '1')
			chkRuralidad.selected = true;
	}
	btnNuevoEstablecimiento.enabled = true;			
	btnNuevoEstablecimiento.addEventListener("click" ,fncAgregarEstablecimiento);
	if (_xmlEstablecimientos.establecimiento.length() == 10)
		btnNuevoEstablecimiento.enabled = false;
}

private function especadult():void
{
	if (parentDocument.accion == 'B') {
		this.currentState = 'especadultbaja';
		var i:int;
		if (_id_tipo_clasificacion == '2' || _id_tipo_clasificacion == '5') {								
			for (i = 0;i < this.parentDocument.xmlDatosDocente.instancias.length();i++) {
				if (this.parentDocument.xmlDatosDocente.instancias[i].@orden == this.parentDocument.xmlDatosDocente.docentellamado.@orden) {
					cmbInstancias.selectedIndex = i;
					break;	
				}
			}
		} else {
			cmbInstancias.selectedIndex = 0;
			cmbInstancias.enabled = false;							
		}
	}
	else{
		this.currentState = "especadult";
		if (parentDocument.accion == 'A') {									
			if (_id_tipo_clasificacion == '1' || _id_tipo_clasificacion == '2' || _id_tipo_clasificacion == '5') {							
				cmbInstancias.enabled = true;							
			} else {
				cmbInstancias.selectedIndex = 0;
				cmbInstancias.enabled = false;							
			}
		} else {
			if (_id_tipo_clasificacion == '1' || _id_tipo_clasificacion == '2' || _id_tipo_clasificacion == '5') {
				if (_id_tipo_clasificacion == '1') {
					var orden:String;
					for (i = 0;i < this.parentDocument.xmlDatosDocente.instancias.length();i++) {
						if (this.parentDocument.xmlDatosDocente.docentellamado.@con_cargo == '1')
							orden = '1';
						else
							orden = '2';
						if (this.parentDocument.xmlDatosDocente.instancias[i].@orden == orden) {
							cmbInstancias.selectedIndex = i;
							break;
						}
					}
				} else {
					cmbInstancias.enabled = true;				
					for (i = 0;i < this.parentDocument.xmlDatosDocente.instancias.length();i++) {
						if (this.parentDocument.xmlDatosDocente.instancias[i].@orden == this.parentDocument.xmlDatosDocente.docentellamado.@orden) {
							cmbInstancias.selectedIndex = i;
							break;	
						}
					}	
				}			
			} else {
				cmbInstancias.selectedIndex = 0;
				cmbInstancias.enabled = false;							
			}
		}
		btnAgregarC.enabled = true;
		btnAgregarA.enabled = true;
		btnAgregarE.enabled = true;
		btnAgregarC.addEventListener("click" ,fncAgregarCargoC);
		btnAgregarA.addEventListener("click" ,fncAgregarCargoA);
		btnAgregarE.addEventListener("click" ,fncAgregarCargoE);
	}
	
	initCargos();
}

private function dirpsic():void
{
	if (parentDocument.accion == 'B') 
		{this.currentState = 'dirpsicbaja';}
	else{
		this.currentState = "dirpsic";
		btnAgregarP.enabled = true;
		btnAgregarP.addEventListener("click" ,fncAgregarCargoP);	
	}
	
	initCargos();
}

/**
 * @param idNivel: nivel del usuario que está realizando las inscripción (inicial, primario, secundario, superior)
 * @param id_tipo_clasificacion: tipo de clasificación a la que corresponde el llamado
 * @id_tipo_llamado: tipo de llamado al que corresponde la inscripción
 */
public function fncInit(idNivel:String,id_tipo_clasificacion:String,id_tipo_llamado:String):void
{	
	initValues(idNivel,id_tipo_clasificacion, id_tipo_llamado);
	// Niveles inicial y primario se tratan de la misma forma			
	if (_idNivel == '1' || _idNivel == '2') {			
		iniprim();	
	}
	// Niveles secundario y superior se tratan de la misma forma
	if (_idNivel == '3' || _idNivel == '4') {			
		secsup();			
	}
	// Nivel especiales y adultos, tratamiento propio
	if (_idNivel == '5') {
		especadult();			
	}
	// Nivel dirección de psicología, tratamiento propio
	if (_idNivel == '6') {
		dirpsic();
	}						
}

private function fncCompletaNo(e:Event):void
{
	_xmlCargosCompleta = <cargoscomp></cargoscomp>;
	_xmlCargosP = <cargosp></cargosp>;
	if (_xmlCargosSimple.cargo.length() < 3)
		btnAgregarSimple.enabled = true;
	gridPsico0.visible = false;
	btnAgregarP0.visible = false;
}

private function fncCompletaSi(e:Event):void
{
	_xmlCargosSimple = <cargossimp></cargossimp>;
	_xmlCargosP = <cargosp></cargosp>;
	if (_xmlCargosCompleta.cargo.length() < 3)
		btnAgregarCompleta.enabled = true;
	gridPsico0.visible = false;
	btnAgregarP0.visible = false;
}

private function fncSimpComp(e:Event):void
{		
	_xmlCargosP = <cargosp></cargosp>;
	if (_xmlCargosSimple.cargo.length() < 3)
		btnAgregarSimple.enabled = true;
	if (_xmlCargosCompleta.cargo.length() < 3)
		btnAgregarCompleta.enabled = true;
	gridPsico0.visible = false;
	btnAgregarP0.visible = false;
}

private function fncDirPsicSi(e:Event):void
{
	_xmlCargosSimple = <cargossimp></cargossimp>;
	_xmlCargosCompleta = <cargoscomp></cargoscomp>;
	gridPsico0.visible = true;
	btnAgregarP0.visible = true;
	if (_xmlCargosP.cargo.length() < 2)
		btnAgregarP0.enabled = true;
	btnAgregarP0.addEventListener("click" ,fncAgregarCargoP0);
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
	
private function fncAgregarEstablecimiento(e:Event):void
{
	_twNuevosEstablecimientos = new nuevo_establecimiento;
	_twNuevosEstablecimientos.idNivel = _idNivel;
	_twNuevosEstablecimientos.addEventListener("EventConfirmarAntecedente",fncGrabarNuevoEstablecimiento);
	PopUpManager.addPopUp(_twNuevosEstablecimientos,this,true);
	PopUpManager.centerPopUp(_twNuevosEstablecimientos);
}

private function fncAgregarCargoSimple(e:Event):void
{
	_twNuevosCargos = new nuevo_cargo;
	_twNuevosCargos.jornada = "0";
	_twNuevosCargos.idNivel = _idNivel;
	_twNuevosCargos.addEventListener("EventConfirmarCargo",fncGrabarNuevoCargoSimple);
	PopUpManager.addPopUp(_twNuevosCargos,this,true);
	PopUpManager.centerPopUp(_twNuevosCargos);
}

private function fncAgregarCargoC(e:Event):void
{
	_twNuevosCargos = new nuevo_cargo;
	_twNuevosCargos.jornada = "0";
	_twNuevosCargos.subtipo = "C";
	_twNuevosCargos.idNivel = _idNivel;
	_twNuevosCargos.addEventListener("EventConfirmarCargo",fncGrabarNuevoCargoC);
	PopUpManager.addPopUp(_twNuevosCargos,this,true);
	PopUpManager.centerPopUp(_twNuevosCargos);
}

private function fncAgregarCargoA(e:Event):void
{
	_twNuevosCargos = new nuevo_cargo;
	_twNuevosCargos.jornada = "0";
	_twNuevosCargos.subtipo = "A";
	_twNuevosCargos.idNivel = _idNivel;
	_twNuevosCargos.addEventListener("EventConfirmarCargo",fncGrabarNuevoCargoA);
	PopUpManager.addPopUp(_twNuevosCargos,this,true);
	PopUpManager.centerPopUp(_twNuevosCargos);
}

private function fncAgregarCargoE(e:Event):void
{
	_twNuevosCargos = new nuevo_cargo;
	_twNuevosCargos.jornada = "0";
	_twNuevosCargos.subtipo = "E";
	_twNuevosCargos.idNivel = _idNivel;
	_twNuevosCargos.addEventListener("EventConfirmarCargo",fncGrabarNuevoCargoE);
	PopUpManager.addPopUp(_twNuevosCargos,this,true);
	PopUpManager.centerPopUp(_twNuevosCargos);
}

private function fncAgregarCargoP(e:Event):void
{
	_twNuevosCargos = new nuevo_cargo;
	_twNuevosCargos.jornada = "0";
	_twNuevosCargos.idNivel = _idNivel;
	_twNuevosCargos.addEventListener("EventConfirmarCargo",fncGrabarNuevoCargoP);
	PopUpManager.addPopUp(_twNuevosCargos,this,true);
	PopUpManager.centerPopUp(_twNuevosCargos);
}

private function fncAgregarCargoP0(e:Event):void
{
	_twNuevosCargos = new nuevo_cargo;
	_twNuevosCargos.jornada = "0";
	_twNuevosCargos.subtipo = "P";
	_twNuevosCargos.idNivel = _idNivel;
	_twNuevosCargos.addEventListener("EventConfirmarCargo",fncGrabarNuevoCargoP0);
	PopUpManager.addPopUp(_twNuevosCargos,this,true);
	PopUpManager.centerPopUp(_twNuevosCargos);
}

private function fncAgregarCargoCompleta(e:Event):void
{
	_twNuevosCargos = new nuevo_cargo;
	_twNuevosCargos.jornada = "1";
	_twNuevosCargos.idNivel = _idNivel;
	_twNuevosCargos.addEventListener("EventConfirmarCargo",fncGrabarNuevoCargoCompleta);
	PopUpManager.addPopUp(_twNuevosCargos,this,true);
	PopUpManager.centerPopUp(_twNuevosCargos);
}

private function fncGrabarNuevoEstablecimiento(e:Event):void
{
	var xmlEstablecimiento : XML = _twNuevosEstablecimientos.xmlEstablecimiento;
	var existente : Boolean = false;
	for (var i:int = 0;i < _xmlEstablecimientos.establecimiento.length();i++) {
		if (xmlEstablecimiento.@codigo == _xmlEstablecimientos.establecimiento[i].@codigo) {
			existente = true;
		}
	}
	if (existente == true) {
		Alert.show("El Establecimiento " + xmlEstablecimiento.@nombre + " ya ha sido seleccionado","E R R O R");
	} else {
		_xmlEstablecimientos.appendChild(xmlEstablecimiento);
		if (_xmlEstablecimientos.establecimiento.length() == 10)
			btnNuevoEstablecimiento.enabled = false;
		PopUpManager.removePopUp(e.target as nuevo_establecimiento);	
	}		
}

private function fncGrabarNuevoCargoSimple(e:Event):void
{
	var xmlCargoSimple : XML = _twNuevosCargos.xmlCargo;						 
	_xmlCargosSimple.appendChild(xmlCargoSimple);		
	if (_xmlCargosSimple.cargo.length() == 3)
		btnAgregarSimple.enabled = false;
	PopUpManager.removePopUp(e.target as nuevo_cargo);
}

private function fncGrabarNuevoCargoC(e:Event):void
{
	var xmlCargoC : XML = _twNuevosCargos.xmlCargo;						 
	_xmlCargosC.appendChild(xmlCargoC);		
	if (_xmlCargosC.cargo.length() == 2)
		btnAgregarC.enabled = false;
	PopUpManager.removePopUp(e.target as nuevo_cargo);
}

private function fncGrabarNuevoCargoA(e:Event):void
{
	var xmlCargoA : XML = _twNuevosCargos.xmlCargo;						 
	_xmlCargosA.appendChild(xmlCargoA);		
	if (_xmlCargosA.cargo.length() == 2)
		btnAgregarA.enabled = false;
	PopUpManager.removePopUp(e.target as nuevo_cargo);
}

private function fncGrabarNuevoCargoE(e:Event):void
{
	var xmlCargoE : XML = _twNuevosCargos.xmlCargo;						 
	_xmlCargosE.appendChild(xmlCargoE);		
	if (_xmlCargosE.cargo.length() == 2)
		btnAgregarE.enabled = false;
	PopUpManager.removePopUp(e.target as nuevo_cargo);
}

private function fncGrabarNuevoCargoP(e:Event):void
{
	var xmlCargoP : XML = _twNuevosCargos.xmlCargo;						 
	_xmlCargosP.appendChild(xmlCargoP);		
	if (_xmlCargosP.cargo.length() == 2)
		btnAgregarP.enabled = false;
	PopUpManager.removePopUp(e.target as nuevo_cargo);
}

private function fncGrabarNuevoCargoP0(e:Event):void
{
	var xmlCargoP : XML = _twNuevosCargos.xmlCargo;						 
	_xmlCargosP.appendChild(xmlCargoP);		
	if (_xmlCargosP.cargo.length() == 2)
		btnAgregarP0.enabled = false;
	PopUpManager.removePopUp(e.target as nuevo_cargo);
}

private function fncGrabarNuevoCargoCompleta(e:Event):void
{
	var xmlCargoCompleta : XML = _twNuevosCargos.xmlCargo;						 
	_xmlCargosCompleta.appendChild(xmlCargoCompleta);
	if (_xmlCargosCompleta.cargo.length() == 3)
		btnAgregarCompleta.enabled = false;
	PopUpManager.removePopUp(e.target as nuevo_cargo);
}

public function fncEliminarEstablecimiento():void
{
	Alert.show("¿Realmente desea Eliminar el Establecimiento "+ gridEstablecimientos.selectedItem.@nombre+"?", "Confirmar", Alert.OK | Alert.CANCEL, this, fncConfirmEliminarEstablecimiento, null, Alert.OK);
}

public function fncEliminarCargoSimple():void
{
	var xmlCargoSimple : XML = _xmlCargosSimple.cargo[(gridCargosSimple.selectedItem as XML).childIndex()];					
	delete _xmlCargosSimple.cargo[(gridCargosSimple.selectedItem as XML).childIndex()];
	if (_xmlCargosSimple.cargo.length() < 3)
			btnAgregarSimple.enabled = true;		
}

public function fncEliminarCargoCompleta():void
{
	var xmlCargoCompleta : XML = _xmlCargosCompleta.cargo[(gridCargosCompleta.selectedItem as XML).childIndex()];					
	delete _xmlCargosCompleta.cargo[(gridCargosCompleta.selectedItem as XML).childIndex()];
	if (_xmlCargosCompleta.cargo.length() < 3)
			btnAgregarCompleta.enabled = true;		
}

public function fncEliminarCargoC():void
{
	var xmlCargoC : XML = _xmlCargosC.cargo[(gridCargosC.selectedItem as XML).childIndex()];					
	delete _xmlCargosC.cargo[(gridCargosC.selectedItem as XML).childIndex()];
	if (_xmlCargosC.cargo.length() < 2)
			btnAgregarC.enabled = true;		
}

public function fncEliminarCargoA():void
{
	var xmlCargoA : XML = _xmlCargosA.cargo[(gridCargosA.selectedItem as XML).childIndex()];					
	delete _xmlCargosA.cargo[(gridCargosA.selectedItem as XML).childIndex()];
	if (_xmlCargosA.cargo.length() < 2)
			btnAgregarA.enabled = true;		
}

public function fncEliminarCargoE():void
{
	var xmlCargoE : XML = _xmlCargosE.cargo[(gridCargosE.selectedItem as XML).childIndex()];					
	delete _xmlCargosE.cargo[(gridCargosE.selectedItem as XML).childIndex()];
	if (_xmlCargosE.cargo.length() < 2)
			btnAgregarE.enabled = true;		
}

public function fncEliminarCargoP():void
{
	var xmlCargoP : XML = _xmlCargosP.cargo[(gridPsico.selectedItem as XML).childIndex()];					
	delete _xmlCargosP.cargo[(gridPsico.selectedItem as XML).childIndex()];
	if (_xmlCargosP.cargo.length() < 2)
			btnAgregarP.enabled = true;		
}

public function fncEliminarCargoP0():void
{
	var xmlCargoP : XML = _xmlCargosP.cargo[(gridPsico0.selectedItem as XML).childIndex()];					
	delete _xmlCargosP.cargo[(gridPsico0.selectedItem as XML).childIndex()];
	if (_xmlCargosP.cargo.length() < 2)
			btnAgregarP0.enabled = true;		
}

private function fncConfirmEliminarEstablecimiento(e:CloseEvent):void
{
	var xmlEstablecimiento : XML = _xmlEstablecimientos.establecimiento[(gridEstablecimientos.selectedItem as XML).childIndex()];
	if (e.detail==Alert.OK) {			
		delete _xmlEstablecimientos.establecimiento[(gridEstablecimientos.selectedItem as XML).childIndex()];
		if (_xmlEstablecimientos.establecimiento.length() < 10)
			btnNuevoEstablecimiento.enabled = true;		
	}
}