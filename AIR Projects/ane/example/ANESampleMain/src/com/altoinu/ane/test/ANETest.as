package com.altoinu.ane.test
{
	
	import com.altoinu.ane.test.events.ANETestEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
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
		
		private var extContext:ExtensionContext;
		
		public function ANETest(h:Function = null)
		{
			
			super();
			
			if (!(h === hidden))
				throw new Error("Use getInstance() to get reference to singleton");
			
			// Create extension context, with id specified in extension.xml so
			// this library can figure out which native code to access
			extContext = ExtensionContext.createExtensionContext("com.altoinu.ane.test.aneTest", "");
			
			if (!extContext)
			{
				
				throw new Error("ANETest is not supported on this device.");
				
			}
			else
			{
				
				// Listen for status event coming from native code
				extContext.addEventListener(StatusEvent.STATUS, onStatus);
				
			}
			
		}
		
		public function showAlert(message:String):String
		{
			
			// example of calling function with argument and return value
			return extContext.call("showAlertMessage", message) as String;
			
		}
		
		public function showNativeView():void
		{
			
			extContext.call("showNativeView");
			
		}
		
		private function onStatus(event:StatusEvent):void
		{
			
			dispatchEvent(new ANETestEvent(ANETestEvent.BOOM, false, false, {code: event.code, level: event.level}));
			
		}
		
	}
	
}