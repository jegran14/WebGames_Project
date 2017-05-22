package Utilites 
{
	import starling.display.Sprite;
	import GameObjects.Ball;
	import com.friendsofed.vector.*;
	
	public class Physics extends Sprite 
	{
		protected var v0:VectorModel;
		protected var v1:VectorModel;
		protected var v2:VectorModel;
		protected var v3:VectorModel;
		
		public function Physics() 
		{
			super();
			
			//inicialización de los vectores para los cálculos de colisión
			v0 = new VectorModel();
			v1 = new VectorModel();
			v2 = new VectorModel();
			v3 = new VectorModel();	
		}
		
		//Comprobar que la bola esté dentro de 
		private function inStage(b:Ball):void 
		{
			if (b.PosX < 0 || b.PosX > stage.stageWidth)
			{
				var side:Number = b.PosX - stage.stageWidth
				
				if (side > 0)
					b.SetX = stage.stageWidth - 0.1;
				else
					b.SetX = 0 + 0.1;
			}
			
			if (b.PosY < 0 || b.PosY > stage.stageHeight)
			{
				var sideY:Number = b.PosY - stage.stageHeight;
				
				if (sideY > 0)
					b.SetY = stage.stageHeight - 0.1;
				else
					b.SetY = 0 + 0.1;
			}
		}
		
		
		//Seleccionar con que lateral se va a comprobar la colisión
		public function testBoundaries(b:Ball):Boolean
		{	
			inStage(b);
			
			//Comprobar dirección en el eje X para decidir con que pared comprobamos la colisión
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
			
			//Comprobar colision con las paredes laterales, y en caso afirmativo salir devolviendo verdadero
			if (collideWithBoundarie(b))
			{
				return true;
			}
			
			//En caso negativo comprobamos la colisión con las paredes superior e inferior
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
			
			//Comprobar colision con las paredes inferior y superior, y en caso afirmativo salir devolviendo verdadero
			if (collideWithBoundarie(b))
			{
				return true;
			}
			
			return b.PosX < 0 || b.PosY < 0 || b.PosX > stage.stageWidth || b.PosY > stage.stageHeight;
		}
		
		//Comprobar la colisión con una barrera
		public function collideWithBoundarie(b:Ball):Boolean 
		{
			v0.update(b.PosX, b.PosY, b.PosX + v2.ln.dx * b.getRadius(), b.PosY + v2.ln.dy * b.getRadius());
			
			v1.update(v0.b.x, v0.b.y, v0.b.x + b.Vx, v0.b.y + b.Vy);
			
			v3.update(v1.a.x, v1.a.y, v2.a.x, v2.a.y);
			
			var dp1:Number = VectorMath.dotProduct(v3, v2);
			var dp2:Number = VectorMath.dotProduct(v3, v2.ln);
			
			if (dp1 >= -v2.m && dp1 <= 0)
			{				
				if (dp2 <= 0)
				{
					return true;
				}
			}
			
			return false;
		}
		
		//Calcular rebote contra una de las barreras
		public function bounceWithBoundarie(b:Ball):void
		{
			var collisionForce_Vx:Number;
			var collisionForce_Vy:Number;
			var overlap:Number;
			
			overlap = b.getRadius() - v0.m;
					
			b.SetX = b.PosX - (overlap * v0.dx);
			b.SetY = b.PosY - (overlap * v0.dy);
			
			var motion:VectorModel = new VectorModel(b.PosX, b.PosY, b.PosX + b.Vx, b.PosY + b.Vy);
			
			var bounce:VectorModel = VectorMath.bounce(motion, v0.ln);
			
			b.Vx = bounce.vx;
			b.Vy = bounce.vy;
		}
		
		//Comprobar colisión entre varios objetos herederos de la clase bola
		public function collisionWithBalls(b1:Ball, b2:Ball):Boolean
		{			
			v0.update(b1.PosX, b1.PosY, b2.PosX, b2.PosY);
			
			var totalRadii:Number = b1.getRadius() + b2.getRadius();
			
			if (v0.m < totalRadii)
			{
				return true;
			}
			
			return false;
		}
		
		//Calcular rebote entre varias bolas en movimiento
		public function bounceBalls(b1:Ball, b2:Ball):void
		{
			var totalRadii:Number = b1.getRadius() + b2.getRadius();
			
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
			
			/*var bounce1:VectorModel = new VectorModel(0, 0, 0, 0, p1b.vx + p2a.vx, p1b.vy + p2a.vy);
			var bounce2:VectorModel = new VectorModel(0, 0, 0, 0, p1a.vx + p2b.vx, p1a.vy + p2b.vy);
			
			b1.Vx = b1.Speed*bounce1.dx;
			b1.Vy = b1.Speed*bounce1.dy;
			
			b2.Vx = b2.Speed*bounce2.dx;
			b2.Vy = b2.Speed*bounce2.dy;*/
		
			b1.Vx = p1b.vx + p2a.vx;
			b1.Vy = p1b.vy + p2a.vy;
			
			b2.Vx = p1a.vx + p2b.vx;
			b2.Vy = p1a.vy + p2b.vy;
		}
		
		public function bounceWithPlayer(b:Ball, player:Ball):void 
		{
			var totalRadii:Number = b.getRadius() + player.getRadius();
			var overlap:Number = totalRadii - v0.m;
			
			b.SetX = b.PosX - (overlap * v0.dx);
			b.SetY = b.PosY - (overlap * v0.dy);
			
			v1.update(b.PosX, b.PosY, b.PosX + b.Vx, b.PosY + b.Vy);
			
			var bounce:VectorModel = VectorMath.bounce(v1, v0.ln);
			
			b.Vx = bounce.vx;
			b.Vy = bounce.vy;
		}
		
	}

}