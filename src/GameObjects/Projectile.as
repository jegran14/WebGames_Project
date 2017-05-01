package GameObjects 
{
	import GameObjects.Ball;
	import com.friendsofed.vector.*;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.textures.Texture;
	
	public class Projectile extends Ball 
	{
		private var ballImage:Image;
		
		public function Projectile(posX:Number, posY:Number, angle:Number) 
		{
			super(posX, posY, angle,15);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		//Event Handlers
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			create();
		}
		
		override public function getRadius():Number {return (ballImage.width/2)*0.8; }
		
		//Private functions
		private function create():void 
		{
			//Cargar textura
			ballImage = new Image(Assets.getTexture("Projectile"));
			
			//Escalar
			/*ballImage.scaleX = 0.05;
			ballImage.scaleY = 0.05;*/
			
			//cambiar pivote
			ballImage.alignPivot();
			
			//Colocar en las coordenadas
			ballImage.x = _posActual.x;
			ballImage.y = _posActual.y;
			
			//rotation
			var direction:VectorModel = new VectorModel(_posActual.x, _posActual.y, _posAnterior.x, _posAnterior.y)
			ballImage.rotation = direction.angle;
			
			//Añadir al stage
			this.addChild(ballImage);
		}
		
		override public function UpdateMovement():void
		{
			var _tempX:Number = PosX;
			var _tempY:Number = PosY;
			
			PosX += Vx;
			PosY += Vy;
			
			_posAnterior.x =_tempX;
			_posAnterior.y = _tempY;
			
			ballImage.x = PosX;
			ballImage.y = PosY;
		}
		
	}

}