package {
	
	import com.gestureworks.cml.away3d.elements.Model;
	import com.gestureworks.cml.events.StateEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class Model2 extends Model { 
				
		public function Model2() {
			super();
			addEventListener(StateEvent.CHANGE, onLoad);
		}
		
		private function onLoad(e:StateEvent):void {
			trace("loaded: ", src);
		}
		
	}
}