package plugins {
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Reset extends Plugin {
		
		public function Reset() {
			super();
		}
		
		override public function update():void {
			if (FlxG.keys.justPressed("R"))
				reg.resetReq = true;
		}
	}
}
