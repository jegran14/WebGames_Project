package Levels 
{
	import GameObjects.*;
	import Utilites.*;
	import com.friendsofed.vector.*;
	import com.friendsofed.utils.TextBox;
	import events.*;
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
	import flash.media.Sound;
	
	
	
	public class Level extends Sprite
	{	
		protected var bg:Image;
		
		protected var player:Cannon;
		
		protected var proyectiles:Vector.<Projectile>;
		protected var pelotas:Vector.<Enemies>;
		
		protected var nballs:int;
		
		protected var scoreText:TextField;
		protected var score:Score;
		protected var minuteTimer:Timer;
		protected var finalScoreText:TextField;
		
		protected var menuButton:Button;
		protected var nextButton:Button;
		
		protected var state:String;
		
		protected var physics:Physics
		
		protected var nextLvl:Level;
		protected var EnemyCollide:Sound = new Assets.EnemyCollide(); 
		protected var EnemyDestroy:Sound = new Assets.EnemyDestroy(); 
		protected var shieldCollision:Sound = new Assets.ShieldCollision(); 
	
		
		public function Level(_nextLvl:Level = null, _nbolas:int = 10, _bg:String = "BlueBg") 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			//Cargar textura
			bg = new Image(Assets.getTexture(_bg));
			nballs = _nbolas;
			nextLvl = _nextLvl;
		}
		
		public function get NextLvl():Level	{ return nextLvl; }
		public function set NextLvl(_nextLvl:Level):void { nextLvl = _nextLvl; }
		public function get LvlScore():int { return score.GetTotalScore; }
		public function get Bg():Image { return bg;}
		
		private function onAdded(e:Event):void 
		{		
			//initialize();
		}
		
		private function drawGame():void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(DestroyBallEvent.DESTROYBALL, onDestroy);
			
			//Inicializar vector
			proyectiles = new Vector.<Projectile>();
			pelotas = new Vector.<Enemies>();
			
			//Cosas del nivel	
			
			//Rellenar array de pelotas
			createBalls(0.6);
			
			//Configurar temporizador y puntuación
			score = new Score();
			
			scoreText = new TextField (300, 100, "Score = 5000", "MyFont", 30, 0xFFFFFF , false);
			scoreText.alignPivot();
			scoreText.x = 100;
			scoreText.y = 20;
			addChild(scoreText);
			
			finalScoreText = new TextField (stage.stageWidth - stage.stageWidth / 4, stage.stageHeight / 2, "Score = 5000", "MyFont", 35, 0xbf8f00 , false);
			finalScoreText.alignPivot();
			finalScoreText.x  = stage.stageWidth - stage.stageWidth / 4;
			finalScoreText.y =  stage.stageHeight / 2;
			
			//Inicializar y ocultar boton para volver al menu
			menuButton = new Button(Assets.getTexture("BackBtnOff"));
			menuButton.overState = Assets.getTexture("BackBtnOn");
			menuButton.alignPivot();
			menuButton.x = stage.stageWidth - 50 - menuButton.width;
			menuButton.y = 10 + menuButton.height;
			menuButton.visible = false;
			addChild(menuButton);
			
			//Inicializar y ocultar boton para pasar al siguiente nivel
			if (nextLvl != null)
			{
				nextButton = new Button(Assets.getTexture("BackBtnOff"));
				nextButton.overState = Assets.getTexture("BackBtnOn");
				nextButton.alignPivot();
				nextButton.x = menuButton.x + menuButton.width + 10;
				nextButton.y = 10 + nextButton.height;
				nextButton.rotation = Math.PI;
				nextButton.visible = false;
				addChild(nextButton);
			}
			
			
			//Enable Physics
			physics = new Physics();
			addChild(physics);
			
			shortTimer();
		}
		
		private function onDestroy(e:DestroyBallEvent):void 
		{
			var ball:Ball = e.target as Ball;
			
			removeChild(ball);
		}
		
		protected function createBalls(scale:Number):void 
		{
			for (var i:int = 0; i < nballs; i++)
			{
				var initX:int = Math.random() * stage.stageWidth;
				var initY:int = Math.random() * stage.stageHeight;
				var angle:Number = Math.random() * 2 * Math.PI;
				
				var lasPelotasDeCarlos:Enemies = new Enemies(initX, initY, angle);
				
				pelotas.push(lasPelotasDeCarlos);
				
				addChild(lasPelotasDeCarlos);
			}
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
						player.createShield();
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
					if (!physics.testBoundaries(proyectiles[i]))
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
							EnemyCollide.play();
						}
					}
					
					for (var k:int = proyectiles.length - 1; k >= 0; k--)
					{
						if (physics.collisionWithBalls(pelotas[i], proyectiles[k]))
						{
							pelotas[i].Destroy();
							EnemyDestroy.play();
							//removeChild(pelotas[i]);
							pelotas.removeAt(i);
							score.addScore();
							return;
						}
					}
					
					if (physics.collisionWithBalls(pelotas[i], player))
					{
						physics.bounceWithPlayer(pelotas[i], player);
						player.ExecuteShield();
						shieldCollision.play();
					}
					
					pelotas[i].UpdateMovement();
				}
			}
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
			
			dispatchEvent(new NavigationEnvent(NavigationEnvent.CHANGE_SCREEN, {id: "frmLvlToResults"}, true));
			/*//Textos a mostrar
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
			if(nextButton != null)
				nextButton.visible = true;*/
		}	
		
		/*private function onButtonClick(e:Event):void 
		{
			var Btn:Button = e.target as Button;
			if (Btn == menuButton)
				dispatchEvent(new NavigationEnvent(NavigationEnvent.CHANGE_SCREEN, {id: "frmLvlToMenu"}, true)); 
			else
				dispatchEvent(new NavigationEnvent(NavigationEnvent.CHANGE_SCREEN, {id: "frmLvlToLvl"}, true));
		}*/
	}

}