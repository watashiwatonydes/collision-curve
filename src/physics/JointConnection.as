package physics
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.Joints.b2RopeJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class JointConnection extends Shape
	{
		public static const DISTANCE_JOINT:int 	= 0;	
		public static const REVOLUTE_JOINT:int 	= 1;	
		public static const ROPE_JOINT:int 		= 2;	
		
		private var vertexBodyA:VertexBody;
		private var vertexBodyB:VertexBody;
		
		private var jointType:int;
		public var joint:b2Joint;
		private var frequencyHz:Number;
		private var dampingRatio:Number;
		
		public function JointConnection(jointType:int, vertexBodyA:VertexBody, vertexBodyB:VertexBody, 
										freqHz:Number = 4, dampingRatio:Number = .1)
		{
			this.jointType 		= jointType;

			this.vertexBodyA 	= vertexBodyA;
			this.vertexBodyB 	= vertexBodyB;
			
			this.frequencyHz 	= freqHz;
			this.dampingRatio 	= dampingRatio;
			
			this.init();
		}
		
		public function destroy():void
		{
			Config.WORLD.DestroyJoint( joint );
			joint = null;
		}
		
		private function init():void
		{
			
			switch(jointType)
			{
				case JointConnection.DISTANCE_JOINT:
				
					var distanceJointDef:b2DistanceJointDef = null;;
					var localAnchorA:b2Vec2    = vertexBodyA.body.GetWorldCenter();
					var localAnchorB:b2Vec2    = vertexBodyB.body.GetWorldCenter();
					
					distanceJointDef = new b2DistanceJointDef();
					distanceJointDef.Initialize( vertexBodyA.body, vertexBodyB.body, localAnchorA, localAnchorB );
					distanceJointDef.collideConnected   = false;
					distanceJointDef.frequencyHz        = this.frequencyHz;
					distanceJointDef.dampingRatio       = this.dampingRatio; // Super Elastic
					
					this.joint                  = Config.WORLD.CreateJoint(distanceJointDef);
					
				break;
				case JointConnection.ROPE_JOINT:
					
					var ropeJointDef:b2RopeJointDef = new b2RopeJointDef();
					ropeJointDef.bodyA 				= vertexBodyA.body;
					ropeJointDef.bodyB 				= vertexBodyB.body;
					
					ropeJointDef.localAnchorA 		= new b2Vec2(0,0);
					ropeJointDef.localAnchorB 		= new b2Vec2(0,0);
					
					var dist:Number					= Point.distance( vertexBodyA.pixelCoordinates, 
																	  vertexBodyB.pixelCoordinates );
					
					
					ropeJointDef.maxLength	 		= (dist) / Config.WORLDSCALE;
					ropeJointDef.collideConnected 	= false;
					
					this.joint	= Config.WORLD.CreateJoint(ropeJointDef);
				
				break;
					
			}
			
			
		}		
		
		public function draw( scale:int = 1, color:Number = 0x0000FF, alpha:Number = 1 ):void
		{
			var posBodyA:Point = this.vertexBodyA.pixelCoordinates;
			var posBodyB:Point = this.vertexBodyB.pixelCoordinates;
			
			graphics.clear();
			graphics.lineStyle( 1, color );
			graphics.moveTo(posBodyA.x, posBodyA.y);
			graphics.lineTo(posBodyB.x, posBodyB.y);
		}
			
	}
}


		




