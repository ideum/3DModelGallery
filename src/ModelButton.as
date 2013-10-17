package {
	
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.element.Button;
	import com.gestureworks.cml.element.Image;
	import com.gestureworks.cml.element.TouchContainer;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.events.GWTouchEvent;
	import com.greensock.TweenMax;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class ModelButton extends Image {
		
		public var tapFn:Function;
		private var alphaMin:Number = .25;
		private var alphaMax:Number = .80;
		
		public function ModelButton() {
			super();
			mouseChildren = false;
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
		}
		
		private function cmlInit(event:Event):void {
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlInit);
			alpha = alphaMin;
			gestureList = { "n-tap":true };
			addEventListener(GWGestureEvent.TAP, onButtonTap);
		}
		
		private function onButtonTap(e:GWGestureEvent):void {
			if (tapFn != null)
				tapFn.call(null, id);
			if (alpha == alphaMin)
				tweenIn();	
			else
				tweenOut();
		}	
		
		public function tweenIn():void {
			if (TweenMax.isTweening(this)) 
				TweenMax.killTweensOf(this);
			TweenMax.to(this, .25, { alpha:alphaMax } );
		}
		
		public function tweenOut():void {
			if (TweenMax.isTweening(this)) 
				TweenMax.killTweensOf(this);
			TweenMax.to(this, .25, {alpha:alphaMin});
		}		
		
	}
}