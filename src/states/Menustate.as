package states {
	
	import com.newgrounds.Medal;
	import flash.display.StageQuality;
	import objs.AnimatedBG;
	import objs.Taker;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import utils.FlashingText;
	import utils.GFX;
	import utils.Registry;
	import utils.SFX;
	import utils.textmenu.HorizontalOption;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	Game::NG_API {
		import com.newgrounds.API;
	}
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Menustate extends FlxState {
		
		private var animBG:AnimatedBG;
		
		private const reg:Registry = Registry.self;
		static private var firstFocus:Boolean = false;
		
		private const NEWGAME:String = "New game";
		private const CONTINUE:String = "Continue";
		private const OPTIONS:String = "Options";
		private const MUSICBOX:String = "Music Box";
		private const ACHIEVEMENTS:String = "Achievements";
		private const EDITOR:String = "Editor";
		
		private var arr:Vector.<FlxSprite>;
		private var st:int;
		private var ft:FlashingText;
		
		private var bg:FlxSprite;
		private var help:FlxText;
		
		private var didUpload:Boolean;
		
		public function Menustate(doComplete:Boolean = false, AnimBG:AnimatedBG = null) {
			super();
			if (doComplete)
				st = 1;
			else
				st = 0;
			
			if (AnimBG == null)
				animBG = new AnimatedBG();
			else
				animBG = AnimBG;
		}
		
		override public function create():void {
			FlxG.bgColor = 0xff736585;
			
			saver.load();
			
			var X:Number = 35;
			var Y:Number = 15+8;
			arr = new Vector.<FlxSprite>();
			arr.push(new FlxSprite(X    , Y   ));
			arr.push(new FlxSprite(X+70 , Y   ));
			arr.push(new FlxSprite(X+12 , Y+20));
			arr.push(new FlxSprite(X+66 , Y+20));
			arr.push(new FlxSprite(X+24 , Y+40));
			arr.push(new FlxSprite(X+36 , Y+60));
			arr.push(new FlxSprite(X+118, Y+60));
			
			arr[0].loadGraphic(GFX.self.title_01GFX, false, false);
			arr[1].loadGraphic(GFX.self.title_02GFX, false, false);
			arr[2].loadGraphic(GFX.self.title_03GFX, false, false);
			arr[3].loadGraphic(GFX.self.title_04GFX, false, false);
			arr[4].loadGraphic(GFX.self.title_05GFX, false, false);
			arr[5].loadGraphic(GFX.self.title_06GFX, false, false);
			arr[6].loadGraphic(GFX.self.title_07GFX, false, false);
			
			animBG.setBG(AnimatedBG.MENU);
			add(animBG);
			
			var i:int = 6;
			while (i >= 0) {
				arr[i].alpha = 0;
				add(arr[i--]);
			}
			
			if (!firstFocus) {
				firstFocus = true;
				ft = new FlashingText(0, 128, 318, "-- CLICK TO START --");
				add(ft);
				st = -1;
			}
			else
				SFX.self.playMenuSong();
			
			reg.initParticles();
			
			//saver.erase();
			didUpload = saver.uploadAchievements(false);
		}
		override public function destroy():void {
			while (arr.length > 0)
				arr.pop();
			arr = null;
			ft = null;
			super.destroy();
		}
		
		override public function update():void {
			// Make sure the achievements were uploaded
			if (!didUpload && reg.apiConnected) {
				didUpload = saver.uploadAchievements(false);
			}
			
			if (st == -1) {
				if (FlxG.mouse.justPressed()) {
					st++;
					ft.kill();
					SFX.self.playMenuSong();
				}
			}
			else if (st == 0) {
				if (FlxG.mouse.justPressed() || FlxG.keys.any())
					st++;
				else
					state0();
			}
			else if (st == 1)
				state1();
			else if (st == 2) {
				if (FlxG.keys.justPressed("H"))
					st++;
				else if (FlxG.keys.justPressed("J")) {
					SFX.self.bep();
					st = 7;
				}
				else if (!FlxG.debug && FlxG.keys.justPressed("Q")) {
					SFX.self.bep();
					st = 10;
				}
				Game::NG_API {
					if (FlxG.debug && FlxG.keys.justPressed("F2")) {
						FlxG.log("Did connect to API? " + reg.apiConnected.toString());
						FlxG.log("Is connected to API? " + API.connected.toString());
					}
					else if (FlxG.debug && FlxG.keys.justPressed("F3")) {
						var medals:Vector.<String>;
						
						medals = new Vector.<String>();
						medals.push("Still alive");
						medals.push("But it was so pretty...");
						medals.push("Speedrunner");
						medals.push("Praise the RNG");
						medals.push("Treasure #1");
						medals.push("Treasure #2");
						medals.push("Treasure #3");
						medals.push("Treasure #4");
						medals.push("Treasure #5");
						medals.push("Gotta grab 'em all");
						medals.push("Completionist");
						medals.push("Can't touch this");
						medals.push("The chosen one");
						
						FlxG.log("Checking NG medals...");
						
						for each (var item:String in medals) {
							var medal:Medal;
							
							medal = API.getMedal(item);
							if (medal) {
								FlxG.log("Got medal \"" + item + "\"");
							}
							else {
								FlxG.log("Failed to get medal \"" + item + "\"");
							}
						}
					}
					else if (FlxG.debug && FlxG.keys.justPressed("F4")) {
						FlxG.log("Clearing local medals...");
						API.clearLocalMedals();
					}
					else if (FlxG.debug && FlxG.keys.justPressed("F5")) {
						FlxG.log("Erasing save...");
						saver.erase();
					}
				}
			}
			else if (st == 3) {
				help.alpha += FlxG.elapsed * 2;
				bg.alpha += FlxG.elapsed;
				if (help.alpha >= 1)
					st++;
			}
			else if (st == 4) {
				if (!FlxG.keys.any())
					st++;
			}
			else if (st == 5) {
				if (FlxG.keys.any())
					st = 6;
			}
			else if (st == 6) {
				help.alpha -= FlxG.elapsed * 2;
				bg.alpha -= FlxG.elapsed;
				if (help.alpha <= 0)
					st = 2;
			}
			else if (st == 7) {
				if (FlxG.keys.justPressed("K")) {
					st++;
					SFX.self.bep();
				}
				else if (FlxG.keys.any() && !FlxG.keys.J)
					st = 2;
			}
			else if (st == 8) {
				if (FlxG.keys.justPressed("K")) {
					st++;
					SFX.self.bep();
				}
				else if (FlxG.keys.any() && !FlxG.keys.K)
					st = 2;
			}
			else if (st == 9) {
				if (FlxG.keys.justPressed("L")) {
					st = 2;
					SFX.self.beeep();
					FlxG.camera.flash();
					saver.difficulty = saver.NOOB;
					
					Game::NG_API {
						API.logCustomEvent("Unlocked noob mode");
					}
				}
				else if (FlxG.keys.any() && !FlxG.keys.K)
					st = 2;
			}
			else if (st >= 10) {
				var str:String = "QETUOWRYIP";
				var curChar:int = st - 10 + 1;
				
				if (FlxG.keys.justPressed(str.charAt(curChar))) {
					st++;
					if (st == 10 + str.length - 1) {
						st = 2;
						SFX.self.beeep();
						FlxG.camera.flash();
						
						Main.addDebug();
						
						Game::NG_API {
							API.logCustomEvent("Enabled debug log");
						}
					}
					else {
						SFX.self.bep();
					}
				}
				else if (FlxG.keys.any() && !FlxG.keys.pressed(str.charAt(curChar - 1))) {
					st = 2;
				}
			}
			super.update();
		}
		
		public function textMenuCallback(tm:TextMenu):void {
			if (st != 2)
				return;
			if (tm.selected) {
				SFX.self.beeep();
				if (tm.currentOpt == NEWGAME) {
					tm.active = false;
					FlxG.fade(0xff000000, 1, function():void {
							Game::twitterIconEnabled {
								reg.twitter.kill();
							}
							reg.cleanParticles();
							FlxG.switchState(new NewIntrostate());
						});
				}
				else if (tm.currentOpt == CONTINUE) {
					tm.active = false;
					FlxG.fade(0xff000000, 1, function():void {
							Game::twitterIconEnabled {
								reg.twitter.kill();
							}
							reg.cleanParticles();
							FlxG.switchState(new NewPlaystate(false));
						});
				}
				else if (tm.currentOpt == EDITOR) {
					tm.active = false;
					FlxG.fade(0xff000000, 1, function():void {
							Game::twitterIconEnabled {
								reg.twitter.kill();
							}
							reg.cleanParticles();
							FlxG.switchState(new Teststate());
						});
				}
				else if (tm.currentOpt == MUSICBOX) {
					tm.active = false;
					reg.cleanParticles();
					FlxG.switchState(new Musicboxstate(animBG));
					remove(animBG);
				}
				else if (tm.currentOpt == OPTIONS) {
					tm.active = false;
					reg.cleanParticles();
					FlxG.switchState(new Optionstate(animBG));
					remove(animBG);
				}
				else if (tm.currentOpt == ACHIEVEMENTS) {
					tm.active = false;
					reg.cleanParticles();
					FlxG.switchState(new Achievementsstate(animBG));
					remove(animBG);
				}
			}
			else
				SFX.self.bep();
		}
		
		private function state0():void {
			var i:int = 0;
			while (i < arr.length && arr[i].alpha == 1) i++;
			if (i >= arr.length) {
				st++;
				return;
			}
			var s:FlxSprite = arr[i];
			if (s.alpha == 0)
				SFX.self.title();
			if (s.alpha < 0.5) {
				s.velocity.x = 25;
				if (i >= 2) {
					s.velocity.x = 14;
					s.velocity.y = 8;
				}
			}
			else {
				s.velocity.x = -25;
				if (i >= 2) {
					s.velocity.x = -14;
					s.velocity.y = -8;
				}
			}
			s.alpha += 2 * FlxG.elapsed;
			if (s.alpha >= 1)
				setTitlePosition(i);
		}
		
		private function state1():void {
			FlxG.flash(0xffffffff, 0.5);
			SFX.self.title_complete();
			
			var i:int = 0;
			while (i < arr.length)
				setTitlePosition(i++);
			
			var tm:TextMenu = new TextMenu(112, textMenuCallback);
			
			if (saver.hasSave)
				tm.addOption(new Option(CONTINUE, 8, 0xffedde8d, 0x88b48e6d));
			tm.addOption(new Option(NEWGAME, 8, 0xffedde8d, 0x88b48e6d));
			tm.addOption(new Option(OPTIONS, 8, 0xffedde8d, 0x88b48e6d));
			tm.addOption(new Option(MUSICBOX, 8, 0xffedde8d, 0x88b48e6d));
			tm.addOption(new Option(ACHIEVEMENTS, 8, 0xffedde8d, 0x88b48e6d));
			tm.addOption(new Option(EDITOR, 8, 0xffedde8d, 0x88b48e6d));
			
			add(tm);
			
			(add(new FlashingText(8, FlxG.height - 12, 160, "Press H for help")) as FlxText).setFormat(null, 8, 0xffedde8d, "left", 0x88b48e6d);
			(add(new FlxText(0, FlxG.height - 12, FlxG.width - 8, "Version: " + Game::version)) as FlxText).setFormat(null, 8, 0xffedde8d, "left", 0x88b48e6d).alignment = "right";
			
			bg = new FlxSprite();
			bg.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			bg.alpha = 0;
			
			help = new FlxText(16, 64, FlxG.width - 32, "There's a saying about a dungeon with many treasures... but way too many dangers, as well. Also, it seems that if the wrong treasure is gotten, it'll vanish as it's claimer leaves the place...\n\nKnowing that, explorer, will you go after that treasure? Follow your hunch and go after that one treasure that you believe is the right one, no matter how many rooms you have to go through.\n\nGood luck on your adventure.");
			help.setFormat(null, 8, 0xffedde8d, null, 0x88b48e6d);
			help.alpha = 0;
			
			add(bg);
			add(help);
			
			Game::twitterIconEnabled {
				reg.twitter.revive();
			}
			
			st++;
		}
		
		private function setTitlePosition(i:int):void {
			var X:Number = 35;
			var Y:Number = 15+8;
			var s:FlxSprite;
			
			s = arr[i];
			if (i == 0) {
				s.x = X;
				s.y = Y;
			}
			else if (i == 1) {
				s.x = X+70;
				s.y = Y;
			}
			else if (i == 2) {
				s.x = X+12;
				s.y = Y+20;
			}
			else if (i == 3) {
				s.x = X+66;
				s.y = Y+20;
			}
			else if (i == 4) {
				s.x = X+24;
				s.y = Y+40;
			}
			else if (i == 5) {
				s.x = X+36;
				s.y = Y+60;
			}
			else if (i == 6) {
				s.x = X+118;
				s.y = Y+60;
			}
			s.alpha = 1;
			s.velocity.x = 0;
			s.velocity.y = 0;
		}
	}
}
