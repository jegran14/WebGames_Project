package Levels 
{
	import starling.display.Sprite;
	import GameObjects.*;
	import Utilites.*;
	import com.friendsofed.vector.*;
	import com.friendsofed.utils.TextBox;
	import events.NavigationEnvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.display.Button;
	import starling.events.*;
	import starling.text.TextField;
    import flash.events.TimerEvent; 
	import starling.textures.Texture;
	import starling.display.Image;
	import flash.display.Bitmap;
	
	public class ResultsScreen extends Sprite 
	{
		private var scoreText:TextField;
		private var finalScoreText:TextField;
		
		private var menuButton:Button;
		private var nextButton:Button;
		
		private var nextLvl:Level;
		
		private var bg:Image;
		
		public function ResultsScreen() 
		{
			super();
			
		}
		
		public function get NextLvl():Level
		{
			return nextLvl;
		}
		
		public function initialize(lvlScore:int, totalScore:int, _nextLvl:Level, _bg:Image):void 
		{
			nextLvl = _nextLvl;
			
			bg = _bg;
			addChild(bg);
			
			scoreText = new TextField (0 + stage.stageWidth / 4, stage.stageHeight / 2, "" + lvlScore, "MyFont", 35, 0xFFFFFF , false);
			scoreText.alignPivot();
			scoreText.x = 0 + stage.stageWidth / 4;
			scoreText.y =  stage.stageHeight / 2;
			addChild(scoreText);
			
			finalScoreText = new TextField (stage.stageWidth - stage.stageWidth / 4, stage.stageHeight / 2, "" + totalScore, "MyFont", 35, 0xbf8f00 , false);
			finalScoreText.alignPivot();
			finalScoreText.x  = stage.stageWidth - stage.stageWidth / 4;
			finalScoreText.y =  stage.stageHeight / 2;
			
			//Textos a mostrar
			var showLevelScoreText:TextField = new TextField (300, 100, "Level score:", "Verdana",20, 0xFFFFFF, true);
			showLevelScoreText.alignPivot();
			showLevelScoreText.x  = 0 + stage.stageWidth / 4;
			showLevelScoreText.y =  stage.stageHeight / 2 - 50;
			
			var showTotalScoreText:TextField = new TextField (600, 100, "Total score:", "Verdana", 20, 0xFFFFFF, true);
			showTotalScoreText.alignPivot();
			showTotalScoreText.x  = stage.stageWidth - stage.stageWidth / 4;
			showTotalScoreText.y =  stage.stageHeight / 2 - 50;
			
			
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
			
			addChild(finalScoreText);
			addChild(showTotalScoreText);
			addChild(showLevelScoreText);
			
			//Show button and enable the trigger ivent
			addEventListener(Event.TRIGGERED, onButtonClick);
			menuButton.visible = true;
			if(nextButton != null)
				nextButton.visible = true;
			
			this.visible = true;
			
		}
		
		public function DisposeTemporarily():void 
		{
			this.visible = false;
		}
		
		private function onButtonClick(e:Event):void 
		{
			var Btn:Button = e.target as Button;
			if (Btn == menuButton)
				dispatchEvent(new NavigationEnvent(NavigationEnvent.CHANGE_SCREEN, {id: "frmResultsToMenu"}, true)); 
			else
				dispatchEvent(new NavigationEnvent(NavigationEnvent.CHANGE_SCREEN, {id: "frmResultsToLvl"}, true));
		}
		
	}

}