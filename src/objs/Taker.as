package objs {
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author 
	 */
	public class Taker extends Basic {
		
		private var tgt:FlxObject;
		
		private var doorway:FlxSprite;
		private var jewel:FlxSprite;
		private var cnt:FlxTilemap;
		private var n:int;
		
		private var cur:Number;
		private var max:Number
		private var finishing:Boolean;
		private var counter:int;
		
		public function Taker() {
			super();
			
			doorway = new FlxSprite();
			jewel = new FlxSprite();
			cnt = new FlxTilemap();
			
			gfx.door(this);
			gfx.doorway(doorway);
			gfx.doorJewel(jewel);
			cnt.loadMap("0, 0", gfx.doorNumGFX, 5, 7, FlxTilemap.OFF, 0, 0);
			tgt = new FlxObject();
		}
		override public function destroy():void {
			super.destroy();
			tgt.destroy();
			jewel.destroy();
			cnt.destroy();
		}
		
		override public function update():void {
			super.update();
			
			if (cur < max) {
				cur += 3.33 * FlxG.elapsed;
				if (cur > max)
					cur = max;
			}
		}
		
		override public function draw():void {
			if (finishing && _flashRect.height > 0) {
				var dy:Number = height * FlxG.elapsed;
				_flashRect.y += dy;
				_flashRect.height -= dy;
				cnt.y -= dy;
				if (counter % 4 == 0) {
					sfx.spark();
					if (reg.particlesEnabled) {
						tgt.y = y + _flashRect.height;
						reg.cloudEmitter.setXSpeed( -28, 28);
						reg.cloudEmitter.setYSpeed( 24, 48);
						
						tgt.x = doorway.x+6;
						reg.cloudEmitter.at(tgt);
						reg.cloudEmitter.explode(0.4, 4);
						
						tgt.x += width;
						reg.cloudEmitter.at(tgt);
						reg.cloudEmitter.explode(0.4, 4);
					}
				}
				counter++;
			}
			doorway.draw();
			if (_flashRect.height > 0)
				super.draw();
			if (_flashRect.height > 18)
				cnt.draw();
			
			var tmp:Number = 0;
			jewel.frame = 0;
			jewel.alpha = 1;
			jewel.x = doorway.x + 5;
			jewel.y = doorway.y + 2;
			while (tmp < cur-1 && tmp < 8) {
				jewel.draw();
				tmp++;
				if (tmp < 4)
					jewel.x += jewel.width;
				else if (tmp == 4)
					jewel.x = doorway.x + 38;
				else
					jewel.x -= jewel.width;
			}
			tmp = cur - tmp;
			if (tmp > 0) {
				if (cur > 8) {
					jewel.frame = 1;
					jewel.alpha = tmp / 2;
				}
				else
					jewel.alpha = tmp;
				jewel.draw();
			}
		}
		
		public function get needed():int {
			if (!finishing && n <= saver.totalGold) {
				finishing = true;
				FlxG.camera.shake(0.025, 1);
			}
			return n;
		}
		
		override public function revive():void {
			var i:int;
			
			switch (saver.next+1) {
				case 13: i = 0; break;
				case 19: i = 1; break;
				case 28: i = 2; break;
				case 30: i = 3; break;
				case 35: i = 4; break;
			}
			
			var _x:Number;
			var _y:Number = 11 * 16;
			if (i == 0 || i >= 3) {
				_x = 16 * 16;
				facing = LEFT;
			}
			else if (i <= 2) {
				_x = 1 * 16;
				facing = RIGHT;
			}
			
			super.revive();
			x = _x + 5;
			y = _y + 7;
			
			doorway.x = _x;
			doorway.y = _y;
			
			cnt.x = x + 24;
			cnt.y = y + 19;
			
			n = saver.payArr[i];
			cnt.setTileByIndex(0, n / 10, true);
			cnt.setTileByIndex(1, n % 10, true);
			
			cur = 0;
			max = saver.totalGold / n * 10;
			if (max > 10)
				max = 10;
			finishing = false;
			
			_flashRect.y = 0;
			_flashRect.height = height;
			counter = 0;
			
			tgt.x = doorway.x;
			tgt.width = 1;
			tgt.height = 1;
		}
	}
}
