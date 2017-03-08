package objs {
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Platform extends Basic {
		
		// TODO fix graphic direction
		
		private var _activated:Boolean;
		private var max:int;
		
		private var acc:Number;
		private var add:Number;
		
		public function Platform() {
			super();
		}
		
		override public function update():void {
			if (_activated) {
				if (acc < 1) {
					acc += add;
				}
				while(acc >= 1) {
					acc -= 1;
					
					if (width % 8 == 0)
						sfx.platform();
					
					width += 1;
					if (facing == LEFT) {
						x--;
						last.x = x;
					}
					if (width % 16 == 0)
						width += 0;
					if (int(width / 16) >= max) {
						width = max * 16;
						_activated = false;
					}
				}
			}
		}
		
		override public function draw():void {
			if (width == 16) {
				super.draw();
				return;
			}
			
			var _x:int = x;
			
			if (facing == RIGHT) {
				_flashRect.width = 4;
				super.draw();
				x += 4;
				_flashRect.x = 4;
				_flashRect.width = 8;
				while (x + _flashRect.width < _x + width - 4) {
					super.draw();
					x += _flashRect.width;
				}
				if (x < _x + width - 4) {
					_flashRect.width = (_x + width - 4) - x;
					super.draw();
				}
				x = _x + width - 4;
				_flashRect.x = 12;
				_flashRect.width = 4;
				super.draw();
				_flashRect.x = 0;
				_flashRect.width = 16;
			}
			else if (facing == LEFT) {
				_flashRect.width = 4;
				super.draw();
				x += 4;
				_flashRect.x = 4;
				_flashRect.width = 8;
				while (x + _flashRect.width < _x + width - 4) {
					super.draw();
					x += _flashRect.width;
				}
				if (x < _x + width - 4) {
					_flashRect.width = (_x + width - 4) - x;
					super.draw();
				}
				x = _x + width - 4;
				_flashRect.x = 12;
				_flashRect.width = 4;
				super.draw();
				_flashRect.x = 0;
				_flashRect.width = 16;
			}
			
			x = _x;
		}
		
		public function activate():void {
			if (max != 0)
				_activated = true;
		}
		
		override public function recycle(argc:int, argv:Array):void {
			super.recycle(argc, argv);
			gfx.platform(this);
			
			immovable = true;
			_activated = false;
			max = 0;
			acc = 0;
			
			if (argc > 4) {
				var str:String = argv[4];
				if (str == "left")
					facing = LEFT;
				else if (str == "right")
					facing = RIGHT;
			}
			if (argc > 5)
				max = int(argv[5]);
			if (argc > 6) {
				var time:int = int(argv[6] as String);
				if (time != 1) {
					time--;
					add = max * 16 * FlxG.elapsed / time;
				}
				else {
					add = max * 16 * FlxG.elapsed / time;
					add *= 2;
				}
			}
			else
				add = 1;
		}
	}
}
