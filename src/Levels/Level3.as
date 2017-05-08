package Levels 
{
	import GameObjects.*;
	import com.friendsofed.vector.VectorModel;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Level3 extends Level 
	{		
		private var time:Number;
		private var timer:Timer;
		
		public function Level3(_nbolas:int=3, _bg:String="BlueBg") 
		{
			super(_nbolas, "Lvl3Bg");
			time = 0;
		}
		
		private function startTiming():void 
		{
			timer = new Timer (5000,0);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onSec);
		}
		
		private function onSec(e:TimerEvent):void 
		{
			trace(time);
			var i:int = Math.random() * pelotas.length - 1;
			
			//Antigua dirección de la bola
			var dir:VectorModel = new VectorModel(0, 0, 0, 0, pelotas[i].Vx, pelotas[i].Vy)
			var oldVx:Number = pelotas[i].Vx;
			var oldVy:Number = pelotas[i].Vy;
			
			//Reescalar y cambiar dirección de la bola

			
			
			//Crear y reescalar la nueva bola
			var newCube:Enemies = new Enemies(pelotas[i].PosX + 0.5, pelotas[i].PosY + 0.5, dir.angle, pelotas[i].CubeScale)
			newCube.Vx = oldVx * Math.cos(dir.angle - Math.PI / 4);
			newCube.Vy = oldVy * Math.sin(dir.angle - Math.PI / 4);
			pelotas.push(newCube);
			addChild(newCube);
		}
		protected override function createBalls(scale:Number):void 
		{
			startTiming();
			
			for (var i:int = 0; i < nballs; i++)
			{
				var initX:int = Math.random() * stage.stageWidth;
				var initY:int = Math.random() * stage.stageHeight;
				var angle:Number = Math.random() * 2 * Math.PI;
				
				var lasPelotasDeCarlos:Enemies = new Enemies(initX, initY, angle, 1);
				
				pelotas.push(lasPelotasDeCarlos);
				
				addChild(lasPelotasDeCarlos);
			}
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
					
					for (var j:int = 0; j < i; j++ )
					{
						if (physics.testBoundaries(pelotas[j]))
						{
							physics.bounceWithBoundarie(pelotas[j]);
						}
						
						if (physics.collisionWithBalls(pelotas[i], pelotas[j]))
						{
							physics.bounceBalls(pelotas[i], pelotas[j]);
						}
					}
					
					for (var k:int = proyectiles.length - 1; k >= 0; k--)
					{
						if (physics.collisionWithBalls(pelotas[i], proyectiles[k]))
						{
							removeChild(proyectiles[k]);
							proyectiles.removeAt(k);
							
							if (pelotas[i].CubeScale <= 0.7)
							{
								removeChild(pelotas[i]);
								pelotas.removeAt(i);
								score.addScore();
								return;
							}
							else
							{		
								//Antigua dirección de la bola
								var dir:VectorModel = new VectorModel(0, 0, 0, 0, pelotas[i].Vx, pelotas[i].Vy)
								
								//Reescalar y cambiar dirección de la bola
								pelotas[i].CubeScale -= 0.2;
								pelotas[i].Vx *= Math.cos(dir.angle + Math.PI / 2);
								pelotas[i].Vy *= Math.sin(dir.angle + Math.PI / 2);
								
								
								//Crear y reescalar la nueva bola
								var newCube:Enemies = new Enemies(pelotas[i].PosX, pelotas[i].PosY, dir.angle, pelotas[i].CubeScale)
								newCube.Vx = pelotas[i].Vx * Math.cos(dir.angle - Math.PI / 2);
								newCube.Vy = pelotas[i].Vy * Math.sin(dir.angle - Math.PI / 2);
								pelotas.push(newCube);
								addChild(newCube);
							}
							
							
						}
					}
					
					if (physics.collisionWithBalls(pelotas[i], player))
					{
						physics.bounceWithPlayer(pelotas[i], player);
						player.ExecuteShield();	
					}
					
					pelotas[i].UpdateMovement();
				}
			}
		}
	}

}