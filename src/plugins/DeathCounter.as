package plugins {
	
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	import org.flixel.FlxSprite;
	import states.Teststate;
	
	/**
	 * ...
	 * @author 
	 */
	public class DeathCounter extends Counter {
		
		private var s:FlxSprite;
		
		public function DeathCounter() {
			s = new FlxSprite();
			gfx.deadHead(s);
			super(s, 1, 4);
			kill();
		}
		
		override public function revive():void {
			super.revive();
			setDefaultPosition(1);
		}
		
		override public function setPosition(X:Number, Y:Number):void {
			super.setPosition(X, Y-4);
			s.y += 4;
		}
		
		override public function get num():int {
			return super.num;
		}
		override public function set num(value:int):void {
			super.num = value;
		}
	}
}
