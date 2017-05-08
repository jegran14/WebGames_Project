package Levels 
{
	import GameObjects.*;
	
	public class Level3 extends Level 
	{
		
		public function Level3(_nbolas:int=3, _bg:String="BlueBg") 
		{
			super(_nbolas, _bg);
			
		}
		
		protected override function createBalls(scale:Number):void 
		{
			for (var i:int = 0; i < nballs; i++)
			{
				var initX:int = Math.random() * stage.stageWidth;
				var initY:int = Math.random() * stage.stageHeight;
				var angle:Number = Math.random() * 2 * Math.PI;
				
				var lasPelotasDeCarlos:Enemies = new Enemies(initX, initY, angle);
				
				lasPelotasDeCarlos.CubeScale = 1;
				
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
							removeChild(pelotas[i]);
							pelotas.removeAt(i);
							score.addScore();
							return;
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