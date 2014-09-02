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
			
			extContext = ExtensionContext.createExtensionContext("com.altoinu.ane.test.aneTest", "");
			
			if (!extContext)
			{
				
				throw new Error("ANETest is not supported on this device.");
				
			}
			else
			{
				
				extContext.addEventListener(StatusEvent.STATUS, onStatus);
				
			}
			
		}
		
		public function showAlert(message:String):String
		{
			
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