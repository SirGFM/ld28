package plugins {
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class FullScreen extends FlxBasic {
		
		private var _isFullScreen:Boolean;
		
		public function FullScreen() {
			super();
			exists = false;
			active = false;
			visible = false;
			_isFullScreen = false;
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onFullScreen);
		}
		override public function destroy():void {
			super.destroy();
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onFullScreen);
		}
		
		private function onFullScreen(e:Event):void {
			if (FlxG.keys.justPressed("F12"))
				if (_isFullScreen) {
					_isFullScreen = false;
					FlxG.stage.displayState = StageDisplayState.NORMAL;
				}
				else {
					_isFullScreen = true;
					FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
				}
		}
	}
}
