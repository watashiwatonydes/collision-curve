package
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Dot extends Shape
	{
		private var _radius:Number = 10;
		private var _iterations:int = 10;
		private var _angle:Number = 360 / _iterations;
		private var _iteration:int = 0;
		
		
		public function Dot( radius:Number, iteration:int, color:Number )
		{
			var x0:Number = _radius * Math.cos( 0 * 180 / Math.PI );
			var y0:Number = _radius * Math.sin( 0 * 180 / Math.PI );
			
			graphics.moveTo( x0, y0 );

			draw();
		}
		
		private function draw():void
		{
			graphics.lineStyle( 1, 0xFFFFFF );
			
			for ( _iteration = 0 ; _iteration < _iterations + 1 ; _iteration++ )
			{
				var theta:Number 	= _iteration * _angle * 0.0174532925;
				
				var _x:Number 		= _radius * Math.cos( theta );
				var _y:Number 		= _radius * Math.sin( theta );
				
				graphics.lineTo( _x, _y );
			}
			
		}		
		
		
	}
}