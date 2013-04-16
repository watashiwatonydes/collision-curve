package utils
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Grid extends Sprite
	{
		private var _cellSize:Number;
		private var _width:Number;
		private var _height:Number;
		private var _columns:int;
		private var _lines:int;
		
		private const _gridPoint:Point = new Point();
		
		
		public function Grid( pWidth:Number, pHeight:Number, cellSize:Number )
		{
			_width		 	= pWidth;
			_height			= pHeight;
			_cellSize		= cellSize;
		
			draw();
		}
		
		private function draw():void
		{
			graphics.lineStyle( 1, 0x004400, 1 );
			
			_columns 	= _width / _cellSize;
			_lines		= _height / _cellSize;
			
			var i:int, xAxis:Number, yAxis:Number;
			for ( i = 0 ; i < _lines + 1 ; i++ )
			{
				yAxis	= i * _cellSize;
				graphics.moveTo( 0, yAxis );
				graphics.lineTo( _width, yAxis );
			}
			
			for ( i = 0 ; i < _columns + 1 ; i++ )
			{
				xAxis	= i * _cellSize;
				graphics.moveTo( xAxis, 0 );
				graphics.lineTo( xAxis, _height );
			}
		}
		
		public function findGridPoint( mousePoint:Point ):Point
		{
			_gridPoint.x = int(mousePoint.x / _cellSize) * _cellSize;		
			_gridPoint.y = int(mousePoint.y / _cellSize) * _cellSize;
			
			return _gridPoint;
		}
		
		
	}
}