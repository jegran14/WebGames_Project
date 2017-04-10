package 
{
	import com.friendsofed.vector.*;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.textures.Texture;
	
	public class Ball extends Sprite 
	{
		protected var _posActual:Point;
		protected var _posAnterior:Point;
		protected var _IsFreezed:Boolean;
		
		//Constructores
		public function Ball(posX:Number, posY:Number, angle:Number, speed:Number = 10) 
		{
			super();
						
			_posActual = new Point(posX, posY);
			
			_posAnterior = new Point( _posActual.x - Math.cos(angle) * speed, _posActual.y - Math.sin(angle) * speed);
		}
		
		
		//Getters y Setters
		public function set PosX(x:Number):void	{ _posActual.x = x; }
		public function set PosY(y:Number):void { _posActual.y = y; }
		public function set Vx(value:Number):void {_posAnterior.x = PosX - value; }
		public function set Vy(value:Number):void {_posAnterior.y = PosY - value; }
		public function set SetX(value:Number):void 
		{
			_posAnterior.x = value - Vx; 
			PosX = value;
		}
		public function set SetY(value:Number):void 
		{
			_posAnterior.y = value - Vy; 
			PosY = value;
		}
		
		public function get PosX():Number { return _posActual.x;}
		public function get PosY():Number {return _posActual.y; }
		public function get Vx():Number { return PosX - _posAnterior.x; }
		public function get Vy():Number { return PosY - _posAnterior.y;}
			
		public function get IsFreezed():Boolean {return _IsFreezed; }
				
		//Public functions
		public function getRadius():Number {return 0;}
		
		public function UpdateMovement():void
		{
			var _tempX:Number = PosX;
			var _tempY:Number = PosY;
			
			PosX += Vx;
			PosY += Vy;
			
			_posAnterior.x =_tempX;
			_posAnterior.y = _tempY;
		}
	}
}