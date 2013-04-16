package interaction
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2RopeJointDef;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import physics.JointConnection;
	import physics.VertexBody;

	public class MouseDestination
	{
		private var _target:Sprite;
		private var _bodies:Vector.<VertexBody>;
		private var _destRopeJoint:b2Joint;

		private var _destAnchor:VertexBody;
		
		
		public function MouseDestination( target:Sprite, bodies:Vector.<VertexBody> )
		{
			if ( !target.stage )
				throw new Error( "MousePicking requires the target: " + target.name + " to be added to the stage beforehand." );
			
			_target = target;
			_bodies = bodies;
			
			_target.stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		}
		
		protected function handleMouseDown(event:MouseEvent):void
		{
			trace ( "MouseDestination::handleMouseDown" );
			
			var mousePoint:Point 			= new Point( _target.stage.mouseX, _target.stage.mouseY );
			
			
			var closestVertexBody:VertexBody 	= null;
			var dist:Number 				= Number.MAX_VALUE;
			
			for each(var b:VertexBody in _bodies)
			{
				var dist2Point:Number = Point.distance( b.pixelCoordinates, mousePoint );
				if( dist2Point < dist )
				{
					closestVertexBody 	= b;
					dist 				= dist2Point;
				}
			}


			closestVertexBody.body.SetPosition( mouseToWorld() );
		}		
		
		protected function mouseToWorld():b2Vec2
		{
			var buffer:b2Vec2 = new b2Vec2( _target.stage.mouseX / Config.WORLDSCALE, _target.stage.mouseY / Config.WORLDSCALE );
			return buffer;
		}
		
		public function draw():void 
		{
			if( _destAnchor )
			{
				_destAnchor.update();
			}
		}
		
		
	}
}