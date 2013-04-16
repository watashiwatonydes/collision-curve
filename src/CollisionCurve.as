package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.BaselineShift;
	
	import net.ivank.voronoi.VEdge;
	import net.ivank.voronoi.Voronoi;
	
	[SWF( widthPercent="100", heightPercent="100", frameRate="40", backgroundColor=0x111111 )]
	public class CollisionCurve extends Sprite
	{
		private var _particles:Vector.<Ball>;
		private var _particlesContainer:Sprite;
		private var _curvePoints:Vector.<Point>;
		private var _voronoiHolder:Sprite;
		
		
		private var RANGE_X:int = 300;
		private var DRAW_OFFSET_Y:int = 0;
		private var POSY:Number 	= 40;
		private var DRAW_BUFFER:BitmapData;
		private var CANVAS:Bitmap;
		private var DRAW_TIMER:Timer;
		private var BASE_VX:Number 	= 6;
		private var BASE_VY:Number 	= 1;
		private var LEFT:int 		= 0;
		private var RIGHT:int		= 1;

		
		public function CollisionCurve()
		{
			stage.align		= StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.init();
		}
		
		private function init():void
		{
			DRAW_BUFFER 		= new BitmapData( stage.stageWidth, stage.stageHeight * .5, true, 0x00ffffff )
			CANVAS 				= new Bitmap( DRAW_BUFFER );
			CANVAS.bitmapData 	= DRAW_BUFFER;
			CANVAS.y 			= stage.stageHeight * .5;
			addChild( CANVAS );	
			
			DRAW_TIMER = new Timer( 100, 30 );
			DRAW_TIMER.addEventListener(TimerEvent.TIMER, snap);
			DRAW_TIMER.start();
			
			_particles 				= new Vector.<Ball>();

			_particlesContainer 	= new Sprite();
			addChild( _particlesContainer );
			
			_curvePoints 	= new Vector.<Point>();
			
			addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			var ns:Number = _particles[0].speed;
			switch( event.keyCode )
			{
				case Keyboard.UP:
					ns += .02;
					break;
				case Keyboard.DOWN:
					ns -= .02;
					break;
			}
			
			for each ( var p:Ball in _particles )
				p.speed = ns;
		}
		
		protected function update(event:Event):void
		{
			var top:Number 		= 0;
			var right:Number 	= RANGE_X;
			var bottom:Number 	= stage.stageHeight;
			var left:Number 	= 0;
			
			var b0:Ball, bn:Ball;
			var i:int;
			var ln:int = _particles.length;
			
			if ( _particles.length > 0 )
			{
				for ( i = 0 ; i < ln ; i ++ )
				{
					b0 = _particles[ i ];
					b0.update(event);
					b0.solveCollisionWithBounds( top, right, bottom, left);
				}

				graphics.clear();
				graphics.lineStyle( 1, 0xCCCCCC, 1 );

				for ( i = 0 ; i < ln ; i ++ )
				{
					b0 			= _particles[ i ];
					bn			= _particles[ ln - i - 1 ];
				}
				
			}
			
		}
		
		protected function createBall( side:int ):void
		{
			var ball:Ball;
		
			ball  		= new Ball( 10, 1, 0xff0000, 150, RANGE_X );
			
			_particlesContainer.addChild( ball );
					
			ball.y 		= POSY;
		
			POSY 	+= 20;
			
			_particles.push( ball );
		}
		
		protected function snap(event:TimerEvent):void
		{
			createBall( LEFT );
		}
		
	}
}