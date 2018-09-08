/**
 *	@author		Daniel Bulli
 *	@link		http://www.nuff-respec.com
 *	@version	1.0
 *
 *	@history
 *	07-18-2008		dbulli		Initial Version
 */
 package
{
	import com.nuffrespec.utils.XMLUtils;

	import flash.display.Sprite;

	public class XMLUtilExample extends Sprite
	{
		public function XMLUtilExample()
		{
			var xml:XML =
						<body id="someId">
							<p displayOrder="15">Hello</p>
							<p displayOrder="7">World</p>
							<p displayOrder="3">Is</p>
							<p displayOrder="9">This</p>
							<p displayOrder="25">Thing</p>
							<p displayOrder="13">Working</p>
						</body>;

			// original XML object
			trace("Xml BEFORE sort:\n" + xml + "\n");

			XMLUtils.sortXMLByAttribute(xml,'displayOrder');
			trace("Default sort\n" + xml + "\n");

			XMLUtils.sortXMLByAttribute(xml,'displayOrder', Array.NUMERIC);
			trace("Array.NUMERIC:\n" + xml + "\n");

			var reverseXML:XML = XMLUtils.sortXMLByAttribute(xml,'displayOrder', Array.NUMERIC | Array.DESCENDING, true);
			trace("Original untouched:\n" + xml + "\n");
			trace("Array.NUMERIC | Array.DESCENDING:\n" + reverseXML + "\n");
		}

	}
}