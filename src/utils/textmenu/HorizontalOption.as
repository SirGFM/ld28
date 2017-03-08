package utils.textmenu {
	
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class HorizontalOption extends Option {
		
		private var _opts:Vector.<FlxText>;
		private var _length:int;
		private var _cur:int;
		
		protected var _myMidColor:uint;
		
		public function HorizontalOption(Text:String, Options:Array, Current:int = 0, Size:int = 8, Color:uint = 0xffffffff, Shadow:uint = 0x33333333) {
			super(Text, Size, Color, Shadow);
			
			_opts = new Vector.<FlxText>();
			
			var w:int = 0;
			var i:int = 0;
			var t:FlxText;
			while (i < Options.length) {
				t = new FlxText(0, height + 2, (Options[i] as String).length * 9, (Options[i++] as String));
				t.shadow = 0x887b6049;
				w += t.width + 12;
				_opts.push(t);
			}
			w -= 12;
			
			height *= 2;
			height += 2;
			
			var x:int = (FlxG.width - w) / 2;
			_length = i;
			i = 0;
			while (i < _length) {
				t = _opts[i++];
				t.x = x;
				t.color = _myUnColor;
				x += t.width + 12;
			}
			
			//_myMidColor = (_myColor && 0xff000000) | (_myColor & 0x00cccccc);
			_myMidColor = 0xffc6b17d;
			
			_cur = Current;
			_opts[_cur].color = _myMidColor;
		}
		override public function destroy():void {
			super.destroy();
			
			while (_opts.length > 0)
				_opts.pop().destroy();
			_opts = null;
		}
		
		override public function draw():void {
			var h:int = height;
			super.draw();
			
			var i:int = 0;
			while (i < _length) {
				_opts[i].y += y;
				_opts[i].draw();
				_opts[i].y -= y;
				i++;
			}
			height = h;
		}
		
		override public function select():void {
			var h:int = height;
			super.select();
			_opts[_cur].color = _myColor;
			height = h;
		}
		override public function unselect():void {
			var h:int = height;
			super.unselect();
			_opts[_cur].color = _myMidColor;
			height = h;
		}
		override public function left():void {
			_opts[_cur].color = _myUnColor;
			_cur--;
			
			if (_cur < 0)
				_cur = _length - 1;
			
			_opts[_cur].color = _myColor;
		}
		override public function right():void {
			_opts[_cur].color = _myUnColor;
			_cur++;
			
			if (_cur >= _length)
				_cur = 0;
			
			_opts[_cur].color = _myColor;
		}
		
		public function get currentOption():String {
			return _opts[_cur].text;
		}
	}
}
