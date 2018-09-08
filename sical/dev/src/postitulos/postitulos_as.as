import mx.managers.PopUpManager;

[Bindable] private var _xmlPostitulos:XML = 
<postitulos>		
	<postitulo codigo="A.2.1.c" postitulo="Diplomatura" valoracion="2.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<postitulo codigo="A.2.1.b" postitulo="Espec. Superior" valoracion="1.50" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<postitulo codigo="A.2.1.a" postitulo="Act. Académica" valoracion="1.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<postitulo codigo="A.2.2.c" postitulo="600 o más" valoracion="1.25" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />		
	<postitulo codigo="A.2.2.b" postitulo="400 o más" valoracion="1.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<postitulo codigo="A.2.2.a" postitulo="200 o más" valoracion="0.75" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
</postitulos>;
[Bindable] private var _xmlPosgrados:XML =
<posgrados>				
	<postitulo codigo="A.3.2.a" postitulo="Especialización" valoracion="4.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<postitulo codigo="A.3.2.b" postitulo="Magister" valoracion="5.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />
	<postitulo codigo="A.3.2.c" postitulo="Doctorado" valoracion="6.00" cantidad="" acum="" puntos="" tope="" desc="" tipo_tope="" />		
</posgrados>

public function get xmlPostitulos():XML {return _xmlPostitulos.copy();}
public function get xmlPosgrados():XML {return _xmlPosgrados.copy();}

