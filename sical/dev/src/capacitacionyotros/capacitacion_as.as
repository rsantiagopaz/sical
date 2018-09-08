import mx.managers.PopUpManager;

[Bindable] private var _xmlCobertura:XML = <coberturas></coberturas>;
private var _xmlDatosPaciente:XML = <datospaciente></datospaciente>;	

[Bindable] private var _xmlCapacitaciones:XML = 
<capacitaciones>
	<curso codigo="K.4.a" curso="De 25 a 50 hs. Cat" valoracion="0.15" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="K.4.b" curso="De 51 a 100 hs. Cat" valoracion="0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="K.4.c" curso="De 101 a 150 hs. Cat" valoracion="0.35" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="K.4.d" curso="De 151 a 200 hs. Cat" valoracion="0.45" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />				
</capacitaciones>;

[Bindable] private var _xmlPublicaciones:XML =
<publicaciones>
	<curso codigo="D.1.a" curso="Autor Único" valoracion="2.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="D.1.b" curso="Coautor o Grupal" valoracion="1.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="D.2" curso="Art. en Revistas" valoracion="0.30" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />						
</publicaciones>;

[Bindable] private var _xmlProducciones:XML =
<producciones>
	<curso codigo="D.3.a" curso="Exposiciones (Sin Tope)" valoracion="0.50" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="D.3.b" curso="Composición (Tope 1 punto)" valoracion="0.20" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="D.3.c" curso="Producciones (Tope 1 punto)" valoracion="0.50" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />						
</producciones>;

[Bindable] private var _xmlPremiosIC:XML =
<premiosic>
	<curso codigo="E.1.a" curso="Provincial" valoracion="0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="E.1.b" curso="Nacional" valoracion="0.50" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="E.1.c" curso="Internacional" valoracion="1.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />						
</premiosic>;

[Bindable] private var _xmlConcAnteced:XML =
<concantec>
	<curso codigo="F.1.a" curso="Dur. hasta 6 meses" valoracion="0.20" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="F.1.b" curso="Dur. más de 6 meses a un año" valoracion="0.30" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="F.1.c" curso="Mayor a 1 año" valoracion="0.50" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />						
</concantec>;

[Bindable] private var _xmlPremiosP:XML =
<premiosp>
	<curso codigo="E.2" curso="Distinción/Premio" valoracion="0.30" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />								
</premiosp>;

[Bindable] private var _xmlConcursosTitulo:XML =
<concursost>
	<curso codigo="G.a" curso="Títulos y Antec." valoracion="0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="G.b" curso="Títulos y Antec. y oposición" valoracion="0.50" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />								
</concursost>;

[Bindable] private var _xmlConcOpos:XML =
<concopos>
	<curso codigo="F.2.a" curso="Dur. hasta 6 meses" valoracion="0.20 + 0.20" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="F.2.b" curso="Dur. más de 6 meses a un año" valoracion="0.30 + 0.20" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="F.2.c" curso="Mayor a 1 año" valoracion="0.50 + 0.20" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />						
</concopos>;

public function get xmlCapacitaciones():XML {return _xmlCapacitaciones.copy();}
public function get xmlPublicaciones():XML {return _xmlPublicaciones.copy();}
public function get xmlProducciones():XML {return _xmlProducciones.copy();}
public function get xmlPremiosIC():XML {return _xmlPremiosIC.copy();}
public function get xmlPremiosP():XML {return _xmlPremiosP.copy();}
public function get xmlConcursosTitulo():XML {return _xmlConcursosTitulo.copy();}
public function get xmlConcAnteced():XML {return _xmlConcAnteced.copy();}
public function get xmlConcOpos():XML {return _xmlConcOpos.copy();}

