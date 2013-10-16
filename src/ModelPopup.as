package {
	
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.element.Button;
	import com.gestureworks.cml.element.TouchContainer;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	import com.greensock.TweenMax;
	import flash.events.Event;
	
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
			tweenOut();
		}	
		
		private function onTouchBegin(e:GWTouchEvent):void {
			parent.addChild(this);
		}	
		
		public function tweenIn():void {
			if (TweenMax.isTweening(this)) return;
			rotation = 0;
			x = stage.stageWidth / 2 + 100;
			y = stage.stageHeight / 2 - 100;			
			alpha = 0;			
			visible = true;
			TweenMax.to(this, .25, { alpha:1 } );
		}
		
		public function tweenOut():void {
			if (TweenMax.isTweening(this)) return;
			TweenMax.to(this, .25, { alpha:0, onComplete:hide } );
			function hide():void {
				alpha = 1;
				visible = false;
			}
		}		
		
	}
}