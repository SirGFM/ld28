package states {
	import objs.AnimatedBG;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	import utils.GFX;
	import utils.Saver;
	import utils.SFX;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	/**
	 * ...
	 * @author 
	 */
	public class Achievementsstate extends FlxState {
		
		private var animBG:AnimatedBG;
		
		public function Achievementsstate(AnimBG:AnimatedBG = null) {
			super();
			animBG = AnimBG;
		}
		
		override public function create():void {
			var saver:Saver = Saver.self;
			
			FlxG.flash(0xffffffff, 0.5);
			super.create();
			
			animBG.setBG(AnimatedBG.ACHIEVEMENTS);
			
			var s:FlxSprite = new FlxSprite(85, 15+8, GFX.self.achievementsGFX);
			var tm:TextMenu = new TextMenu(FlxG.height - 32, textmenuCallback);
			tm.addOption(new Option("Back"));
			
			add(animBG);
			add(s);
			add(tm);
			
			addText(40, 72, "Fastest run");
			if (saver.fastestRun == 0xffffffff)
				addText(72, 84, "N/A");
			else
				addText(72, 84, FlxU.formatTime(saver.fastestRun / 1000, true));
			addText(40, 98, "Slowest run");
			if (saver.slowestRun == 0)
				addText(72, 110, "N/A");
			else
				addText(72, 110, FlxU.formatTime(saver.slowestRun / 1000, true));
			addText(40, 124, "Total time");
			if (saver.gametime == 0)
				addText(72, 136, "N/A");
			else
				addText(72, 136, FlxU.formatTime(saver.gametime / 1000, true));
			
			addText(184, 72, "Fewest deaths");
			if (saver.fewestDeaths == 0x7fffffff)
				addText(232, 84, "N/A");
			else
				addText(232, 84, saver.fewestDeaths.toString());
			addText(184, 98, "Most deaths");
			if (saver.mostDeaths == -1)
				addText(232, 110, "N/A");
			else
				addText(232, 110, saver.mostDeaths.toString());
			addText(184, 124, "Total deaths");
			addText(232, 136, saver.totaldeath.toString());
			
			var arr:Array = saver.gottenTreasures;
			var i:int = 0;
			var l:int = arr.length;
			while (i < l) {
				var ts:int = arr[i];
				var spr:FlxSprite;
				
				spr = new FlxSprite(56 + 3*16*ts, 184);
				GFX.self.treasures(spr);
				spr.frame = ts;
				add(spr);
				
				i++;
			}
		}
		override public function destroy():void {
			remove(animBG);
			super.destroy();
		}
		
		private function textmenuCallback(tm:TextMenu):void {
			if (tm.selected) {
				FlxG.switchState(new Menustate(true, animBG));
				active = false;
				tm.active = false;
				SFX.self.beeep();
			}
		}
		
		private function addText(X:Number, Y:Number, txt:String):void {
			var t:FlxText = new FlxText(X, Y, FlxG.width, txt);
			t.setFormat(null, 8, 0xffedde8d, "left", 0x88b48e6d);
			add(t);
		}
	}
}
