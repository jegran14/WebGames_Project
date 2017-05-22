package Levels 
{
	import GameObjects.*;
	import com.friendsofed.vector.VectorModel;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Level3 extends Level 
	{		
		private var timer:Timer;
		
		public function Level3(_nextLvl:Level = null, _nbolas:int=3, _bg:String="BlueBg") 
		{
			super(_nextLvl, _nbolas, "Lvl3Bg");
		}
		
		private function startTiming():void 
		{
			timer = new Timer (5000,0);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onSec);
		}
		
		private function onSec(e:TimerEvent):void 
		{
			if (pelotas.length > 0 && pelotas.length <= 7)
			{
				var i:int = Math.random() * (pelotas.length - 1);
				
				//Crear y reescalar la nueva bola
				var newCube:Enemies = new Enemies(pelotas[i].PosX, pelotas[i].PosY, 0, pelotas[i].CubeScale)
				newCube.Vx = -pelotas[i].Vx;
				newCube.Vy = pelotas[i].Vy;
				newCube.IsFreezed = true;
				pelotas.push(newCube);
				addChild(newCube);
			}
		}
		protected override function createBalls(scale:Number):void 
		{			
			for (var i:int = 0; i < nballs; i++)
			{
				var initX:int = Math.random() * stage.stageWidth;
				var initY:int = Math.random() * stage.stageHeight;
				var angle:Number = Math.random() * 2 * Math.PI;
				
				var lasPelotasDeCarlos:Enemies = new Enemies(initX, initY, angle, 0.6);
				
				pelotas.push(lasPelotasDeCarlos);
				
				addChild(lasPelotasDeCarlos);
			}
			
			startTiming();
		}
		
		protected override function moveBalls():void
		{
			if (pelotas.length > 0)
			{
				for (var i:int = pelotas.length - 1; i >= 0 ; i--)
				{		
					if (physics.testBoundaries(pelotas[i]))
					{
						physics.bounceWithBoundarie(pelotas[i]);
					}
					
					var inCollission:Boolean = pelotas[i].IsFreezed;
					
					for (var j:int = 0; j < i; j++ )
					{
						if (physics.testBoundaries(pelotas[j]))
						{
							physics.bounceWithBoundarie(pelotas[j]);
						}
						
						if (physics.collisionWithBalls(pelotas[i], pelotas[j]))
						{
							if(!pelotas[i].IsFreezed && !pelotas[j].IsFreezed)
								physics.bounceBalls(pelotas[i], pelotas[j]);
								EnemyCollide.play();
						}
						else if (inCollission) inCollission = false;
					}
					
					pelotas[i].IsFreezed = inCollission;
					
					for (var k:int = proyectiles.length - 1; k >= 0; k--)
					{
						if (physics.collisionWithBalls(pelotas[i], proyectiles[k]))
						{
							removeChild(proyectiles[k]);
							proyectiles.removeAt(k);
							
							if (pelotas[i].CubeScale <= 0.3)
							{
								pelotas[i].Destroy();
								EnemyDestroy.play();
								pelotas.removeAt(i);
								score.addScore();
								return;
							}
							else
							{								
								//Reescalar la bola
								pelotas[i].CubeScale -= 0.2;
								
								
								//Crear y reescalar la nueva bola
								var newCube:Enemies = new Enemies(pelotas[i].PosX, pelotas[i].PosY, 0, pelotas[i].CubeScale)
								newCube.Vx = -pelotas[i].Vx;
								newCube.Vy = pelotas[i].Vy;
								newCube.IsFreezed = true;
								pelotas.push(newCube);
								addChild(newCube);
							}
							
							
						}
					}
					
					if (physics.collisionWithBalls(pelotas[i], player))
					{
						physics.bounceWithPlayer(pelotas[i], player);
						player.ExecuteShield();	
						shieldCollision.play();
					}
					
					pelotas[i].UpdateMovement();
				}
			}
		}
		
		override protected function isLevelFinished():Boolean 
		{
			if (pelotas.length == 0)
			{
				removeEventListener(TimerEvent.TIMER, onSec);
				return true;
			}
			return false;
		}
	}

}