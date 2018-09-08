import mx.managers.PopUpManager;

[Bindable] private var _xmlCobertura:XML = <coberturas></coberturas>;
private var _xmlDatosPaciente:XML = <datospaciente></datospaciente>;	
[Bindable] private var _xmlCursosAprobados:XML = 
<cursosap>
	<curso codigo="J.1.a" curso="De 25 a 50 hs"	valoracion="0.15" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.1.b" curso="De 51 a 100 hs"	valoracion="0.30" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.1.c" curso="De 101 a 150 hs"	valoracion="0.45" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.1.d" curso="De 151 a 200 hs"	valoracion="0.60" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />				
</cursosap>;
[Bindable] private var _xmlCursosAdHonorem:XML = 
<cursosad>
	<curso codigo="J.2.a.1" curso="De 25 a 50 hs" valoracion="0.15 + 0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />		
	<curso codigo="J.2.a.2" curso="De 51 a 100 hs" valoracion="0.30 + 0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.2.a.3" curso="De 101 a 150 hs"	valoracion="0.45 + 0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.2.a.4" curso="De 151 a 200 hs"	valoracion="0.60 + 0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />		
</cursosad>;
[Bindable] private var _xmlCursosCosteados:XML = 
<cursoscost>
	<curso codigo="J.2.b.1" curso="De 25 a 50 hs" valoracion="+ 0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />		
	<curso codigo="J.2.b.2" curso="De 51 a 100 hs" valoracion="+ 0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.2.b.3" curso="De 101 a 150 hs"	valoracion="+ 0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope=""	/>
	<curso codigo="J.2.b.4" curso="De 151 a 200 hs"	valoracion="+ 0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope=""	/>		
</cursoscost>;
[Bindable] private var _xmlCursosSinResolucion:XML = 
<cursossr>
	<curso codigo="K.2.a" curso="De 25 a 50 hs"	valoracion="0.10" cantidad="" acum="" />
	<curso codigo="K.2.b" curso="De 51 a 100 hs"	valoracion="0.20" cantidad="" acum="" />
	<curso codigo="K.2.c" curso="De 101 a 150 hs"	valoracion="0.30" cantidad="" acum="" />
	<curso codigo="K.2.d" curso="De 151 a 200 hs"	valoracion="0.40" cantidad="" acum="" />				
</cursossr>;
[Bindable] private var _xmlCursosConResolucion:XML =
<cursoscr>
	<curso codigo="K.3.a" curso="De 25 a 50 hs"	valoracion="0.20" cantidad="" acum="" />
	<curso codigo="K.3.b" curso="De 51 a 100 hs"	valoracion="0.35" cantidad="" acum="" />
	<curso codigo="K.3.c" curso="De 101 a 150 hs"	valoracion="0.50" cantidad="" acum="" />
	<curso codigo="K.3.d" curso="De 151 a 200 hs"	valoracion="0.65" cantidad="" acum="" />				
</cursoscr>

public function get xmlCursosAprobados():XML {return _xmlCursosAprobados.copy();}
public function get xmlCursosAdHonorem():XML {return _xmlCursosAdHonorem.copy();}
public function get xmlCursosCosteados():XML {return _xmlCursosCosteados.copy();}
public function get xmlCursosSinResolucion():XML {return _xmlCursosSinResolucion.copy();}
public function get xmlCursosConResolucion():XML {return _xmlCursosConResolucion.copy();}

