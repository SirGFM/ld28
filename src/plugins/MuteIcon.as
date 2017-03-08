package plugins {
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import utils.SFX;
	/**
	 * ...
	 * @author 
	 */
	public class MuteIcon extends Icon {
		
		[Embed(source = "../../assets/gfx/gui/mute.png")]		private var muteIcon:Class;
		
		public function MuteIcon() {
			super(FlxG.width - 40, 4, loader, true);
		}
		
		override protected function callback():void {
			if (FlxG.mute) {
				FlxG.mute = false;
				SFX.self.resumeMusic();
			}
			else {
				FlxG.mute = true;
				SFX.self.pauseMusic();
			}
		}
		
		private function loader(icon:FlxSprite):void {
			icon.loadGraphic(muteIcon, true, false, 16, 16);
		}
	}
}
