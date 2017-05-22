package GameObjects 
{
	import com.adobe.tvsdk.mediacore.AdPolicySelectorType;
	import com.friendsofed.vector.*;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.textures.Texture;
	import com.greensock.TweenLite
	import events.DestroyBallEvent;
	
	public class Enemies extends Ball
	{
		private var ballImage:Image;
		private var myScale:Number;
		
		public function Enemies(posX:Number, posY:Number, angle:Number, _scale:Number = 0.2) 
		{
			super(posX, posY, angle, 4);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			myScale = _scale;
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
			ballImage = new Image(Assets.getTexture("EnemyCube"));
			
			//Escalar
			ballImage.scaleX = myScale;
			ballImage.scaleY = myScale;
			
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
		
		
		override public function getRadius():Number {return (ballImage.width / 2) * 0.8; }
		public function set CubeScale (_scale:Number):void 
		{ 
			myScale = _scale;
			ballImage.scale = _scale;
		}
		public function get CubeScale ():Number	{ return myScale; }
		
		override public function UpdateMovement():void
		{
			if (!IsFreezed)
			{
				var _tempX:Number = PosX;
				var _tempY:Number = PosY;
				
				PosX += Vx;
				PosY += Vy;
				
				_posAnterior.x =_tempX;
				_posAnterior.y = _tempY;
				
				ballImage.x = PosX;
				ballImage.y = PosY;
				ballImage.rotation += 0.1;
			}
			
		}
		
		public function freeze():void 
		{
			_IsFreezed = true;
			ballImage.alpha = 0.5;
		}
		
		public function unfreeze():void 
		{
			_IsFreezed = false;
			
			ballImage.alpha = 1;
			
			var alpha:Number = Math.random() * 2 * Math.PI;
			Vx = Speed * Math.cos(alpha);
			Vy = Speed * Math.sin(alpha);
		}
		
		public function Destroy():void
		{
			TweenLite.to(ballImage, 0.2, {scale:1.5,color:0x000000, onComplete:continueDestroying});
		}
		
		private function continueDestroying():void 
		{
			TweenLite.to(ballImage, 0.2, {scale:0, alpha:0, onComplete:endDestroying})
		}
		
		private function endDestroying():void 
		{
			dispatchEvent(new DestroyBallEvent(DestroyBallEvent.DESTROYBALL, true));
		}
	}

}