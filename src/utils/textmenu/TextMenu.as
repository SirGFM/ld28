package utils.textmenu {
	
	import flash.events.KeyboardEvent;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class TextMenu extends FlxBasic {
		
		public var y:Number;
		public var selected:Boolean;
		
		private var _opts:Vector.<Option>;
		private var _cur:int;
		private var _callback:Function;
		private var _length:int;
		
		public function TextMenu(Y:Number, Callback:Function) {
			super();
			
			y = Y;
			
			_opts = new Vector.<Option>();
			_cur = 0;
			_length = 0;
			selected = false;
			
			_callback = Callback;
			
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		override public function destroy():void {
			super.destroy();
			
			while (_opts.length > 0)
				_opts.pop().destroy();
			_opts = null;
			
			_callback = null;
			
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function addOption(opt:Option):void {
			var i:int = 0;
			
			while (i < _length)
				if (_opts[i++] == opt)
					return;
			
			if (_length == 0)
				opt.select();
			else
				opt.unselect();
			
			_opts.push(opt);
			
			if (_length > 0)
				opt.y = _opts[_length - 1].y + _opts[_length - 1].height + 2;//_length * (_opts[_length - 1].height + 2);
			else
				opt.y = 0;
			
			_length++;
		}
		
		override public function draw():void {
			var i:int = 0;
			
			while (visible && i < _length) {
				_opts[i].y += y;
				_opts[i].draw();
				_opts[i].y -= y;
				i++;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			var previous:uint = _cur;
			var horizontal:Boolean = false;
			if (!active || _opts.length == 0)
				return;
			
			// UP
			if (e.keyCode == 38)
				_cur--;
			// DOWN
			else if(e.keyCode == 40)
				_cur++;
			// left
			else if (e.keyCode == 37) {
				horizontal = true;
				_opts[_cur].left();
			}
			// right
			else if (e.keyCode == 39) {
				horizontal = true;
				_opts[_cur].right();
			}
			// selection
			else if (e.keyCode == 13 || e.keyCode == 32 || e.keyCode == 67 || e.keyCode == 88 || e.keyCode == 89 || e.keyCode == 90)
				selected = true;
			
			if (_cur < 0)
				_cur = _opts.length - 1;
			else if (_cur >= _opts.length)
				_cur = 0;
			
			horizontal = horizontal && (_opts[_cur] is HorizontalOption);
			
			if (previous != _cur) {
				_opts[previous].unselect();
				_opts[_cur].select();
				
				if (_callback != null)
					_callback(this);
			}
			else if ((horizontal || selected) && _callback != null)
				_callback(this);
			
			selected = false;
		}
		
		public function get currentOpt():String {
			if (_opts.length == 0)
				return "";
			return _opts[_cur].text;
		}
		
		public function get currentHorizontalOpt():String {
			if (_opts.length == 0)
				return "";
			return (_opts[_cur] as HorizontalOption).currentOption;
		}
	}
}
