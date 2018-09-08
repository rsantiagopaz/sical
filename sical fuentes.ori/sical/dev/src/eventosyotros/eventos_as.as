import mx.managers.PopUpManager;

[Bindable] private var _xmlCobertura:XML = <coberturas></coberturas>;
private var _xmlDatosPaciente:XML = <datospaciente></datospaciente>;	

[Bindable] private var _xmlParticipacion:XML = 
<participacion>
	<curso codigo="K.1.a" curso="Provincial" valoracion="0.15" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="K.1.b" curso="Regional" valoracion="0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="K.1.c" curso="Nacional" valoracion="0.35" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="K.1.d" curso="Internacional" valoracion="0.45" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />				
</participacion>;

[Bindable] private var _xmlDesempenio:XML = 
<desempenio>
	<curso codigo="K.5.1" curso="Jefe Depto/Tutoría" valoracion="0.15" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="K.5.2" curso="Equipo de Conducción" valoracion="0.10" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />						
</desempenio>;

[Bindable] private var _xmlCertificadoLenguasNativas:XML = 
<lenguasnat>
	<curso codigo="K.6.A" curso="Est. Compl. Lengua Reg Quichua" valoracion="0.50" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="K.6.B" curso="Est. Compl. Otras Lenguas" valoracion="0.30" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />						
</lenguasnat>;		

[Bindable] private var _xmlDesempenioEnt:XML = 
<desempenioent>
	<curso codigo="I.1" curso="Vocal/Director" valoracion="1.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="I.2" curso="Miemb. Tit Asoc. Prof y otras" valoracion="1.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />						
</desempenioent>;

[Bindable] private var _xmlCertificadoLenguasExtranjeras:XML = 
<lenguasext>
	<curso codigo="K.7.3" curso="Aprobación Examen Internac" valoracion="0.40" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="K.8" curso="Título Entrenador" valoracion="0.10" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="K.9" curso="Cert. Proyecto Invest Educ" valoracion="0.50" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
</lenguasext>;

[Bindable] private var _xmlDeducciones:XML = 
<deducciones>
	<curso codigo="L.1.a" curso="Apercibimiento" valoracion="0.20" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="L.1.b" curso="Suspensión" valoracion="0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="L.1.c" curso="Traslado" valoracion="5.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="L.1.d" curso="Disminución Jerárquica" valoracion="10.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="L.1.e" curso="Por disminución de jerarquía escal" valoracion="15.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="L.1.f" curso="Por cesantía (reduce a 0 los antecedentes)" valoracion="" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
</deducciones>;

[Bindable] private var _xmlMiembroJurado:XML = 
<jurado>
	<curso codigo="H" curso="Miem. Jurado" valoracion="0.50" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />		
</jurado>;

public function get xmlParticipacion():XML {return _xmlParticipacion.copy();}
public function get xmlDesempenio():XML {return _xmlDesempenio.copy();}
public function get xmlCertificadoLenguasNativas():XML {return _xmlCertificadoLenguasNativas.copy();}
public function get xmlDesempenioEnt():XML {return _xmlDesempenioEnt.copy();}
public function get xmlCertificadoLenguasExtranjeras():XML {return _xmlCertificadoLenguasExtranjeras.copy();}
public function get xmlDeducciones():XML {return _xmlDeducciones.copy();}
public function get xmlMiembroJurado():XML {return _xmlMiembroJurado.copy();}

