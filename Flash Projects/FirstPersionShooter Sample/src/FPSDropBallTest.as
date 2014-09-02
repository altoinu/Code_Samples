﻿package{		import com.eprize.flash.datamodels.Acceleration;	import com.eprize.flash.datamodels.Plane3DSpace;	import com.eprize.flash.datamodels.Point3DSpace;	import com.eprize.flash.datamodels.Sphere3DSpace;	import com.eprize.flash.datamodels.Vector3DSpace;	import com.eprize.flash.datamodels.Velocity;	import com.eprize.flash.pv3d.events.DisplayObject3DMouseEvent;	import com.eprize.flash.simplephysicsengine.controllers.collision.SimplePhysicsObject3DHitArea;	import com.eprize.flash.simplephysicsengine.events.SimplePhysicsObject3DEvent;	import com.eprize.flash.simplephysicsengine.objects.SimplePhysicsPV3DObject3D;	import com.eprize.flash.simplephysicsengine.utils.CollisionMath;	import com.eprize.flash.templates.firstpersonshooter.controllers.FPSLockOnIndicatorRangeType;	import com.eprize.flash.templates.firstpersonshooter.objects.FPSGameStage;	import com.eprize.flash.templates.firstpersonshooter.objects.FPSGun;	import com.eprize.flash.templates.firstpersonshooter.objects.FPSLockOnIndicator;	import com.eprize.flash.templates.firstpersonshooter.objects.FPSLockOnIndicatorAimRange;	import com.eprize.fps.object.SnowBall;		import flash.display.MovieClip;	import flash.events.KeyboardEvent;		import org.papervision3d.core.math.Number3D;	import org.papervision3d.events.InteractiveScene3DEvent;	import org.papervision3d.materials.shadematerials.GouraudMaterial;	import org.papervision3d.objects.primitives.Plane;	import org.papervision3d.objects.primitives.Sphere;	import org.papervision3d.view.stats.StatsView;
		/**	 * 	 * @author kaoru.kawashima	 * 	 */	public class FPSDropBallTest extends MovieClip	{				//--------------------------------------------------------------------------		//		//  Class constants		//		//--------------------------------------------------------------------------				/**		 * @private		 * for debugging 		 */		private const VIEW_HIT_REGION:Boolean = true;		private const VIEW_DEBUG_TARGETREGION:Boolean = true;		private const SHOW_STATS:Boolean = true;				//--------------------------------------------------------------------------		//		//  Constructor		//		//--------------------------------------------------------------------------				public function FPSDropBallTest()		{						super();						init();					}				//--------------------------------------------------------------------------		//		//  Variables		//		//--------------------------------------------------------------------------				/**		 * @private		 * Game stage.		 */		private var _gameStage:FPSGameStage;				/**		 * @private		 * Target user will control with mouse to aim.		 */		private var _lockOnIndicator:FPSLockOnIndicator;				/**		 * @private		 */		private var _lockOnIndicatorAimRange:FPSLockOnIndicatorAimRange;				/**		 * @private		 * Player who is going to throw		 */		private var _thrower:FPSGun;				private var _ground:Plane;		private var _groundPlane:Plane3DSpace;				//--------------------------------------------------------------------------		//		//  Properties		//		//--------------------------------------------------------------------------				//--------------------------------------		//  MovieClips already on stage		//--------------------------------------				/**		 * @private		 */		public var gameStageHolder:MovieClip;					//--------------------------------------------------------------------------		//		//  Methods		//		//--------------------------------------------------------------------------				private function init():void		{						// Create game stage			_gameStage = new FPSGameStage(stage.stageWidth, stage.stageHeight, false);			_gameStage.camera.x = 0;			_gameStage.camera.y = 0;			_gameStage.camera.z = 0;			_gameStage.camera.rotationX = 0;			_gameStage.camera.rotationY = 0;			_gameStage.camera.rotationZ = 0;			_gameStage.camera.useCulling = true;			/*			_gameStage.camera.focus = INITIAL_CAMERA_PROPERTIES.focus;			_gameStage.camera.zoom = INITIAL_CAMERA_PROPERTIES.zoom;			_gameStage.camera.near = INITIAL_CAMERA_PROPERTIES.near;			_gameStage.camera.far = INITIAL_CAMERA_PROPERTIES.far;			_gameStage.camera.fov = INITIAL_CAMERA_PROPERTIES.fov;			*/						// Game physics			_gameStage.stagePhysics.gravity = new Acceleration(0, -0.00980665 / 50, 0);						// Position lighting			_gameStage.lightSource.x = _gameStage.camera.x - 500;			_gameStage.lightSource.y = _gameStage.camera.y + 500;			_gameStage.lightSource.z = _gameStage.camera.z - 500;						// Set how target			_gameStage.separateLockOnIndicatorRender = false;						gameStageHolder.addChild(_gameStage);												// Create target aim region with visual target			_lockOnIndicator = new FPSLockOnIndicator(null, _gameStage.lightSource);						//_lockOnIndicatorAimRange = new FPSLockOnIndicatorAimRange(_gameStage.camera, _lockOnIndicator, AIM_FIELD_WIDTH, AIM_FIELD_LENGTH, AIM_FIELD_HEIGHT, "cube", VIEW_DEBUG_TARGETREGION);			_lockOnIndicatorAimRange = new FPSLockOnIndicatorAimRange(_lockOnIndicator,																	  1000, 750, 500,																	  FPSLockOnIndicatorRangeType.PLANE, VIEW_DEBUG_TARGETREGION);			_lockOnIndicatorAimRange.lockOnIndicatorLookAt = _gameStage.camera;			_lockOnIndicatorAimRange.userMouseControl3D.addEventListener(DisplayObject3DMouseEvent.MOUSE_ACTION, onMouseActionOnTargetAimRegion);						_gameStage.lockOnIndicatorAimRange = _lockOnIndicatorAimRange;												// FPSGun which will be shooting			_thrower = new FPSGun(_lockOnIndicatorAimRange);			_thrower.addChild(new Sphere());			_thrower.camera = _gameStage.camera;			_thrower.enablePhysics = true;			_thrower.enableCollisionReaction = false;			_thrower.enableExternalForce = false;			_thrower.lockOnIndicatorAimRange_Offset = new Number3D(0, 750, 1500);			_thrower.lockOnIndicatorAimRange_OffsetAngle = new Number3D(90, 0, 0);			_thrower.max_shootSpeed = 2;			_thrower.shootSpeed = 0;			_thrower.addEventListener(SimplePhysicsObject3DEvent.MOVED, onObjectMove);			_gameStage.scene.addChild(_thrower);												// Testing....			_ground = new Plane(null, 20000, 20000, 20, 20);			_ground.rotationX = 90;			_ground.y = -2000;			_groundPlane = new Plane3DSpace(new Point3DSpace(_ground.x, _ground.y, _ground.z), new Vector3DSpace(0, 1, 0));			if (VIEW_DEBUG_TARGETREGION)				_gameStage.scene.addChild(_ground);						var ballObject:SimplePhysicsPV3DObject3D = new SimplePhysicsPV3DObject3D(VIEW_HIT_REGION);			ballObject.x = 0;			ballObject.y = 0;			ballObject.z = 1500;			var ballSphere:Sphere = new Sphere(new GouraudMaterial(_gameStage.lightSource), 300, 8, 8);			ballObject.addChild(ballSphere);			ballObject.enablePhysics = true;			ballObject.enableCollision = true;			ballObject.enableCollisionReaction = true;			ballObject.enableExternalForce = false;			ballObject.hitRegion = new Vector.<SimplePhysicsObject3DHitArea>();			ballObject.hitRegion.push(new SimplePhysicsObject3DHitArea(0, 0, 0, 300));			ballObject.addEventListener(SimplePhysicsObject3DEvent.COLLIDED, onCenterBallHit);			_gameStage.scene.addChild(ballObject);						// this one is bouncing off of ballObject			/*			var ballObject1:SimplePhysicsPV3DObject3D = addDropBall(new Point3DSpace(0, 500, 1500), "dropball0");			ballObject1.addEventListener(SimplePhysicsObject3DEvent.MOVED, onObjectMove)						var ballObject2:SimplePhysicsPV3DObject3D = addDropBall(new Point3DSpace(1000, 0, 2500), "dropball2");			ballObject2.addEventListener(SimplePhysicsObject3DEvent.MOVED, onObjectMove)			*/						stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownForMovement);			_gameStage.startRendering();						if (SHOW_STATS)				this.addChild(new StatsView(_gameStage.renderer));					}				private function addDropBall(pos:Point3DSpace, name:String = ""):SimplePhysicsPV3DObject3D		{			var ballobj:SimplePhysicsPV3DObject3D = new SimplePhysicsPV3DObject3D(VIEW_HIT_REGION, null, name);			ballobj.x = pos.x;			ballobj.y = pos.y;			ballobj.z = pos.z;			var ballsphere:Sphere = new Sphere(new GouraudMaterial(_gameStage.lightSource), 50, 8, 8);			ballobj.addChild(ballsphere);			ballobj.enablePhysics = true;			ballobj.enableCollision = true;			ballobj.enableCollisionReaction = false;			ballobj.enableExternalForce = true;			var hitRegion:Vector.<SimplePhysicsObject3DHitArea> = new Vector.<SimplePhysicsObject3DHitArea>();			hitRegion.push(new SimplePhysicsObject3DHitArea(0, 0, 0, 50));			ballobj.hitRegion = hitRegion;			_gameStage.scene.addChild(ballobj);						return ballobj;					}				//--------------------------------------------------------------------------		//		//  Event handlers		//		//--------------------------------------------------------------------------				/**		 * Event hanlder for the user mouse control on TargetAimRegion.		 * @param event		 * 		 */		private function onMouseActionOnTargetAimRegion(event:DisplayObject3DMouseEvent):void		{						if (event.interactiveEvent.type == InteractiveScene3DEvent.OBJECT_CLICK)			{								// TargetAimRegion clicked.  Shoot snow ball				var newSnowBall:SnowBall = new SnowBall(_gameStage.lightSource, VIEW_HIT_REGION);				newSnowBall.addEventListener(SimplePhysicsObject3DEvent.MOVED, checkToSeeIfSnowBallHitGround);								_thrower.loadBullet(newSnowBall);				_thrower.shoot();								newSnowBall.x = _thrower.lockOnIndicatorAimRange.targetPoint.x;				newSnowBall.y = _thrower.lockOnIndicatorAimRange.targetPoint.y;				newSnowBall.z = _thrower.lockOnIndicatorAimRange.targetPoint.z;							}					}				private var _upKeyDown:Boolean = false;		private var _downKeyDown:Boolean = false;		private var _leftKeyDown:Boolean = false;		private var _rightKeyDown:Boolean = false;				private function onKeyDownForMovement(event:KeyboardEvent):void		{						switch(event.keyCode)			{								case 38:				{										_thrower.moveForward(100);					break;									}								case 40:				{										_thrower.moveBackward(100);					break;									}								case 37:				{										_thrower.rotationY -= 5;					break;									}								case 39:				{										_thrower.rotationY += 5;					break;									}							}					}				/**		 * Event handler that watches snowball move, and removes it when it hits the ground level.		 * @param event		 * 		 */		private function checkToSeeIfSnowBallHitGround(event:SimplePhysicsObject3DEvent):void		{									if (SnowBall(event.target).y < _ground.y)			{								// SnowBall hit the ground.  Remove it				SnowBall(event.currentTarget).removeEventListener(SimplePhysicsObject3DEvent.MOVED, checkToSeeIfSnowBallHitGround);				SnowBall(event.currentTarget).scene.removeChild(SnowBall(event.target));								if (snowBallsHit.indexOf(SnowBall(event.currentTarget)) != -1)					snowBallsHit.splice(snowBallsHit.indexOf(SnowBall(event.currentTarget)), 1);							}					}				private var snowBallsHit:Array = [];				private function onCenterBallHit(event:SimplePhysicsObject3DEvent):void		{						if (event.collidedObject.velocity.y < 0)			{								if (snowBallsHit.indexOf(event.collidedObject) == -1)				{										// Sphere to represent the hit area of the ball (event.currentTarget)					var hitTargetSphere:Sphere3DSpace = new Sphere3DSpace(new Point3DSpace(SimplePhysicsPV3DObject3D(event.currentTarget).x + event.currentTargetHitAreas[0].x,																						   SimplePhysicsPV3DObject3D(event.currentTarget).y + event.currentTargetHitAreas[0].y,																						   SimplePhysicsPV3DObject3D(event.currentTarget).z + event.currentTargetHitAreas[0].z),																		  event.currentTargetHitAreas[0].radius);										CollisionMath.applyDeflectionAgainstSphere(event.collidedObject, hitTargetSphere, event.collidedObjectHitAreas[0]);									}								if (event.collidedObject is SnowBall)					snowBallsHit.push(event.collidedObject);							}					}				private function onObjectMove(event:SimplePhysicsObject3DEvent):void		{						if (SimplePhysicsPV3DObject3D(event.currentTarget).y < _ground.y)			{								var objectVelocity:Velocity = SimplePhysicsPV3DObject3D(event.currentTarget).velocity;				var groundNormal:Vector3DSpace = new Vector3DSpace(0, 1, 0);				var angleBetweenGroundNormalAndVelocity:Number = Vector3DSpace.angleBetweenVectors(objectVelocity, groundNormal);								if (isFinite(angleBetweenGroundNormalAndVelocity) &&					(angleBetweenGroundNormalAndVelocity >= (Math.PI / 2)))				{										// Deflect off of the ground					CollisionMath.applyDeflection(SimplePhysicsPV3DObject3D(event.currentTarget), _groundPlane);									}							}					}			}	}