import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.DataGrid;
import mx.utils.ObjectUtil;

public function sinAcentos(textoConAcentos:String):String {
	var texto1:String=textoConAcentos as String;
	texto1=textoConAcentos.toLowerCase();
	var acentos:Array=new Array("á","é","í","ó","ú");
	var sinAcentos:Array=new Array("a","e","i","o","u");
	function quitarAcentos(texto:String,letraSplit:String,letraCambio:String):String {
		var letras:Array=texto.split(letraSplit);
		var nuevoTexto:String=new String();
		for (var i:uint=0;i < letras.length;i++) {
			nuevoTexto+=letras[i];
			nuevoTexto+=letraCambio;
		}
		nuevoTexto=nuevoTexto.substring(0,nuevoTexto.length-1);
		return nuevoTexto;
	}
	for (var i:uint=0; i < acentos.length; i++) {
		texto1=quitarAcentos(texto1,acentos[i],sinAcentos[i]);
	}
	return texto1;
}

public function doCaselessSortForField(field:String):Function
{
	return function(obj1:Object, obj2:Object):int
	{
		return mx.utils.ObjectUtil.stringCompare(sinAcentos(obj1[field]),sinAcentos(obj2[field]),true);
	}
}

public function getSortOrder(grid:DataGrid):Array
{		
	var sortList:Array = [];
	try {
		var s:SortField = Sort(grid.dataProvider.sort).fields[0];
		var order:String = (s.descending == true) ? "DESC" : "ASC"
		sortList[0] = "sorted";
		sortList[1] = s.name;
		sortList[2] = order;
	} catch (err:*) {
		sortList[0] = "unsorted";
		sortList[1] = "";
		sortList[2] = "";
	}
	return sortList;
}