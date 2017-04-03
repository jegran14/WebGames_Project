package 
{
	import com.friendsofed.vector.*;
	import flash.geom.Point;
	import starling.display.Sprite;
	import starling.events.*;
	
	
	public class Level extends Sprite
	{
		private var player:Cannon;
		protected var proyectiles:Vector.<Projectile>;
		
		public function Level() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		//Event Handlers
		protected function onAdded(e:Event):void 
		{
			//Eventos
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			//Inicializar vector
			proyectiles = new Vector.<Projectile>();
			
			//Cosas del nivel
			player = new Cannon(stage.stageWidth / 2, stage.stageHeight / 2);
			addChild(player);
		}
		
		protected function onEnterFrame(e:Event):void 
		{
			//move objects
			moveProjectile();
			
			trace(proyectiles.length);
					
		}
		
		protected function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			
			if (touch)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
					shoot(touch.globalX, touch.globalY);
				}
			}
		}
		
		protected function shoot(mPosx:Number, mPosY:Number):void 
		{
			player.Shoot();
			
			var direction:VectorModel = new VectorModel(player.PosX, player.PosY, mPosx, mPosY);
			
			var aX:Number = player.height
			
			var proyectil:Ball = new Projectile(player.PosX, player.PosY, direction);
			
			proyectiles.push(proyectil);
			
			addChild(proyectil);
		}
		
		protected function moveProjectile():void
		{
			if (proyectiles.length > 0)
			{
				for (var i:int = proyectiles.length-1; i >= 0; i--)
				{
					//test collisions
					if (!handleProjectileCollision(i))
					{
						var newX:Number = proyectiles[i].PosX + proyectiles[i].Vx;
						var newY:Number = proyectiles[i].PosY + proyectiles[i].Vy;
					
						proyectiles[i].Update(newX, newY);
					}		
				}
			}
			
		}
		
		protected function handleProjectileCollision(i:int):Boolean
		{
			if ((proyectiles[i].PosX < 0) || (proyectiles[i].PosX > stage.stageWidth) || (proyectiles[i].PosY < 0) || (proyectiles[i].PosY > stage.stageHeight))
			{
				deleteBall(proyectiles, i);
				return true;
			}
			
			return false;
		}
		
		private function deleteBall( v:Vector.<Projectile>, i:int):void 
		{
			removeChild(v[i]);
			v.removeAt(i);
		}
				
	}

}