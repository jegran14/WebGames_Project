package 
{
	import events.NavigationEnvent;
	import flash.net.URLRequest;
	import starling.display.Sprite;
	import starling.events.*;
	import Levels.*;
	import flash.media.*;
	
	public class Game extends Sprite 
	{
		private var totalScore:int;
		
		private var levelSong:Sound = new Sound(new URLRequest("../media/sounds/levelSong.mp3")); // make sure you use the proper path!
		private var level2Song:Sound = new Sound (new URLRequest("../media/sounds/Level2Song.mp3"));
		private var welcomeSong:Sound = new Sound (new URLRequest("../media/sounds/WelcomeSong.mp3"));
		private var endingStart:Sound = new Sound (new URLRequest("../media/sounds/LevelEnding.mp3"));
		private var myChannel:SoundChannel = new SoundChannel();
		
		
		private var screenWelcome:Welcome;
		private var level1:Level;
		private var level2:Level2;
		private var level3:Level3;
		private var results:ResultsScreen;

		public function Game() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			addEventListener(NavigationEnvent.CHANGE_SCREEN, onChangeScreen);
			
			totalScore = 0;
			
			level1 = new Level();
			level1.disposeTemporarily();
			addChild(level1)
			
			level2 = new Level2();
			level2.disposeTemporarily();
			addChild(level2);
			
			level3 = new Level3();
			addChild(level3);
			level3.disposeTemporarily();
			
			results = new ResultsScreen();
			addChild(results);
			results.DisposeTemporarily();
			
			//Asignar los niveles siguientes
			level1.NextLvl = level2;
			level2.NextLvl = level3;
			
			screenWelcome = new Welcome();
			addChild(screenWelcome);
			myChannel = welcomeSong.play(0, int.MAX_VALUE);
			screenWelcome.initialize();
		}
		
		private function onChangeScreen(e:NavigationEnvent):void 
		{
			
			switch (e.params.id) 
			{
				case "level1":
					screenWelcome.disposeTemporarily();
					level1.initialize();
					playScreenMusic();
					break;
				
				case "level2":
					screenWelcome.disposeTemporarily();
					level2.initialize();
					playScreenMusic();
					break;
					
				case "level3":
					screenWelcome.disposeTemporarily();
					level3.initialize();
					playScreenMusic();
					break;
				
				case "frmResultsToMenu":
					results.DisposeTemporarily();
					screenWelcome.initialize();
					playMenuMusic();
					break;
				case "frmResultsToLvl":
					var nextLvl:Level = results.NextLvl;
					results.DisposeTemporarily();
					nextLvl.initialize();
					break;
				case "frmLvlToResults":
					var Lvl:Level = e.target as Level
					var nexLvl:Level = Lvl.NextLvl;
					totalScore += Lvl.LvlScore;
					Lvl.disposeTemporarily();
					results.initialize(Lvl.LvlScore, totalScore, nexLvl, Lvl.Bg);
					playEndSound();
					break;
			}
		}
		
		private function playMenuMusic():void 
		{
			myChannel.stop();
			myChannel = welcomeSong.play(0, int.MAX_VALUE);
		}
		
		private function playScreenMusic():void 
		{
			myChannel.stop();
			myChannel = level2Song.play(0,int.MAX_VALUE);
		}

		private function playEndSound():void 
		{
			myChannel.stop()
			myChannel = endingStart.play();
		}
		
	}

}