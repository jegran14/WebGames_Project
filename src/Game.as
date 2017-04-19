package 
{
	import events.NavigationEnvent;
	import starling.display.Sprite;
	import starling.events.*;
	import Levels.*;
	
	public class Game extends Sprite 
	{
		private var screenWelcome:Welcome;
		private var level1:Level;
		private var level2:Level2;
		
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
			
			screenWelcome = new Welcome();
			addChild(screenWelcome);
			screenWelcome.initialize();
		}
		
		private function onChangeScreen(e:NavigationEnvent):void 
		{
			switch (e.params.id) 
			{
				case "level1":
					trace("you");
					screenWelcome.disposeTemporarily();
					level1.initialize();
					break;
				
				case "level2":
					trace("yau");
					screenWelcome.disposeTemporarily();
					level2.initialize();
					break;
			}
		}
		
	}

}