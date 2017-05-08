package Levels 
{
	import GameObjects.*;
	import com.friendsofed.vector.VectorModel;
	
	public class Level3 extends Level 
	{
		
		public function Level3(_nbolas:int=1, _bg:String="BlueBg") 
		{
			super(_nbolas, "Lvl3Bg");
			
		}
		
		protected override function createBalls(scale:Number):void 
		{
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
							
							if (pelotas[i].CubeScale <= 0.6)
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
								pelotas[i].CubeScale = pelotas[i].CubeScale - 0.2;
								pelotas[i].Vx *= Math.cos(dir.angle + Math.PI / 2);
								pelotas[i].Vy *= Math.sin(dir.angle + Math.PI / 2);
								
								
								//Crear y reescalar la nueva bola
								var newCube:Enemies = new Enemies(pelotas[i].PosX, pelotas[i].PosY, dir.angle - Math.PI / 2, pelotas[i].CubeScale)
								pelotas.push(newCube);
								addChild(newCube);
							}
							
							
						}
					}
					
					if (physics.collisionWithBalls(pelotas[i], player))
					{
						physics.bounceWithPlayer(pelotas[i], player);
					}
					
					pelotas[i].UpdateMovement();
				}
			}
		}
	}

}