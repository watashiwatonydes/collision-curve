package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;

	public class Config
	{
		

		public static const GRAVITY:b2Vec2 		= new b2Vec2( 0, 0 );
		public static const WORLDSCALE:uint 	= 30;
		public static const WORLD:b2World 		= new b2World(GRAVITY, true);
		public static const DT:Number			= 1/30;
		
		
	}
}