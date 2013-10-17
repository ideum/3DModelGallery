package  {
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.math.MathConsts;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.Parsers;
	import com.gestureworks.away3d.TouchManager2D;
	import com.gestureworks.away3d.utils.Math3DUtils;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.cml.utils.NumberUtils;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import com.greensock.TweenLite; 
	import com.greensock.plugins.TweenPlugin; 
	import com.greensock.plugins.ShortRotationPlugin; 	
	
	public class ModelGallery extends Sprite{ 		
		private var models:Array = [];
		private var modelNames:Array = [];
		private var modelIndex:Number = 1;
		private var modelButtons:Array = [];	
		private var modelPositions:Array = [];
		private var modelScales:Array = [];
		private var modelScaleMap:Dictionary = new Dictionary;
		private var modelY:Array = [];
		
		private var minScale:Number = .75;
		private var maxScale:Number = 1.25;
		
		private var touchSprites:Array = [];
		private var view:View3D;
		private var container:ObjectContainer3D;
		private var cameraController:HoverController;
		private var touchView:TouchSprite;
		private var loadCnt:uint = 0;
		private var popups:Array = [];
		private var fileList:Array = [];
		private var dragRight:Boolean = false;
		private var initialized:Boolean = false;
		
		public function ModelGallery() {
			TweenPlugin.activate([ShortRotationPlugin]);	
			super();
		}
		
		public function init():void {
			initAway3d();
			
			fileList  = [
				"library/assets/models/star-blanket.awd",
				"library/assets/models/stone-sculpture.awd",				
				"library/assets/models/clown.awd",
				"library/assets/models/coyote.awd"
			];
			
			modelNames = [ 
				"star-blanket",							
				"stone-sculpture",			
				"clown",
				"coyote"
			];
			
			modelPositions = [
				0,
				90,
				180,
				270
			]
			
			modelY = [
				0,
				0,
				0,
				-5
			]			
			
			modelScales = [
				.75,
				.4,
				1.1,
				.5
			]
			
			for (var j:int = 0; j < modelNames.length; j++) {
				modelScaleMap[modelNames[j]] = modelScales[j];
			}
						
			Parsers.enableAllBundled();		
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceComplete);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);	
			AssetLibrary.load(new URLRequest(fileList[loadCnt]));
			
			popups = document.getElementsByTagName("ModelPopup");
			modelButtons = document.getElementsByTagName("ModelButton");
			
			for (var i:int = 0; i < modelButtons.length; i++) {
				modelButtons[i].tapFn = onModelButtonTap;
			}			
		}
		
		protected function initAway3d():void {
			view = new View3D();
			view.backgroundColor = 0x000000;
			view.width = 1920;
			view.height = 1080;
			view.antiAlias = 4;
			view.camera.lens.far = 15000;
			addChild(view);
			cameraController = new HoverController( view.camera, null, 0, 0, -1); 
			cameraController.yFactor = 1;
			cameraController.wrapPanAngle = true;			
			cameraController.minTiltAngle = -30;		
			cameraController.maxTiltAngle = 0;		
			
			container = new ObjectContainer3D;
			container.rotationX = 0;
			container.rotationY = 0;
			container.rotationZ = 0;
			view.scene.addChild(container);
			
			touchView = new TouchSprite(view);
			touchView.gestureList = { "n-drag":true };
			touchView.releaseInertia = true;
			touchView.addEventListener(GWGestureEvent.DRAG, onContainerDrag);			
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
				p = Math3DUtils.sphericalToCartesian(new Vector3D( (modelPositions[i] ) , 0, 150));				
				models[i].x = p.x;
				models[i].y = modelY[i];
				models[i].z = p.z;
				models[i].scaleX = modelScales[i];
				models[i].scaleY = modelScales[i];
				models[i].scaleZ = modelScales[i];				
				
				t = TouchManager2D.registerTouchObject(models[i]);
				t.gestureList = { "n-drag":true, "n-tap":true, "n-scale":true };					
				t.addEventListener(GWGestureEvent.DRAG, onModelDrag);					
				t.addEventListener(GWGestureEvent.TAP, onModelTap);		
				t.addEventListener(GWGestureEvent.SCALE, onModelScale);		
				t.releaseInertia = true;					
				touchSprites.push(t);				
			}
			initialized = true;
		}
		
		private function update(e:Event = null):void {
			if (initialized) {
				updateModelButtons();
				view.render();
			}
		}			
		
		private function onModelDrag(e:GWGestureEvent):void {
			e.target.vto.rotationY -= e.value.drag_dx * .5;	
		}
		
		private function onModelScale(e:GWGestureEvent):void {
			var val:Number = e.target.vto.scaleX + e.value.scale_dsx * .75;
			var orig:Number = modelScaleMap[e.target.vto.name];
			
			if (val < (minScale * orig))
				val = minScale * orig;
			else if (val > (maxScale * orig))
				val = maxScale * orig;
				
			e.target.vto.scaleX = val;
			e.target.vto.scaleY = val;
			e.target.vto.scaleZ = val;
		}	
		
		private function onModelTap(e:GWGestureEvent):void {
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
				
		
		
		private function onContainerDrag(e:GWGestureEvent):void {
			container.rotationY += e.value.drag_dx * .1;
		}	
		

		
		private function updateModelButtons():void {	
			
			// TODO: reduce redundant code
			for (var i:int = 0; i < modelPositions.length; i++) {
				if (container.rotationY <= 0) {
					if (-modelPositions[i] >= (container.rotationY % 360) - 45 && 
						-modelPositions[i] < (container.rotationY % 360) + 45) {
						if (i != modelIndex) {
							if (popups[modelIndex].visible) {
								popups[modelIndex].tweenOut();
							}
							for each (var item:ModelButton in modelButtons) {
								if ( item != modelButtons[i])
									modelButtons[modelIndex].tweenOut();
							}
							modelButtons[i].tweenIn();
							modelIndex = i;
						}					
					}
				}
				else {			
					if (modelPositions[i] >= (360 - (container.rotationY % 360) - 45) && 
						modelPositions[i] < (360 - (container.rotationY % 360) + 45) ) {
						if (i != modelIndex) {
							if (popups[modelIndex].visible) {
								popups[modelIndex].tweenOut();
							}
							for each (var item:ModelButton in modelButtons) {
								if ( item != modelButtons[i])
									modelButtons[modelIndex].tweenOut();
							}							
							modelButtons[i].tweenIn();
							modelIndex = i;
						}					
					}					
				}
			}		
		}
		
		private function onModelButtonTap(targetId:String):void {
			
			// TODO: take the shortest route to rotation
			for (var i:int = 0; i < modelNames.length; i++) {
				if ( (targetId == modelNames[i]  + "-button")) {	
					container.rotationY = container.rotationY  % 360;
					TweenMax.to(container, 1, { shortRotation:{ rotationY:-modelPositions[i] } });
					break;
				}
			}
			trace(targetId);
		}
					
	}
}