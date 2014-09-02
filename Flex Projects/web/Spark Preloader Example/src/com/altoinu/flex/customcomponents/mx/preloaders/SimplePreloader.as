package com.altoinu.flex.customcomponents.mx.preloaders
{
	
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	
	/**
	 * Simple preloader which uses 100 frame MovieClip.
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
	 * location https://svn.int.eprize.net/svn/flash/common/samples/Flex_SimplePreloader/.</p>
	 * 
	 * <p>To specify this preloader in a Flex application, set properties of main <code>Application</code> to following:
	 * <listing version="3.0">
	 * &lt;mx:Application
	 *     xmlns:mx="http://www.adobe.com/2006/mxml"
	 *     usePreloader="true" preloader="com.altoinu.flex.customcomponents.mx.preloaders.SimplePreloader"&gt;
	 * 
	 * ...
	 * </listing>
	 * </p>
	 * 
	 * <p>You can customize this class by extending it... For example, if you want to add extra images, you can use extended
	 * class and add them under setter <code>override public function set preloader(preloader:Sprite):void</code>.</p>
	 * 
	 * @author kaoru.kawashima
	 * 
	 */
	public class SimplePreloader extends DownloadProgressBar
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
		public function SimplePreloader()
		{
			
			super();
			
			// Create a preloader instance
			preloaderClip = new PRELOADERSYMBOL();
			this.addChild(preloaderClip);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var endFrameActionAdded:Boolean = false;
		private var endAnimationFound:Boolean = false;
		
		private var _initComplete:Boolean = false;
		protected var loadingCompleteReached:Boolean = false;
		
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
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		private var _preloader:Sprite; 
		
		/**
		 * @inheritDoc
		 */
		override public function set preloader(value:Sprite):void
		{
			
			_preloader = value;
			
			value.addEventListener(ProgressEvent.PROGRESS , onDownloadProgress);    
			value.addEventListener(Event.COMPLETE , onDownloadComplete);
			value.addEventListener(FlexEvent.INIT_PROGRESS , onFlexInitProgress);
			value.addEventListener(FlexEvent.INIT_COMPLETE , onInitComplete);
			
			// Position preloader in the center
			preloaderClip.x = (this.stageWidth / 2) - (preloaderClip.width / 2);
			preloaderClip.y = (this.stageHeight / 2) - (preloaderClip.height / 2);
			
			preloaderClip.gotoAndStop(1);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function updatePreloader(percentLoaded:int):void
		{
			
			if ((preloaderClip != null) && (preloaderClip.hasOwnProperty("preloadMeter")))
			{
				
				try
				{
					
					// Indicate the progress on meter by going to specific frame
					preloaderClip.gotoAndStop(1);
					preloaderClip.preloadMeter.gotoAndStop(percentLoaded);
					
					// Display the progress % number
					if (preloaderClip.preloadMeter.hasOwnProperty("progressText") &&
						preloaderClip.preloadMeter.progressText.hasOwnProperty("text_PercentLoaded") &&
						(preloaderClip.preloadMeter.progressText.text_PercentLoaded is TextField))
					{
						
						TextField(preloaderClip.preloadMeter.progressText.text_PercentLoaded).text = String(percentLoaded);
						
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
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Event handler executed as main application loads.
		 * @param event
		 * 
		 */
		protected function onDownloadProgress(event:ProgressEvent):void
		{
			
			//trace("onDownloadProgress Loaded: "+percentLoaded+"%");
			
			var percentLoaded:int = Math.round((event.bytesLoaded / event.bytesTotal)*100);
			
			if (percentLoaded < 0)
				percentLoaded = 0;
			if (percentLoaded > 100)
				percentLoaded = 100;
			
			updatePreloader(percentLoaded);
			
		}
		
		/**
		 * Event handler executed when main application load reaches 100%.
		 * @param event
		 * 
		 */
		protected function onDownloadComplete(event:Event):void
		{
			
			//trace("onDownloadComplete");
			updatePreloader(100);
			
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
		
		protected function onFlexInitProgress(event:Event):void
		{
			
			//trace("onFlexInitProgress");
			
		}
		
		/**
		 * Event handler executed when 100% of contents have been loaded and Application is ready to start.  It makes
		 * <code>Preloader</code> symbol loaded from /assets/preloader_assets.swf go to frame label <code>Loading Complete</code> to play
		 * animation, then when it hits the following frame label <code>Preloader End</code>, it executes event handler
		 * <code>preloaderDone</code> which notifies Flex application that loading has completed.
		 * 
		 * @param event
		 * 
		 */
		protected function onInitComplete(event:Event):void 
		{
			
			//trace("onInitComplete: "+event);
			
			if (!_initComplete)
			{
				
				_initComplete = true;
				
				// go to the frame that has animation to play when 100% loaded
				preloaderClip.gotoAndPlay(FRAMELABEL_LOADING_COMPLETE);
				
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				
			}
			
		}
		
		private function onEnterFrame(event:Event):void
		{
			
			if (preloaderClip.currentLabel == FRAMELABEL_LOADING_COMPLETE)
			{
				
				if (!loadingCompleteReached)
				{
					
					loadingComplete();
					
				}
				
			}
			else if (preloaderClip.currentLabel == FRAMELABEL_PRELOADER_END)
			{
				
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
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
			
			// Stop animation
			preloaderClip.gotoAndStop(FRAMELABEL_PRELOADER_END);
			
			// and dispatch event to notify application that preloader has ended
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
	}
	
}