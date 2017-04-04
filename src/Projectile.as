package 
{
	import com.friendsofed.vector.*;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.textures.Texture;
	
	public class Projectile extends Ball 
	{
		[Embed(source = "../media/graphics/firegreen.png")]
		private static var ballBitmap:Class;
		private var ballImage:Image;
		
		public function Projectile(posX:Number, posY:Number, angle:Number) 
		{
			super(posX, posY, angle);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		//Event Handlers
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			create();
		}
		
		//Private functions
		private function create():void 
		{
			//Cargar textura
			var bitmap:Bitmap = new ballBitmap();
			ballImage = new Image(Texture.fromBitmap(bitmap));
			
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
			ballImage.rotation = direction.angle - Math.PI/2;
			
			//Añadir al stage
			this.addChild(ballImage);
		}
		
		override public function UpdateMovement():void
		{
			var _tempX = PosX;
			var _tempY = PosY;
			
			PosX += Vx;
			PosY += Vy;
			
			_posAnterior.x =_tempX;
			_posAnterior.y = _tempY;
			
			ballImage.x = PosX;
			ballImage.y = PosY;
		}
		
	}

}