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
		public function Ball(posX:Number, posY:Number, vector:VectorModel, speed:Number = 6) 
		{
			super();
						
			_posActual = new Point(posX, posY);
			
			_posAnterior = new Point( _posActual.x - Math.cos(vector.angle) * speed, _posActual.y - Math.sin(vector.angle) * speed);
		}
		
		/*public function Ball(posX:Number, posY:Number) 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_posActual = new Point(posX, posY);
			_posAnterior = new Point (posX + 5, posY + 5);
		}
		/*
		public function Ball(InitX:Number, InitY:Number, direction:VectorModel) 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}*/
		
		//Getters y Setters
		public function set PosX(x:Number):void	{ _posActual.x = x; }
		public function set PosY(y:Number):void { _posActual.y = y; }
		public function get PosX():Number { return _posActual.x;}
		public function get PosY():Number {return _posActual.y; }
		public function get IsFreezed():Boolean {return _IsFreezed; }
		
		public function get Speed():Point 
		{
			return new Point(_posActual.x - _posAnterior.x, _posActual.y - _posAnterior.y);
		}
		
		public function get Direction():VectorModel 
		{ 
			var bx:Number = _posActual.x + this.Speed.x;
			var by:Number = _posActual.y + this.Speed.y;
			return new VectorModel(_posActual.x, _posActual.y, bx, by);
			
		}
				
		//Public functions
		public function Update(x:Number, y:Number):void
		{
			_posAnterior.x = _posActual.x;
			_posAnterior.y = _posActual.y;
			
			_posActual.x = x;
			_posActual.y = y;
		}
	}
}