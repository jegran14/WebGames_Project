package Levels 
{
	import starling.events.Event;
	import starling.display.Image;
	public class Level2 extends Levels.Level 
	{
		private var frostCount:int;
		
		public function Level2() 
		{
			super(11,"PinkBg");
			frostCount = 0;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		//Comprobar colisiones
		override protected function moveBalls():void
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
						
						if (!pelotas[i].IsFreezed && !pelotas[j].IsFreezed && physics.collisionWithBalls(pelotas[i], pelotas[j]))
						{
							physics.bounceBalls(pelotas[i], pelotas[j]);
						}
					}
					
					for (var k:int = proyectiles.length - 1; k >= 0; k--)
					{
						if (physics.collisionWithBalls(pelotas[i], proyectiles[k]))
						{
							//Congelar o descongelar pelotas
							if (pelotas[i].IsFreezed)
							{
								pelotas[i].unfreeze();
								frostCount--;
								score.substractScore();
							}
							else
							{
								pelotas[i].freeze();
								frostCount++;
								score.addScore();
							}
								
							//Eliminar proyectil
							removeChild(proyectiles[k]);
							proyectiles.removeAt(k);
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
		
		override protected function isLevelFinished():Boolean 
		{
			return frostCount == nballs;
		}
		
		override public function disposeTemporarily():void 
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			frostCount = 0;
			visible = false;
		}
		
	}

}