package 
{
	import com.gestureworks.away3d.Away3DTouchManager;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.events.*;
	import flash.events.Event;
	import com.gestureworks.cml.core.CMLAway3D; CMLAway3D;
	ModelPopup;
	ModelGallery;
	Model2;



	[SWF(width = "1920", height = "1080", backgroundColor = "0x000000", frameRate = "60")]

	public class Main extends GestureWorks
	{
		public function Main():void 
		{
			super();
			cml = "library/cml/main.cml";
			gml = "library/gml/gestures.gml";
			
			// add this event listener so we know when the CML parsing is complete
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
		}
	
		override protected function gestureworksInit():void
 		{
			trace("gestureWorksInit()");			
		}
		
		private function cmlInit(event:Event):void
		{
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlInit);
			trace("cmlInit()");
			Away3DTouchManager.initialize();
			var mg:ModelGallery =  new ModelGallery();
			addChild(mg);
			mg.init();
		}

	}
}