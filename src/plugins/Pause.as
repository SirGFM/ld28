package plugins {
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import states.Menustate;
	import states.NewPlaystate;
	import states.Teststate;
	import utils.textmenu.HorizontalOption;
	import utils.textmenu.TextMenu;
	
	/**
	 * ...
	 * @author 
	 */
	public class Pause extends Plugin {
		
		private var alpha:Number;
		private var s0:FlxSprite;
		private var s1:FlxSprite;
		private var tm:TextMenu;
		
		public function Pause() {
			super();
			
			alpha = 0;
			s0 = new FlxSprite(0, 0);
			s0.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			s1 = new FlxSprite(123, 15, gfx.pausedGFX);
			
			tm = new TextMenu(140, textmenuCallback);
			tm.addOption(new HorizontalOption("Back to menu?", ["No", "Yes"], 0));
			tm.active = false;
			visible = false;
		}
		
		override public function update():void {
			if (FlxG.keys.justPressed("ESCAPE")) {
				if (!(FlxG.state is NewPlaystate) || (FlxG.state is Teststate))
					return;
				if (FlxG.paused) {
					FlxG.paused = false;
					FlxG.state.active = true;
				}
				else {
					FlxG.paused = true;
					visible = true;
					FlxG.state.active = false;
				}
			}
			
			if (FlxG.paused && alpha < 1) {
				alpha += 3 * FlxG.elapsed;
				if (alpha >= 1) {
					alpha = 1;
					tm.active = true;
					tm.visible = true;
				}
				s0.alpha = 0.75*alpha;
				s1.alpha = alpha;
			}
			else if (!FlxG.paused && alpha > 0) {
				if (alpha == 1) {
					tm.active = false;
					tm.visible = false;
				}
				alpha -= 3 * FlxG.elapsed;
				if (alpha <= 0) {
					alpha = 0;
					visible = false;
				}
				s0.alpha = 0.75*alpha;
				s1.alpha = alpha;
			}
		}
		
		override public function draw():void {
			if (visible) {
				s0.draw();
				s1.draw();
				if (tm.visible)
					tm.draw();
			}
		}
		
		private function textmenuCallback(tm:TextMenu):void {
			if (tm.selected) {
				if (tm.currentHorizontalOpt == "No") {
					FlxG.paused = false;
					FlxG.state.active = true;
				}
				else if (tm.currentHorizontalOpt == "Yes") {
					FlxG.fade(0xff000000, 0.5, function():void
					{
						FlxG.switchState(new Menustate());
						alpha = 0;
						visible = false;
						FlxG.paused = false;
					} );
				}
				tm.active = false;
				sfx.beeep();
			}
			else
				sfx.bep();
		}
	}
}