//inicializa las variales necesarias para el modulo
public function fncInit():void
{	
	if (parentDocument.accion == 'B') 
		{this.currentState = 'baja';}
	else{this.currentState = ''; }
	
	var a21a:String = '';
	var a21b:String = '';
	var a21c:String = '';
	var a22a:String = '';
	var a22b:String = '';
	var a22c:String = '';
	var a32a:String = '';
	var a32b:String = '';
	var a32c:String = '';
	var a21aAc:String = '';
	var a21bAc:String = '';
	var a21cAc:String = '';
	var a22aAc:String = '';
	var a22bAc:String = '';
	var a22cAc:String = '';
	var a32aAc:String = '';
	var a32bAc:String = '';
	var a32cAc:String = '';
	var a21aPtos:String = '';
	var a21bPtos:String = '';
	var a21cPtos:String = '';
	var a22aPtos:String = '';
	var a22bPtos:String = '';
	var a22cPtos:String = '';
	var a21aTope:String = '';
	var a21bTope:String = '';
	var a21cTope:String = '';
	var a22aTope:String = '';
	var a22bTope:String = '';
	var a22cTope:String = '';
	var a21aDesc:String = '';
	var a21bDesc:String = '';
	var a21cDesc:String = '';
	var a22aDesc:String = '';
	var a22bDesc:String = '';
	var a22cDesc:String = '';
	var a21aTipoTope:String = '';
	var a21bTipoTope:String = '';
	var a21cTipoTope:String = '';
	var a22aTipoTope:String = '';
	var a22bTipoTope:String = '';
	var a22cTipoTope:String = '';
	var i:int;		
	for (i = 0;i < this.parentDocument.xmlDatosDocente.tope_antecedente.length();i++) {
		if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'A21A') {
			a21aPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			a21aTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			a21aDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			a21aTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'A21B') {
			a21bPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			a21bTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			a21bDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			a21bTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;				
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'A21C') {
			a21cPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			a21cTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			a21cDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			a21cTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;				
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'A22A') {
			a22aPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			a22aTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			a22aDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			a22aTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;				
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'A22B') {
			a22bPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			a22bTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			a22bDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			a22bTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;				
		}
		else if (this.parentDocument.xmlDatosDocente.tope_antecedente[i].@codigo == 'A22C') {
			a22cPtos = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@puntos;
			a22cTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tope;
			a22cDesc = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@descripcion;
			a22cTipoTope = this.parentDocument.xmlDatosDocente.tope_antecedente[i].@tipo_tope;				
		}			
	}	
	// Si ya tiene antecedentes (modificación o baja de ficha) no interesan acumulados
	// de la inscripción anterior
	if (this.parentDocument.xmlDatosDocente.antecedente.length() == 0) {		
		for (i = 0;i < this.parentDocument.xmlDatosDocente.acum_antecedente.length();i++) {
			if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'A21A') {
				a21aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'A21B') {
				a21bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;				
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'A21C') {
				a21cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;				
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'A22A') {
				a22aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;				
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'A22B') {
				a22bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;				
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'A22C') {
				a22cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;				
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'A22C') {
				a32aAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;				
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'A22C') {
				a32bAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;				
			}
			else if (this.parentDocument.xmlDatosDocente.acum_antecedente[i].@codigo == 'A22C') {
				a32cAc = this.parentDocument.xmlDatosDocente.acum_antecedente[i].@acum_historico;				
			}
		}
	}
	for (i = 0;i < this.parentDocument.xmlDatosDocente.antecedente.length();i++) {
		if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'A21A') {
			a21a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			a21aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;				
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'A21B') {
			a21b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			a21bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;				
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'A21C') {
			a21c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			a21cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;			
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'A22A') {
			a22a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			a22aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;			
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'A22B') {
			a22b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			a22bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;			
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'A22C') {
			a22c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			a22cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;			
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'A32A') {
			a32a = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			a32aAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'A32B') {
			a32b = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			a32bAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
		else if (this.parentDocument.xmlDatosDocente.antecedente[i].@codigo == 'A32C') {
			a32c = this.parentDocument.xmlDatosDocente.antecedente[i].@unidades;
			a32cAc = this.parentDocument.xmlDatosDocente.antecedente[i].@acum_historico;
		}
	}
	_xmlPostitulos = 
	<postitulos>
	<postitulo codigo="A.2.1.c" postitulo="Diplomatura" valoracion="2.00" cantidad={a21c} acum={a21cAc} puntos={a21cPtos} tope={a21cTope} desc={a21cDesc} tipo_tope={a21cTipoTope} />
	<postitulo codigo="A.2.1.b" postitulo="Espec. Superior" valoracion="1.50" cantidad={a21b} acum={a21bAc} puntos={a21bPtos} tope={a21bTope} desc={a21bDesc} tipo_tope={a21bTipoTope} />
	<postitulo codigo="A.2.1.a" postitulo="Act. Académica" valoracion="1.00" cantidad={a21a} acum={a21aAc} puntos={a21aPtos} tope={a21aTope} desc={a21aDesc} tipo_tope={a21aTipoTope} />
	<postitulo codigo="A.2.2.c" postitulo="600 o más" valoracion="1.25" cantidad={a22c} acum={a22cAc} puntos={a22cPtos} tope={a22cTope} desc={a22cDesc} tipo_tope={a22cTipoTope} />		
	<postitulo codigo="A.2.2.b" postitulo="400 o más" valoracion="1.00" cantidad={a22b} acum={a22bAc} puntos={a22bPtos} tope={a22bTope} desc={a22bDesc} tipo_tope={a22bTipoTope} />
	<postitulo codigo="A.2.2.a" postitulo="200 o más" valoracion="0.75" cantidad={a22a} acum={a22aAc} puntos={a22aPtos} tope={a22aTope} desc={a22aDesc} tipo_tope={a22aTipoTope} />		
	</postitulos>;
	_xmlPosgrados = 
	<posgrados>				
	<postitulo codigo="A.3.2.a" postitulo="Especialización" valoracion="4.00" cantidad={a32a} acum={a32aAc} puntos="" tope="" desc="" tipo_tope="" />
	<postitulo codigo="A.3.2.b" postitulo="Magister" valoracion="5.00" cantidad={a32b} acum={a32bAc} puntos="" tope="" desc="" tipo_tope="" />
	<postitulo codigo="A.3.2.c" postitulo="Doctorado" valoracion="6.00" cantidad={a32c} acum={a32cAc} puntos="" tope="" desc="" tipo_tope="" />		
	</posgrados>;
}
