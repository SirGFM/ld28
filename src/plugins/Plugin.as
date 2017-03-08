package plugins {
	
	import org.flixel.FlxBasic;
	import utils.GFX;
	import utils.Registry;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Plugin extends FlxBasic {
		
		static protected var gfx:GFX = GFX.self;
		static protected var reg:Registry = Registry.self;
		
		public function Plugin() {
			super();
		}
	}
}
