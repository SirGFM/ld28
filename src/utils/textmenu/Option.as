package utils.textmenu {
	
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Option extends FlxText {
		
		protected var _myColor:uint;
		protected var _myUnColor:uint;
		
		public function Option(Text:String, Size:int = 8, Color:uint = 0xffffffff, Shadow:uint = 0x33333333) {
			super(0, 0, FlxG.width, Text);
			setFormat(null, Size, 0xffedde8d, "center", 0x887b6049);
			
			_myColor = 0xffedde8d;
			_myUnColor = 0xffb48e6d;
			/*
			setFormat(null, Size, Color, "center", Shadow);
			_myColor = Color;
			_myUnColor = (_myColor && 0xff000000) | ((_myColor & 0x00cccccc) >> 1);
			*/
		}
		
		public function unselect():void {
			color = _myUnColor;
		}
		public function select():void {
			color = _myColor;
		}
		
		public function left():void {}
		public function right():void { }
		
	}
}
