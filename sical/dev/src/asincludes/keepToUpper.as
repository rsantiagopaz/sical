// ActionScript file

	/*********************************************************************
	 ******************** Funciones Auxiliares ***************************
	 * ******************************************************************/
	private function keepToUpper(event:Event):void
	{
   		var targetText:TextInput;
   		targetText = event.target as TextInput;
   		targetText.text = targetText.text.toUpperCase();
	}
	/********************************************************************/
