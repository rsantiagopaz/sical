// ActionScript file
	import clases.HTTPServices;
	
	import conscomcarreras.carrera;
	
	import flash.events.Event;
	
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	
	
	include "../control_acceso.as";
	
	[Bindable] private var _xmlCarreras:XML = <carreras></carreras>;
	[Bindable] private var _xmlNiveles:XML = <niveles></niveles>;	
	private var httpDatos:HTTPServices = new HTTPServices;
	private var httpDatos2:HTTPServices = new HTTPServices;
	private var twCarrera:carrera;
	
	public function get xmlNiveles():XML { return _xmlNiveles }
	
	public function get xmlCarreras():XML { return _xmlCarreras }
	
	
	public function fncInit():void
	{		
		httpDatos.url = "conscomcarreras/conscomcarreras.php";
		httpDatos.addEventListener("acceso",acceso);
		httpDatos.addEventListener(ResultEvent.RESULT,fncCargarDatos);		
		httpDatos2.url = "carreras/carreras.php";
		httpDatos2.addEventListener("acceso",acceso);
		httpDatos2.addEventListener(ResultEvent.RESULT,fncCargarDatos2)
		httpDatos2.send({rutina:"traer_datos2"});		
		btnCerrar.addEventListener("click" ,fncCerrar);
		txtNombre.addEventListener("change",fncTraerCarreras);
		btnBuscar.addEventListener("click",fncTraerEscuelasBoton);
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
	
	private function fncTraerCarreras(e:Event):void{
		if (chkComodin.selected == false) {
			if (txtNombre.text.length==3){
				httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
			}
			if(txtNombre.text.length>3){
			
		  		gridCarreras.dataProvider.filterFunction = filtroTexto;
	            gridCarreras.dataProvider.refresh();			
			}
		}		
	}
	
	public function fncEditar():void
	{
		twCarrera = new carrera;
		twCarrera.xmlCarrera =  (gridCarreras.selectedItem as XML).copy();		
		PopUpManager.addPopUp(twCarrera,this,true);
		PopUpManager.centerPopUp(twCarrera);
	}
	
	private function filtroTexto (item : Object) : Boolean
	{
		return item.@nombre.toString().substr(0, txtNombre.text.length).toLowerCase() == txtNombre.text.toLowerCase();   
	}
	
	private function fncTraerEscuelasBoton(e:Event):void{
		if (chkComodin.selected == false)
			httpDatos.send({rutina:"traer_datos",filter:txtNombre.text});
		else
			httpDatos.send({rutina:"buscar_carrera",filter:txtNombre.text});
	}
	
	private function fncCargarDatos(e:Event):void {
		_xmlCarreras = <carreras></carreras>;
		_xmlCarreras.appendChild(httpDatos.lastResult.carrera);				
	}
	
	private function fncCargarDatos2(e:Event):void {		
		_xmlNiveles.appendChild(httpDatos2.lastResult.niveles);		
	}
	
	private function fncCerrar(e:Event):void{
		dispatchEvent(new Event("eventClose"));
	}		
	