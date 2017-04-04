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

		private var v0:VectorModel;
		private var v1:VectorModel;
		private var v2:VectorModel;
		private var v3:VectorModel;

		
		public function Basura() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			v0 = new VectorModel();
			v1 = new VectorModel();
			v2 = new VectorModel();
			v3 = new VectorModel();
			
			pelotas = new Vector.<Enemies>();
			score = new Score();
			
			scoreText = new TextField (300, 100, "Score = 5000", "Verdana", 24, 0x880088 , false);
			
			for (var i:int = 0; i < 10; i++)
			{
				var initX:int = Math.random() * stage.stageWidth;
				var initY:int = Math.random() * stage.stageHeight;
				var angle:Number = Math.random() * 2 * Math.PI;
				
				var lasPelotasDeCarlos:Enemies = new Enemies(initX, initY, angle);
				
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

					testBoundaries(pelotas[i]);
			
					pelotas[i].UpdateMovement();

				}
			}
		}
		

		
	
		/*private function testBoundaries(b:Ball):void
		{						
			v1.update(b.PosX, b.PosY, b.PosX + b.Vx, b.PosY + b.Vy);

			if (v1.b.x - b.getRadius() <= 0)
			{
				//Vector pared izquierda
				v2.update(0, 0, 0, stage.stageHeight);
			}
			
			else if (v1.b.x + b.getRadius() >= stage.stageWidth)
			{
				//Vector pared derecha
				v2.update(stage.stageWidth, stage.stageHeight, stage.stageWidth, 0);
			}
						
			else if (v1.b.y - b.getRadius() < 0)
			{
				//Vector pared superior
				v2.update(0, 0, stage.stageWidth, 0);
			}
			else
			{
				//Vector pared inferior
				v2.update(stage.stageWidth, stage.stageHeight, 0, stage.stageHeight);
			}
			
			v0.update(b.PosX, b.PosY, b.PosX + v2.ln.dx * b.getRadius(), b.PosY + v2.ln.dy * b.getRadius());
			
			v3.update(v1.a.x, v1.a.y, v2.a.x, v2.a.y);
			
			var dp1:Number = VectorMath.dotProduct(v3, v2);
			var dp2:Number = VectorMath.dotProduct(v3, v2.ln);
			
			var collisionForce_Vx:Number;
			var collisionForce_Vy:Number;
			var overlap:Number;
			
			if (dp1 > -v2.m && dp1 < 0)
			{				
				if (dp2 <= 0)
				{
					/*collisionForce_Vx = v1.dx * Math.abs(dp2);
					collisionForce_Vy = v1.dy * Math.abs(dp2);
					
					b.SetX = v1.a.x - collisionForce_Vx;
					b.SetY = v1.a.y - collisionForce_Vy;
					
					b.Vx = 0;
					b.Vy = 0;
										
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
					
					b.Vx = bounce_Vx;
					b.Vy = bounce_Vy;
					
					overlap = b.getRadius() - v0.m;
					b.SetX = b.PosX - (overlap * v0.dx);
					b.SetY = b.PosY - (overlap * v0.dy);
					
					var motion:VectorModel = new VectorModel(v0.b.x, v0.b.y, v0.b.x + b.Vx, v0.b.y + b.Vy);
					
					var bounce:VectorModel = VectorMath.bounce(motion, v0.ln);
					
					b.Vx = bounce.vx;
					b.Vy = bounce.vy;
				}
			}

			return false;
		}	
		

		}	*/
		
		private function testBoundaries(b:Ball):void
		{									
			//Vector pared izquierda
			v2.update(0, stage.stageHeight, 0, 0);
			collideWithBoundarie(b);

			//Vector pared derecha
			v2.update(stage.stageWidth, 0, stage.stageWidth, stage.stageHeight);
			collideWithBoundarie(b);
						
			//Vector pared superior
			v2.update(0, 0, stage.stageWidth, 0);
			collideWithBoundarie(b);
			
			//Vector pared inferior
			v2.update(stage.stageWidth, stage.stageHeight, 0, stage.stageHeight);	
			collideWithBoundarie(b);
		}
		
		private function collideWithBoundarie(b:Ball):void 
		{
			v0.update(b.PosX, b.PosY, b.PosX + v2.ln.dx * b.getRadius(), b.PosY + v2.ln.dy * b.getRadius());
			
			v1.update(v0.b.x, v0.b.y, v0.b.x + b.Vx, v0.b.y + b.Vy);
			
			v3.update(v1.a.x, v1.a.y, v2.a.x, v2.a.y);
			
			var dp1:Number = VectorMath.dotProduct(v3, v2);
			var dp2:Number = VectorMath.dotProduct(v3, v2.ln);
			
			var collisionForce_Vx:Number;
			var collisionForce_Vy:Number;
			var overlap:Number;
			
			if (dp1 > -v2.m && dp1 < 0)
			{				
				if (dp2 <= 0)
				{
					overlap = b.getRadius() - v0.m;
					
					b.SetX = b.PosX - (overlap * v0.dx);
					b.SetY = b.PosY - (overlap * v0.dy);
					
					var motion:VectorModel = new VectorModel(b.PosX, b.PosY, b.PosX + b.Vx, b.PosY + b.Vy);
					
					var bounce:VectorModel = VectorMath.bounce(motion, v0.ln);
					
					b.Vx = bounce.vx;
					b.Vy = bounce.vy;
				}
			}
		}

	}

}