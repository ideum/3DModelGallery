package  {
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.lights.DirectionalLight;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.MaterialBase;
	import com.gestureworks.away3d.*;
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.away3d.utils.*;
	import com.gestureworks.away3d.utils.Math3DUtils;
	import com.gestureworks.cml.away3d.geometries.CubeGeometry;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.core.TouchSprite;
	import com.gestureworks.events.GWGestureEvent;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	

	public class ModelGallery extends Sprite { 	

		private var hitMeshAlpha:Number = 0;
		
		private var minScale:Number = .75;
		private var maxScale:Number = 1.5;		
		
		private var models:Array = [];
		private var modelNames:Array = [];
		private var modelIndex:Number = 1;
		private var modelButtons:Array = [];	
		private var modelPositions:Array = [];
		private var modelScales:Array = [];
		private var modelScaleMap:Dictionary = new Dictionary;
		private var modelY:Array = [];
		private var modelRotationsX:Array = [];
		private var modelRotationsY:Array = [];

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
		private var leapTouch:TouchSprite;
		
		private var vis3d:MotionVisualizer3D;
		
		private var hitGeometry:CubeGeometry;
		
		private var light:DirectionalLight;
		private var lightPicker:StaticLightPicker;
		
		public function ModelGallery() {
			TweenPlugin.activate([ShortRotationPlugin]);
			super();
		}
		
		public function init():void {
			
			fileList  = [
				"library/assets/molecules/caffeine.awd",
				"library/assets/molecules/taurine.awd",
				"library/assets/molecules/vitamin-b6.awd"
			];
			
			modelNames = [ 
				"caffeine",	
				"taurine",
				"vitamin-b6"
			];
			
			modelPositions = [
				0,
				120,
				240,
			];
			
			modelRotationsX = [
				45,
				45,
				45
			];
			
			modelRotationsY = [
				0,
				125,
				24
			];
			
			view = new View3D();
			view.backgroundColor = 0x000000;
			view.width  = 1920;
			view.height = 1080;
			view.antiAlias = 4;
			view.camera.lens.far = 15000;
			addChild(view);
			
			//cameraController = new HoverController(view.camera, null, 180, 30, 400); // GREAT FOR VIEWING THE SKELETAL MODEL IN NATIVE 3D SPACE
			cameraController = new HoverController(view.camera, null, 180, 0, 100);
			
			
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
				touchView.nativeTransform = false; // MUST BE MANUALLY SET TO FALSE
				touchView.affineTransform = false; // MUST BE MANUALLY SET TO FALSE
			touchView.mouseChildren = true;
				touchView.motionEnabled = true; // ENABLES THE TOUCH SPRITE TO PROCESS MOTION GESTURES
				touchView.transform3d = false; // ENSURES THAT THE 3D MOTION INTERACTION POINTS ARE PROJECTED INTO THE 2D STAGE
				touchView.gestureEvents = true; // ACTIVATES THE OBJECT GESTURE EVENT PIPELINE 
				touchView.motionClusterMode = "global"; // CONFIGURES THE TOUCH SPRITE TO GLOBALLY COLLECT ALL 3D MOTION INTERACTION POINTS FROM THE SKELETAL MODEL
				
				// IN THS EXAMPLE THERE IS A TOUCH GESTURE AND A MOTION GESTURE PRIMATIVE
				// 1. A PALM DRAG/PAN GESTURE THAT REQUIRES A FULLY CLOSED FIST (FACING DOWN)
				// THIS WILL PAN THE CARASELE VIEW
				touchView.gestureList = { "n-drag-inertia":true, "3dmotion-1-palm-2dtranslate":true };
				// A SIMPLE N TOUCH DRAG GESTURE LISTENER
				touchView.addEventListener(GWGestureEvent.DRAG, onContainerDrag);
				// A MOTION SINGLE PALM DRAG GESTURE LISTNER
				touchView.addEventListener(GWGestureEvent.MOTION_DRAG, onContainerMotionDrag);
				
			addEventListener( Event.ENTER_FRAME, update );				
			
			Parsers.enableAllBundled();		
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceComplete);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);	
			AssetLibrary.load(new URLRequest(fileList[loadCnt]));
			
			popups = document.getElementsByTagName(ModelPopup);
			modelButtons = document.getElementsByTagName(ModelButton);
			
			for (var i:int = 0; i < modelButtons.length; i++) {
				modelButtons[i].tapFn = onModelButtonTap;
			}
			
			///////////////////////////////////////////////
			// 2D DEBUG TOUCHSPRITE
			///////////////////////////////////////////////
			// THIS IS USED AS A WAY TO DISPLAY ISOGRAPHICALLY PROJECTED 3D DATA
			// FROM THE 3D INTERACTION POINTS CREATED BY THE HAND MODEL ON THE INTERACTIVE 3D DISPLAY OBJECTS
			// SINCE THE 3D DISPLAY OBJECTS ARE ON STAGE3D USING AN 2D SIMPLIFIED DISPLAY CAN BE USEFUL
			
			var td:TouchSprite = new TouchSprite();
				td.mouseChildren = true; // ALLOWS TOUCH POINTS TO PASS INTO THE 3DSTAGE SCENE
				td.debugDisplay = true; // SO THAT THE INPUT POINTS CAN BE VISULIZED
				td.nativeTransform = false; // MUST BE MANUALLY SET TO FALSE
				td.affineTransform = false; // MUST BE MANUALLY SET TO FALSE

				td.motionEnabled = true; // ENABLES THE TOUCH SPRITE TO PROCESS MOTION GESTURES
				td.transform3d = false; // ENSURES THAT THE 3D MOTION INTERACTION POINTS ARE PROJECTED INTO THE 2D STAGE
				td.gestureEvents = true; // ACTIVATES THE OBJECT GESTURE EVENT PIPELINE 
				td.motionClusterMode = "global"; // CONFIGURES THE TOUCH SPRITE TO GLOBALLY COLLECT ALL 3D MOTION INTERACTION POINTS FROM THE SKELETAL MODEL
				
				// IN THS EXAMPLE THERE ARE THREE MOTION GESTURE PRIMATIVES
				// 1. A PALM DRAG/PAN GESTURE THAT REQUIRES A FULLY CLOSED FIST (FACING DOWN)
				// 2. A TRIGGER HOLD GESTURE THAT REQUIRES A BENT THUMB
				// 3. A PINCH DRAG/ROTATE GESTURE THAT REQUIRES THAT TWO FINGERS OR A FINGER AND A THUMB ARE CLOSE BUT NOT TOUCHING
				
				td.gestureList = {  "3dmotion-1-palm-2dtranslate":true,
									"3dmotion-1-trigger-3dhold":true,
									"3dmotion-1-pinch-2dtranslate":true
									};
									
				// NOTE THAT THERE ARE NO GESTURE EVENT LISTENERS AS WE ARE ONLY USING THE TOUCHSPRITE TO VISUALIZE MOTION/INTERACTION POINTS
				// THE GESTURES ARE REQUIRED IN THE GESTURE LIST TO ACTIVATE INTERNAL PROCESSING AND NATIVE VISUALIZATION METHODS
			addChild(td);
			
			//////////////////////////////////////////////
			// AN OPTIONAL VISULIZATION VIEW THAT SHOWS THE SKELETAL MODEL IN NATIVE 3D SPACE
			// NOTE THAT 3D RAY CAST HIT TESTING IS PERFROMED ON THE ORTHOGRAPHICALLY PROJECTED POINTS
			/*
			vis3d = new MotionVisualizer3D();
				vis3d.lightPicker = lightPicker;
				vis3d.init();
				vis3d.cO = td.cO;
				vis3d.trO = td.trO;
				vis3d.tiO = td.tiO;
				vis3d.mouseEnabled= false;
			view.scene.addChild(vis3d);	
			*/
			
			hitGeometry = new CubeGeometry(100, 100, 100, 1, 1, 1);
			
			TouchManager3D.onlyTouchEnabled = false;
			
			light = new DirectionalLight;
			lightPicker = new StaticLightPicker([light]);
		}

		private function assetComplete(e:AssetEvent):void {
			if (e.asset is ObjectContainer3D && ObjectContainer3D(e.asset).parent == null) {
				models.push(e.asset);
				e.asset.name = modelNames[loadCnt];
			}		
			else if (e.asset is MaterialBase) {
				MaterialBase(e.asset).lightPicker = lightPicker;
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
			
				p = Math3DUtils.sphericalToCartesian(new Vector3D( (modelPositions[i] ) , 0, 300));		
				
				var hitMesh:Mesh = new Mesh(hitGeometry);
				hitMesh.material = new ColorMaterial(0xFFFFFF, hitMeshAlpha);
				hitMesh.addChild(models[i]);
				container.addChild(hitMesh);
				
				hitMesh.x = p.x;
				models[i].y = 0
				hitMesh.z = p.z;
				models[i].rotationX = modelRotationsX[i];
				models[i].rotationY = modelRotationsY[i];
				hitMesh.name = models[i].name;
				hitMesh.rotationY = modelRotationsY[i];
				
				// REGISTER THE ACTUAL 3D OBJECT TO THE MANAGER. WHAT RETURNS IS A TOUCH OBJECT THAT HOLDS THE TRANSFORMATION OF THAT OBJECT
				t = TouchSprite(TouchManager3D.registerTouchObject(hitMesh, false));
					t.view = view;
					t.mouseEnabled = true; // ENSURES THAT THE 3D OBJECT CAN PROCESS TOUCH AND MOTION POINTS 
					t.nativeTransform = false; // MUST BE MANUALLY SET TO FALSE
					t.affineTransform = false; // MUST BE MANULALLY SET TO FALSE
					
					t.motionEnabled = true; // ENSURES THAT MOTION GESTURES ARE PROCESSED ON THE TOUCHSPRITE
					t.transform3d = false;  // ENSURES THAT THE 3D MOTION INTERACTION POINTS ARE PROJECTED INTO THE 2D STAGE
					t.gestureEvents = true; // ENABLES GESTURE EVENT DISPATCHING ON THE TOUCHSPRITE
					
					// CONFIGURES THE TOUCH SPRITE TO COLLECT ONLY 3D MOTION INTERACTION POINTS FROM THE SKELETAL MODEL 
					// THAT COLLIDE WITH THE 3D MODEL/OBJECT WHEN INITIALIZED (INTERACTIONPOINT_BEGIN)
					t.motionClusterMode = "local_strong";
					
					//CONFIGURES THE 3D MODEL TO PROCESS 3 STANDARD TOUCH GESTURES AND 2 3D MOTION GESTURES
					// 1. A TRIGGER HOLD GESTURE THAT REQUIRES A TRIGGER POSTURE (WITH BENT THUMB) HELD IN PLACE FOR HALF A SECOND 
					// 2. A PINCH DRAG/ROTATE GESTURE THAT REQUIRES THAT TWO FINGERS OR A FINGER AND A THUMB ARE CLOSE BUT NOT TOUCHING
					t.gestureList = { 	"n-tap":true, "n-drag":true, "n-scale":true};					
					// SIMPLE TOUCH GESTURE LISTENERS
					t.addEventListener(GWGestureEvent.DRAG, onModelDrag);
					t.addEventListener(GWGestureEvent.TAP, onModelTap);
					t.addEventListener(GWGestureEvent.SCALE, onModelScale);
					// A PINCH MOTION DRAG GESTURE LISTENER
					t.addEventListener(GWGestureEvent.MOTION_DRAG, onModelMotionDrag);	
					// A TRIGGER MOTION HOLD GESTURE LISTENER
					t.addEventListener(GWGestureEvent.MOTION_HOLD, onModelMotionTap);	
					//t.addEventListener(GWGestureEvent.MOTION_SCALE, onModelMotionScale);		
				
				touchSprites.push(t);				
			}
			initialized = true;
		}
		
		private function update(e:Event = null):void {
			if (initialized) {
				updateModelButtons();
				//vis3d.updateDisplay();	
				view.render();
			}
		}			
		
		// THE TARGET'S VTO (VIRTUAL TRANSFORM OBJECT) IS THE OBJECT SHOULD RECEIVED THE VIRTUAL TRANSFORMATIONS. IN THIS CASE IT HOLDS THE ACTUAL 3D OBJECT OR MESH
		
		private function onModelDrag(e:GWGestureEvent):void {
			trace("model drag");
			e.target.vto.rotationY -= e.value.drag_dx * .5;	
		}
		private function onModelMotionDrag(e:GWGestureEvent):void {
			trace("motion drag", e.target,e.target.vto);
			e.target.vto.rotationY -= e.value.dx * .5;
		}
		
		private function onModelScale(e:GWGestureEvent):void {
			trace("model scale");
			var val:Number = e.target.vto.scaleX + e.value.scale_dsx * .75;
			
			if (val < minScale)
				val = minScale;
			else if (val > maxScale)
				val = maxScale;
				
			e.target.vto.scaleX = val;
			e.target.vto.scaleY = val;
			e.target.vto.scaleZ = val;
		}	
		
		private function onModelMotionScale(e:GWGestureEvent):void {
			var val:Number = e.target.vto.scaleX + e.value.dsx * .75;
			
			if (val < minScale)
				val = minScale;
			else if (val > maxScale)
				val = maxScale;
				
			e.target.vto.scaleX = val;
			e.target.vto.scaleY = val;
			e.target.vto.scaleZ = val;
		}	
		
		private function onModelTap(e:GWGestureEvent):void {
			trace("model tap");
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
		
		private function onModelMotionTap(e:GWGestureEvent):void {
			trace("motion tap model");
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
		private function onContainerMotionDrag(e:GWGestureEvent):void {
			container.rotationY += e.value.dx * .1;
			//trace("motion drag container");
		}
		
		private function updateModelButtons():void {	
			var pop:ModelPopup;
			var btn:ModelButton;
			
			// TODO: remove redundant code
			for (var i:int = 0; i < modelPositions.length; i++) {
				
				if (	( (container.rotationY % 360) >= 0 && (container.rotationY % 360) <= 45 ) ||
						( (container.rotationY % 360) >= -360 && (container.rotationY % 360) <= -315 )
				) {	
					if (i != modelIndex) {
						for each (pop in popups) {
							pop.tweenOut();
						}
						for each (btn in modelButtons) {
							if ( btn != modelButtons[i])
								btn.tweenOut();
						}
						modelButtons[i].tweenIn();
						modelIndex = i;
					}					
					break;
				}
				else if (container.rotationY < 0) {
					if (-modelPositions[i] >= (container.rotationY % 360) - 45 && 
						-modelPositions[i] < (container.rotationY % 360) + 45) {
						if (i != modelIndex) {
							for each (pop in popups) {
								pop.tweenOut();
							}
							for each (btn in modelButtons) {
								if ( btn != modelButtons[i])
									btn.tweenOut();
							}
							modelButtons[i].tweenIn();
							modelIndex = i;
						}				
						break;
					}
				}
				else {	
					if (modelPositions[i] >= (360 - (container.rotationY % 360) - 45) && 
						modelPositions[i] < (360 - (container.rotationY % 360) + 45)) {
						if (i != modelIndex) {
							for each (pop in popups) {
								pop.tweenOut();
							}
							for each (btn in modelButtons) {
								if ( btn != modelButtons[i])
									btn.tweenOut();
							}						
							modelButtons[i].tweenIn();
							modelIndex = i;
						}	
						break;
					}					
				}
			}		
		}
		
		private function onModelButtonTap(targetId:String):void {
			for (var i:int = 0; i < modelNames.length; i++) {
				if ( (targetId == modelNames[i] + "-button")) {	
					container.rotationY = container.rotationY  % 360;
					TweenMax.to(container, 1, { shortRotation:{ rotationY:-modelPositions[i] } });
					break;
				}
			}
		}
					
	}
}