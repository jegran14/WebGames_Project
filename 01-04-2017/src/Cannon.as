package 
{
	import com.friendsofed.vector.*;
	import flash.display.Bitmap;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.textures.Texture;
	
	public class Cannon extends Sprite
	{		
		[Embed(source = "../media/graphics/cannon.png")]
		private static var cannonBitmap:Class;
		private var cannon:Image;
		private var _posX:Number;
		private var _posY:Number;
		
		public function Cannon(posX:Number, posY:Number) 
		{
			super();
		    addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			//Posiciones iniciales
			_posX = posX;
			_posY = posY;
		}
		
		//Getters y Setters
		public function set PosX(x:Number):void { _posX = x; }
		public function set PosY(y:Number):void { _posY = y; }
		public function get PosX():Number {	return _posX; }
		public function get PosY():Number {	return _posY; }
		
		//Event Handlers
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			create();
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			if (touch)
			{
				if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.MOVED)
				{
					rotate(new VectorModel(_posX, _posY, touch.globalX, touch.globalY));
				}
			}
		}
		
		//Otras funciones
		private function create():void
		{
			//Cargar textura
			var bitmap:Bitmap = new cannonBitmap();
			cannon = new Image(Texture.fromBitmap(bitmap));
			
			//Escalar
			//cannon.scaleX = 0.7;
			//cannon.scaleY = 0.7;
			
			//Cambiar pivote
			cannon.alignPivot();
			
			//Poner coordenadas
			cannon.x = _posX;
			cannon.y = _posY;
			
			//Añadirlo al stage
			this.addChild(cannon);
		}
		
		private function rotate(vector:VectorModel):void
		{
			cannon.rotation = vector.angle + Math.PI/2;
		}
		
		public function Shoot():void
		{
			
		}
	}
}