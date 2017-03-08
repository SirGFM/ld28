package states {
	
	import flash.display.StageQuality;
	import objs.AnimatedBG;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import utils.GFX;
	import utils.Registry;
	import utils.SFX;
	import utils.textmenu.HorizontalOption;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	/**
	 * ...
	 * @author 
	 */
	public class Optionstate extends FlxState {
		
		private const reg:Registry = Registry.self;
		
		private const DIFF:String = "Difficulty"
		private const MVOLUME:String = "Music Volume";
		private const SVOLUME:String = "Sounds Volume";
		private const FILTER:String = "Filter";
		private const QUALITY:String = "Quality";
		private const BACK:String = "Back";
		private const NOOB:String = "Noob";
		private const EASY:String = "Easy";
		private const NORM:String = "Normal";
		private const HARD:String = "Hard";
		private const _0:String = "0%";
		private const _20:String = "20%";
		private const _40:String = "40%";
		private const _60:String = "60%";
		private const _80:String = "80%";
		private const _100:String = "100%";
		private const ON:String = "On";
		private const OFF:String = "Off";
		private const LOW:String = "Low";
		private const MED:String = "Med";
		private const HIGH:String = "High";
		
		private var animBG:AnimatedBG;
		
		public function Optionstate(AnimBG:AnimatedBG = null):void {
			super();
			animBG = AnimBG;
		}
		override public function destroy():void {
			remove(animBG);
			super.destroy();
		}
		
		override public function create():void {
			FlxG.flash(0xffffffff, 0.5);
			super.create();
			
			add(animBG);
			
			(add(new FlxSprite(116, 15+8)) as FlxSprite).loadGraphic(GFX.self.optionsGFX);
			
			
			var m:int = saver.musicVolume * 5;
			var s:int = saver.soundVolume * 5;
			Game::filterEnabled {
				var f:int = (reg.filterVisibility)?0:1;
			}
			var q:int = 0;
			if (FlxG.stage.quality.toLowerCase() == StageQuality.LOW.toLowerCase()) 		q = 0;
			else if (FlxG.stage.quality.toLowerCase() == StageQuality.MEDIUM.toLowerCase())	q = 1;
			else if (FlxG.stage.quality.toLowerCase() == StageQuality.HIGH.toLowerCase())	q = 2;
			
			var tm:TextMenu = new TextMenu(80 - 32, textMenuCallback);
			
			var d:int;
			if (saver.difficulty == saver.NOOB) d = 0;
			else if (saver.difficulty == saver.EASY) d = 1;
			else if (saver.difficulty == saver.NORMAL) d = 2;
			else if (saver.difficulty == saver.HARD) d = 3;
			
			if (saver.difficulty == saver.NOOB)
				tm.addOption(new HorizontalOption(DIFF, [NOOB, EASY, NORM, HARD], d, 8, 0xffedde8d, 0x88b48e6d));
			else
				tm.addOption(new HorizontalOption(DIFF, [EASY, NORM, HARD], d-1, 8, 0xffedde8d, 0x88b48e6d));
			
			tm.addOption(new HorizontalOption(MVOLUME, [_0, _20, _40, _60, _80, _100], m, 8, 0xffedde8d, 0x88b48e6d));
			tm.addOption(new HorizontalOption(SVOLUME, [_0, _20, _40, _60, _80, _100], s, 8, 0xffedde8d, 0x88b48e6d));
			Game::filterEnabled {
				tm.addOption(new HorizontalOption(FILTER, [ON, OFF], f, 8, 0xffedde8d, 0x88b48e6d));
			}
			tm.addOption(new HorizontalOption(QUALITY, [LOW, MED, HIGH], q, 8, 0xffedde8d, 0x88b48e6d));
			tm.addOption(new Option(BACK, 8, 0xffedde8d, 0x88b48e6d));
			
			add(tm);
			
			animBG.setBG(AnimatedBG.OPTIONS);
		}
		
		private function textMenuCallback(tm:TextMenu):void {
			if (tm.currentOpt == BACK) {
				if (tm.selected) {
					SFX.self.beeep();
					tm.active = false;
					FlxG.switchState(new Menustate(true, animBG));
				}
				else
					SFX.self.bep();
				return
			}
			else if (tm.currentOpt == DIFF) {
				if (tm.currentHorizontalOpt == NOOB)
					saver.difficulty = saver.NOOB;
				else if (tm.currentHorizontalOpt == EASY)
					saver.difficulty = saver.EASY;
				else if (tm.currentHorizontalOpt == NORM)
					saver.difficulty = saver.NORMAL;
				else if (tm.currentHorizontalOpt == HARD)
					saver.difficulty = saver.HARD;
			}
			else if (tm.currentOpt == MVOLUME) {
				if (tm.currentHorizontalOpt ==  _0)
					saver.musicVolume = 0.00;
				else if (tm.currentHorizontalOpt ==  _20)
					saver.musicVolume = 0.20;
				else if (tm.currentHorizontalOpt ==  _40)
					saver.musicVolume = 0.40;
				else if (tm.currentHorizontalOpt ==  _60)
					saver.musicVolume = 0.60;
				else if (tm.currentHorizontalOpt ==  _80)
					saver.musicVolume = 0.80;
				else if (tm.currentHorizontalOpt ==  _100)
					saver.musicVolume = 1.00;
				SFX.self.volume = FlxG.volume;
			}
			else if (tm.currentOpt == SVOLUME) {
				if (tm.currentHorizontalOpt ==  _0)
					saver.soundVolume = 0.00;
				else if (tm.currentHorizontalOpt ==  _20)
					saver.soundVolume = 0.20;
				else if (tm.currentHorizontalOpt ==  _40)
					saver.soundVolume = 0.40;
				else if (tm.currentHorizontalOpt ==  _60)
					saver.soundVolume = 0.60;
				else if (tm.currentHorizontalOpt ==  _80)
					saver.soundVolume = 0.80;
				else if (tm.currentHorizontalOpt ==  _100)
					saver.soundVolume = 1.00;
				SFX.self.volume = FlxG.volume;
			}
			else if (tm.currentOpt == QUALITY) {
				if (tm.currentHorizontalOpt == LOW)
					FlxG.stage.quality = StageQuality.LOW;
				else if (tm.currentHorizontalOpt == MED)
					FlxG.stage.quality = StageQuality.MEDIUM;
				else if (tm.currentHorizontalOpt == HIGH)
					FlxG.stage.quality = StageQuality.HIGH;
			}
			Game::filterEnabled {
				if (tm.currentOpt == FILTER) {
					if (tm.currentHorizontalOpt == ON && !reg.filter.visible) {
						saver.filterVisibility = true;
						reg.filterVisibility = true;
					}
					else if (tm.currentHorizontalOpt == OFF && reg.filter.visible) {
						saver.filterVisibility = false;
						reg.filterVisibility = false;
					}
				}
			}
			
			saver.save();
			SFX.self.bep();
		}
	}
}
