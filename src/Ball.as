package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Ball extends Sprite
	{
		
		private var _radius:Number;
		private var _angle:Number = 0;
		private var _speed:Number = 0.02;
		private var _color:Number = 0xff0000;
		private var _rangeX:Number;
		private var _centerX:Number;
		
		
		public function Ball( radius:Number, mass:Number, color:Number, centerX:Number, rangeX:Number )
		{
			super();
			
			_radius 	= radius;
			_color 		= color;
			_centerX 	= centerX; 
			_rangeX 	= rangeX; 
			
			this.init( color );
		}
		
		private function init( color:Number ):void
		{
			graphics.clear();
			graphics.beginFill( color );			
			graphics.drawCircle(0, 0, _radius);			
			graphics.endFill();			
		}
		
		public function update(event:Event):void
		{
			x 		= _centerX + Math.sin( _angle ) * (_rangeX * .5 - _radius * .5);
			_angle 	+= _speed;
			
			alpha 		+= (.1 - alpha) * .05;
			
			scaleX 		+= (1 - scaleX) * .05;
			scaleY 		+= (1 - scaleY) * .05;
		}
		
		public function solveCollisionWithBounds(top:Number, right:Number, bottom:Number, left:Number):void
		{
			
			if ( Math.abs( (x + _radius) - right) < 1 )
			{
				alpha  = 1;
				scaleX = scaleY = 1.0;
			}
			if ( Math.abs( (x - _radius) - left) < 1 )
			{
				alpha = 1;
				scaleX = scaleY = 1.0;
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
			
		
		
		
	}
}