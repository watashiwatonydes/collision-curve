package physics
{
	import flash.geom.Point;
	
	import geometry.Delaunay;

	public class PhysicHelper
	{
		
		private static var ConnectionsMap:Object = new Object();
		
		public static function ConnectBodies( bodies:Vector.<VertexBody> ):Vector.<JointConnection>
		{
			
			var ln:int = bodies.length; 
			if ( ln < 2 )
				throw new Error( "Parameter bodies must contains at least 2 VerticeBody instances" );
			
			var buffer:Vector.<JointConnection> 	= new Vector.<JointConnection>();
			

			var b0:VertexBody, b1:VertexBody;
			var conn:JointConnection;
			
			for ( var i:int = 0 ; i < ln - 1 ; i++ )
			{
				b0 	= bodies[ i ];
				
				for ( var j:int = i + 1 ; j < ln ; j++ )
				{
					b1 	= bodies[ j ];
					
					conn = new JointConnection( JointConnection.DISTANCE_JOINT, b0, b1 );
					
					buffer.push( conn );
				}
			}
			
			return buffer;
		}
		
		
		
		
	}
}