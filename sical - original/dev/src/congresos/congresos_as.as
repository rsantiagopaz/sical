import mx.managers.PopUpManager;
	
private var _xmlDatosPaciente:XML = <datospaciente></datospaciente>;
[Bindable] private var _xmlExpositor:XML = 
<congresosexp>
	<curso codigo="J.3.1.a" curso="Provinciales" valoracion="0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.3.1.b" curso="Regionales" valoracion="0.35" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.3.1.c" curso="Nacionales" valoracion="0.45" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.3.1.d" curso="Internacionales" valoracion="0.55" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />				
</congresosexp>;

[Bindable] private var _xmlParticipante:XML = 
<congresospart>
	<curso codigo="J.3.2.a" curso="Provincial" valoracion="0.15" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.3.2.b" curso="Regional" valoracion="0.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.3.2.c" curso="Nacional" valoracion="0.35" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.3.2.d" curso="Internacional" valoracion="0.45" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />				
</congresospart>;

[Bindable] private var _xmlAsistente:XML = 
<congresosasist>
	<curso codigo="J.3.3.a" curso="A Nivel Prov. o Reg." valoracion="0.10" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.3.3.b" curso="A Nivel Nacional" valoracion="0.20" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<curso codigo="J.3.3.c" curso="A Nivel Internacional" valoracion="0.30" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />						
</congresosasist>;

public function get xmlExpositor():XML {return _xmlExpositor.copy();}
public function get xmlParticipante():XML {return _xmlParticipante.copy();}
public function get xmlAsistente():XML {return _xmlAsistente.copy();}

