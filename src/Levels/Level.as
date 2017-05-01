package Levels 
{
	import GameObjects.*;
	import Utilites.*;
	import com.friendsofed.vector.*;
	import com.friendsofed.utils.TextBox;
	import events.NavigationEnvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
    import flash.events.TimerEvent; 
	import starling.textures.Texture;
	import starling.display.Image;
	import flash.display.Bitmap;
	
	public class Level extends Sprite
	{	
		protected var bg:Image;
		
		protected var player:Cannon;
		
		protected var proyectiles:Vector.<Projectile>;
		protected var pelotas:Vector.<Enemies>;
		
		protected var nball:int;
		
		protected var v0:VectorModel;
		protected var v1:VectorModel;
		protected var v2:VectorModel;
		protected var v3:VectorModel;
		
		protected var scoreText:TextField;
		protected var score:Score;
		protected var minuteTimer:Timer;
		protected var finalScoreText:TextField;
		
		protected var menuButton:Button;
		
		protected var state:String;
		
		public function Level(_nbolas:int = 10, _bg:String = "BlueBg") 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			//Cargar textura
			bg = new Image(Assets.getTexture(_bg));
			nball = _nbolas;
		}
		
		private function onAdded(e:Event):void 
		{		
			//initialize();
		}
		
		private function drawGame():void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			
			
			
			//Inicializar vector
			proyectiles = new Vector.<Projectile>();
			pelotas = new Vector.<Enemies>();
			
			//Cosas del nivel		
			
			//inicialización de los vectores para los cálculos de colisión
			v0 = new VectorModel();
			v1 = new VectorModel();
			v2 = new VectorModel();
			v3 = new VectorModel();	
			
			//Rellenar array de pelotas
			for (var i:int = 0; i < nball; i++)
			{
				var initX:int = Math.random() * stage.stageWidth;
				var initY:int = Math.random() * stage.stageHeight;
				var angle:Number = Math.random() * 2 * Math.PI;
				
				var lasPelotasDeCarlos:Enemies = new Enemies(initX, initY, angle);
				
				pelotas.push(lasPelotasDeCarlos);
				
				addChild(lasPelotasDeCarlos);
			}
			
			//Configurar temporizador y puntuación
			score = new Score();
			
			scoreText = new TextField (300, 100, "Score = 5000", "MyFont", 30, 0xFFFFFF , false);
			scoreText.alignPivot();
			scoreText.x = 100;
			scoreText.y = 20;
			addChild(scoreText);
			
			finalScoreText = new TextField (stage.stageWidth - stage.stageWidth / 4, stage.stageHeight / 2, "Score = 5000", "MyFont", 35, 0x880000 , false);
			finalScoreText.alignPivot();
			finalScoreText.x  = stage.stageWidth - stage.stageWidth / 4;
			finalScoreText.y =  stage.stageHeight / 2;
			
			//Inicializar y ocultar boton para volver al menu
			menuButton = new Button(Assets.getTexture("BackBtnOff"));
			menuButton.overState = Assets.getTexture("BackBtnOn");
			menuButton.alignPivot();
			menuButton.x = stage.stageWidth - 50;
			menuButton.y = 20;
			menuButton.visible = false;
			addChild(menuButton);
			
			shortTimer();
		}
		
		//Control de visibilidad del nivel
		public function disposeTemporarily():void 
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			visible = false;
		}
		
		public function initialize():void 
		{
			//Event handlers
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//cambiar pivote
			bg.alignPivot();
			bg.x = stage.stageWidth / 2;
			bg.y = stage.stageHeight / 2;
			
			//Añadir al stage
			this.addChild(bg)
			
			player = new Cannon(stage.stageWidth / 2, 0 - 70);
			addChild(player);
			
			visible = true;
			
			state = "start";
		}
		
		//Event handlers
		protected function onEnterFrame(e:Event):void 
		{
			switch (state) 
			{
				case "playing":
					//move objects
					moveBalls();
			
					moveProjectile();
			
					if (isLevelFinished())
					{
						state = "end"
						endLevel();
					}
					break;
					
				case "start":
					if (startPlayerAnimation()) 
					{
						state = "playing";
						drawGame();
					}
					break;
			}
		}
		
		private function startPlayerAnimation():Boolean
		{
			player.PosY += 5;
			player.UpdateImage();
			return player.PosY == stage.stageHeight/2;
		}
		
		protected function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			
			if (touch)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
					shoot(touch.globalX, touch.globalY);
				}
			}
		}
		
		//Controlar score
		public function shortTimer():void 
		{
			minuteTimer = new Timer (100, 0);
			minuteTimer.start();
			minuteTimer.addEventListener(TimerEvent.TIMER, ontick);
		}
		
		private function ontick(e:TimerEvent):void 
		{
			score.updateScore(score);
			scoreText.text = "Score = " + score.GetScore;
		}
		
		//Crear un nuevo proyectil cuando se dispare, y ejecutar la animación del jugador
		
		protected function shoot(mPosx:Number, mPosY:Number):void 
		{
			player.Shoot();
			
			var direction:VectorModel = new VectorModel(player.PosX, player.PosY, mPosx, mPosY);
			
			var bulletX:Number = player.bulletStartX;
			var bulletY:Number = player.bulletStartY;
			
			var proyectil:Projectile = new Projectile(bulletX, bulletY, direction.angle);
			
			proyectiles.push(proyectil);
			
			addChild(proyectil);
		}
		
		//Actualizar posición de los proyectiles y las pelotas
		
		protected function moveProjectile():void
		{
			if (proyectiles.length > 0)
			{
				for (var i:int = proyectiles.length-1; i >= 0; i--)
				{
					//test collisions
					if (!testBoundaries(proyectiles[i]))
					{					
						proyectiles[i].UpdateMovement();
					}
					else
					{
						removeChild(proyectiles[i]);
						proyectiles.removeAt(i);
					}
				}
			}
			
		}
		
		protected function moveBalls():void
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
						
						if (collisionWithBalls(pelotas[i], pelotas[j]))
						{
							bounceBalls(pelotas[i], pelotas[j]);
						}
					}
					
					for (var k:int = proyectiles.length - 1; k >= 0; k--)
					{
						if (collisionWithBalls(pelotas[i], proyectiles[k]))
						{
							removeChild(pelotas[i]);
							pelotas.removeAt(i);
							score.addScore();
							return;
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
		
		//Seleccionar con que lateral se va a comprobar la colisión
		protected function testBoundaries(b:Ball):Boolean
		{	
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
		private function collideWithBoundarie(b:Ball):Boolean 
		{
			v0.update(b.PosX, b.PosY, b.PosX + v2.ln.dx * b.getRadius(), b.PosY + v2.ln.dy * b.getRadius());
			
			v1.update(v0.b.x, v0.b.y, v0.b.x + b.Vx, v0.b.y + b.Vy);
			
			v3.update(v1.a.x, v1.a.y, v2.a.x, v2.a.y);
			
			var dp1:Number = VectorMath.dotProduct(v3, v2);
			var dp2:Number = VectorMath.dotProduct(v3, v2.ln);
			
			if (dp1 > -v2.m && dp1 < 0)
			{				
				if (dp2 <= 0)
				{
					return true;
				}
			}
			
			return false;
		}
		
		//Calcular rebote contra una de las barreras
		protected function bounceWithBoundarie(b:Ball):void
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
		protected function collisionWithBalls(b1:Ball, b2:Ball):Boolean
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
		protected function bounceBalls(b1:Ball, b2:Ball):void
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
		
		protected function bounceWithPlayer(b:Ball):void 
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
		
		//Final de partida
		protected function isLevelFinished():Boolean
		{
			return pelotas.length <= 0;
		}
		
		public function endLevel():void 
		{
			//Parar temporizador
			minuteTimer.stop();
			minuteTimer.removeEventListener(TimerEvent.TIMER, ontick);
			
			//Limpiar la pantalla de proyectiles
			for (var i:int = proyectiles.length - 1; i >= 0; i--)
			{
				removeChild(proyectiles[i]);
				proyectiles.removeAt(i);
			}
			
			//Limpiar pantalla de pelotas en caso de que haya alguna
			for (var j:int = pelotas.length - 1; j >= 0; j--)
			{
				removeChild(pelotas[j]);
				pelotas.removeAt(j);
			}
			
			//Textos a mostrar
			var showLevelScoreText:TextField = new TextField (300, 100, "Level score:", "Verdana",20, 0xFFFFFF, true);
			showLevelScoreText.alignPivot();
			showLevelScoreText.x  = 0 + stage.stageWidth / 4;
			showLevelScoreText.y =  stage.stageHeight / 2 - 50;
			
			var showTotalScoreText:TextField = new TextField (600, 100, "Total score:", "Verdana", 20, 0xFFFFFF, true);
			showTotalScoreText.alignPivot();
			showTotalScoreText.x  = stage.stageWidth - stage.stageWidth / 4;
			showTotalScoreText.y =  stage.stageHeight / 2 - 50;
			
			
			
			finalScoreText.text = "" + score.GetTotalScore;
			
			stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			
			scoreText.text = "" + score.GetScore;
			scoreText.x = 0 + stage.stageWidth / 4;
			scoreText.y = stage.stageHeight / 2;
			scoreText.fontSize = 35;
			
			removeChild(player);

			addChild(finalScoreText);
			addChild(showTotalScoreText);
			addChild(showLevelScoreText);
			
			//Show button and enable the trigger ivent
			addEventListener(Event.TRIGGERED, onButtonClick);
			menuButton.visible = true;
		}	
		
		private function onButtonClick(e:Event):void 
		{
			dispatchEvent(new NavigationEnvent(NavigationEnvent.CHANGE_SCREEN, {id: "frmLvlToMenu"}, true)); 
		}
	}

}