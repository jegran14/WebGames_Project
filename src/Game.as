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
		
		private var levelSong:Sound = new Sound(new URLRequest("../media/sounds/levelSong.mp3")); // make sure you use the proper path!
		private var myChannel:SoundChannel = new SoundChannel();
		
		
		private var screenWelcome:Welcome;
		private var level1:Level;
		private var level2:Level2;
		private var level3:Level3;

		public function Game() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			addEventListener(NavigationEnvent.CHANGE_SCREEN, onChangeScreen);
			
			level1 = new Level();
			level1.disposeTemporarily();
			addChild(level1)
			
			level2 = new Level2();
			level2.disposeTemporarily();
			addChild(level2);
			
			level3 = new Level3();
			addChild(level3);
			level3.disposeTemporarily();
			
			screenWelcome = new Welcome();
			addChild(screenWelcome);
			screenWelcome.initialize();
		}
		
		private function onChangeScreen(e:NavigationEnvent):void 
		{
			
			switch (e.params.id) 
			{
				case "level1":
					screenWelcome.disposeTemporarily();
					level1.initialize();
					myChannel.stop();
					myChannel = levelSong.play(0, int.MAX_VALUE);
					break;
				
				case "level2":
					screenWelcome.disposeTemporarily();
					level2.initialize();
					myChannel.stop();
					myChannel = levelSong.play(0,int.MAX_VALUE);
					break;
					
				case "level3":
				screenWelcome.disposeTemporarily();
				level3.initialize();
				myChannel.stop();
				myChannel = levelSong.play(0,int.MAX_VALUE);
				break;
				
				case "frmLvlToMenu":
					var lvl:Level = e.target as Level;
					lvl.disposeTemporarily();
					screenWelcome.initialize();
					myChannel.stop();
					
					break;
			}
		}
		
	}

}