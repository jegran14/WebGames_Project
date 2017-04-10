package 
{
	import flash.utils.Timer;
	import starling.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class Score 
	{
		private var scoreTime:int;
		private var time:Timer;
		
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
		public function updateScore (score:Score):void
		{
			
			score.scoreTime = score.scoreTime - 1;
			
		}
	}

}