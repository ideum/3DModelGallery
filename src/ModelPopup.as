package {
	
	import com.gestureworks.cml.core.CMLObjectList;
	import com.gestureworks.cml.element.Button;
	import com.gestureworks.cml.element.TouchContainer;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	import com.greensock.TweenMax;
	import flash.events.Event;
	import flash.events.TouchEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class ModelPopup extends TouchContainer {
		
		public var button:Button;
		public var modelGallery:ModelGallery;
		
		public function ModelPopup() {
			super();
			mouseChildren = true;
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
			visible = false;
		}
		
		private function cmlInit(event:Event):void {
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlInit);
			button = searchChildren(Button); 
			button.addEventListener(GWGestureEvent.TAP, onButtonTap);
			addEventListener(GWTouchEvent.TOUCH_BEGIN, onTouchBegin);
		}
		
		private function onButtonTap(e:GWGestureEvent):void {
			TweenMax.to(this, .25, { alpha:0, onComplete:hide } );
			function hide():void {
				visible = false;
				alpha = 1;
			}
		}	
		
		private function onTouchBegin(e:GWTouchEvent):void {
			parent.addChild(this);
		}		
		
	}
}