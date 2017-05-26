package events 
{
	import starling.events.Event;
	
	public class DestroyBallEvent extends Event 
	{
		
		public static const DESTROYBALL:String = "destroyBall";
		
		public function DestroyBallEvent(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);
			
		}
		
	}

}