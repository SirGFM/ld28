package objs.helpers {
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import utils.GFX;
	import utils.Registry;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Instructions extends FlxSprite {
		
		static protected var gfx:GFX = GFX.self;
		static protected var reg:Registry = Registry.self;
		
		public function Instructions() {
			super();
			
		}
		
		public function wakeup(level:int):void {
			revive();
			switch(level) {
				case 0: {
					gfx.inst00(this);
					var i:Instructions = FlxG.state.recycle(Instructions) as Instructions;
					i.revive();
					gfx.inst01(i);
				}break;
				case 1: gfx.inst02(this); break;
				case 2: gfx.inst03(this); break;
			}
		}
	}
}
