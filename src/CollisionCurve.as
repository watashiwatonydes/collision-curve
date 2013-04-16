package
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.BaselineShift;
	
	import geometry.Quad;
	
	import net.ivank.voronoi.VEdge;
	import net.ivank.voronoi.Voronoi;
	
	import physics.JointConnection;
	import physics.PhysicHelper;
	import physics.VertexBody;
	
	[SWF( widthPercent="100", heightPercent="100", frameRate="40", backgroundColor=0x000000 )]
	public class CollisionCurve extends Sprite
	{
		private var _particles:Vector.<Ball>;
		private var _particlesContainer:Sprite;
		private var _quadsContainer:Sprite;
		private var _voronoiHolder:Sprite;
		
		
		private var DRAW_OFFSET_Y:int 	= 0;
		private var POSY:Number 		= 10;
		private var DRAW_BUFFER:BitmapData;
		private var CANVAS:Bitmap;
		private var CREATION_TIMER:Timer;
		private var BASE_VX:Number 	= 6;
		private var BASE_VY:Number 	= 1;
		private var LEFT:int 		= 0;
		private var RIGHT:int		= 1;
		private var _quads:Object	= new Vector.<Quad>();
		
		public static const COLORS:Array = [ 0xFFD702, 0xFFFFFF, 0x323232, 0x111111, 0x000000 ];
		private var CAPTURE_TIMER:Timer;

		private var DRAW_MATRIX:Matrix;

		
		public function CollisionCurve()
		{
			stage.align		= StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.initWave();
		}
	
		private function initWave():void
		{
			DRAW_BUFFER 		= new BitmapData( stage.stageWidth, stage.stageHeight, true, 0x00ffffff )
			CANVAS 				= new Bitmap( DRAW_BUFFER );
			CANVAS.bitmapData 	= DRAW_BUFFER;
			CANVAS.x 			= 0;
			CANVAS.y 			= 0;
			addChild( CANVAS );	
			
			CREATION_TIMER = new Timer( 500, 20 );
			CREATION_TIMER.addEventListener(TimerEvent.TIMER, create);
			CREATION_TIMER.start();
			
			CAPTURE_TIMER = new Timer( 400, 1 );
			CAPTURE_TIMER.addEventListener(TimerEvent.TIMER, takeSnapshot);
			// CAPTURE_TIMER.start();
			
			_particles 				= new Vector.<Ball>();

			_particlesContainer 	= new Sprite();
			 
			addChild( _particlesContainer );
			
			_quadsContainer 	= new Sprite();
			
			addChild( _quadsContainer );

			
			addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		protected function takeSnapshot(event:TimerEvent):void
		{
			DRAW_MATRIX = new Matrix();
			
			DRAW_BUFFER.draw( _quadsContainer );
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			var ns:Number = _particles[0].speed;
			switch( event.keyCode )
			{
				case Keyboard.UP:
						ns += .01;
					break;
				case Keyboard.DOWN:
						ns -= .01;
					break;
				case Keyboard.SPACE:
					takeSnapshot( null );
					break;
				case Keyboard.P:
					
					if (contains( _particlesContainer ) )
						removeChild( _particlesContainer );
					else
						addChild( _particlesContainer );
					
					break;
				case Keyboard.Q:
					
					if (contains( _quadsContainer ) )
						removeChild( _quadsContainer );
					else
						addChild( _quadsContainer );
					
					break;
			}
			
			for each ( var p:Ball in _particles )
				p.speed = ns;
		}
		
		protected function update(event:Event):void
		{
			var top:Number 		= 0;
			var right:Number 	= stage.stageWidth * .5;
			var bottom:Number 	= stage.stageHeight;
			var left:Number 	= stage.stageWidth * .5;
			
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

			
			renderPhysic();
		}
		
		private function renderPhysic():void
		{
			Config.WORLD.Step( Config.DT, 6, 6 );
			Config.WORLD.ClearForces();
			
			var q:Quad;
			for each ( q in _quads )
			{
				q.draw();
			}
		}
		
		protected function createBall():Ball
		{
			var ball:Ball;
			var speed:Number 	= 0.02;
			var radius:Number 	= (stage.stageHeight / CREATION_TIMER.repeatCount) / 2;
			
			ball  		= new Ball( radius, speed, 0xff0000, stage.stageWidth * .5, 200 );
			
			_particlesContainer.addChild( ball );
					
			ball.x		= stage.stageWidth * .5;
			ball.y 		= POSY;

			POSY 	+= radius * 2;
			
			_particles.push( ball );
			
			return ball;
		}
		
		protected function create(event:TimerEvent):void
		{
			var b:Ball = createBall();
			b.addEventListener( Ball.COLLISION, onBallCollideWithWall );
		}
		
		protected function onBallCollideWithWall(event:Event):void
		{
			var b:Ball 		= event.currentTarget as Ball;
		
			var point:Point = new Point( b.x, b.y );	
			
			var quad:Quad 	= createQuadAtPoint( point );
			
			var colorIndex:int	= Math.random() * COLORS.length;
			
			quad.color		= 0xffffff; // COLORS[ colorIndex ];
			
			var ln:int 		= _quads.length;
			
			var bodyIndex:int = Math.random() * 5;
			
			var b1:b2Body 	= quad.bodies[ bodyIndex ].body;
			
			var vx:Number	= (Math.random() * 2) / Config.WORLDSCALE; 	
			var vy:Number	= (Math.random() * 2) / Config.WORLDSCALE;
			
			if ( b.vx < 0 )
				vx *= -1;
			
			
			var f1:b2Vec2	= new b2Vec2( vx, vy );
			var fap1:b2Vec2	= b1.GetWorldCenter();
			
			b1.ApplyImpulse( f1, fap1 );
			
			
			if ( ln > 60 )
			{
				var q:Quad = _quads.shift();
				q.destroy();
				_quadsContainer.removeChild( q );
			}
			
		}
		
		private function createQuadAtPoint( p:Point ):Quad
		{
			var points:Vector.<Point> = new Vector.<Point>(4, true);
			
			var _loc1:Number 	= p.x;
			var _loc2:Number 	= p.y - 5;
			
			var _loc3:int		= 20 + Math.random() * Math.random() * 40;
			
			points[0] = new Point( _loc1 , _loc2 );
			points[1] = new Point( _loc1 + _loc3, _loc2 );
			points[2] = new Point( _loc1 + _loc3, _loc2 + _loc3 );
			points[3] = new Point( _loc1, _loc2 + _loc3 );
			
			var quad:Quad = new Quad( points );
			_quadsContainer.addChild( quad );	
			
			_quads.push( quad );
			
			return quad;
		}
		
	}
}