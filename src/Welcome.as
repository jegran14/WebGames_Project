package 
{
	import flash.geom.Point;
	import starling.display.Sprite;
	import starling.events.*;
	 
	public class Welcome extends Sprite
	{
		public function Welcome() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
		}
	}
}