package utils {
	
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class FlashingText extends FlxText {
		
		private var timer:Number;
		
		public function FlashingText(X:Number, Y:Number, Width:uint, Text:String) {
			super(X, Y, Width, Text);
			setFormat(null, 8, 0xffedde8d, "center", 0x88b48e6d);
			timer = 0;
		}
		
		override public function update():void {
			var step:Number = FlxG.elapsed;
			timer += step;
			if (timer < 0.5)
				alpha -= step * 2;
			else if (timer < 1)
				alpha += step * 2;
			else
				timer = 0;
		}
	}
}
