package com.eprize.fps.object
{
	
	import com.eprize.flash.simplephysicsengine.controllers.collision.SimplePhysicsObject3DHitArea;
	import com.eprize.flash.templates.firstpersonshooter.controllers.collision.FPSStageObject3DHitArea;
	import com.eprize.flash.templates.firstpersonshooter.objects.FPSBullet;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.shadematerials.GouraudMaterial;
	import org.papervision3d.objects.primitives.Sphere;
	
	/**
	 * Snowball.
	 * @author kaoru.kawashima
	 * 
	 */
	public class SnowBall extends FPSBullet
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const RADIUS:Number = 50;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param lightSource
		 * @param viewHitRegion
		 * 
		 */
		public function SnowBall(lightSource:PointLight3D = null, viewHitRegion:Boolean = false)
		{
			
			super(viewHitRegion);
			
			enableCollision = true;
			enablePhysics = true;
			
			//this.rotationX = 10;
			//this.rotationY = 10;
			//this.rotationZ = 10;
			
			var hitAreas:Vector.<SimplePhysicsObject3DHitArea> = new Vector.<SimplePhysicsObject3DHitArea>();
			hitAreas.push(new FPSStageObject3DHitArea(0, 0, 0, RADIUS));
			//hitAreas.push(new FPSStageObject3DHitArea(RADIUS * 5, 0, 0, RADIUS));
			//hitAreas.push(new FPSStageObject3DHitArea(0, RADIUS * 5, 0, RADIUS));
			//hitAreas.push(new FPSStageObject3DHitArea(0, 0, RADIUS * 5, RADIUS));
			hitRegion = hitAreas
			
			var targetMaterial:MaterialObject3D;
			
			_lightSource = lightSource;
			
			if (_lightSource != null)
				targetMaterial = new GouraudMaterial(lightSource, 0xFFFFFF, 0x888888);
			else
				targetMaterial = new ColorMaterial(0xFFFFFF);
			
			var snowBallObj:Sphere = new Sphere(targetMaterial, RADIUS, 4, 4);
			snowBallObj.name = "snowballObject";
			this.addChild(snowBallObj);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _lightSource:PointLight3D;
		
	}
	
}