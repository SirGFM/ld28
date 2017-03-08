package states {
	import adobe.utils.CustomActions;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxTimer;
	import utils.GFX;
	import utils.Registry;
	import utils.Saver;
	
	/**
	 * ...
	 * @author 
	 */
	public class Cutscene extends FlxState {
		
		static protected const gfx:GFX = GFX.self;
		static protected const reg:Registry = Registry.self;
		static protected const saver:Saver = Saver.self;
		
		private var _t:FlxTimer;
		private var _current:int;
		private var _next:int;
		private var _arr:Vector.<State>;
		private var _ok:Boolean;
		
		override public function create():void {
			super.create();
			
			_current = -1;
			_next = 0;
			
			_t = new FlxTimer();
			_t.finished = true;
			_arr = new Vector.<State>;
			
			_ok = false;
		}
		override public function destroy():void {
			super.destroy();
			_t.destroy();
			while (_arr.length)
				_arr.pop();
		}
		
		override public function update():void {
			super.update();
			reg.doParticles();
			
			if (_t.finished && _next >= 0) {
				var newState:State = _arr[_next];
				
				_current = _next;
				_next = newState.next;
				
				if (newState.init != null) {
					_ok = true;
					newState.init();
					_ok = false;
				}
				
				_t.start(newState.time);
			}
		}
		override public function draw():void {
			super.draw();
			reg.drawParticles();
		}
		
		protected function addState(time:Number, next:int, init:Function):void {
			var newState:State = new State();
			
			newState.time = time;
			newState.next = next;
			newState.init = init;
			
			_arr.push(newState);
		}
		
		public function get state():int {
			return _current;
		}
		public function set state(val:int):void {
			if (_ok)
				_next = val;
		}
	}
}

class State {
	public var time:Number;
	public var next:int;
	public var init:Function;
}
