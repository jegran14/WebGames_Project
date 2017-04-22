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
			bg = new Image(Assets.getTexture("PinkBg"));
			addChild(bg);
			
			hero = new Image(Assets.getTexture("Player"));
			addChild(hero);
			
			lvl1Btn = new Button(Assets.getTexture("Lvl1Btn"));
			lvl1Btn.x = 500;
			lvl1Btn.y = 260;
			addChild(lvl1Btn);
			
			lvl2Btn = new Button(Assets.getTexture("Lvl2Btn"));
			lvl2Btn.x = 500;
			lvl2Btn.y = 260;
			addChild(lvl2Btn);
			
			addEventListener(Event.TRIGGERED, onMainMenuClick);
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
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			if (touch)
			{
				if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.MOVED)
				{
					var dir:VectorModel = new VectorModel(hero.x, hero.y, touch.globalX, touch.globalY);
					hero.rotation = dir.angle + Math.PI/2;
				}
			}
		}
		
		public function initialize():void 
		{
			this.visible = true;
			
			hero.x = 100;
			hero.y = 0 - hero.height;
			hero.rotation = Math.PI/2
			hero.alignPivot();
			
			TweenLite.to(hero, 2, {x:190, onComplete:initMenu});
			
			this.addEventListener(Event.ENTER_FRAME, heroAnimation);			
		}
		
		private function initMenu():void 
		{
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function heroAnimation(e:Event):void 
		{
			var currentDate:Date = new Date();
			hero.y = 225 + (Math.cos(currentDate.getTime() * 0.002) * 5);
			lvl1Btn.y = 150 + (Math.cos(currentDate.getTime() * 0.002) * 3);
			lvl2Btn.y = 210 + (Math.cos(currentDate.getTime() * 0.002) * 3);
		}
		
		public function disposeTemporarily():void 
		{
			visible = false;
			
			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, heroAnimation);
		}
	}

}