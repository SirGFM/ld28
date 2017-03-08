package utils {
	import com.newgrounds.API;
	import flash.display.StageQuality;
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	import org.flixel.FlxU;
	import states.NewPlaystate;
	import states.Teststate;
	
	/**
	 * ...
	 * @author 
	 */
	public class Saver {
		
		static public const self:Saver = new Saver();
		
		public var _save:FlxSave;
		
		public var hasSave:Boolean;
		
		public var next:int;
		public var iniX:int;
		public var iniY:int;
		
		public var goldArr:Array;
		public var totalGold:int;
		public var maxGold:int;
		
		public var rundeath:int;
		public var totaldeath:int;
		
		public var runtime:uint;
		public var gametime:uint;
		public var totaltime:uint;
		private var lasttime:uint;
		
		public var quality:String;
		
		public var payArr:Array;
		public var curTreasure:int;
		public var goalTreasure:int;
		public var treasures:Array;
		
		Game::filterEnabled {
			public var filterVisibility:Boolean;
		}
		public var musicVolume:Number;
		public var soundVolume:Number;
		
		public var mostDeaths:int;
		public var fewestDeaths:int;
		public var slowestRun:uint;
		public var fastestRun:uint;
		public var gottenTreasures:Array;
		
		public const NOOB:int = 0;
		public const EASY:int = 1;
		public const NORMAL:int = 2;
		public const HARD:int = 3;
		public var difficulty:int;
		
		Game::NG_API {
			public var sessionTimeStats:Number;
			public var isNewGameStat:Boolean;
			
			public var medal_001_still_alive:Boolean;
			public var medal_002_but_it_was_so_pretty:Boolean;
			public var medal_003_speedrunner:Boolean;
			public var medal_004_praise_the_rng:Boolean;
			public var medal_005_collected_treasure_1:Boolean;
			public var medal_006_collected_treasure_2:Boolean;
			public var medal_007_collected_treasure_3:Boolean;
			public var medal_008_collected_treasure_4:Boolean;
			public var medal_009_collected_treasure_5:Boolean;
			public var medal_010_gotta_grab_em_all:Boolean;
			public var medal_011_completionist:Boolean;
			public var medal_012_cant_touch_this:Boolean;
			public var medal_013_the_chosen_one:Boolean;
		}
		
		public function Saver() {
			
		}
		
		public function init():void {
			_save = new FlxSave();
			_save.bind("gfm_save_ld28_pc");
			
			if (!_save.data.hasOwnProperty("hasSave"))
				_save.data.hasSave = false;
			
			if (!_save.data.hasOwnProperty("next"))
				_save.data.next = 0;
			if (!_save.data.hasOwnProperty("iniX"))
				_save.data.iniX = 0;
			if (!_save.data.hasOwnProperty("iniY"))
				_save.data.iniY = 0;
		
			if (!_save.data.hasOwnProperty("goldArr"))
				_save.data.goldArr = [];
			if (!_save.data.hasOwnProperty("totalGold"))
				_save.data.totalGold = 0;
			if (!_save.data.hasOwnProperty("maxGold"))
				_save.data.maxGold = 0;
			
			if (!_save.data.hasOwnProperty("rundeath"))
				_save.data.rundeath = 0;
			if (!_save.data.hasOwnProperty("totaldeath"))
				_save.data.totaldeath = 0;
			
			if (!_save.data.hasOwnProperty("runtime"))
				_save.data.runtime = 0;
			if (!_save.data.hasOwnProperty("gametime"))
				_save.data.gametime = 0;
			if (!_save.data.hasOwnProperty("totaltime"))
				_save.data.totaltime = 0;
			
			if (!_save.data.hasOwnProperty("quality"))
				_save.data.quality = StageQuality.MEDIUM;
			
			if (!_save.data.hasOwnProperty("payArr"))
				_save.data.payArr = [5, 8, 11, 14, 15];
			if (!_save.data.hasOwnProperty("treasures"))
				_save.data.treasures = [0, 1, 2, 3, 4];
			if (!_save.data.hasOwnProperty("curTreasure"))
				_save.data.curTreasure = -1;
			if (!_save.data.hasOwnProperty("goalTreasure"))
				_save.data.goalTreasure = -1;
			
			Game::filterEnabled {
				if (!_save.data.hasOwnProperty("filterVisibility"))
					_save.data.filterVisibility = true;
			}
			if (!_save.data.hasOwnProperty("musicVolume"))
				_save.data.musicVolume = 1.0;
			if (!_save.data.hasOwnProperty("soundVolume"))
				_save.data.soundVolume = 0.8;
			
			if (!_save.data.hasOwnProperty("mostDeaths"))
				_save.data.mostDeaths = -1;
			if (!_save.data.hasOwnProperty("fewestDeaths"))
				_save.data.fewestDeaths = 0x7fffffff;
			if (!_save.data.hasOwnProperty("slowestRun"))
				_save.data.slowestRun = 0;
			if (!_save.data.hasOwnProperty("fastestRun"))
				_save.data.fastestRun = 0xffffffff;
			if (!_save.data.hasOwnProperty("gottenTreasures"))
				_save.data.gottenTreasures = [];
			
			if (!_save.data.hasOwnProperty("difficulty"))
				_save.data.difficulty = HARD;
			
			Game::NG_API {
				if (!_save.data.hasOwnProperty("medal_001_still_alive")) {
					_save.data.medal_001_still_alive = false;
				}
				if (!_save.data.hasOwnProperty("medal_002_but_it_was_so_pretty")) {
					_save.data.medal_002_but_it_was_so_pretty = false;
				}
				if (!_save.data.hasOwnProperty("medal_003_speedrunner")) {
					_save.data.medal_003_speedrunner = false;
				}
				if (!_save.data.hasOwnProperty("medal_004_praise_the_rng")) {
					_save.data.medal_004_praise_the_rng = false;
				}
				if (!_save.data.hasOwnProperty("medal_005_collected_treasure_1")) {
					_save.data.medal_005_collected_treasure_1 = false;
				}
				if (!_save.data.hasOwnProperty("medal_006_collected_treasure_2")) {
					_save.data.medal_006_collected_treasure_2 = false;
				}
				if (!_save.data.hasOwnProperty("medal_007_collected_treasure_3")) {
					_save.data.medal_007_collected_treasure_3 = false;
				}
				if (!_save.data.hasOwnProperty("medal_008_collected_treasure_4")) {
					_save.data.medal_008_collected_treasure_4 = false;
				}
				if (!_save.data.hasOwnProperty("medal_009_collected_treasure_5")) {
					_save.data.medal_009_collected_treasure_5 = false;
				}
				if (!_save.data.hasOwnProperty("medal_010_gotta_grab_em_all")) {
					_save.data.medal_010_gotta_grab_em_all = false;
				}
				if (!_save.data.hasOwnProperty("medal_011_completionist")) {
					_save.data.medal_011_completionist = false;
				}
				if (!_save.data.hasOwnProperty("medal_012_cant_touch_this")) {
					_save.data.medal_012_cant_touch_this = false;
				}
				if (!_save.data.hasOwnProperty("medal_013_the_chosen_one")) {
					_save.data.medal_013_the_chosen_one = false;
				}
			}
			
			hasSave = _save.data.hasSave;
			
			next = _save.data.next;
			iniX = _save.data.iniX;
			iniY = _save.data.iniY;
			
			goldArr = [];
			cloneArr(_save.data.goldArr, goldArr);
			totalGold = _save.data.totalGold;
			maxGold = _save.data.maxGold;
			
			rundeath = _save.data.rundeath;
			totaldeath = _save.data.totaldeath;
			
			quality = _save.data.quality;
			saveQuality();
			
			payArr = [];
			cloneArr(_save.data.payArr, payArr);
			treasures = [];
			cloneArr(_save.data.treasures, treasures);
			curTreasure = _save.data.treasure;
			goalTreasure = _save.data.goalTreasure;
			
			mostDeaths = _save.data.mostDeaths;
			fewestDeaths = _save.data.fewestDeaths;
			slowestRun = _save.data.slowestRun;
			fastestRun = _save.data.fastestRun;
			gottenTreasures = [];
			cloneArr(_save.data.gottenTreasures, gottenTreasures);
			
			difficulty = _save.data.difficulty;
			
			Game::filterEnabled {
				filterVisibility = _save.data.filterVisibility;
				Registry.self.filterVisibility = filterVisibility;
			}
			musicVolume = _save.data.musicVolume;
			soundVolume = _save.data.soundVolume;
			SFX.self.volume = FlxG.volume;
			
			totaltime = _save.data.totaltime + FlxU.getTicks();
			_save.data.totaltime = totaltime;
			
			Game::NG_API {
				medal_001_still_alive = _save.data.medal_001_still_alive;
				medal_002_but_it_was_so_pretty = _save.data.medal_002_but_it_was_so_pretty;
				medal_003_speedrunner = _save.data.medal_003_speedrunner;
				medal_004_praise_the_rng = _save.data.medal_004_praise_the_rng;
				medal_005_collected_treasure_1 = _save.data.medal_005_collected_treasure_1;
				medal_006_collected_treasure_2 = _save.data.medal_006_collected_treasure_2;
				medal_007_collected_treasure_3 = _save.data.medal_007_collected_treasure_3;
				medal_008_collected_treasure_4 = _save.data.medal_008_collected_treasure_4;
				medal_009_collected_treasure_5 = _save.data.medal_009_collected_treasure_5;
				medal_010_gotta_grab_em_all = _save.data.medal_010_gotta_grab_em_all;
				medal_011_completionist = _save.data.medal_011_completionist;
				medal_012_cant_touch_this = _save.data.medal_012_cant_touch_this;
				medal_013_the_chosen_one = _save.data.medal_013_the_chosen_one;
			}
			
			_save.flush();
		}
		
		public function saveQuality():void {
			if (quality != FlxG.stage.quality.toLowerCase()) {
				quality = FlxG.stage.quality.toLowerCase();
				Registry.self.setQuality();
				_save.data.quality = quality;
			}
		}
		
		public function saveTime():void {
			var ct:uint = FlxU.getTicks();
			var dt:uint = ct - lasttime;
			
			if ((FlxG.state is NewPlaystate) && !(FlxG.state is Teststate)) {
				runtime += dt;
				gametime += dt;
				
				_save.data.runtime = runtime;
				_save.data.gametime = gametime;
				
				Game::NG_API {
					if (sessionTimeStats < 60000 && sessionTimeStats + dt >= 60000) {
						API.logCustomEvent("1 minute session");
					}
					else if (sessionTimeStats < 300000 && sessionTimeStats + dt >= 300000) {
						API.logCustomEvent("5 minutes session");
					}
					else if (sessionTimeStats < 600000 && sessionTimeStats + dt >= 600000) {
						API.logCustomEvent("10 minutes session");
					}
					else if (sessionTimeStats < 1200000 && sessionTimeStats + dt >= 1200000) {
						API.logCustomEvent("20 minutes session");
					}
					else if (sessionTimeStats < 1800000 && sessionTimeStats + dt >= 1800000) {
						API.logCustomEvent("20 minutes session");
					}
					else if (sessionTimeStats < 3600000 && sessionTimeStats + dt >= 3600000) {
						API.logCustomEvent("60 minutes session");
					}
					
					sessionTimeStats += dt;
				}
			}
			totaltime += dt;
			lasttime = ct;
			
			_save.data.totaltime = totaltime;
		}
		
		public function finalSave():void {
			if (rundeath > mostDeaths || mostDeaths == -1)
				mostDeaths = rundeath;
			if (rundeath < fewestDeaths || fewestDeaths == 0x7fffffff)
				fewestDeaths = rundeath;
			
			if (runtime > slowestRun || slowestRun == 0)
				slowestRun = runtime;
			if (runtime < fastestRun || fastestRun == 0)
				fastestRun = runtime;
			
			Game::NG_API {
				if (isNewGameStat) {
					API.logCustomEvent("Finished in a single run");
				}
				else {
					API.logCustomEvent("Finished in some runs");
				}
				
				if (gottenTreasures.length >= 5) {
					API.logCustomEvent("kept playing"); /* After getting all treasures */
				}
			}
			
			if (curTreasure == goalTreasure && gottenTreasures.indexOf(curTreasure) < 0)
				gottenTreasures.push(curTreasure);
			
			hasSave = false;
			save();
		}
		
		public function save():void {
			saveTime();
			
			_save.data.hasSave = hasSave;
			
			_save.data.next = next;
			_save.data.iniX = iniX;
			_save.data.iniY = iniY;
			
			cloneArr(payArr, _save.data.payArr);
			cloneArr(goldArr, _save.data.goldArr);
			_save.data.totalGold = totalGold;
			if (totalGold > maxGold) {
				maxGold = totalGold;
				_save.data.maxGold = maxGold;
			}
			
			_save.data.rundeath = rundeath;
			_save.data.totaldeath = totaldeath;
			
			saveQuality();
			
			cloneArr(treasures, _save.data.treasures);
			_save.data.curTreasure = curTreasure;
			_save.data.goalTreasure = goalTreasure;
			
			_save.data.mostDeaths = mostDeaths;
			_save.data.fewestDeaths = fewestDeaths;
			_save.data.slowestRun = slowestRun;
			_save.data.fastestRun = fastestRun;
			cloneArr(gottenTreasures, _save.data.gottenTreasures);
			
			Game::filterEnabled {
				_save.data.filterVisibility = filterVisibility;
			}
			_save.data.musicVolume = musicVolume;
			_save.data.soundVolume = soundVolume;
			
			_save.data.difficulty = difficulty;
			
			Game::NG_API {
				_save.data.medal_001_still_alive = medal_001_still_alive;
				_save.data.medal_002_but_it_was_so_pretty = medal_002_but_it_was_so_pretty;
				_save.data.medal_003_speedrunner = medal_003_speedrunner;
				_save.data.medal_004_praise_the_rng = medal_004_praise_the_rng;
				_save.data.medal_005_collected_treasure_1 = medal_005_collected_treasure_1;
				_save.data.medal_006_collected_treasure_2 = medal_006_collected_treasure_2;
				_save.data.medal_007_collected_treasure_3 = medal_007_collected_treasure_3;
				_save.data.medal_008_collected_treasure_4 = medal_008_collected_treasure_4;
				_save.data.medal_009_collected_treasure_5 = medal_009_collected_treasure_5;
				_save.data.medal_010_gotta_grab_em_all = medal_010_gotta_grab_em_all;
				_save.data.medal_011_completionist = medal_011_completionist;
				_save.data.medal_012_cant_touch_this = medal_012_cant_touch_this;
				_save.data.medal_013_the_chosen_one = medal_013_the_chosen_one;
			}
		}
		
		public function load():void {
			hasSave = _save.data.hasSave;
			
			next = _save.data.next;
			iniX = _save.data.iniX;
			iniY = _save.data.iniY;
			
			cloneArr(_save.data.goldArr, goldArr);
			totalGold = _save.data.totalGold;
			maxGold = _save.data.maxGold;
			
			rundeath = _save.data.rundeath;
			totaldeath = _save.data.totaldeath;
			
			runtime = _save.data.runtime;
			gametime = _save.data.gametime;
			
			cloneArr(_save.data.payArr, payArr);
			cloneArr(_save.data.treasures, treasures);
			curTreasure = _save.data.curTreasure;
			goalTreasure = _save.data.goalTreasure;
			
			difficulty = _save.data.difficulty;
			
			mostDeaths = _save.data.mostDeaths;
			fewestDeaths = _save.data.fewestDeaths;
			slowestRun = _save.data.slowestRun;
			fastestRun = _save.data.fastestRun;
			cloneArr(_save.data.gottenTreasures, gottenTreasures);
			
			Game::filterEnabled {
				filterVisibility = _save.data.filterVisibility;
				Registry.self.filterVisibility = filterVisibility;
			}
			musicVolume = _save.data.musicVolume;
			soundVolume = _save.data.soundVolume;
			SFX.self.volume = FlxG.volume;
			
			Game::NG_API {
				sessionTimeStats = 0;
				isNewGameStat = false;
				
				medal_001_still_alive = _save.data.medal_001_still_alive;
				medal_002_but_it_was_so_pretty = _save.data.medal_002_but_it_was_so_pretty;
				medal_003_speedrunner = _save.data.medal_003_speedrunner;
				medal_004_praise_the_rng = _save.data.medal_004_praise_the_rng;
				medal_005_collected_treasure_1 = _save.data.medal_005_collected_treasure_1;
				medal_006_collected_treasure_2 = _save.data.medal_006_collected_treasure_2;
				medal_007_collected_treasure_3 = _save.data.medal_007_collected_treasure_3;
				medal_008_collected_treasure_4 = _save.data.medal_008_collected_treasure_4;
				medal_009_collected_treasure_5 = _save.data.medal_009_collected_treasure_5;
				medal_010_gotta_grab_em_all = _save.data.medal_010_gotta_grab_em_all;
				medal_011_completionist = _save.data.medal_011_completionist;
				medal_012_cant_touch_this = _save.data.medal_012_cant_touch_this;
				medal_013_the_chosen_one = _save.data.medal_013_the_chosen_one;
			}
			
		}
		
		public function clear():void {
			next = 0;
			iniX = 0;
			iniY = 13*16;
			
			goldArr = [];
			totalGold = 0;
			
			rundeath = 0;
			
			runtime = 0;
			
			treasures = [];
			payArr = [];
			var rnd:Array = [0, 1, 2, 3, 4];
			while (rnd.length > 0) {
				var item:int = FlxG.getRandom(rnd) as int;
				treasures.push(item);
				removeItem(rnd, item);
			}
			while (payArr.length < treasures.length) {
				var i:int =  6 + int(FlxG.random() * 100 % payArr.length*2);
				if (i <= 15 && payArr.indexOf(i) < 0)
					payArr.push(i);
			}
			curTreasure = -1;
			
			Game::NG_API {
				sessionTimeStats = 0;
				isNewGameStat = true;
			}
		}
		
		public function removeItem(arr:Array, item:int):void {
			var i:int = 0;
			var l:int = arr.length;
			while (i < l) {
				var tmp:int = arr.shift();
				if (tmp != item)
					arr.push(tmp);
				i++
			}
		}
		public function cloneArr(from:Array, to:Array):void {
			var i:int = 0;
			while (i < from.length && i < to.length) {
				to[i] = from[i];
				i++;
			}
			while (i < from.length) {
				to.push(from[i]);
				i++;
			}
			while (to.length > from.length)
				to.pop();
		}
		
		public function erase():void {
			_save.erase();
			_save.flush();
			//_save = null;
		}
		
		public function uploadAchievements(isEndState:Boolean = false):Boolean {
			var reg:Registry = Registry.self;
			
			if (!reg.apiConnected) {
				return false;
			}
			
			Game::NG_API {
				if (isEndState) {
					if (curTreasure != goalTreasure) {
						medal_002_but_it_was_so_pretty = true;
					}
					
					if (curTreasure == goalTreasure && runtime <= 210000) {
						medal_004_praise_the_rng = true;
					}
					
					if (curTreasure == goalTreasure) {
						switch (curTreasure) {
							case 0: medal_005_collected_treasure_1 = true; break;
							case 1: medal_006_collected_treasure_2 = true; break;
							case 2: medal_007_collected_treasure_3 = true; break;
							case 3: medal_008_collected_treasure_4 = true; break;
							case 4: medal_009_collected_treasure_5 = true; break;
						}
					}
					
					if (rundeath == 0) {
						medal_012_cant_touch_this = true;
					}
					
					if (curTreasure == goalTreasure && rundeath == 0) {
						medal_013_the_chosen_one = true;
					}
				}
				
				if (isEndState || mostDeaths != -1) {
					medal_001_still_alive = true;
				}
				
				if (fastestRun <= 210000 || (isEndState && runtime <= 210000)) {
					medal_003_speedrunner = true;
				}
				
				if (gottenTreasures && gottenTreasures.length > 0) {
					var arr:Array = gottenTreasures;
					var i:int = 0;
					var l:int = arr.length;
					
					while (i < l) {
						var ts:int = arr[i];
						
						switch (ts) {
							case 0: medal_005_collected_treasure_1 = true; break;
							case 1: medal_006_collected_treasure_2 = true; break;
							case 2: medal_007_collected_treasure_3 = true; break;
							case 3: medal_008_collected_treasure_4 = true; break;
							case 4: medal_009_collected_treasure_5 = true; break;
						}
						
						i++;
					}
				}
				
				if (gottenTreasures && gottenTreasures.length >= 5) {
					medal_010_gotta_grab_em_all = true;
				}
				
				if (fewestDeaths == 0) {
					medal_012_cant_touch_this = true;
				}
				
				if (gottenTreasures && gottenTreasures.length >= 5 &&
						maxGold == 15) {
					medal_011_completionist = true;
				}
				
				// Actually upload everything
				if (medal_001_still_alive) {
					API.unlockMedal("Still alive");
				}
				if (medal_002_but_it_was_so_pretty) {
					API.unlockMedal("But it was so pretty...");
				}
				if (medal_003_speedrunner) {
					API.unlockMedal("Speedrunner");
				}
				if (medal_004_praise_the_rng) {
					API.unlockMedal("Praise the RNG");
				}
				if (medal_005_collected_treasure_1) {
					API.unlockMedal("Treasure #1"); 
				}
				if (medal_006_collected_treasure_2) {
					API.unlockMedal("Treasure #2"); 
				}
				if (medal_007_collected_treasure_3) {
					API.unlockMedal("Treasure #3"); 
				}
				if (medal_008_collected_treasure_4) {
					API.unlockMedal("Treasure #4"); 
				}
				if (medal_009_collected_treasure_5) {
					API.unlockMedal("Treasure #5"); 
				}
				if (medal_010_gotta_grab_em_all) {
					API.unlockMedal("Gotta grab 'em all");
				}
				if (medal_011_completionist) {
					API.unlockMedal("Completionist");
				}
				if (medal_012_cant_touch_this) {
					API.unlockMedal("Can't touch this");
				}
				if (medal_013_the_chosen_one) {
					API.unlockMedal("The chosen one");
				}
				
				// Make sure the stats are saved and nothing bad happens
				save();
			}
			
			return true;
		}
	}
}
