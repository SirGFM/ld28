package {
	
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Preloader extends MovieClip {
		
		private var lbl:Label;
		private var bar:ProgressBar;
		
		public function Preloader() {
			stop();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			addEventListener(Event.ENTER_FRAME, init);
		}
		
		private function init(event:Event):void {
			if( (stage.stageWidth <= 0) || (stage.stageHeight <= 0) )
				return;
			
			removeEventListener(Event.ENTER_FRAME, init);
			
			bar = new ProgressBar(this);
			bar.x = 320 - bar.width / 2;
			bar.y = 250 - bar.height / 2;
			bar.maximum = 1;
			bar.value = 0;
			
			lbl = new Label(this, 0, 0, "Loading...");
			lbl.x = 320 - lbl.width / 2;
			lbl.y = bar.y - lbl.height - 5;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void {
			var percent:Number = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
			
			bar.value = percent;
			
			if (percent == 1) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				removeChild(bar);
				bar = null;
				removeChild(lbl);
				lbl = null;
				
				var app:Object = new Main();
				addChild(app as DisplayObject);
			}
		}
	}
}
