package
{
	
	import com.altoinu.flash.video.StageVideoPlayer;
	import com.altoinu.flash.video.VideoPlayerEvent;
	import com.altoinu.flash.video.VideoPlayerMetaDataEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	public class StageVideoDemo extends Sprite
	{
		
		public function StageVideoDemo()
		{
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			player.source = "http://googledrive.com/host/0B15rMw1YAucncjBVOWhyMmtVeE0/test/video/Desperate.mp4";
			
			//player.width = 640;
			//player.height = 480;
			player.x = 50;
			player.y = 50;
			//player.autoPlay = true;
			//player.autoRewind = false;
			
			player.addEventListener(VideoPlayerMetaDataEvent.METADATA_RECEIVED, onStageVideoPlayerMetadata);
			player.addEventListener(VideoPlayerEvent.CLOSE, onVideoPlayerEvent);
			player.addEventListener(VideoPlayerEvent.COMPLETE, onVideoPlayerEvent);
			player.addEventListener(VideoPlayerEvent.PLAYING_STATE_ENTERED, onVideoPlayerEvent);
			player.addEventListener(VideoPlayerEvent.STOPPED_STATE_ENTERED, onVideoPlayerEvent);
			player.addEventListener(VideoPlayerEvent.SEEKED, onVideoPlayerEvent);
			
			addChild(player);
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			
		}
		
		private var player:StageVideoPlayer = new StageVideoPlayer();
		
		private function onMouseClick(event:MouseEvent):void
		{
			
			if (player.isPlaying)
				player.stop();
			else
				player.play();
			
			/*
			if (player.isPaused)
				player.resume();
			else
				player.pause();
			*/
			
			//player.seek(2);
			
		}
		
		private function onStageVideoPlayerMetadata(event:VideoPlayerMetaDataEvent):void
		{
			
			trace(event);
			
		}
		
		private function onVideoPlayerEvent(event:VideoPlayerEvent):void
		{
			
			trace(event);
			
		}
		
	}
	
}