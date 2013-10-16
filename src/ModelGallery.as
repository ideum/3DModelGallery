package  {
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.Trident;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.Parsers;
	import com.gestureworks.away3d.TouchManager2D;
	import com.gestureworks.away3d.utils.Math3DUtils;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class ModelGallery extends Sprite{ 		
		private var cameraPosition:Vector3D = new Vector3D(0, -0, -500);
		private var models:Array = [];
		private var modelNames:Array = [];
		private var touchSprites:Array = [];
		private var view:View3D;
		private var container:ObjectContainer3D;
		private var cameraController:HoverController;
		private var touchCamera:TouchSprite;
		private var tts:Array = [];
		private var loadCnt:uint = 0;
		private var popups:Array = [];
		private var cameraPositions:Array = [];
		private var fileList:Array = [];
		
		
		public function ModelGallery() {
			super();
		}
		
		public function init():void {
			initAway3d();
			
			fileList  = [
				"library/assets/models/clown.awd",
				"library/assets/models/coyote.awd"
			];
			
			modelNames = [ 
				"clown",
				"coyote"
			];
			
			cameraPositions = [
				292,
				50
			]
			
			Parsers.enableAllBundled();		
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceComplete);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);	
			AssetLibrary.load(new URLRequest(fileList[loadCnt]));
			
			popups = document.getElementsByTagName("ModelPopup");
		}
		
		protected function initAway3d():void {
			view = new View3D();
			view.backgroundColor = 0x000000;
			view.width = 1920;
			view.height = 1080;
			view.antiAlias = 4;
			view.camera.lens.far = 15000;
			addChild(view);
			cameraController = new HoverController( view.camera, null, 0, 0, 1); 
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
				
		private function assetComplete(e:AssetEvent):void {
			if (e.asset is ObjectContainer3D) {
				models.push(e.asset);
				e.asset.name = modelNames[loadCnt];
			}			
		}
		
		private function resourceComplete(e:LoaderEvent):void {				
			loadCnt++;			
			if (fileList.length == loadCnt) {
				initObjects();
			}
			else {
				AssetLibrary.load(new URLRequest(fileList[loadCnt]));
			}
		}
		
		private function initObjects():void {
			var t:TouchSprite;
			var p:Vector3D;
			for (var i:int = 0; i < models.length; i++) {				
				container.addChild(models[i]);
				p = Math3DUtils.sphericalToCartesian(new Vector3D(90*(i+1), 0, 300));	
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

		private function onTap(e:GWGestureEvent):void {
			var popup:ModelPopup = document.getElementById(e.target.vto.name);

			for (var i:int = 0; i < popups.length; i++) {
				if (popups[i].visible && popups[i] != popup) {
					popups[i].tweenOut();
				}
			}
			
			if (!popup.visible)
				popup.tweenIn();
			else
				popup.tweenOut();			
		}		
		
		private function onDrag(e:GWGestureEvent):void {
			e.target.vto.rotationY += e.value.drag_dx * .5;				
		}
		
		private function onScale(e:GWGestureEvent):void {
			e.target.vto.scaleX += e.value.scale_dsx;
			e.target.vto.scaleY += e.value.scale_dsx;
			e.target.vto.scaleZ += e.value.scale_dsx;
		}	
		
		private var haltDrag:Boolean = false;
		
		private function update(e:Event = null):void {
			view.render();			
		}	
		
		private var dragRight:Boolean = false;
		
		private function onCameraDrag(e:GWGestureEvent):void {
			var drag:Number;
			
			if (TweenMax.isTweening(cameraController)) 
				return;
		
			drag = e.value.drag_dx * .1;
			
			if (drag > 0) {
				dragRight = true;
				if (drag < .05) {
					cameraController.panAngle -= e.value.drag_dx * .1;
				}
			}
			else if (drag < 0) {
				dragRight = false;
				if (drag < .05) {
					cameraController.panAngle -= e.value.drag_dx * .1;
				}
				cameraController.panAngle -= e.value.drag_dx * .1;
			}
			else {
				TweenMax.to(cameraController, .25, { panAngle:292 } );
			}
			
			//cameraController.tiltAngle -= e.value.drag_dy * .1;
		}	
					
	}
}