/**
 * Numerically sorts a column in the DataGrid.
 *
 * @param	fieldName	The string name for the dataField in the column that you want to sort.
 */
import mx.utils.ObjectUtil;

private function numericSortByField(fieldName:String):Function
{
	return function(obj1:Object, obj2:Object):int
	{
		var value1:Number = (obj1[fieldName] == '' || obj1[fieldName] == null) ? null : new Number(obj1[fieldName]);
		var value2:Number = (obj2[fieldName] == '' || obj2[fieldName] == null) ? null : new Number(obj2[fieldName]);
		return ObjectUtil.numericCompare(value1, value2);
	}
}