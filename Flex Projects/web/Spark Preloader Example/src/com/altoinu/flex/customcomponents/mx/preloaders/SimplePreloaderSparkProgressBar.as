package com.altoinu.flex.customcomponents.mx.preloaders
{
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	import mx.events.RSLEvent;
	import mx.preloaders.SparkDownloadProgressBar;
	
	/**
	 * Simple Flex 4 spark preloader that uses 100 frame MovieClip.
	 * 
	 * <p>To use this class, there needs to be <code>/assets/preloader_assets.swf</code>, which is a separate .swf
	 * containing preloader assets.  SimplePreloader will use symbol with Linkage ID <code>Preloader</code> as the preloader
	 * that displays in the center of the stage.</p>
	 * 
	 * <p>In the first frame of the <code>Preloader</code> symbol, there should be a MovieClip instance named
	 * <code>preloadMeter</code> which contains 100 frames.  As Flex application loads, it moves the playhead in it
	 * so appropriate progress can be shown.  Optionally, it can contain MovieClip named <code>progressText</code> with a Texfield
	 * inside it named <code>text_PercentLoaded</code>, so SimplePreloader can display % progress into
	 * <code>preloadMeter.progressText.text_PercentLoaded.text</code>.</p>
	 * 
	 * <p>Also in <code>Preloader</code> there should be two frame labels in following order so SimplePreloader knows
	 * when to do certain actions:
	 * <ol>
	 *   <li><code>Loading Complete</code> - SimplePreloader will jump to this frame and play whatever animation in here
	 * after 100% of the Flex application has been loaded.</li>
	 *   <li><code>Preloader End</code> - Frame label located after <code>Loading Complete</code>.  When play head reaches here
	 * after playing animation in <code>Loading Complete</code>, SimplePreloader will notify Flex application that it can start.</li>
	 * </ol></p>
	 * 
	 * <p>You can obtain a template preloader_assets.fla that you can simply modify to use this class under Flash SVN
	 * location https://svn.int.eprize.net/svn/flash/common/samples/Flex_SimpleSparkPreloader/.</p>
	 * 
	 * <p>To specify this preloader in a Flex application, set properties of main <code>Application</code> to following:
	 * <listing version="3.0">
	 * &lt;s:Application
	 *     xmlns:mx="http://www.adobe.com/2006/mxml"
	 *     usePreloader="true" preloader="com.altoinu.flex.customcomponents.mx.preloaders.SimplePreloaderSparkProgressBar"&gt;
	 * 
	 * ...
	 * </listing>
	 * </p>
	 * 
	 * <p>You can customize this class by extending it... For example, if you want to add extra images, you can use extended
	 * class and add them under setter <code>override public function set preloader(preloader:Sprite):void</code>.</p>
	 * 
	 * @author Kaoru Kawashima
	 * 
	 */
	public class SimplePreloaderSparkProgressBar extends SparkDownloadProgressBar
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		[Embed(source="/assets/preloader_assets.swf", symbol="Preloader")]
		protected const PRELOADERSYMBOL:Class;
		
		protected const FRAMELABEL_LOADING_COMPLETE:String = "Loading Complete";
		protected const FRAMELABEL_PRELOADER_END:String = "Preloader End";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 */
		public function SimplePreloaderSparkProgressBar()
		{
			
			super();
			
			// Create a preloader instance
			preloaderClip = new PRELOADERSYMBOL();
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var endFrameActionAdded:Boolean = false;
		private var endAnimationFound:Boolean = false;
		
		private var _initComplete:Boolean = false;
		private var progress100Reached:Boolean = false;
		protected var loadingCompleteReached:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function set preloader(value:Sprite):void
		{
			
			super.preloader = value;
			
			// Position preloader in the center
			preloaderClip.x = (stageWidth / 2) - (preloaderClip.width / 2);
			preloaderClip.y = (stageHeight / 2) - (preloaderClip.height / 2);
			
			preloaderClip.gotoAndStop(1);
			
			updatePreloaderPos(0);
			updatePreloaderProgressText("0");
			updateRSLPreloaderPos(0);
			updateRSLPreloaderProgressText("", "");
			
			addChild(preloaderClip);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * MovieClip that displays the preloading progress.  This is the 100 frame MovieClip created from
		 * symbol <code>Preloader</code> under <code>/assets/preloader_assets.swf</code>.
		 */
		protected var preloaderClip:MovieClip;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates preloader display.
		 * 
		 */
		override protected function createChildren():void
		{
			
			// do nothing
			
		}
		
		/**
		 * Updates initialization progress.
		 * 
		 * @param completed Number of initialization steps that
		 * have been completed
		 * @param total Total number of initialization steps
		 * 
		 */
		override protected function setInitProgress(completed:Number, total:Number):void
		{
			
			var progress:Number = Math.round((completed / total) * 100); // 0 - 100
			//trace("setInitProgress: "+completed+"/"+total+" "+progress);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function updatePreloaderPos(percentLoaded:int):void
		{
			
			if ((preloaderClip != null) && (preloaderClip.hasOwnProperty("preloadMeter")))
			{
				
				try
				{
					
					// Indicate the progress on meter by going to specific frame
					preloaderClip.gotoAndStop(1);
					preloaderClip.preloadMeter.gotoAndStop(percentLoaded);
					
				}
				catch (error:Error)
				{
					
					// Don't do anything if error occurred
					//trace("Preloader broke....");
					
				}
				
			}
			
		}
		
		private function updatePreloaderProgressText(progress:String = ""):void
		{
			
			if ((preloaderClip != null) && (preloaderClip.hasOwnProperty("preloadMeter")))
			{
				
				try
				{
					
					// Display the progress text
					if (preloaderClip.preloadMeter.hasOwnProperty("progressText") &&
						preloaderClip.preloadMeter.progressText.hasOwnProperty("text_PercentLoaded") &&
						(preloaderClip.preloadMeter.progressText.text_PercentLoaded is TextField))
					{
						
						TextField(preloaderClip.preloadMeter.progressText.text_PercentLoaded).text = progress;
						
					}
					
				}
				catch (error:Error)
				{
					
					// Don't do anything if error occurred
					//trace("Preloader broke....");
					
				}
				
			}
			
		}
		
		private function updateRSLPreloaderPos(percentLoaded:int):void
		{
			
			if ((preloaderClip != null) && (preloaderClip.hasOwnProperty("rslPreloadMeter")))
			{
				
				try
				{
					
					// Indicate the progress on meter by going to specific frame
					preloaderClip.gotoAndStop(1);
					preloaderClip.rslPreloadMeter.gotoAndStop(percentLoaded);
					
				}
				catch (error:Error)
				{
					
					// Don't do anything if error occurred
					//trace("Preloader broke....");
					
				}
				
			}
			
		}
		
		private function updateRSLPreloaderProgressText(progress:String = "", rslNumber:String = "", rslTotal:String = ""):void
		{
			
			if ((preloaderClip != null) && (preloaderClip.hasOwnProperty("rslPreloadMeter")))
			{
				
				try
				{
					
					// Display the progress text
					if (preloaderClip.rslPreloadMeter.hasOwnProperty("progressText"))
					{
						
						if (preloaderClip.rslPreloadMeter.progressText.hasOwnProperty("text_PercentLoaded") &&
							(preloaderClip.rslPreloadMeter.progressText.text_PercentLoaded is TextField))
						{
							
							TextField(preloaderClip.rslPreloadMeter.progressText.text_PercentLoaded).text = progress;
							
						}
						
					}
					
					// Display the RSL progress text
					if (preloaderClip.rslPreloadMeter.hasOwnProperty("rslProgressText"))
					{
						
						if (preloaderClip.rslPreloadMeter.rslProgressText.hasOwnProperty("rslNumber") &&
							(preloaderClip.rslPreloadMeter.rslProgressText.rslNumber is TextField))
						{
							
							TextField(preloaderClip.rslPreloadMeter.rslProgressText.rslNumber).text = rslNumber;
							
						}
						
						if (preloaderClip.rslPreloadMeter.rslProgressText.hasOwnProperty("rslTotal") &&
							(preloaderClip.rslPreloadMeter.rslProgressText.rslTotal is TextField))
						{
							
							TextField(preloaderClip.rslPreloadMeter.rslProgressText.rslTotal).text = rslTotal;
							
						}
						
					}
					
				}
				catch (error:Error)
				{
					
					// Don't do anything if error occurred
					//trace("Preloader broke....");
					
				}
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden protected event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Watches main SWF being loaded.
		 * @param event
		 * 
		 */
		override protected function progressHandler(event:ProgressEvent):void
		{
			
			var percentLoaded:Number = Math.round((event.bytesLoaded / event.bytesTotal) * 100); // 0 - 100
			
			if (percentLoaded < 0)
				percentLoaded = 0;
			if (percentLoaded > 100)
				percentLoaded = 100;
			
			if (percentLoaded != 100)
				progress100Reached = false;
			
			if (!progress100Reached)
			{
				
				//trace("Main progress: "+percentLoaded);
				updatePreloaderPos(percentLoaded);
				updatePreloaderProgressText(String(percentLoaded));
				
			}
			
			if (percentLoaded == 100)
				progress100Reached = true;
			
		}
		
		/**
		 * Event handler when main SWF is completely loaded.
		 * @param event
		 * 
		 */
		override protected function completeHandler(event:Event):void
		{
			
			//trace("Main complete");
			
			updatePreloaderPos(100);
			updatePreloaderProgressText("100");
			
			// Assign function to be executed at a certain frame
			var frameLabels:Array = preloaderClip.currentLabels;
			var numLabels:int = preloaderClip.currentLabels.length;
			for (var i:int = 0; i < numLabels; i++)
			{
				
				if (!endFrameActionAdded && (FrameLabel(frameLabels[i]).name == FRAMELABEL_PRELOADER_END))
				{
					
					// addFrameScript here to indicate end of preloading
					//preloaderClip.addFrameScript(frameLabels[i].frame, preloaderDone);
					endFrameActionAdded = true;
					
				}
				else if (!endAnimationFound && (FrameLabel(frameLabels[i]).name == FRAMELABEL_LOADING_COMPLETE))
				{
					
					// Found frame that plays ending animation
					endAnimationFound = true;
					
				}
				
			}
			
			if (!endFrameActionAdded)
			{
				
				// Invalid preloader_asset.swf
				throw(new Error("Preloader symbol specified in /assets/preloader_assets.swf does not contain the required frame label \"Preloader End.\""));
				
			}
			
			if (!endAnimationFound)
			{
				
				// Invalid preloader_asset.swf
				throw(new Error("Preloader symbol specified in /assets/preloader_assets.swf does not contain the required frame label \"Loading Complete.\""));
				
			}
			
		}
		
		
		/**
		 * Watches RSL components being loaded.
		 * @param event
		 * 
		 */
		override protected function rslProgressHandler(event:RSLEvent):void
		{
			
			if (event.rslIndex && event.rslTotal)
			{
				
				var rsl_progress:Number = (event.bytesTotal > 0) ? Math.round((event.bytesLoaded / event.bytesTotal) * 100) : 100; // 0 - 100 of current RSL being loaded
				var progress:Number = Math.round((event.rslIndex  * 100 + rsl_progress) / event.rslTotal); // 0 - 100 of all RSL being loaded;
				
				//trace("RSL ("+(event.rslIndex+1)+" of "+event.rslTotal+"):" + rsl_progress+"% Total: "+progress+"%");
				
				updateRSLPreloaderPos(progress);
				updateRSLPreloaderProgressText(String(progress), String(event.rslIndex + 1), String(event.rslTotal));
				
			}
			
		}
		
		override protected function rslCompleteHandler(event:RSLEvent):void
		{
			
			var rsl_progress:Number = (event.bytesTotal > 0) ? Math.round((event.bytesLoaded / event.bytesTotal) * 100) : 100; // 0 - 100 of current RSL being loaded
			var progress:Number = Math.round((event.rslIndex  * 100 + rsl_progress) / event.rslTotal); // 0 - 100 of all RSL being loaded;
			
			//trace("RSL complete: ("+(event.rslIndex+1)+" of "+event.rslTotal+"):" + rsl_progress+"% Total: "+progress+"%");
			
			updateRSLPreloaderPos(progress);
			updateRSLPreloaderProgressText(String(progress), String(event.rslIndex + 1), String(event.rslTotal));
			
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function initCompleteHandler(event:Event):void
		{
			
			//trace("init complete");
			
			if (!_initComplete)
			{
				
				_initComplete = true;
				
				// go to the frame that has animation to play when 100% loaded
				preloaderClip.gotoAndPlay(FRAMELABEL_LOADING_COMPLETE);
				
				this.addEventListener(Event.ENTER_FRAME, onLoadCompleteEnterFrame);
				
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * @param event
		 * 
		 */
		private function onLoadCompleteEnterFrame(event:Event):void
		{
			
			if (preloaderClip.currentLabel == FRAMELABEL_LOADING_COMPLETE)
			{
				
				if (!loadingCompleteReached)
					loadingComplete();
				
			}
			else if (preloaderClip.currentLabel == FRAMELABEL_PRELOADER_END)
			{
				
				this.removeEventListener(Event.ENTER_FRAME, onLoadCompleteEnterFrame);
				preloaderDone();
				
			}
			
		}
		
		/**
		 * Event handler executed when 100% preload completes, but before preload complete animation in <code>Preloader</code>
		 * symbol  specified in /assets/preloader_assets.swf plays (reached frame label <code>Loading Complete</code>).
		 * 
		 * <p>Override this method to do any custom methods.</p>
		 * 
		 */
		protected function loadingComplete():void
		{
			
			loadingCompleteReached = true;
			
		}
		
		/**
		 * Event handler executed when 100% preload complete animation in <code>Preloader</code> symbol specified in /assets/preloader_assets.swf
		 * finishes playing (reached frame label <code>Preloader End</code>).  When this event handler executes, it notifies the
		 * Flex Application to start.
		 * 
		 * @param event
		 * 
		 */
		protected function preloaderDone(event:Event = null):void
		{
			
			//trace("Now, really done");
			
			// Stop animation
			preloaderClip.gotoAndStop(FRAMELABEL_PRELOADER_END);
			
			// and dispatch event to notify application that preloader has ended
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
	}
	
}