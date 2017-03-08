package plugins {
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import utils.Registry;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Transition extends FlxSprite {
		
		static protected var reg:Registry = Registry.self;
		
		private var plvx:Number;
		private var plvy:Number;
		private var dx:Number;
		private var dy:Number;
		private var vx:Number;
		private var vy:Number;
		private var vertDone:Boolean;
		private var horFirst:Boolean;
		
		public function Transition() {
			super();
			exists = false;
			
			makeGraphic(FlxG.width, FlxG.height, 0, true, "transitionSS");
		}
		
		override public function update():void {
			super.update();
			
			if (dx == 0 && dy == 0) {
				exists = false;
				reg.player.visible = true;
				FlxG.timeScale = 1;
				return;
			}
			
			reg.player.x += plvx;
			reg.player.y += plvy;
			
			if (!horFirst && !vertDone) {
				if (FlxU.abs(vy) < FlxU.abs(dy)) {
					dy -= vy;
					FlxG.camera.scroll.y -= vy;
				}
				else {
					FlxG.camera.scroll.y = 0;
					dy = 0;
					vertDone = true;
				}
				
			}
			else {
				if (FlxU.abs(vx) < FlxU.abs(dx)) {
					dx -= vx;
					FlxG.camera.scroll.x -= vx;
				}
				else {
					FlxG.camera.scroll.x = 0;
					dx = 0;
					horFirst = false;
				}
			}
		}
		override public function draw():void {
			super.draw();
			reg.player.visible = true;
			reg.player.moves = false;
			reg.player.postUpdate();
			reg.player.draw();
			reg.player.moves = true;
			reg.player.visible = false;
		}
		
		public function setGraphic():void {
			stamp(FlxG.camera.screen);
		}
		
		public function wakeup(SrcX:int, SrcY:int, DstX:int, DstY:int, Facing:uint, time:Number):void {
			horFirst = false;
			
			time /= 2;
			
			dx = DstX - SrcX;
			dy = DstY - SrcY;
			if (Facing == LEFT) {
				dx += 16;
				plvx = 16 / time * FlxG.elapsed;
				plvy = 0;
			}
			else if (Facing == RIGHT) {
				dx -= 16;
				plvx = -16 / time * FlxG.elapsed;
				plvy = 0;
			}
			else if (Facing == UP) {
				dy += 16;
				plvx = 0;
				plvy = 16 / time * FlxG.elapsed;
				horFirst = true;
			}
			else if (Facing == DOWN) {
				dy -= 16;
				plvx = 0;
				plvy = -16 / time * FlxG.elapsed;
				horFirst = true;
			}
			
			var adx:Number = FlxU.abs(dx);
			var ady:Number = FlxU.abs(dy);
			var d:Number = adx + ady;
			
			var tx:Number = (dx/d) * time;
			var ty:Number = (dy/d) * time;
			
			vx = adx / tx * FlxG.elapsed;
			vy = ady / ty * FlxG.elapsed;
			
			vertDone = false;
			exists = true;
			alive = true;
			visible = true;
			active = true;
			
			x = dx;
			y = dy;
			FlxG.camera.scroll.x = dx;
			FlxG.camera.scroll.y = dy;
			reg.player.visible = false;
			reg.player.x += dx;
			reg.player.y += dy;
			
			FlxG.timeScale = 0.75;
		}
	}
}
