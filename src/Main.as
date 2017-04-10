package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	
	[SWF(width="800", height="600", framerate="50", backgroundColor="#000000")]
	public class Main extends Sprite 
	{
		private var _myStarling:Starling
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			_myStarling = new Starling(Level, stage);
			_myStarling.antiAliasing = 2;
			_myStarling.start();
		}
		
	}
	
}