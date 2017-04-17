package 
{
	public class Level2 extends Level 
	{
		private var freezedCount:int;
		
		public function Level2() 
		{
			super();
			freezedCount = 0;
		}
		
		//Comprobar colisiones
		override protected function moveBalls():void
		{
			if (pelotas.length > 0)
			{
				for (var i:int = pelotas.length - 1; i >= 0 ; i--)
				{		
					if (testBoundaries(pelotas[i]))
					{
						bounceWithBoundarie(pelotas[i]);
					}
					
					for (var j:int = 0; j < i; j++ )
					{
						if (testBoundaries(pelotas[j]))
						{
							bounceWithBoundarie(pelotas[j]);
						}
						
						if (!pelotas[i].IsFreezed && !pelotas[j].IsFreezed && collisionWithBalls(pelotas[i], pelotas[j]))
						{
							bounceBalls(pelotas[i], pelotas[j]);
						}
					}
					
					for (var k:int = proyectiles.length - 1; k >= 0; k--)
					{
						if (collisionWithBalls(pelotas[i], proyectiles[k]))
						{
							//Congelar o descongelar pelotas
							if (pelotas[i].IsFreezed)
							{
								pelotas[i].unfreeze();
								freezedCount--;
								score.substractScore();
							}
							else
							{
								pelotas[i].freeze();
								freezedCount++;
								score.addScore();
							}
								
							//Eliminar proyectil
							removeChild(proyectiles[k]);
							proyectiles.removeAt(k);
						}
					}
					
					if (collisionWithBalls(pelotas[i], player))
					{
						bounceWithPlayer(pelotas[i]);
					}
					
					pelotas[i].UpdateMovement();
				}
			}
		}
		
		override protected function isLevelFinished():Boolean 
		{
			return freezedCount == pelotas.length;
		}
		
	}

}