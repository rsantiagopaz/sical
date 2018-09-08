// ActionScript file
	import clases.HTTPServices;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
	
	include "../control_acceso.as";
	
	[Bindable] private var _xmlEspaciosA:XML = <espacios></espacios>;
	[Bindable] private var _xmlEspaciosD:XML = <espacios></espacios>;
	[Bindable] private var _xmlEspaciosDE:XML = <espacios></espacios>;
	[Bindable] private var _xmlEspaciosNuevos:XML = <espacios></espacios>;
	private var httpDatos:HTTPServices = new HTTPServices;
	private var httpEspaciosA:HTTPServices = new HTTPServices;
	private var httpEspaciosD:HTTPServices = new HTTPServices;
	private var httpEspacioN:HTTPServices = new HTTPServices;
	private var httpAcCarreraA:HTTPServices = new HTTPServices;
	private var httpAcCarreraD:HTTPServices = new HTTPServices;
	private var httpCodCarreraA:HTTPServices = new HTTPServices;
	private var httpCodCarreraD:HTTPServices = new HTTPServices;
	private var httpCodEspacio:HTTPServices = new HTTPServices;	
	
	public function fncInit():void
	{
		httpDatos.url = "espaciosencarreras/espaciosencarreras.php";
		httpDatos.method = URLRequestMethod.POST;
		httpDatos.addEventListener("acceso",acceso);
		httpDatos.addEventListener(ResultEvent.RESULT,fncDatosResult);
		//preparo el autocomplete		
		acCarreraA.addEventListener(ListEvent.CHANGE,ChangeAcCarreraA);
		acCarreraA.addEventListener("close",CloseAcCarreraA);
		acCarreraA.labelField = "@nombre";
		//preparo el autocomplete		
		acCarreraD.addEventListener(ListEvent.CHANGE,ChangeAcCarreraD);
		acCarreraD.addEventListener("close",CloseAcCarreraD);
		acCarreraD.labelField = "@nombre";
		httpAcCarreraA.url = "espaciosencarreras/espaciosencarreras.php";
		httpAcCarreraA.addEventListener("acceso",acceso);
		httpAcCarreraA.addEventListener(ResultEvent.RESULT,fncCargarAcCarreraA);
		httpAcCarreraD.url = "espaciosencarreras/espaciosencarreras.php";
		httpAcCarreraD.addEventListener("acceso",acceso);
		httpAcCarreraD.addEventListener(ResultEvent.RESULT,fncCargarAcCarreraD);
		httpEspaciosA.url = "espaciosencarreras/espaciosencarreras.php";
		httpEspaciosA.addEventListener("acceso",acceso);
		httpEspaciosA.addEventListener(ResultEvent.RESULT,fncCargarespaciosA);
		httpEspaciosD.url = "espaciosencarreras/espaciosencarreras.php";
		httpEspaciosD.addEventListener("acceso",acceso);
		httpEspaciosD.addEventListener(ResultEvent.RESULT,fncCargarespaciosD);
		
		httpCodEspacio.url = "espaciosencarreras/espaciosencarreras.php";
		httpCodEspacio.addEventListener("acceso",acceso);
		httpCodEspacio.addEventListener(ResultEvent.RESULT,fncCargarEspacio);
		
		httpCodCarreraA.url = "espaciosencarreras/espaciosencarreras.php";
		httpCodCarreraA.addEventListener("acceso",acceso);
		httpCodCarreraA.addEventListener(ResultEvent.RESULT,fncCargarCarreraA);
		httpCodCarreraD.url = "espaciosencarreras/espaciosencarreras.php";
		httpCodCarreraD.addEventListener("acceso",acceso);
		httpCodCarreraD.addEventListener(ResultEvent.RESULT,fncCargarCarreraD);
		
		//preparo el autocomplete		
		acEspacioN.addEventListener(ListEvent.CHANGE,ChangeacEspacioN);
		acEspacioN.addEventListener("close",CloseacEspacioN);
		acEspacioN.labelField = "@denominacion";
		httpEspacioN.url = "espaciosencarreras/espaciosencarreras.php";
		httpEspacioN.addEventListener("acceso",acceso);
		httpEspacioN.addEventListener(ResultEvent.RESULT,fncCargarespacioN);
		btnAddUno.addEventListener("click",fncAddUno);
		btnAddTodos.addEventListener("click",fncAddTodos);
		btnDelUno.addEventListener("click",fncDelUno);
		btnDelTodos.addEventListener("click",fncDelTodos);
		btnDelUno.enabled = false;
		gridEspaciosD.addEventListener("change",fncChangeespaciosD);
		btnGuardar.addEventListener("click",fncGuardar);
		txiCodigoCA.addEventListener("focusOut",fncBuscarCarreraA);
		txiCodigoCD.addEventListener("focusOut",fncBuscarCarreraD);
		txiCodigoE.addEventListener("focusOut",fncBuscarEspacio);
	}
	
	private function fncBuscarEspacio(e:Event):void
	{
		if (txiCodigoE.text != "") {
			httpCodEspacio.send({rutina:"buscar_espacio",codigo:txiCodigoE.text});	
		}		
	}
	
	private function fncCargarEspacio(e:Event):void{
		acEspacioN.dataProvider = httpCodEspacio.lastResult.espacio;
		if (acEspacioN.selectedIndex!=-1) {
			AgregarEspacio();	
		}				
	}
	
	private function fncBuscarCarreraA(e:Event):void
	{
		if (txiCodigoCA.text != "") {
			httpCodCarreraA.send({rutina:"buscar_carrera",codigo:txiCodigoCA.text});	
		}		
	}
	
	private function fncBuscarCarreraD(e:Event):void
	{
		if (txiCodigoCD.text != "") {
			httpCodCarreraD.send({rutina:"buscar_carrera",codigo:txiCodigoCD.text});	
		}		
	}
	
	private function fncCargarCarreraA(e:Event):void{
		acCarreraA.dataProvider = httpCodCarreraA.lastResult.carrera;
		if (acCarreraA.selectedIndex!=-1) {
			httpEspaciosA.send({rutina:"traer_espacios",id_carrera:acCarreraA.selectedItem.@id_carrera});
		}	
	}
	
	private function fncCargarCarreraD(e:Event):void{
		acCarreraD.dataProvider = httpCodCarreraD.lastResult.carrera;
		if (acCarreraD.selectedIndex!=-1) {			
			httpEspaciosD.send({rutina:"traer_espacios",id_carrera:acCarreraD.selectedItem.@id_carrera});
		}		
	}
	
	private function fncDatosResult(e:Event):void {
		_xmlEspaciosA = <espacios></espacios>;
		_xmlEspaciosD = <espacios></espacios>;
		_xmlEspaciosNuevos = <espacios></espacios>;
		txiCodigoCA.text = "";
		txiCodigoCD.text = "";
		acCarreraA.text = "";
		acCarreraA.typedText = "";
		acCarreraA.selectedItem=null;
		acCarreraD.text = "";
		acCarreraD.typedText = "";
		acCarreraD.selectedItem=null;		
		Alert.show("El alta de espacios para la carrera se ha realizado con éxito.");		
	}
	
	private function fncGuardar(e:Event):void
	{		
		var error:String = '';
		if (acCarreraD.selectedItem==null) {
			error += "Debe seleccionar la carrera para la cual se asignan los espacios.\n";
		}
		if (_xmlEspaciosDE.espacios.length() > 0) {
			error += "La carrera seleccionada ya tiene espacios asignados previamente. Dirígase a la opción de 'Modificación de Espacios en Carreras' del Menú ";
			error += "para agregar o eliminar espacios asignados.\n";
		}
		if (error == '') {
			Alert.yesLabel = "Si";			 
    		Alert.show("Está a punto de incluir los espacios seleccionados en la carrera " + acCarreraD.selectedItem.@nombre + " ¿Confirmar?","Confirmación", Alert.YES | Alert.NO,null,fncConfirmGuardar);								
		} else {
			Alert.show(error,"E R R O R");
		}
	}
	
	private function fncConfirmGuardar(e:CloseEvent):void
	{
		if(e.detail==Alert.YES) 
		{
			httpDatos.send({rutina:"dar_alta",xmlEspacios:_xmlEspaciosD,id_carrera:acCarreraD.selectedItem.@id_carrera,
				cod_carrera:acCarreraD.selectedItem.@codigo});	
		}
	}
	
	/*
	* FunciÃ³n para ordenar los datos de la columna 'codigo' de manera numÃ©rica, no alfabÃ©tica:
	*/
    public function numericSort(a:*,b:*):int
    {
    	var nA:Number=Number(a.@codigo);
        var nB:Number=Number(b.@codigo);
        if (nA<nB){
         	return -1;
        }else if (nA>nB){
         	return 1;
        }else {
            return 0;
        }
    }
	
	private function fncChangeespaciosD(obj:Event):void
	{		
		if (gridEspaciosD.selectedIndex >= 0) {
			var xmlEspacio:XML = (gridEspaciosD.selectedItem as XML).copy();			
			if (xmlEspacio.@origen == 'A') 			
				btnDelUno.enabled = true;
			else
				btnDelUno.enabled = false;
		}			
	}
	
	private function fncCargarespacioN(e:Event):void{
		acEspacioN.typedText = acEspacioN.text;
		acEspacioN.dataProvider = httpEspacioN.lastResult.espacio;		
	}
	
	private function ChangeacEspacioN(e:Event):void{
		if (acEspacioN.text.length==3){
			httpEspacioN.send({rutina:"traer_espacios_n",denominacion:acEspacioN.text});
		}
	}
	
	private function AgregarEspacio():void
	{
		var xmlEspacioN:XML = <espacios id_espacio="" codigo="" denominacion="" origen=""/>;
		var existente : Boolean = false;
		for (var i:int = 0;i < _xmlEspaciosD.espacios.length();i++) {
			if (acEspacioN.selectedItem.@id_espacio == _xmlEspaciosD.espacios[i].@id_espacio) {
				existente = true;
			}
		}		
		if (existente == false) {			
			xmlEspacioN.@id_espacio = acEspacioN.selectedItem.@id_espacio;
			xmlEspacioN.@codigo = acEspacioN.selectedItem.@codigo;
			xmlEspacioN.@denominacion = acEspacioN.selectedItem.@denominacion;
			xmlEspacioN.@origen = acEspacioN.selectedItem.@origen;
			_xmlEspaciosD.appendChild(xmlEspacioN.copy());
			_xmlEspaciosNuevos.appendChild(xmlEspacioN.copy());	
		}
	}
	private function CloseacEspacioN(e:Event):void {
		if (acEspacioN.selectedIndex!=-1) {
			txiCodigoE.text = acEspacioN.selectedItem.@codigo;
			AgregarEspacio();	
		}								
	}
	
	public function fncEliminarEspacio():void
	{
		var xmlEspacio:XML = (gridEspaciosD.selectedItem as XML).copy();
		var index:int;
		delete _xmlEspaciosD.espacios[(gridEspaciosD.selectedItem as XML).childIndex()];		
		for (var i:int = 0;i < _xmlEspaciosNuevos.espacios.length();i++) {
			if (xmlEspacio.@id_espacio == _xmlEspaciosNuevos.espacios[i].@id_espacio) {
				index = i;
				break;
			}
		}
		delete _xmlEspaciosNuevos.espacios[index];
	}
	
	private function fncAddUno(e:Event):void
	{
		var xmlEspacio:XML = (gridEspaciosA.selectedItem as XML).copy();
		_xmlEspaciosD.appendChild(xmlEspacio);
		delete _xmlEspaciosA.espacios[(gridEspaciosA.selectedItem as XML).childIndex()];	
	}
	
	private function fncAddTodos(e:Event):void
	{
		for (var i:int = 0;i < _xmlEspaciosA.espacios.length();i++) {
			var xmlEspacio:XML = _xmlEspaciosA.espacios[i];
			_xmlEspaciosD.appendChild(xmlEspacio);
		}
		_xmlEspaciosA = <espacios></espacios>;			
	}
	
	private function fncDelTodos(e:Event):void
	{		
		for (var i:int = 0;i < _xmlEspaciosD.espacios.length();i++) {
			var xmlEspacio:XML = _xmlEspaciosD.espacios[i];
			if (_xmlEspaciosD.espacios[i].@origen == 'A') {
				_xmlEspaciosA.appendChild(xmlEspacio);				
			}		
		}
		_xmlEspaciosD = _xmlEspaciosNuevos.copy();
	}
	
	private function fncDelUno(e:Event):void
	{
		var xmlEspacio:XML = (gridEspaciosD.selectedItem as XML).copy();
		_xmlEspaciosA.appendChild(xmlEspacio);		
		delete _xmlEspaciosD.espacios[(gridEspaciosD.selectedItem as XML).childIndex()];	
	}
	
	private function fncCargarespaciosA(e:Event):void {
		_xmlEspaciosA = <espacios></espacios>;
		_xmlEspaciosA.appendChild(httpEspaciosA.lastResult.espacios);		
	}
	
	private function fncCargarespaciosD(e:Event):void {
		_xmlEspaciosDE = <espacios></espacios>;
		_xmlEspaciosDE.appendChild(httpEspaciosD.lastResult.espacios);		
	}
	
	private function ChangeAcCarreraA(e:Event):void{
		if (acCarreraA.text.length==3){
			httpAcCarreraA.send({rutina:"traer_carreras",nombre:acCarreraA.text});
		}
	}
	
	private function CloseAcCarreraA(e:Event):void {
		if (acCarreraA.selectedIndex!=-1) {
			txiCodigoCA.text = acCarreraA.selectedItem.@codigo;
			httpEspaciosA.send({rutina:"traer_espacios",id_carrera:acCarreraA.selectedItem.@id_carrera});
		}		
	}
		
	private function fncCargarAcCarreraA(e:Event):void{
		acCarreraA.typedText = acCarreraA.text;
		acCarreraA.dataProvider = httpAcCarreraA.lastResult.carrera;		
	}
	
	private function ChangeAcCarreraD(e:Event):void{
		if (acCarreraD.text.length==3){
			httpAcCarreraD.send({rutina:"traer_carreras",nombre:acCarreraD.text});
		}
	}
	
	private function CloseAcCarreraD(e:Event):void {
		if (acCarreraD.selectedIndex!=-1) {
			txiCodigoCD.text = acCarreraD.selectedItem.@codigo;
			httpEspaciosD.send({rutina:"traer_espacios",id_carrera:acCarreraD.selectedItem.@id_carrera});
		}
	}
		
	private function fncCargarAcCarreraD(e:Event):void{
		acCarreraD.typedText = acCarreraD.text;
		acCarreraD.dataProvider = httpAcCarreraD.lastResult.carrera;		
	}		
	
	private function fncCerrar(e:Event):void{
		dispatchEvent(new Event("eventClose"));
	}
	