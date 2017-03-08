package plugins {
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author 
	 */
	public class Icon extends Plugin {
		
		protected var p:Boolean;	// pressed
		private var t:Boolean;		// toggle
		protected var icon:FlxSprite;
		
		public function Icon(X:Number, Y:Number, loader:Function, Toggle:Boolean) {
			super();
			icon = new FlxSprite(X, Y);
			loader(icon);
			icon.moves = false;
			icon.scrollFactor.make();
			t = Toggle;
			p = false;
		}
		
		override public function update():void {
			if (icon.overlapsPoint(FlxG.mouse)) {
				if (icon.frame == 1 && FlxG.mouse.justPressed()) {
					if (t && p)
						icon.frame = 0;
					else
						icon.frame = 2;
				}
				else if (FlxG.mouse.justReleased() && (t && (p && icon.frame == 0 || !p && icon.frame == 2) || !t && icon.frame == 2)) {
					if (t && !p)
						icon.frame = 2;
					else
						icon.frame = 0;
					if (t)
						p = !p;
					callback();
				}
				else if (icon.frame != 1 && !FlxG.mouse.pressed()) {
					icon.frame = 1;
				}
			}
			else {
				if (t && p)
					icon.frame = 2;
				else
					icon.frame = 0;
			}
		}
		override public function draw():void {
			icon.draw();
		}
		
		protected function callback():void { }
	}
}
