package geometry
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import interaction.MouseDestination;
	import interaction.MousePicking;
	
	import physics.JointConnection;
	import physics.PhysicHelper;
	import physics.VertexBody;
	
	public class Quad extends Sprite
	{
		private var _bodies:Vector.<VertexBody>;

		private var _bodiesConnections:Vector.<JointConnection>;
		private var _color:Number 			= 0xffffff;
		private var _alpha:Number			= .9;
		
		public function Quad( points:Vector.<Point>, bodyType:uint = 2 /* b2Body.b2_dynamicBody */ )
		{
			_bodies 	= new Vector.<VertexBody>(5, true);
			
			_bodies[0] 	= new VertexBody( points[0], bodyType );
			_bodies[1] 	= new VertexBody( points[1], bodyType );
			_bodies[2] 	= new VertexBody( points[2], bodyType );
			_bodies[3]	= new VertexBody( points[3], bodyType );
			
			var center:Point = Point.interpolate( points[0], points[3], .5 );
			_bodies[4]	= new VertexBody( center, bodyType );
			
			_bodiesConnections	= PhysicHelper.ConnectBodies( _bodies );
			
			
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function destroy():void
		{
			var b:VertexBody;
			var j:JointConnection;

			for each ( j in _bodiesConnections )
			{
				j.destroy();
				j = null;
			}
			
			for each ( b in _bodies )
			{
				b.destroy();
				b = null;
			}
		}
		
		protected function onAddedToStage(event:Event):void
		{
			
			var j:JointConnection;
			for each ( j in _bodiesConnections )
			{
				stage.addChild(j);
			}
			
			var r:VertexBody;
			for each ( r in _bodies )
			{
				stage.addChild( r );				
			}
			
			draw();
		}		
		
		public function draw():void
		{
			if ( true )
			{
				graphics.clear();

				var r:VertexBody
				for each ( r in _bodies )
				{
					r.update();
				}
				
				graphics.lineStyle( 1, _color, _alpha );
				graphics.beginFill( _color, _alpha );
				
				
				var cpl:Point 	= new Point();
				var cp1:Point 	= new Point();
				cp1.x 			= (_bodies[ 0 ].x + _bodies[ 3 ].x) * .5;
				cp1.y 			= (_bodies[ 0 ].y + _bodies[ 3 ].y) * .5;
				
				graphics.moveTo( cp1.x, cp1.y );
					
				var i:int;
				for ( i = 0 ; i < 3 ; i++)
				{
					cpl.x = (_bodies[ i ].x + _bodies[ i+1 ].x) * .5;
					cpl.y = (_bodies[ i ].y + _bodies[ i+1 ].y) * .5;
					
					graphics.curveTo( _bodies[ i ].x, _bodies[ i ].y, cpl.x, cpl.y );
				}
				
				graphics.curveTo( _bodies[ i ].x, _bodies[ i ].y, cp1.x, cp1.y );
				graphics.endFill();
				
				// Fade out slowly
				_alpha 		+= (.1 - _alpha) * .1;
			
				
				// scaleX		+= (.95 - scaleX) * .05;
				// scaleY 		+= (.95 - scaleX) * .05;
				
				/*
				graphics.moveTo( _bodies[ 0 ].x, _bodies[ 0 ].y );
				graphics.lineTo( _bodies[ 1 ].x, _bodies[ 1 ].y );
				graphics.lineTo( _bodies[ 2 ].x, _bodies[ 2 ].y );
				graphics.lineTo( _bodies[ 3 ].x, _bodies[ 3 ].y );
				graphics.lineTo( _bodies[ 0 ].x, _bodies[ 0 ].y );
				*/
				
			}
		}

		public function get bodies():Vector.<VertexBody>
		{
			return _bodies;
		}

		public function set bodies(value:Vector.<VertexBody>):void
		{
			_bodies = value;
		}

		public function get color():Number
		{
			return _color;
		}

		public function set color(value:Number):void
		{
			_color = value;
		}
		
		
	}
}