//inicializa las variales necesarias para el modulo
public function fncInit():void
{
	if (parentDocument.accion == 'B') 
		{this.currentState = 'baja';}
	else{this.currentState = ''; }
		
	var k1a:String = '';
	var k1b:String = '';
	var k1c:String = '';
	var k1d:String = '';
	var k51:String = '';
	var k52:String = '';
	var k6a:String = '';
	var k6b:String = '';
	var i1:String = '';
	var i2:String = '';
	var k73:String = '';
	var k8:String = '';
	var k9:String = '';
	var l1a:String = '';
	var l1b:String = '';
	var l1c:String = '';
	var l1d:String = '';
	var l1e:String = '';
	var l1f:String = '';
	var h:String = '';
	var k1aAc:String = '';
	var k1bAc:String = '';
	var k1cAc:String = '';
	var k1dAc:String = '';
	var k51Ac:String = '';
	var k52Ac:String = '';
	var k6aAc:String = '';
	var k6bAc:String = '';
	var i1Ac:String = '';
	var i2Ac:String = '';
	var k73Ac:String = '';
	var k8Ac:String = '';
	var k9Ac:String = '';
	var l1aAc:String = '';
	var l1bAc:String = '';
	var l1cAc:String = '';
	var l1dAc:String = '';
	var l1eAc:String = '';
	var l1fAc:String = '';
	var hAc:String = '';
	var i:int;
	// Si ya tiene antecedentes (modificación o baja de ficha) no interesan acumulados
	// de la inscripción anterior
	if (this.parentDocument.xmlDatosDocente.antecedente.length() == 0) {
		for (i = 0;i < this.parentDocument.xmlDatosDocente.acum_antecedente.length();i++) {
			if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K1A') {
				k1aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K1B') {
				k1bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K1C') {
				k1cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K1D') {
				k1dAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K51') {
				k51Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K52') {
				k52Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K6A') {
				k6aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K6B') {
				k6bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'I1') {
				i1Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'I2') {
				i2Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K73') {
				k73Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K8') {
				k8Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K9') {
				k9Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'L1A') {
				l1aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'L1B') {
				l1bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'L1C') {
				l1cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'L1D') {
				l1dAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'L1E') {
				l1eAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'L1F') {
				l1fAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'H') {
				hAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
		}	
	}		
	for (i = 0;i < this.parentDocument.xmlDatosDocente.antecedente.length();i++) {
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K1A') {
			k1a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k1aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K1B') {
			k1b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k1bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K1C') {
			k1c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k1cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K1D') {
			k1d = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k1dAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K51') {
			k51 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k51Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K52') {
			k52 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k52Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K6A') {
			k6a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k6aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K6B') {
			k6b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k6bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'I1') {
			i1 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			i1Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'I2') {
			i2 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			i2Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K73') {
			k73 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k73Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K8') {
			k8 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k8Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K9') {
			k9 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k9Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'L1A') {
			l1a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			l1aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'L1B') {
			l1b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			l1bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'L1C') {
			l1c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			l1cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'L1D') {
			l1d = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			l1dAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'L1E') {
			l1e = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			l1eAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'L1F') {
			l1f = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			l1fAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'H') {
			h = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			hAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
	}
	_xmlParticipacion = 
	<participacion>
		<curso codigo="K.1.a" curso="Provincial" valoracion="0.15" cantidad={k1a} acum={k1aAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="K.1.b" curso="Regional" valoracion="0.25" cantidad={k1b} acum={k1bAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="K.1.c" curso="Nacional" valoracion="0.35" cantidad={k1c} acum={k1cAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="K.1.d" curso="Internacional" valoracion="0.45" cantidad={k1d} acum={k1dAc} puntos="" tope="" desc="" tipo_tope="" />				
	</participacion>;
	
	_xmlDesempenio = 
	<desempenio>
		<curso codigo="K.5.1" curso="Jefe Depto/Tutoría" valoracion="0.10" cantidad={k51} acum={k51Ac} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="K.5.2" curso="Equipo de Conducción" valoracion="0.15" cantidad={k52} acum={k52Ac} puntos="" tope="" desc="" tipo_tope="" />						
	</desempenio>;
	
	_xmlCertificadoLenguasNativas = 
	<lenguasnat>
		<curso codigo="K.6.A" curso="Est. Compl. Lengua Reg Quichua" valoracion="0.50" cantidad={k6a} acum={k6aAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="K.6.B" curso="Est. Compl. Otras Lenguas" valoracion="0.30" cantidad={k6b} acum={k6bAc} puntos="" tope="" desc="" tipo_tope="" />						
	</lenguasnat>;
	
	_xmlDesempenioEnt = 
	<desempenioent>
		<curso codigo="I.1" curso="Vocal/Director" valoracion="1.00" cantidad={i1} acum={i1Ac} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="I.2" curso="Miemb. Tit Asoc. Prof y otras" valoracion="1.00" cantidad={i2} acum={i2Ac} puntos="" tope="" desc="" tipo_tope="" />						
	</desempenioent>;
	
	_xmlCertificadoLenguasExtranjeras = 
	<lenguasext>
		<curso codigo="K.7.3" curso="Aprobación Examen Internac" valoracion="0.40" cantidad={k73} acum={k73Ac} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="K.8" curso="Título Entrenador" valoracion="0.10" cantidad={k8} acum={k8Ac} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="K.9" curso="Cert. Proyecto Invest Educ" valoracion="0.50" cantidad={k9} acum={k9Ac} puntos="" tope="" desc="" tipo_tope="" />
	</lenguasext>;
	
	_xmlDeducciones = 
	<deducciones>
		<curso codigo="L.1.a" curso="Apercibimiento" valoracion="0.20" cantidad={l1a} acum={l1aAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="L.1.b" curso="Suspensión" valoracion="0.25" cantidad={l1b} acum={l1bAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="L.1.c" curso="Traslado" valoracion="5.00" cantidad={l1c} acum={l1cAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="L.1.d" curso="Disminución Jerárquica" valoracion="10.00" cantidad={l1d} acum={l1dAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="L.1.e" curso="Por disminución de jerarquía escal" valoracion="15.00" cantidad={l1e} acum={l1eAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="L.1.f" curso="Por cesantía (reduce a 0 los antecedentes)" valoracion="" cantidad={l1f} acum={l1fAc} puntos="" tope="" desc="" tipo_tope="" />
	</deducciones>;
	
	_xmlMiembroJurado = 
	<jurado>
		<curso codigo="H" curso="Miem. Jurado" valoracion="0.50" cantidad={h} acum={hAc} puntos="" tope="" desc="" tipo_tope="" />		
	</jurado>;
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
