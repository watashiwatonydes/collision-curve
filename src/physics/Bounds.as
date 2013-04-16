package physics
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	
	import flash.display.Sprite;
	
	public class Bounds extends Sprite
	{
		private var _top:Boolean;
		private var _right:Boolean;
		private var _bottom:Boolean;
		private var _left:Boolean;
		private var _width:Number;
		private var _height:Number;
		
		public function Bounds( pWidth:Number, pHeight:Number, top:Boolean = false, right:Boolean = false, bottom:Boolean = false, left:Boolean = false )
		{
			_width 	= pWidth;	 
			_height = pHeight;
			
			_top 	= top;
			_right 	= right;
			_bottom = bottom;
			_left	= left;

			create();
		}
		
		private function create():void
		{
			var bodyDef:b2BodyDef	= new b2BodyDef();
			
			if (_bottom)
			{
				bodyDef.position.Set( (_width/2) / Config.WORLDSCALE, (_height) / Config.WORLDSCALE );
			}
			
			bodyDef.type 					= b2Body.b2_staticBody;
			
			var polygonShape:b2PolygonShape	= new b2PolygonShape();
			
			if ( _bottom )
			{
				polygonShape.SetAsBox( (_width) / Config.WORLDSCALE, 1 / Config.WORLDSCALE );
			}
			
			var fixtureDef:b2FixtureDef		= new b2FixtureDef();
			fixtureDef.shape				= polygonShape;
			
			var theFloor:b2Body				= Config.WORLD.CreateBody( bodyDef );	
			theFloor.CreateFixture( fixtureDef );
		}		
		
		public function draw():void
		{
			graphics.lineStyle(2, 0xffffff );
			
			if ( _bottom )
			{
				graphics.moveTo( 0, 798 );
				graphics.lineTo( _width, 798 );
			}
		}
		
		
	}
}