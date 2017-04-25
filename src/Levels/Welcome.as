package Levels  
{
	import com.friendsofed.vector.VectorModel;
	import events.NavigationEnvent;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.*;
	
	
	import com.greensock.TweenLite;
	
	public class Welcome extends Sprite 
	{
		private var bg:Image;
		//private var title:Image;
		private var hero:Image;
		
		private var lvl1Btn:Button;
		private var lvl2Btn:Button;
		private var lvl3Btn:Button;
		
		private var lvlMini:Image;
		
		public function Welcome() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void 
		{
			drawScreen();
		}
		
		private function drawScreen():void
		{			
			bg = new Image(Assets.getTexture("MenuBg"));
			addChild(bg);
			
			hero = new Image(Assets.getTexture("Character_menu"));
			addChild(hero);
			
			lvl1Btn = new Button(Assets.getTexture("Lvl1Btn_off"));
			lvl1Btn.overState = Assets.getTexture("Lvl1Btn_over");
			lvl1Btn.x = 450;
			lvl1Btn.y = 192;
			lvl1Btn.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(lvl1Btn);
			
			lvl2Btn = new Button(Assets.getTexture("Lvl2Btn_off"));
			lvl2Btn.overState = Assets.getTexture("Lvl2Btn_over");
			lvl2Btn.x = 450;
			lvl2Btn.y = lvl1Btn.y + lvl1Btn.height + 6;
			lvl2Btn.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(lvl2Btn);
			
			lvl3Btn = new Button(Assets.getTexture("Lvl3Btn_off"));
			lvl3Btn.overState = Assets.getTexture("Lvl3Btn_over");
			lvl3Btn.x = 450;
			lvl3Btn.y = lvl2Btn.y + lvl2Btn.height + 5;
			lvl3Btn.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(lvl3Btn);
			
			lvlMini = new Image(Assets.getTexture("levelOne"));
			lvlMini.x = 500;
			lvlMini.y = 192;
			addChild(lvlMini);
			
			addEventListener(Event.TRIGGERED, onMainMenuClick);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			var buttonHovered:Button = e.target as Button;
			
			var touch:Touch = e.getTouch(this);
				if (touch)
				{
					if (touch.phase == TouchPhase.HOVER)
					{
						if (buttonHovered == lvl1Btn){
							lvlMini.texture = Assets.getTexture("levelOne");
						}
						else if (buttonHovered == lvl2Btn)
						{
							lvlMini.texture = Assets.getTexture("levelTwo");
						}
						else if (buttonHovered == lvl3Btn){
							lvlMini.texture = Assets.getTexture("levelThree");
						}
					}
				}
		}
		
		private function onMainMenuClick(e:Event):void 
		{
			var buttonClicked:Button = e.target as Button;
			if (buttonClicked == lvl1Btn)
			{
				dispatchEvent(new NavigationEnvent(NavigationEnvent.CHANGE_SCREEN, {id: "level1"}, true));
			}
			else if (buttonClicked == lvl2Btn)
			{
				dispatchEvent(new NavigationEnvent(NavigationEnvent.CHANGE_SCREEN, {id: "level2"}, true));
			}
		}
		
		public function initialize():void 
		{
			this.visible = true;
			
			hero.x = 100;
			hero.y = 0 - hero.height;
			hero.alignPivot();
			
			TweenLite.to(hero, 2, {x:190});
			
			this.addEventListener(Event.ENTER_FRAME, heroAnimation);			
		}
		
		
		private function heroAnimation(e:Event):void 
		{
			var currentDate:Date = new Date();
			hero.y = 225 + (Math.cos(currentDate.getTime() * 0.002) * 5);

		}
		
		public function disposeTemporarily():void 
		{
			visible = false;
			
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, heroAnimation);
		}
	}

}