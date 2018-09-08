// ActionScript file
	import clases.HTTPServices;
	
	import espacios.espacio;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	
	include "../control_acceso.as";
	
	[Bindable] private var _xmlEspacios:XML = <espacios></espacios>;	
	private var httpDatos:HTTPServices = new HTTPServices;	
	private var twEspacio:espacio;		
	
	
	public function fncInit():void
	{		
		httpDatos.url = "espacios/espacios.php";
		httpDatos.addEventListener("acceso",acceso);
		httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);		
		btnNuevoEspacio.addEventListener("click" ,fncAgregarEspacio);
		btnCerrar.addEventListener("click" ,fncCerrar);
		txtNombre.addEventListener("change",fncTraerEspacios);
		btnBuscar.addEventListener("click",fncTraerEspaciosBoton);
		txiCodigoE.addEventListener("focusOut",fncBuscarEspacio);
		txiCodigoE.setFocus();
	}
	
	private function fncBuscarEspacio(e:Event):void
	{
		if (txiCodigoE.text != "") {
			httpDatos.send({rutina:"buscar_espacio_codigo",codigo:txiCodigoE.text});	
		}		
	}
	
	/*
	* Función para ordenar los datos de la columna 'total' de manera numérica, no alfabética:
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
	
	private function fncTraerEspacios(e:Event):void{
		if (chkComodin.selected == false) {
			if (txtNombre.text.length==3){
				httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
			}
			if(txtNombre.text.length>3){
			
		  		gridEspacios.dataProvider.filterFunction = filtroTexto;
	            gridEspacios.dataProvider.refresh();			
			}
		}		
	}
	
	private function filtroTexto (item : Object) : Boolean
	{
		return item.@denominacion.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
	}
	
	private function fncTraerEspaciosBoton(e:Event):void{
		if (chkComodin.selected == false)
			httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
		else
			httpDatos.send({rutina:"buscar_espacio",filter:txtNombre.text});
	}
	
	private function fncCargarDatos(e:Event):void {
		_xmlEspacios = <espacios></espacios>;
		_xmlEspacios.appendChild(httpDatos.lastResult.espacios);		
	}
	
	private function fncCerrar(e:Event):void{
		dispatchEvent(new Event("eventClose"));
	}
	
	private function fncAgregarEspacio(e:Event):void
	{
		twEspacio = new espacio;
		twEspacio.addEventListener("EventAlta",fncAltaEspacios);
		PopUpManager.addPopUp(twEspacio,this,true);
		PopUpManager.centerPopUp(twEspacio);
	}
	
	private function fncAltaEspacios(e:Event):void{
		var xmlEspacio : XML = twEspacio.xmlEspacio;
		_xmlEspacios.appendChild(xmlEspacio);
		PopUpManager.removePopUp(e.target as espacio);		
	}
	
	public function fncEditar():void
	{
		twEspacio = new espacio;
		twEspacio.xmlEspacio =  (gridEspacios.selectedItem as XML).copy();
		twEspacio.addEventListener("EventEdit",fncEditarEspacio);
		PopUpManager.addPopUp(twEspacio,this,true);
		PopUpManager.centerPopUp(twEspacio);
	}
	
	public function fncEliminar():void
	{
		twEspacio = new espacio;
		twEspacio.xmlEspacio2 =  (gridEspacios.selectedItem as XML).copy();
		twEspacio.addEventListener("EventDelete",fncEliminarEspacio);
		PopUpManager.addPopUp(twEspacio,this,true);
		PopUpManager.centerPopUp(twEspacio);
	}
	
	private function fncEditarEspacio(e:Event):void
	{
		_xmlEspacios.espacios[(gridEspacios.selectedItem as XML).childIndex()] = twEspacio.xmlEspacio;
		PopUpManager.removePopUp(e.target as espacio);		
	}
	
	private function fncEliminarEspacio(e:Event):void
	{
		delete _xmlEspacios.espacios[(gridEspacios.selectedItem as XML).childIndex()];
		PopUpManager.removePopUp(e.target as espacio);		
	}
	