package com.altoinu.ane.test
{
	
	import com.altoinu.ane.test.events.ANETestEvent;
	
	import flash.events.EventDispatcher;
	
	[Event(name="boom", type="com.altoinu.ane.test.events.ANETestEvent")]
	
	public class ANETest extends EventDispatcher
	{
		
		private static var _instance:ANETest;
		private static function hidden():void {}
		
		public static function getInstance():ANETest
		{
			
			if (!_instance)
				_instance = new ANETest(hidden);
			
			return _instance;
			
		}
		
		public function ANETest(h:Function = null)
		{
			
			super();
			
			if (!(h === hidden))
				throw new Error("Use getInstance() to get reference to singleton");
			
		}
		
		public function showAlert(message:String):String
		{
			
			trace("ANETest.showAlert: " + message);
			return "Hello back from ANESampleDefault.ANETest.showAlert!";
			
		}
		
		public function showNativeView():void
		{
			
			trace("ANETest.showNativeView");
			
		}
		
		/*
		private function onStatus(event:StatusEvent):void
		{
			
			dispatchEvent(new ANETestEvent(ANETestEvent.BOOM, false, false));
			
		}
		*/
		
	}
	
}