//inicializa las variales necesarias para el modulo
public function fncInit():void
{	
	if (parentDocument.accion == 'B') 
		{this.currentState = 'baja';}
	else{this.currentState = ''; }
	
	var j31a:String = '';
	var j31b:String = '';
	var j31c:String = '';
	var j31d:String = '';
	var j32a:String = '';
	var j32b:String = '';
	var j32c:String = '';
	var j32d:String = '';
	var j33a:String = '';
	var j33b:String = '';
	var j33c:String = '';
	var j31aAc:String = '';
	var j31bAc:String = '';
	var j31cAc:String = '';
	var j31dAc:String = '';
	var j32aAc:String = '';
	var j32bAc:String = '';
	var j32cAc:String = '';
	var j32dAc:String = '';
	var j33aAc:String = '';
	var j33bAc:String = '';
	var j33cAc:String = '';
	var j31aPtos:String = '';
	var j31aTope:String = '';
	var j31aDesc:String = '';
	var j31aTipoTope:String = '';
	var j31bPtos:String = '';
	var j31bTope:String = '';
	var j31bDesc:String = '';
	var j31bTipoTope:String = '';
	var j31cPtos:String = '';
	var j31cTope:String = '';
	var j31cDesc:String = '';
	var j31cTipoTope:String = '';
	var j31dPtos:String = '';
	var j31dTope:String = '';
	var j31dDesc:String = '';
	var j31dTipoTope:String = '';
	var j32aPtos:String = '';
	var j32aTope:String = '';
	var j32aDesc:String = '';
	var j32aTipoTope:String = '';
	var j32bPtos:String = '';
	var j32bTope:String = '';
	var j32bDesc:String = '';
	var j32bTipoTope:String = '';
	var j32cPtos:String = '';
	var j32cTope:String = '';
	var j32cDesc:String = '';
	var j32cTipoTope:String = '';
	var j32dPtos:String = '';
	var j32dTope:String = '';
	var j32dDesc:String = '';
	var j32dTipoTope:String = '';
	var j33aPtos:String = '';
	var j33aTope:String = '';
	var j33aDesc:String = '';
	var j33aTipoTope:String = '';
	var j33bPtos:String = '';
	var j33bTope:String = '';
	var j33bDesc:String = '';
	var j33bTipoTope:String = '';
	var j33cPtos:String = '';
	var j33cTope:String = '';
	var j33cDesc:String = '';
	var j33cTipoTope:String = '';
	var i:int;
	for (i = 0;i < this.parentDocument.xmlDatosDocente.tope_antecedente.length();i++) {
		if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J31A') {
			j31aPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j31aTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j31aDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j31aTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J31B') {
			j31bPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j31bTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j31bDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j31bTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J31C') {
			j31cPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j31cTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j31cDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j31cTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J31D') {
			j31dPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j31dTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j31dDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j31dTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J32A') {
			j32aPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j32aTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j32aDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j32aTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J32B') {
			j32bPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j32bTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j32bDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j32bTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J32C') {
			j32cPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j32cTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j32cDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j32cTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J32D') {
			j32dPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j32dTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j32dDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j32dTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J33A') {
			j33aPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j33aTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j33aDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j33aTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J33B') {
			j33bPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j33bTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j33bDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j33bTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'J33C') {
			j33cPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			j33cTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			j33cDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			j33cTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
	}
	// Si ya tiene antecedentes (modificación o baja de ficha) no interesan acumulados
	// de la inscripción anterior
	if (this.parentDocument.xmlDatosDocente.antecedente.length() == 0) {
		for (i = 0;i < this.parentDocument.xmlDatosDocente.acum_antecedente.length();i++) {
			if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J31A') {
				j31aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J31B') {
				j31bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J31C') {
				j31cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J31D') {
				j31dAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J32A') {
				j32aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J32B') {
				j32bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J32C') {
				j32cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J32D') {
				j32dAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J33A') {
				j33aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J33B') {
				j33bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'J33C') {
				j33cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
		}	
	}		
	for (i = 0;i < this.parentDocument.xmlDatosDocente.antecedente.length();i++) {
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J31A') {
			j31a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j31aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J31B') {
			j31b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j31bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J31C') {
			j31c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j31cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J31D') {
			j31d = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j31dAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J32A') {
			j32a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j32aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J32B') {
			j32b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j32bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J32C') {
			j32c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j32cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J32D') {
			j32d = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j32dAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J33A') {
			j33a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j33aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J33B') {
			j33b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j33bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'J33C') {
			j33c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			j33cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
	}
	_xmlExpositor = 
	<congresosexp>
		<curso codigo="J.3.1.a" curso="Provinciales" valoracion="0.25" cantidad={j31a} acum={j31aAc} puntos={j31aPtos} tope={j31aTope} desc={j31aDesc} tipo_tope={j31aTipoTope} />
		<curso codigo="J.3.1.b" curso="Regionales" valoracion="0.35" cantidad={j31b} acum={j31bAc} puntos={j31bPtos} tope={j31bTope} desc={j31bDesc} tipo_tope={j31bTipoTope} />
		<curso codigo="J.3.1.c" curso="Nacionales" valoracion="0.45" cantidad={j31c} acum={j31cAc} puntos={j31cPtos} tope={j31cTope} desc={j31cDesc} tipo_tope={j31cTipoTope} />
		<curso codigo="J.3.1.d" curso="Internacionales" valoracion="0.55" cantidad={j31d} acum={j31dAc} puntos={j31dPtos} tope={j31dTope} desc={j31dDesc} tipo_tope={j31dTipoTope} />				
	</congresosexp>;
	
	_xmlParticipante = 
	<congresospart>
		<curso codigo="J.3.2.a" curso="Provincial" valoracion="0.15" cantidad={j32a} acum={j32aAc} puntos={j32aPtos} tope={j32aTope} desc={j32aDesc} tipo_tope={j32aTipoTope} />
		<curso codigo="J.3.2.b" curso="Regional" valoracion="0.25" cantidad={j32b} acum={j32bAc} puntos={j32bPtos} tope={j32bTope} desc={j32bDesc} tipo_tope={j32bTipoTope} />
		<curso codigo="J.3.2.c" curso="Nacional" valoracion="0.35" cantidad={j32c} acum={j32cAc} puntos={j32cPtos} tope={j32cTope} desc={j32cDesc} tipo_tope={j32cTipoTope} />
		<curso codigo="J.3.2.d" curso="Internacional" valoracion="0.45" cantidad={j32d} acum={j32dAc} puntos={j32dPtos} tope={j32dTope} desc={j32dDesc} tipo_tope={j32dTipoTope} />				
	</congresospart>;
	
	_xmlAsistente = 
	<congresosasist>
		<curso codigo="J.3.3.a" curso="A Nivel Prov. o Reg." valoracion="0.10" cantidad={j33a} acum={j33aAc} puntos={j33aPtos} tope={j33aTope} desc={j33aDesc} tipo_tope={j33aTipoTope} />
		<curso codigo="J.3.3.b" curso="A Nivel Nacional" valoracion="0.20" cantidad={j33b} acum={j33bAc} puntos={j33bPtos} tope={j33bTope} desc={j33bDesc} tipo_tope={j33bTipoTope} />
		<curso codigo="J.3.3.c" curso="A Nivel Internacional" valoracion="0.30" cantidad={j33c} acum={j33cAc} puntos={j33cPtos} tope={j33cTope} desc={j33cDesc} tipo_tope={j33cTipoTope} />						
	</congresosasist>;
}

private function fncCerrar(e:Event):void{
	dispatchEvent(new Event("eventClose"));
}