//inicializa las variales necesarias para el modulo
public function fncInit():void
{	
	if (parentDocument.accion == 'B') 
		{this.currentState = 'baja';}
	else{this.currentState = ''; }
	
	var k4a:String = '';
	var k4b:String = '';
	var k4c:String = '';
	var k4d:String = '';
	var d1a:String = '';
	var d1b:String = '';
	var d2:String = '';
	var d3a:String = '';
	var d3b:String = '';
	var d3c:String = '';
	var e1a:String = '';
	var e1b:String = '';
	var e1c:String = '';
	var e2:String = '';
	var ga:String = '';
	var gb:String = '';
	var f1a:String = '';
	var f1b:String = '';
	var f1c:String = '';
	var f2a:String = '';
	var f2b:String = '';
	var f2c:String = '';
	var k4aAc:String = '';
	var k4bAc:String = '';
	var k4cAc:String = '';
	var k4dAc:String = '';
	var d1aAc:String = '';
	var d1bAc:String = '';
	var d2Ac:String = '';
	var d3aAc:String = '';
	var d3bAc:String = '';
	var d3cAc:String = '';
	var e1aAc:String = '';
	var e1bAc:String = '';
	var e1cAc:String = '';
	var e2Ac:String = '';
	var gaAc:String = '';
	var gbAc:String = '';
	var f1aAc:String = '';
	var f1bAc:String = '';
	var f1cAc:String = '';
	var f2aAc:String = '';
	var f2bAc:String = '';
	var f2cAc:String = '';
	var d2Ptos:String = '';
	var d2Tope:String = '';
	var d2Desc:String = '';
	var d2TipoTope:String = '';
	var i:int;
	for (i = 0;i < this.parentDocument.xmlDatosDocente.tope_antecedente.length();i++) {
		if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'D2') {				
			d2Ptos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			d2Tope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			d2Desc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			d2TipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
			break;
		}
	}
	// Si ya tiene antecedentes (modificación o baja de ficha) no interesan acumulados
	// de la inscripción anterior
	if (this.parentDocument.xmlDatosDocente.antecedente.length() == 0) {
		for (i = 0;i < this.parentDocument.xmlDatosDocente.acum_antecedente.length();i++) {
			if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K4A') {
				k4aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K4B') {
				k4bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K4C') {
				k4cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K4D') {
				k4dAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'D1A') {
				d1aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'D1B') {
				d1bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'D2') {
				d2Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'D3A') {
				d3aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'D3B') {
				d3bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'D3C') {
				d3cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'E1A') {
				e1aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'E1B') {
				e1bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'E1C') {
				e1cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'E2') {
				e2Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'GA') {
				gaAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'GB') {
				gbAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'F1A') {
				f1aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'F1B') {
				f1bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'F1C') {
				f1cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'F2A') {
				f2aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'F2B') {
				f2bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'F2C') {
				f2cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}			
		}	
	}		
	for (i = 0;i < this.parentDocument.xmlDatosDocente.antecedente.length();i++) {
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K4A') {
			k4a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k4aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K4B') {
			k4b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k4bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K4C') {
			k4c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k4cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K4D') {
			k4d = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k4dAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'D1A') {
			d1a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			d1aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'D1B') {
			d1b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			d1bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'D2') {
			d2 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			d2Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'D3A') {
			d3a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			d3aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'D3B') {
			d3b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			d3bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'D3C') {
			d3c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			d3cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'E1A') {
			e1a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			e1aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'E1B') {
			e1b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			e1bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'E1C') {
			e1c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			e1aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'E2') {
			e2 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			e2Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'GA') {
			ga = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			gaAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'GB') {
			gb = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			gbAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'F1A') {
			f1a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			f1aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'F1B') {
			f1b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			f1bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'F1C') {
			f1c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			f1cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'F2A') {
			f2a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			f2aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'F2B') {
			f2b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			f2bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'F2C') {
			f2c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			f2cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
	}
	_xmlCapacitaciones = 
	<capacitaciones>
		<curso codigo="K.4.a" curso="De 25 a 50 hs. Cat" valoracion="0.15" cantidad={k4a} acum={k4aAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="K.4.b" curso="De 51 a 100 hs. Cat" valoracion="0.25" cantidad={k4b} acum={k4bAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="K.4.c" curso="De 101 a 150 hs. Cat" valoracion="0.35" cantidad={k4c} acum={k4cAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="K.4.d" curso="De 151 a 200 hs. Cat" valoracion="0.45" cantidad={k4d} acum={k4dAc} puntos="" tope="" desc="" tipo_tope="" />				
	</capacitaciones>;
	
	_xmlPublicaciones =
	<publicaciones>
		<curso codigo="D.1.a" curso="Autor Único" valoracion="2.00" cantidad={d1a} acum={d1aAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="D.1.b" curso="Coautor o Grupal" valoracion="1.00" cantidad={d1b} acum={d1b} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="D.2" curso="Art. en Revistas" valoracion="0.30" cantidad={d2} acum={d2Ac} puntos={d2Ptos} tope={d2Tope} desc={d2Desc} tipo_tope={d2TipoTope} />						
	</publicaciones>;
	
	_xmlProducciones =
	<producciones>
		<curso codigo="D.3.a" curso="Exposiciones (Sin Tope)" valoracion="0.50" cantidad={d3a} acum={d3a} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="D.3.b" curso="Composición (Tope 1 punto)" valoracion="0.20" cantidad={d3b} acum={d3b} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="D.3.c" curso="Producciones (Tope 1 punto)" valoracion="0.50" cantidad={d3c} acum={d3c} puntos="" tope="" desc="" tipo_tope="" />						
	</producciones>;
	
	_xmlPremiosIC =
	<premiosic>
		<curso codigo="E.1.a" curso="Provincial" valoracion="0.25" cantidad={e1a} acum={e1aAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="E.1.b" curso="Nacional" valoracion="0.50" cantidad={e1b} acum={e1bAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="E.1.c" curso="Internacional" valoracion="1.00" cantidad={e1c} acum={e1cAc} puntos="" tope="" desc="" tipo_tope="" />						
	</premiosic>;
	
	_xmlPremiosP =
	<premiosp>
		<curso codigo="E.2" curso="Distinción/Premio" valoracion="0.30" cantidad={e2} acum={e2Ac} puntos="" tope="" desc="" tipo_tope="" />								
	</premiosp>;
	
	_xmlConcursosTitulo =
	<concursost>
		<curso codigo="G.a" curso="Títulos y Antec." valoracion="0.25" cantidad={ga} acum={gaAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="G.b" curso="Títulos y Antec. y oposición" valoracion="0.50" cantidad={gb} acum={gbAc} puntos="" tope="" desc="" tipo_tope="" />								
	</concursost>;
	
	_xmlConcAnteced =
	<concantec>
		<curso codigo="F.1.a" curso="Dur. hasta 6 meses" valoracion="0.20" cantidad={f1a} acum={f1aAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="F.1.b" curso="Dur. más de 6 meses a un año" valoracion="0.30" cantidad={f1b} acum={f1bAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="F.1.c" curso="Mayor a 1 año" valoracion="0.50" cantidad={f1c} acum={f1cAc} />						
	</concantec>;
	
	_xmlConcOpos =
	<concopos>
		<curso codigo="F.2.a" curso="Dur. hasta 6 meses" valoracion="0.20 + 0.20" cantidad={f2a} acum={f2aAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="F.2.b" curso="Dur. más de 6 meses a un año" valoracion="0.30 + 0.20" cantidad={f2b} acum={f2bAc} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="F.2.c" curso="Mayor a 1 año" valoracion="0.50 + 0.20" cantidad={f2c} acum={f2cAc} puntos="" tope="" desc="" tipo_tope="" />						
	</concopos>;
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
