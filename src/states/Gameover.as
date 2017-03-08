package states {
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Gameover extends FlxState {
		
		private var txt1:FlxText;
		private var txt2:FlxText;
		private var txt3:FlxText;
		private var t:FlxTimer;
		
		override public function create():void {
			txt1 = new FlxText(0, 60, 320, "It's a PIT, but you couldn't save both of them...");
			txt2 = new FlxText(0, 90, 320, "Maybe another time you will be able?");
			txt3 = new FlxText(0, 120, 320, "GAME OVER");
			
			txt1.setFormat(null, 8, 0xaaaaaa, "center", 0xaa555555);
			txt2.setFormat(null, 8, 0xaaaaaa, "center", 0xaa555555);
			txt3.setFormat(null, 16, 0xaaaaaa, "center", 0xaa555555);
			
			txt1.alpha = 0;
			txt2.alpha = 0;
			txt3.alpha = 0;
			
			add(txt1);
			add(txt2);
			add(txt3);
		}
		
		override public function update():void {
			super.update();
			
			txt1.alpha += FlxG.elapsed;
			if (txt1.alpha >= 1)
				txt2.alpha += FlxG.elapsed;
			if (txt2.alpha >= 1)
				txt3.alpha += FlxG.elapsed;
			
			if (!t && txt3.alpha >= 1) {
				t = new FlxTimer();
				t.start(2.5, 1, function():void { FlxG.fade(0xff000000, 1.5, function():void { FlxG.switchState(new Introstate()); } ); } );
			}
		}
	}
}
