package 
{
	import com.friendsofed.vector.*;
	import com.friendsofed.utils.TextBox;
	import flash.geom.Point;
	import starling.display.Sprite;
	import starling.events.*;
	
	public class Basura extends Sprite 
	{
		private var pelotas:Vector.<Enemies>;
		private var v0:VectorModel;
		private var v1:VectorModel;
		private var v2:VectorModel;
		private var v3:VectorModel;
		private var v4:VectorModel;
		private var v5:VectorModel;
		
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
			v4 = new VectorModel();
			v5 = new VectorModel();
			
			
			pelotas = new Vector.<Enemies>();
			
			for (var i:int = 0; i < 10; i++)
			{
				var initX:int = Math.random() * stage.stageWidth;
				var initY:int = Math.random() * stage.stageHeight;
				var angle:Number = Math.random() * 2 * Math.PI;
				
				var lasPelotasDeCarlos:Enemies = new Enemies(initX, initY, angle);
				
				pelotas.push(lasPelotasDeCarlos);
				
				addChild(lasPelotasDeCarlos);
			}
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (pelotas.length > 0)
			{
				for (var i:int = 0; i < pelotas.length; i++)
				{					
					for (var j:int = i+1; j < pelotas.length; j++ )
					{
						collisionWithBalls(pelotas[i], pelotas[j]);
					}
					
					//testBoundaries(pelotas[i]);
			
					pelotas[i].UpdateMovement();
				}
			}
		}
		
		private function testBoundaries(b:Ball):void
		{			
			if (b.Vx < 0)
			{
				//Vector pared izquierda
				v2.update(0, stage.stageHeight, 0, 0);
			}
			else
			{
				//Vector pared derecha
				v2.update(stage.stageWidth, 0, stage.stageWidth, stage.stageHeight);
			}
			collideWithBoundarie(b);

			
			if (b.Vy < 0)
			{
				//Vector pared superior
				v2.update(0, 0, stage.stageWidth, 0);
			}
			else
			{
				//Vector pared inferior
				v2.update(stage.stageWidth, stage.stageHeight, 0, stage.stageHeight);	
			}			
			collideWithBoundarie(b);
		}
		
		/*private function collideWithBoundarie(b:Ball)
		{
			v1.update(b.PosX, b.PosY, b.PosX + b.Vx, b.PosY + b.Vy);
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
					collisionForce_Vx = v1.dx * Math.abs(dp2);
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
				}
			}
		}*/
		
		
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
		
		private function collisionWithBalls(b1:Ball, b2:Ball):void
		{
			testBoundaries(b1);
			testBoundaries(b2);
			
			v0.update(b1.PosX, b1.PosY, b2.PosX, b2.PosY);
			
			var totalRadii:Number = b1.getRadius() + b2.getRadius();
			
			if (v0.m < totalRadii)
			{
				var overlap:Number = totalRadii - v0.m;
				
				var collision_Vx:Number = Math.abs(v0.dx * overlap);
				var collision_Vy:Number = Math.abs(v0.dy * overlap);
				
				var xSide:int;
				var ySide:int;
				
				b1.PosX > b2.PosX ? xSide = 1 : xSide = -1;
				b1.PosY > b2.PosY ? ySide = 1 : ySide = -1;
				
				b1.SetX = b1.PosX + (collision_Vx * xSide);
				b1.SetY = b1.PosY + (collision_Vy * ySide);
				
				b2.SetX = b2.PosX + (collision_Vx * -xSide);
				b2.SetY = b2.PosY + (collision_Vy * -ySide);
				
				v1.update(b1.PosX, b1.PosY, b1.PosX + b1.Vx, b1.PosY + b1.Vy);
				v2.update(b2.PosX, b2.PosY, b2.PosX + b2.Vx, b2.PosY + b2.Vy);
				
				var p1a:VectorModel = VectorMath.project(v1, v0);
				var p1b:VectorModel = VectorMath.project(v1, v0.ln);
				
				var p2a:VectorModel = VectorMath.project(v2, v0);
				var p2b:VectorModel = VectorMath.project(v2, v0.ln);
				
				b1.Vx = p1b.vx + p2a.vx;
				b1.Vy = p1b.vy + p2a.vy;
				
				b2.Vx = p1a.vx + p2b.vx;
				b2.Vy = p1a.vy + p2b.vy;
			}
		}
	}

}