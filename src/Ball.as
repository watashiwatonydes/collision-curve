package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Ball extends Sprite
	{
		
		private var _radius:Number;
		private var _angle:Number 	= 0;
		private var _speed:Number 	= 0.01;
		private var _color:Number 	= 0xff0000;
		private var _rangeX:Number;
		private var _centerX:Number;
		
		
		private var _oldX:Number	= 0;
		private var _vx:Number		= 0;
		
		public static const COLLISION:String = "collision";

		
		public function Ball( radius:Number, speed:Number, color:Number, centerX:Number, rangeX:Number )
		{
			super();
			
			_radius 	= radius;
			_speed		= speed;
			_color 		= color;
			_centerX 	= centerX; 
			_rangeX 	= rangeX; 
			
			_oldX 		= _centerX;
			
			this.init( color );
		}
		
		private function init( color:Number ):void
		{
			graphics.clear();
			graphics.lineStyle( 1, 0xffffff );			
			graphics.beginFill( 0xffffff );			
			graphics.drawCircle(0, 0, _radius);			
			graphics.endFill();			
		}
		
		public function update(event:Event):void
		{
			x 		= _centerX + Math.sin( _angle ) * (_rangeX * .5 - _radius * .5);
			_angle 	+= _speed;

			_vx 	= x - _oldX;
			_oldX	= x;
			
			alpha 		+= (.1 - alpha) * .05;
		}
		
		public function solveCollisionWithBounds(top:Number, right:Number, bottom:Number, left:Number):void
		{
			
			if ( Math.abs( (x + _radius) - right) < 2 )
			{
				alpha  = 1;
				
				dispatchEvent( new Event( Ball.COLLISION ) ); 
			}
			if ( Math.abs( (x - _radius) - left) < 2 )
			{
				alpha = 1;
			}
			if (y + _radius > bottom)
			{
			}
			if (y - _radius < top)
			{
			}
		}
		
		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get vx():Number
		{
			return _vx;
		}
			
		
		
		
	}
}