package 
{
	import com.friendsofed.vector.*;
	import flash.display.Bitmap;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.textures.Texture;
	
	public class Cannon extends Ball
	{		
		[Embed(source = "../media/graphics/cannon.png")]
		private static var cannonBitmap:Class;
		private var cannon:Image;
		
		public function Cannon(posX:Number, posY:Number) 
		{
			super(posX, posY, 0);
		    addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
				
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
					rotate(new VectorModel(PosX, PosY, touch.globalX, touch.globalY));
				}
			}
		}
		
		//Otras funciones
		override public function getRadius():Number {return cannon.width / 2; }
		
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
			cannon.x = PosX;
			cannon.y = PosY;
			
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