package states {
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author 
	 */
	public class LOLstate extends FlxState {
		
		[Embed(source = "../../promo/trailer/sprites/a-dungeon.png")]				private var gfx1:Class;
		[Embed(source = "../../promo/trailer/sprites/lots-of-dangers.png")]			private var gfx2:Class;
		[Embed(source = "../../promo/trailer/sprites/only-one-true-treasure.png")]	private var gfx3:Class;
		[Embed(source = "../../promo/trailer/sprites/title.png")]					private var gfx4:Class;
		[Embed(source = "../../promo/trailer/sprites/dont-get-the-wong-one.png")]	private var gfx5:Class;
		
		private var s:FlxSprite;
		private var time:Number = 0;
		private var to:Number;
		
		override public function create():void {
			FlxG.bgColor = 0xff736585;
			s = new FlxSprite();
			s.alpha = 0;
			time = 0;
			add(s);
			
			
		}
		
		override public function update():void {
			if (FlxG.keys.ONE) {
				s.loadGraphic(gfx1);
				s.x = 56;
				s.y = 105;
				s.alpha = 0;
				time = 0;
				to = 0.5;
			}
			else if (FlxG.keys.TWO) {
				s.loadGraphic(gfx2);
				s.x = 6;
				s.y = 105;
				s.alpha = 0;
				time = 0;
				to = 0.5;
			}
			else if (FlxG.keys.THREE) {
				s.loadGraphic(gfx3);
				s.x = 18;
				s.y = 85;
				s.alpha = 0;
				time = 0;
				to = 0.5;
			}
			else if (FlxG.keys.FOUR) {
				s.loadGraphic(gfx4);
				s.x = 35;
				s.y = 87;
				s.alpha = 0;
				time = 0;
				to = 0.85;
			}
			else if (FlxG.keys.FIVE) {
				s.loadGraphic(gfx5);
				s.x = 12;
				s.y = 83;
				s.alpha = 0;
				time = 0;
				to = 0.75;
			}
			super.update();
			
			time += FlxG.elapsed;
			if (time < to)
				s.alpha += FlxG.elapsed*2;
			else
				s.alpha -= FlxG.elapsed*2;
		}
	}
}