//inicializa las variales necesarias para el modulo
public function fncInit():void
{	
	if (parentDocument.accion == 'B') 
		{this.currentState = 'baja';}
	else{this.currentState = ''; }
	
	var j1a:String = '';
	var j1b:String = '';
	var j1c:String = '';
	var j1d:String = '';
	var j2a1:String = '';
	var j2a2:String = '';
	var j2a3:String = '';
	var j2a4:String = '';
	var j2b1:String = '';
	var j2b2:String = '';
	var j2b3:String = '';
	var j2b4:String = '';
	var k2a:String = '';
	var k2b:String = '';
	var k2c:String = '';
	var k2d:String = '';
	var k3a:String = '';
	var k3b:String = '';
	var k3c:String = '';
	var k3d:String = '';
	var j1aAc:String = '';
	var j1bAc:String = '';
	var j1cAc:String = '';
	var j1dAc:String = '';
	var j2a1Ac:String = '';
	var j2a2Ac:String = '';
	var j2a3Ac:String = '';
	var j2a4Ac:String = '';
	var j2b1Ac:String = '';
	var j2b2Ac:String = '';
	var j2b3Ac:String = '';
	var j2b4Ac:String = '';
	var k2aAc:String = '';
	var k2bAc:String = '';
	var k2cAc:String = '';
	var k2dAc:String = '';
	var k3aAc:String = '';
	var k3bAc:String = '';
	var k3cAc:String = '';
	var k3dAc:String = '';
	var j1aPtos:String = '';
	var j1bPtos:String = '';
	var j1cPtos:String = '';
	var j1dPtos:String = '';
	var j1aTope:String = '';
	var j1bTope:String = '';
	var j1cTope:String = '';
	var j1dTope:String = '';
	var j1aDesc:String = '';
	var j1bDesc:String = '';
	var j1cDesc:String = '';
	var j1dDesc:String = '';
	var j1aTipoTope:String = '';
	var j1bTipoTope:String = '';
	var j1cTipoTope:String = '';
	var j1dTipoTope:String = '';
	var j2b1Ptos:String = '';
	var j2b2Ptos:String = '';
	var j2b3Ptos:String = '';
	var j2b4Ptos:String = '';
	var j2b1Tope:String = '';
	var j2b2Tope:String = '';
	var j2b3Tope:String = '';
	var j2b4Tope:String = '';
	var j2b1Desc:String = '';
	var j2b2Desc:String = '';
	var j2b3Desc:String = '';
	var j2b4Desc:String = '';
	var j2b1TipoTope:String = '';
	var j2b2TipoTope:String = '';
	var j2b3TipoTope:String = '';
	var j2b4TipoTope:String = '';
	var k2aPtos:String = '';
	var k2aTope:String = '';
	var k2aDesc:String = '';
	var k2aTipoTope:String = '';
	var k2bPtos:String = '';
	var k2bTope:String = '';
	var k2bDesc:String = '';
	var k2bTipoTope:String = '';
	var k2cPtos:String = '';
	var k2cTope:String = '';
	var k2cDesc:String = '';
	var k2cTipoTope:String = '';
	var k2dPtos:String = '';
	var k2dTope:String = '';
	var k2dDesc:String = '';
	var k2dTipoTope:String = '';
	var k3aPtos:String = '';
	var k3aTope:String = '';
	var k3aDesc:String = '';
	var k3aTipoTope:String = '';
	var k3bPtos:String = '';
	var k3bTope:String = '';
	var k3bDesc:String = '';
	var k3bTipoTope:String = '';
	var k3cPtos:String = '';
	var k3cTope:String = '';
	var k3cDesc:String = '';
	var k3cTipoTope:String = '';
	var k3dPtos:String = '';
	var k3dTope:String = '';
	var k3dDesc:String = '';
	var k3dTipoTope:String = '';
	var i:int;
	for (i = 0;i < this.parentDocument.xmlDatosDocente.tope_antecedente.length();i++) {
		if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J1A') {				
			j1aPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j1aTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j1aDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j1aTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J1B') {				
			j1bPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j1bTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j1bDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j1bTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J1C') {				
			j1cPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j1cTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j1cDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j1cTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J1D') {				
			j1dPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j1dTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j1dDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j1dTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J2B1') {				
			j2b1Ptos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j2b1Tope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j2b1Desc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j2b1TipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J2B2') {				
			j2b2Ptos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j2b2Tope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j2b2Desc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j2b2TipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J2B3') {				
			j2b3Ptos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j2b3Tope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j2b3Desc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j2b3TipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J2B4') {				
			j2b4Ptos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j2b4Tope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j2b4Desc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j2b4TipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'K2A') {				
			k2aPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			k2aTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			k2aDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			k2aTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'K2B') {				
			k2bPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			k2bTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			k2bDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			k2bTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'K2C') {				
			k2cPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			k2cTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			k2cDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			k2cTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'K2D') {				
			k2dPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			k2dTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			k2dDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			k2dTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'K3A') {				
			k3aPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			k3aTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			k3aDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			k3aTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'K3B') {
			k3bPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			k3bTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			k3bDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			k3bTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'K3C') {
			k3cPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			k3cTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			k3cDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			k3cTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'K3D') {
			k3dPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			k3dTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			k3dDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			k3dTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
	}
	// Si ya tiene antecedentes (modificación o baja de ficha) no interesan acumulados
	// de la inscripción anterior
	if (this.parentDocument.xmlDatosDocente.antecedente.length() == 0) {
		// Tomar los acumulados de la inscripción correspondiente al llamado designado como
		// orígen de valores acumulados para las inscripciones del presente llamado
		for (i = 0;i < this.parentDocument.xmlDatosDocente.acum_antecedente.length();i++) {
			if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J1A') {
				j1aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J1B') {
				j1bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J1C') {
				j1cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J1D') {
				j1dAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J2B1') {
				j2a1Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J2B2') {
				j2a2Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J2B3') {
				j2a3Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J2B4') {
				j2a4Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J2B1') {
				j2b1Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J2B2') {
				j2b2Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J2B3') {
				j2b3Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J2B4') {
				j2b4Ac = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K2A') {
				k2aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K2B') {
				k2bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K2C') {
				k2cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K2D') {
				k2dAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K3A') {
				k3aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K3B') {
				k3bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K3C') {
				k3cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'K3D') {
				k3dAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
		}	
	}	
	// Si es una modificación de inscripción, leer los acumulados de los campos correspondientes
	// de la presente inscripción
	for (i = 0;i < this.parentDocument.xmlDatosDocente.antecedente.length();i++) {
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J1A') {
			j1a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j1aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J1B') {
			j1b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j1bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J1C') {
			j1c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j1cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J1D') {
			j1d = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j1dAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J2A1') {
			j2a1 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j2a1Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J2A2') {
			j2a2 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j2a2Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J2A3') {
			j2a3 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j2a3Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J2A4') {
			j2a4 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j2a4Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J2B1') {
			j2b1 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j2b1Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J2B2') {
			j2b2 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j2b2Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J2B3') {
			j2b3 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j2b3Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J2B4') {
			j2b4 = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j2b4Ac = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K2A') {
			k2a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k2aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K2B') {
			k2b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k2bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K2C') {
			k2c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k2cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K2D') {
			k2d = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k2dAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K3A') {
			k3a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k3aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K3B') {
			k3b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k3bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K3C') {
			k3c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k3cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'K3D') {
			k3d = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			k3dAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
	}
	_xmlCursosAprobados =
	<cursosap>
		<curso codigo="J.1.a" curso="De 25 a 50 hs"	valoracion="0.15" cantidad={j1a} acum={j1aAc} puntos={j1aPtos} tope={j1aTope} desc={j1aDesc} tipo_tope={j1aTipoTope} />
		<curso codigo="J.1.b" curso="De 51 a 100 hs"	valoracion="0.30" cantidad={j1b} acum={j1bAc} puntos={j1bPtos} tope={j1bTope} desc={j1bDesc} tipo_tope={j1bTipoTope} />
		<curso codigo="J.1.c" curso="De 101 a 150 hs"	valoracion="0.45" cantidad={j1c} acum={j1cAc} puntos={j1cPtos} tope={j1cTope} desc={j1cDesc} tipo_tope={j1cTipoTope} />
		<curso codigo="J.1.d" curso="De 151 a 200 hs"	valoracion="0.60" cantidad={j1d} acum={j1dAc} puntos={j1dPtos} tope={j1dTope} desc={j1dDesc} tipo_tope={j1dTipoTope} />				
	</cursosap>;
	_xmlCursosAdHonorem = 
	<cursosad>
		<curso codigo="J.2.a.1" curso="De 25 a 50 hs" valoracion="0.15 + 0.25" cantidad={j2a1} acum={j2a1Ac} puntos="" tope="" desc="" tipo_tope="" />		
		<curso codigo="J.2.a.2" curso="De 51 a 100 hs" valoracion="0.30 + 0.25" cantidad={j2a2} acum={j2a2Ac} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="J.2.a.3" curso="De 101 a 150 hs"	valoracion="0.45 + 0.25" cantidad={j2a3} acum={j2a3Ac} puntos="" tope="" desc="" tipo_tope="" />
		<curso codigo="J.2.a.4" curso="De 151 a 200 hs"	valoracion="0.60 + 0.25" cantidad={j2a4} acum={j2a4Ac} puntos="" tope="" desc="" tipo_tope="" />
	</cursosad>;
	_xmlCursosCosteados =  
	<cursoscost>
		<curso codigo="J.2.b.1" curso="De 25 a 50 hs" valoracion="+ 0.25" cantidad={j2b1} acum={j2b1Ac} puntos={j2b1Ptos} tope={j2b1Tope} desc={j2b1Desc} tipo_tope={j2b1TipoTope} />		
		<curso codigo="J.2.b.2" curso="De 51 a 100 hs" valoracion="+ 0.25" cantidad={j2b2} acum={j2b2Ac} puntos={j2b2Ptos} tope={j2b2Tope} desc={j2b2Desc} tipo_tope={j2b2TipoTope} />
		<curso codigo="J.2.b.3" curso="De 101 a 150 hs"	valoracion="+ 0.25" cantidad={j2b3} acum={j2b3Ac} puntos={j2b3Ptos} tope={j2b3Tope} desc={j2b3Desc} tipo_tope={j2b3TipoTope} />
		<curso codigo="J.2.b.4" curso="De 151 a 200 hs"	valoracion="+ 0.25" cantidad={j2b4} acum={j2b4Ac} puntos={j2b4Ptos} tope={j2b4Tope} desc={j2b4Desc} tipo_tope={j2b4TipoTope} />		
	</cursoscost>;
	_xmlCursosSinResolucion = 
	<cursossr>
		<curso codigo="K.2.a" curso="De 25 a 50 hs"	valoracion="0.10" cantidad={k2a} acum={k2aAc} puntos={k2aPtos} tope={k2aTope} desc={k2aDesc} tipo_tope={k2aTipoTope} />
		<curso codigo="K.2.b" curso="De 51 a 100 hs"	valoracion="0.20" cantidad={k2b} acum={k2bAc} puntos={k2bPtos} tope={k2bTope} desc={k2bDesc} tipo_tope={k2bTipoTope} />
		<curso codigo="K.2.c" curso="De 101 a 150 hs"	valoracion="0.30" cantidad={k2c} acum={k2cAc} puntos={k2cPtos} tope={k2cTope} desc={k2cDesc} tipo_tope={k2cTipoTope} />
		<curso codigo="K.2.d" curso="De 151 a 200 hs"	valoracion="0.40" cantidad={k2d} acum={k2dAc} puntos={k2dPtos} tope={k2dTope} desc={k2dDesc} tipo_tope={k2dTipoTope} />				
	</cursossr>;
	_xmlCursosConResolucion =
	<cursoscr>
		<curso codigo="K.3.a" curso="De 25 a 50 hs"	valoracion="0.20" cantidad={k3a} acum={k3aAc} puntos={k3aPtos} tope={k3aTope} desc={k3aDesc} tipo_tope={k3aTipoTope} />
		<curso codigo="K.3.b" curso="De 51 a 100 hs"	valoracion="0.35" cantidad={k3b} acum={k3bAc} puntos={k3bPtos} tope={k3bTope} desc={k3bDesc} tipo_tope={k3bTipoTope} />
		<curso codigo="K.3.c" curso="De 101 a 150 hs"	valoracion="0.50" cantidad={k3c} acum={k3cAc} puntos={k3cPtos} tope={k3cTope} desc={k3cDesc} tipo_tope={k3cTipoTope} />
		<curso codigo="K.3.d" curso="De 151 a 200 hs"	valoracion="0.65" cantidad={k3d} acum={k3dAc} puntos={k3dPtos} tope={k3dTope} desc={k3dDesc} tipo_tope={k3dTipoTope} />				
	</cursoscr>;
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}			
