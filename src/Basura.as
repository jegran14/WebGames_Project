package 
{	
	import com.friendsofed.vector.*;
	import com.friendsofed.utils.TextBox;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.text.TextField;
    import flash.events.TimerEvent; 
 
	
	public class Basura extends Sprite 
	{
		private var scoreText:TextField;
		private var score:Score;
		private var time:Timer;
		
		public function Basura() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			score = new Score();
			
			scoreText = new TextField (300, 100, "Score = 5000", "Verdana", 24, 0x880088 , false);
			
			addChild(scoreText);
			
			shortTimer();
		}
		
		public function shortTimer():void 
		{
			var minuteTimer:Timer = new Timer (1000, 0);
			minuteTimer.start();
			minuteTimer.addEventListener(TimerEvent.TIMER, ontick);
		}
		
		private function ontick(e:TimerEvent):void 
		{
			score.updateScore(score);
			scoreText.text = "Score = " + score.GetScore;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			
		}
	}
}
	}
}