package 
{
	import com.friendsofed.vector.*;
	import com.friendsofed.utils.TextBox;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
    import flash.events.TimerEvent; 
 
	
	public class Basura extends Sprite 
	{
		private var pelotas:Vector.<Enemies>;
		private var scoreText:TextField;
		private var score:Score;
		private var time:Timer;
		
		public function Basura() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			pelotas = new Vector.<Enemies>();
			score = new Score();
			
			scoreText = new TextField (300, 100, "Score = 5000", "Verdana", 24, 0x880088 , false);
			
			for (var i:int = 0; i < 20; i++)
			{
				var initX:int = Math.random() * stage.stageWidth;
				var initY:int = Math.random() * stage.stageHeight;
				var targetX:int = Math.random() * stage.stageWidth;
				var targetY:int = Math.random() * stage.stageHeight;
				
				var lasPelotasDeCarlos:Enemies = new Enemies(initX, initY, new VectorModel(initX, initY, targetX, targetY));
				
				pelotas.push(lasPelotasDeCarlos);
				addChild(lasPelotasDeCarlos);
				addChild(scoreText);
				shortTimer();
			}
		}
		
		public function shortTimer():void 
		{
			var minuteTimer:Timer = new Timer (1000, 0);
			minuteTimer.start();
			minuteTimer.addEventListener(TimerEvent.TIMER, ontick);
		}
		
		private function ontick(e:TimerEvent):void 
		{
			score.updateScore(score);
			scoreText.text = "Score = " + score.GetScore;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (pelotas.length > 0)
			{
				for (var i:int = pelotas.length - 1; i >= 0; i--)
				{
					if (!boundariesCollisions(i))
					{
						var speed:Point = pelotas[i].Speed;
						var newX:Number = pelotas[i].PosX + speed.x;
						var newY:Number = pelotas[i].PosY + speed.y;
			
						pelotas[i].Update(newX, newY);
						
					}
				}
			}
		}
		
		
		
		private function boundariesCollisions(i:int):Boolean
		{
			var speed:Point = pelotas[i].Speed;
			var ballVector:VectorModel = pelotas[i].Direction;
			
			var x:Number = pelotas[i].PosX + speed.x;
			var y:Number = pelotas[i].PosY + speed.y;
			
			var v1:VectorModel = new VectorModel(pelotas[i].PosX, pelotas[i].PosY, x, y);
			
			var v2:VectorModel;
			
			var v3:VectorModel;
			
			if (v1.b.x <= 0)
			{
				//Vector pared izquierda
				v2 = new VectorModel(0, 0, 0, stage.stageHeight);
			}
			
			else if(v1.b.x >= stage.stageWidth)
			{
				//Vector pared derecha
				v2 = new VectorModel(stage.stageWidth, stage.stageHeight, stage.stageWidth, 0);
			}
						
			else if (v1.b.y < 0)
			{
				//Vector pared superior
				v2 = new VectorModel(0, 0, stage.stageWidth, 0);
			}
			else
			{
				//Vector pared inferior
				v2 = new VectorModel(stage.stageWidth, stage.stageHeight, 0, stage.stageHeight);
			}
			
			v3 = new VectorModel(v1.a.x, v1.a.y, v2.a.x, v2.a.y);
			
			var dp1:Number = VectorMath.dotProduct(v3, v2);
			var dp2:Number = VectorMath.dotProduct(v3, v2.ln);
			
			var collisionForce_Vx:Number;
			var collisionForce_Vy:Number;
			
			if (dp1 > -v2.m && dp1 < 0)
			{				
				if (dp2 <= 0)
				{
					collisionForce_Vx = v1.dx * Math.abs(dp2);
					collisionForce_Vy = v1.dy * Math.abs(dp2);
					
					pelotas[i].PosX = v1.a.x - collisionForce_Vx;
					pelotas[i].PosY = v1.a.y - collisionForce_Vy;
					
					var dp3:Number = VectorMath.dotProduct(v1, v2);
					
					var p1_Vx:Number = dp3 * v2.dx;
					var p1_Vy:Number = dp3 * v2.dy;
					
					var dp4:Number = VectorMath.dotProduct(v1, v2.ln);
					
					var p2_Vx:Number = dp4 * v2.ln.dx;
					var p2_Vy:Number = dp4 * v2.ln.dy;
					
					p2_Vx *= -1;
					p2_Vy *= -1;
					
					var bounce_Vx:Number = p1_Vx + p2_Vx;
					var bounce_Vy:Number = p1_Vy + p2_Vy;
					
					var newX:Number = v1.a.x + bounce_Vx;
					var newY:Number = v1.a.y + bounce_Vy;
					
					pelotas[i].Update(newX, newY)
					
					return true;
				}
			}
			return false;
		}	
		
	}

}