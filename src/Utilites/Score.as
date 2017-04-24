package Utilites 
{
	import flash.utils.Timer;
	import starling.text.TextField;

	public class Score 
	{
		private var scoreTime:int;
		private var time:Timer;
		private var scoreBalls:int;
		
		public function Score() 
		{
			super();
			scoreTime = 5000;
		}
			
		public function set SetScore (setValue:int):void{
			scoreTime = setValue;
		}
		public function get GetScore ():int
		{
			return scoreTime;
		}
		
		public function get GetTotalScore ():int
		{
			return scoreTime + scoreBalls;
		}
		
		public function updateScore (score:Score):void
		{
			
			score.scoreTime = score.scoreTime - 1;
			
		}
		public function addScore ():void{
			scoreBalls += scoreTime * 0.1;
		}
		
		public function substractScore():void
		{
			scoreBalls -= scoreTime * 0.1;
		}
	}

}