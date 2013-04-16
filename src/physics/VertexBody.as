package physics
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Shape;
	import flash.geom.Point;

	public class VertexBody extends Shape
	{
		private var _body:b2Body                = null;
		private var _fixture:b2Fixture           = null;
		private var _bodyType:uint;
		
		private const coord:Point					= new Point();
		private const _pixelInitialPosition:Point 	= new Point();
		
		public static var ID:int = 0;
		private var _id:int = VertexBody.ID++;
		
		
		public function VertexBody( position:Point, bodyType:uint = 2 /* b2Body.b2_dynamicBody */ )
		{
			this._pixelInitialPosition.x = position.x;
			this._pixelInitialPosition.y = position.y;
			
			this._bodyType = bodyType;
			
			this.init();
		}
		
		public function destroy():void
		{
			Config.WORLD.DestroyBody( _body );
			
			_body 					= null;
			_fixture 				= null;
		}
		
		private function init():void
		{
			var bodyDef:b2BodyDef                 = new b2BodyDef();
			bodyDef.position.Set( _pixelInitialPosition.x / Config.WORLDSCALE, _pixelInitialPosition.y / Config.WORLDSCALE );
			
			bodyDef.type 			    = _bodyType; 
			
			bodyDef.linearDamping	    = .01;
			bodyDef.angularDamping	    = .01;
			
			var circularShape:b2CircleShape	= new b2CircleShape( 1 / Config.WORLDSCALE );
			
			var fixtureDef:b2FixtureDef	= new b2FixtureDef();
			fixtureDef.shape			= circularShape;
			fixtureDef.friction			= 0.5;
			fixtureDef.density			= 1;
			fixtureDef.restitution		= 1;
			
			this.body                   = Config.WORLD.CreateBody( bodyDef );
			this._fixture               = this.body.CreateFixture( fixtureDef );
		}
		
		public function  get pixelCoordinates():Point
		{
			var position:b2Vec2 = this.body.GetPosition();
			coord.x = position.x * Config.WORLDSCALE;
			coord.y = position.y * Config.WORLDSCALE;
			return coord;
		}
		
		public function update():void
		{
			var position:Point = this.pixelCoordinates;
			this.x = position.x;
			this.y = position.y;
			
			var angle:Number = body.GetAngle();
			this.rotation = angle * 180 / Math.PI;
		}
		
		public function draw( scale:Number = 1, color:Number = 0xFF0000, alpha:Number = 1 ):void
		{
			var radius:Number  = 1 * scale;
			
			graphics.clear();
			graphics.beginFill( color, alpha );
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
		}

		public function get body():b2Body
		{
			return _body;
		}

		public function set body(value:b2Body):void
		{
			_body = value;
		}

		public function get pixelInitialPosition():Point
		{
			return _pixelInitialPosition;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		
	}
}


	





