package GameObjects 
{
	import com.friendsofed.vector.*;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.textures.Texture;
	import flash.media.Sound;
	import com.greensock.TweenLite;
	
	public class Cannon extends Ball
	{		
		private var cannon:Image;
		private var bx:Number;
		private var by:Number;
		private var bulletRad:Number;
		private var laserGun:Sound = new Assets.LaserGun(); 
		private var shield:Image;
		
		public function Cannon(posX:Number, posY:Number) 
		{
			super(posX, posY, 0);
		    addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
			
		public function get bulletStartX():Number{ return PosX + 35*Math.cos(cannon.rotation+30); }
		public function get bulletStartY():Number{ return PosY + 35*Math.sin(cannon.rotation+30); }
		
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
		override public function getRadius():Number {return (shield.width / 2 )* 0.8; }
		
		private function create():void
		{
			//Cargar textura
			cannon = new Image(Assets.getTexture("Player"));;
			
			//Cambiar pivote
			cannon.alignPivot();
			
			//Poner coordenadas
			cannon.x = PosX;
			cannon.y = PosY;
			
			//Distancia hasta la pistola
			bx =  PosX + cannon.width / 2;
			by =  PosY - cannon.height / 4;
			
			var disX:Number = Math.abs(bx - PosX);
			var disY:Number = Math.abs(PosY - by);
			
			bulletRad = Math.sqrt(disX * disX + disY * disY);
			
			
			//Añadirlo al stage
			this.addChild(cannon);
		}
		//Escudo
		public function createShield():void
		{
			shield = new Image(Assets.getTexture("Shield"));
			shield.alignPivot();
			shield.x = PosX;
			shield.y = PosY;
			shield.scale = 0.3;
		}
		
		private function rotate(vector:VectorModel):void
		{
			cannon.rotation = vector.angle;
		}
		
		public function UpdateImage():void 
		{
			cannon.x = PosX;
			cannon.y = PosY;
		}
		
		public function Shoot():void
		{
			
			laserGun.play();
		
		}
		public function ExecuteShield():void
		{
			addChild(shield);
			TweenLite.to(shield, 0.2, {alpha:0.2, onComplete:remove_shield});
		}
		private function remove_shield():void 
		{
			removeChild(shield);
			shield.alpha = 1;
		}
	}
}