package com.altoinu.ane.test.events
{
	
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class ANETestEvent extends Event
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The ANETestEvent.BOOM constant defines the value of the type property of an
		 * <code>boom</code> event object.
		 */
		public static const BOOM:String = "boom";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function ANETestEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:Object = null)
		{
			
			super(type, bubbles, cancelable);
			
			this.data = data;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var data:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			
			return new ANETestEvent(type, bubbles, cancelable, data);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			
			var eventClassName:String = getQualifiedClassName(this);
			return "[" + eventClassName.substring(eventClassName.lastIndexOf("::") + 2) + " type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + "]";
			
		}
		
	}
	
}