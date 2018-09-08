// ActionScript file
	import clases.HTTPServices;
	
	import conscomespacios.espacio;
	
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
		btnCerrar.addEventListener("click" ,fncCerrar);
		txtNombre.addEventListener("change",fncTraerEspacios);
		btnBuscar.addEventListener("click",fncTraerEspaciosBoton);
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
	
	public function fncEditar():void
	{
		twEspacio = new espacio;
		twEspacio.xmlEspacio =  (gridEspacios.selectedItem as XML).copy();		
		PopUpManager.addPopUp(twEspacio,this,true);
		PopUpManager.centerPopUp(twEspacio);
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
	