package  {
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.Parsers;
	import com.gestureworks.away3d.TouchManager2D;
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 */
	public class ModelGallery extends Sprite{ 
		
		private var cameraPosition:Vector3D = new Vector3D(0, -0, -500);
		
		private var models:Array = [];
		private var touchSprites:Array = [];
		private var view:View3D;
		private var container:ObjectContainer3D;
		private var load:int = 2;
		private var loaded:int = 0;
		private var cameraController:HoverController;

		public function ModelGallery() {
			super();
		}
		
		public function init():void {
			initAway3d();
			Parsers.enableAllBundled();		
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, initObjects);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);	
			AssetLibrary.load(new URLRequest("library/assets/models/clown.awd"));
			AssetLibrary.load(new URLRequest("library/assets/models/coyote.awd"));			
		}
		
		protected function initAway3d():void {
			view = new View3D();
			view.backgroundColor = 0x000000;
			view.width = 1920;
			view.height = 1080;
			view.antiAlias = 4;
			view.camera.lens.far = 15000;
			addChild(view);
			cameraController = new HoverController( view.camera, null, 0, 0, -400); 
			cameraController.yFactor = 1;
			cameraController.wrapPanAngle = true;			
			cameraController.minTiltAngle = -30;		
			cameraController.maxTiltAngle = 0;		
			
			container = new ObjectContainer3D;
			container.rotationX = 0;
			container.rotationY = 0;
			container.rotationZ = 0;
			view.scene.addChild(container);
			
			//var axis:Trident = new Trident(180); 
			//view.scene.addChild(axis);	
			
			touchCamera = new TouchSprite(view);
			touchCamera.gestureList = { "n-drag":true };
			touchCamera.releaseInertia = true;
			touchCamera.addEventListener(GWGestureEvent.DRAG, onCameraDrag);			

			addEventListener( Event.ENTER_FRAME, update );			
		}
				
		private var touchCamera:TouchSprite;
		private var tts:Array = [];
		
		private function assetComplete(e:AssetEvent):void {
			if (e.asset is ObjectContainer3D) {
				models.push(e.asset);
			}

		}
		
		private function initObjects(e:LoaderEvent):void {	
			loaded++;
			if (load == loaded)
				initGestures();
		}
		
		private function initGestures():void {
			var ts:TouchSprite;
			var t:TouchSprite;
			for (var i:int = 0; i < models.length; i++) {				
				container.addChild(models[i]);
				var p:Vector3D = sphericalToCartesian(new Vector3D(180*(i+1), 0, 200));	
				models[i].x = p.x;
				models[i].y = p.y;
				models[i].z = p.z;
				
				t = TouchManager2D.registerTouchObject(models[i]);
				t.gestureList = { "n-drag":true, "n-tap":true, "n-scale":true };					
				t.addEventListener(GWGestureEvent.DRAG, onDrag);					
				t.addEventListener(GWGestureEvent.TAP, onTap);		
				t.addEventListener(GWGestureEvent.SCALE, onScale);		
				t.releaseInertia = true;					
				touchSprites.push(t);				
			}
		}

		private function onTap(e:GWGestureEvent):void
		{
			trace("tap2D");	
			
			trace(e.target.vto);
			trace(e.target.vto);
		}		
		
		private function onDrag(e:GWGestureEvent):void
		{
			trace("drag2D");
			e.target.vto.rotationY += e.value.drag_dx * .5;				
		}
		
		private function onScale(e:GWGestureEvent):void
		{
			e.target.vto.scaleX += e.value.scale_dsx;
			e.target.vto.scaleY += e.value.scale_dsx;
			e.target.vto.scaleZ += e.value.scale_dsx;
		}	
		
		private function update(e:Event=null):void 
		{
			view.render();			
		}	
		
		private function onCameraDrag(e:GWGestureEvent):void
		{
			cameraController.panAngle += e.value.drag_dx * .25;
			cameraController.tiltAngle -= e.value.drag_dy * .25;
		}	
		
		public function sphericalToCartesian(sphericalCoords:Vector3D):Vector3D
		{
			var cartesianCoords:Vector3D = new Vector3D();
			var r:Number = sphericalCoords.z;
			cartesianCoords.y = r*Math.sin(-sphericalCoords.y);
			var cosE:Number = Math.cos(-sphericalCoords.y);
			cartesianCoords.x = r*cosE*Math.sin(sphericalCoords.x);
			cartesianCoords.z = r*cosE*Math.cos(sphericalCoords.x);
			return cartesianCoords;
		}			
	
	}

}