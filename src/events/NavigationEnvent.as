package events 
{
	import starling.events.Event;
	
	public class NavigationEnvent extends Event 
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		
		public var params:Object;
		
		public function NavigationEnvent(type:String, _params:Object = null, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);
			
			params = _params;
		}
		
	}

}