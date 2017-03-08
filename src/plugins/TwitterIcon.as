package plugins {
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author 
	 */
	public class TwitterIcon extends Icon {
		
		[Embed(source = "../../assets/gfx/gui/twitter.png")]		private var twitterIcon:Class;
		
		public function TwitterIcon() {
			super(4, 4, loader, false);
			kill();
		}
		
		override public function revive():void {
			super.revive();
		}
		
		override protected function callback():void {
			FlxU.openURL("https://twitter.com/SirGFM");
		}
		
		private function loader(icon:FlxSprite):void {
			icon.loadGraphic(twitterIcon, true, false, 16, 16);
		}
	}
}
