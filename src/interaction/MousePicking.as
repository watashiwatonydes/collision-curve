package interaction
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	
	import com.adobe.fileformats.vcard.Address;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import physics.JointConnection;
	import physics.VertexBody;

	public class MousePicking
	{
		private var _target:Sprite;
		private var _bodies:Vector.<VertexBody>;

		private var _pickingAnchor:VertexBody;
		private var _pickingJoints:Vector.<JointConnection> = new Vector.<JointConnection>();
		private var _mouseJoint:b2MouseJoint;
		private var _dragJointConnection:JointConnection;
		
		public function MousePicking( target:Sprite, bodies:Vector.<VertexBody> )
		{
			if ( !target.stage )
				throw new Error( "MousePicking requires the target: " + target.name + " to be added to the stage beforehand." );
			
			_target = target;
			_bodies = bodies;
			
			_target.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			
		}
	
		protected function mouseToWorld():b2Vec2
		{
			var buffer:b2Vec2 = new b2Vec2( _target.stage.mouseX / Config.WORLDSCALE, _target.stage.mouseY / Config.WORLDSCALE );
			return buffer;
		}
		
		protected function handleMouseDown(event:MouseEvent):void
		{
			var mousePoint:Point 			= new Point( _target.stage.mouseX, _target.stage.mouseY );
			
			var someVertexBody:VertexBody 	= null;
			var dist:Number 				= Number.MAX_VALUE;
			
			for each(var b:VertexBody in _bodies)
			{
				var dist2Point:Number = Point.distance( b.pixelCoordinates, mousePoint );
				if( dist2Point < dist )
				{
					someVertexBody 	= b;
					dist 			= dist2Point;
				}
			}
			
			_pickingAnchor 					= new VertexBody( mousePoint, b2Body.b2_dynamicBody );
			_pickingAnchor.draw( 20 );
			_pickingAnchor.alpha = 0.3;
			_target.stage.addChild( _pickingAnchor );

			
			_dragJointConnection = new JointConnection( JointConnection.ROPE_JOINT, _pickingAnchor, someVertexBody );
			_target.stage.addChild( _dragJointConnection );
			_dragJointConnection.draw();
			
			// Connect the anchor to all other bodies
			/*
			var conn:JointConnection;
			for each ( b in _bodies )
			{
				conn 	= new JointConnection( JointConnection.ROPE_JOINT, b, _pickingAnchor );
				_pickingJoints.push( conn );
				
				_target.stage.addChild( conn );
				conn.draw();
				
			}
			*/
			
			var v2:b2Vec2 = mouseToWorld();
			Config.WORLD.QueryPoint( this.queryCallback, v2 );
			
			_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
		
		private function queryCallback( fixture:b2Fixture ):void
		{
			if (fixture)
			{
				var touchedBody:b2Body         = fixture.GetBody();
				if( touchedBody.GetType() == b2Body.b2_dynamicBody )
				{
					var jointDef:b2MouseJointDef = new b2MouseJointDef();
					
					jointDef.bodyA 		    = Config.WORLD.GetGroundBody();
					jointDef.bodyB 		    = touchedBody;
					jointDef.target 	    = mouseToWorld();
					jointDef.maxForce	    = 300 * touchedBody.GetMass();
					jointDef.frequencyHz    = 6;
					jointDef.dampingRatio   = .1;
					
					_mouseJoint				= Config.WORLD.CreateJoint( jointDef ) as b2MouseJoint;
					
					var mousePos:b2Vec2 = null;
					if( _mouseJoint )
					{
						mousePos = mouseToWorld();
						_mouseJoint.SetTarget( mousePos );
					}
				}
			}
		}
		
		protected function handleMouseUp(event:MouseEvent):void
		{
			_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			_target.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			
			for each ( var j:JointConnection in _pickingJoints )
			{
				Config.WORLD.DestroyJoint( j.joint );
				j.joint = null;
				j = null;
			}
			
			_pickingJoints.length = 0;
			
			if( _dragJointConnection )
			{
				_target.stage.removeChild( _dragJointConnection );
				Config.WORLD.DestroyJoint( _dragJointConnection.joint );
				_dragJointConnection.joint 	= null;
				_dragJointConnection 		= null;
			}
			
			if( _pickingAnchor )
			{
				if ( _target.stage.contains( _pickingAnchor ) )
					_target.stage.removeChild( _pickingAnchor );
				
				Config.WORLD.DestroyBody(_pickingAnchor.body);
				
				_pickingAnchor.body	= null;
				_pickingAnchor = null;
			}
			
			if(_mouseJoint)
			{
				Config.WORLD.DestroyJoint( _mouseJoint );
				_mouseJoint = null;
			}
		}
		
		protected function handleMouseMove(event:MouseEvent):void
		{
			var mousePos:b2Vec2 = null;
			if( event.buttonDown )
			{
				if( _mouseJoint ){
					
					mousePos = mouseToWorld();
					_mouseJoint.SetTarget( mousePos );
				}
			}
		}
		
		public function draw():void 
		{
			if( _pickingAnchor )
			{
				_pickingAnchor.update();
			}
		}
		
	}
}