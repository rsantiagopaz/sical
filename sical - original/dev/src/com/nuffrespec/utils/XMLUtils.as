/**
 *	@author		Daniel Bulli
 *	@email		daniel.bulli@beamland.com
 *	@link		http://www.beamland.com
 *	@version	1.0
 *
 *	@history
 *	07-17-2008		dbulli		Initial Version
 *
 */
 package com.nuffrespec.utils
{

	/**
	 * A set of useful XML utilities
	 *
	 */
	public class XMLUtils
	{

		/**
		 * Sort an XML based on an attibute
		 *
		 * @param	$xml			XML to sort (it is modified)
		 * @param	$attrubute		Attribute to sort on
		 * @param	$options		One or more numbers or defined constants, separated by the <code>|</code> (bitwise OR) operator, that change the behavior of the sort from the default. This argument is optional. The following values are acceptable for <code>sortOptions</code>:
									<ul>
										<li>1 or <code>Array.CASEINSENSITIVE</code></li>
										<li>2 or <code>Array.DESCENDING</code></li>
										<li>4 or <code>Array.UNIQUESORT</code></li>
										<li>8 or <code>Array.RETURNINDEXEDARRAY</code></li>
										<li>16 or <code>Array.NUMERIC</code></li>
									</ul>
									For more information, see the <code>Array.sortOn()</code> method.
									http://livedocs.adobe.com/flex/3/langref/Array.html#sortOn()
		 * @param	$copy			If false original XML is modified, if true original XML is unmodified
		 * @return	The resulting XML object.
		 */
		 public static function sortXMLByAttribute($xml:XML, $attribute:String, $options:Object=null, $copy:Boolean=false):XML
		 {
			//store in array to sort on
			var xmlArray:Array	= new Array();

			var item:XML;
			for each(item in $xml.children())
			{
				var object:Object = {data: item, order: item.attribute($attribute)};
				xmlArray.push(object);
			}
			xmlArray.sortOn('order',$options);

			var sortedXmlList:XMLList = new XMLList();
			var xmlObject:Object;
			for each(xmlObject in xmlArray )
			{
				sortedXmlList += xmlObject.data;
			}

			if($copy)
			{
				return	$xml.copy().setChildren(sortedXmlList);
			}
			else
			{
				return $xml.setChildren(sortedXmlList);
			}
		 }

	}
}