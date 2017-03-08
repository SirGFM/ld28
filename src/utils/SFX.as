package utils {
	
	import org.flixel.FlxG;
	import org.si.sion.SiONData;
	import org.si.sion.SiONDriver;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class SFX {
		
		[Embed(source = "../../assets/sfx/vmml/song-intro.txt", mimeType = "application/octet-stream")]		private var vmml_intro:Class;
		[Embed(source = "../../assets/sfx/vmml/song-begin.txt", mimeType = "application/octet-stream")]		private var vmml_begin:Class;
		[Embed(source = "../../assets/sfx/vmml/song-treasure.txt", mimeType = "application/octet-stream")]		private var vmml_treasure:Class;
		[Embed(source = "../../assets/sfx/vmml/song-getting-hard.txt", mimeType = "application/octet-stream")]		private var vmml_harder:Class;
		[Embed(source = "../../assets/sfx/vmml/song-last-sprint.txt", mimeType = "application/octet-stream")]		private var vmml_later:Class;
		[Embed(source = "../../assets/sfx/vmml/song-menu.txt", mimeType = "application/octet-stream")]		private var vmml_menu:Class;
		[Embed(source = "../../assets/sfx/vmml/song-bad-end.txt", mimeType = "application/octet-stream")]		private var vmml_badend:Class;
		[Embed(source = "../../assets/sfx/vmml/song-win.txt", mimeType = "application/octet-stream")]		private var vmml_win:Class;
		
		[Embed(source = "../../assets/sfx/button.mp3")]					private var _btSFX:Class;
		[Embed(source = "../../assets/sfx/climb.mp3")]					private var _climbSFX:Class;
		[Embed(source = "../../assets/sfx/fall.mp3")]					private var _fallSFX:Class;
		[Embed(source = "../../assets/sfx/hit1.mp3")]					private var _hitSFX:Class;
		[Embed(source = "../../assets/sfx/jump_ok.mp3")]				private var _jumpSFX:Class;
		[Embed(source="../../assets/sfx/lava.mp3")]						private var _lavaSFX:Class;
		[Embed(source = "../../assets/sfx/level_start.mp3")]			private var _levelSFX:Class;
		[Embed(source = "../../assets/sfx/platform2.mp3")]				private var _platSFX:Class;
		[Embed(source = "../../assets/sfx/spark1.mp3")]					private var _sparkSFX:Class;
		[Embed(source = "../../assets/sfx/walk.mp3")]					private var _walkSFX:Class;
		[Embed(source = "../../assets/sfx/treasure.mp3")]				private var _treasureSFX:Class;
		[Embed(source = "../../assets/sfx/gold.mp3")]				private var _goldSFX:Class;
		[Embed(source = "../../assets/sfx/beeep.mp3")]				private var _beeepSFX:Class;
		[Embed(source = "../../assets/sfx/bep.mp3")]				private var _bepSFX:Class;
		[Embed(source = "../../assets/sfx/bat.mp3")]				private var _batSFX:Class;
		[Embed(source = "../../assets/sfx/charge.mp3")]				private var _chargeSFX:Class;
		[Embed(source = "../../assets/sfx/title.mp3")]				private var _titleSFX:Class;
		[Embed(source = "../../assets/sfx/title-complete.mp3")]		private var _titleCompleteSFX:Class;
		
		static public const self:SFX = new SFX();
		
		private var driver:SiONDriver;
		private var song1:SiONData;
		private var song2:SiONData;
		private var song_intro:SiONData;
		private var song_begin:SiONData;
		private var song_treasure:SiONData;
		private var song_harder:SiONData;
		private var song_later:SiONData;
		private var song_menu:SiONData;
		private var song_badend:SiONData;
		private var song_win:SiONData;
		
		public var curSong:int = -1;
		public var songVol:Number = 1.0;
		public var sfxVol:Number = 0.8;
		private var rnd:Array = [0.25, 0.35, 0.45, 0.5, 0.65, 0.75, 0.8, 0.85];
		
		public function get playing():Boolean {
			Game::sfxEnabled {
				if (driver)
					return driver.isPlaying;
			}
			return false;
		}
		public function get finished():Boolean {
			Game::sfxEnabled {
				if (driver)
					return !driver.isPlaying;
			}
			return true;
		}
		public function set volume(val:Number):void {
			Game::sfxEnabled {
				if (driver)
					driver.volume = val * Saver.self.musicVolume;
				sfxVol = val * Saver.self.soundVolume;
			}
		}
		public function resumeMusic():void {
			Game::sfxEnabled {
				if (driver && driver.isPaused)
					driver.resume();
			}
		}
		public function stopMusic():void {
			Game::sfxEnabled {
				if (driver && driver.isPlaying)
					driver.stop();
			}
		}
		public function pauseMusic():void {
			Game::sfxEnabled {
				if (driver && driver.isPlaying)
					driver.pause();
			}
		}
		
		private function playSong(i:int, song:SiONData):void {
			Game::sfxEnabled {
				if (curSong == i)
					return;
				curSong = i;
				driver.play(song);
				driver.volume = FlxG.volume * Saver.self.musicVolume;
				if (FlxG.mute)
					driver.pause();
			}
		}
		
		public function playIntroSong():void {
			Game::sfxEnabled {
				playSong(0, song_intro);
				driver.autoStop = false;
			}
		}
		public function playBeginSong():void {
			Game::sfxEnabled {
				playSong(1, song_begin);
				driver.autoStop = false;
			}
		}
		public function playTreasureSong():void {
			Game::sfxEnabled {
				playSong(2, song_treasure);
				driver.autoStop = false;
			}
		}
		public function playHarderSong():void {
			Game::sfxEnabled {
				playSong(3, song_harder);
				driver.autoStop = false;
			}
		}
		public function playLaterSong():void {
			Game::sfxEnabled {
				playSong(4, song_later);
				driver.autoStop = false;
			}
		}
		public function playMenuSong():void {
			Game::sfxEnabled {
				playSong(5, song_menu);
				driver.autoStop = false;
			}
		}
		public function playBadendSong():void {
			Game::sfxEnabled {
				playSong(6, song_badend);
				driver.autoStop = true;
			}
		}
		public function playWinSong():void {
			Game::sfxEnabled {
				playSong(7, song_win);
				driver.autoStop = true;
			}
		}
		
		public function button():void {
			Game::sfxEnabled {
				FlxG.loadSound(_btSFX, sfxVol, false, false, true);
			}
		}
		public function climb():void {
			Game::sfxEnabled {
				FlxG.loadSound(_climbSFX, sfxVol, false, false, true);
			}
		}
		public function fall():void {
			Game::sfxEnabled {
				FlxG.loadSound(_fallSFX, sfxVol, false, false, true);
			}
		}
		public function hit():void {
			Game::sfxEnabled {
				FlxG.loadSound(_hitSFX, sfxVol * Number(FlxG.getRandom(rnd)), false, false, true);
			}
		}
		public function jump():void {
			Game::sfxEnabled {
				FlxG.loadSound(_jumpSFX, sfxVol, false, false, true);
			}
		}
		public function lava():void {
			Game::sfxEnabled {
				FlxG.loadSound(_lavaSFX, sfxVol * 0.66, false, false, true);
			}
		}
		public function level_start():void {
			Game::sfxEnabled {
				FlxG.loadSound(_levelSFX, sfxVol, false, false, true);
			}
		}
		public function platform():void {
			Game::sfxEnabled {
				FlxG.loadSound(_platSFX, sfxVol * 0.75 * 0.66, false, false, true);
			}
		}
		public function spark():void {
			Game::sfxEnabled {
				FlxG.loadSound(_sparkSFX, sfxVol * 0.66, false, false, true);
			}
		}
		public function walk():void {
			Game::sfxEnabled {
				FlxG.loadSound(_walkSFX, sfxVol * Number(FlxG.getRandom(rnd)), false, false, true);
			}
		}
		public function treasure():void {
			Game::sfxEnabled {
				FlxG.loadSound(_treasureSFX, sfxVol, false, false, true);
			}
		}
		public function gold():void {
			Game::sfxEnabled {
				FlxG.loadSound(_goldSFX, sfxVol, false, false, true);
			}
		}
		public function beeep():void {
			Game::sfxEnabled {
				FlxG.loadSound(_beeepSFX, sfxVol, false, false, true);
			}
		}
		public function bep():void {
			Game::sfxEnabled {
				FlxG.loadSound(_bepSFX, sfxVol, false, false, true);
			}
		}
		public function bat():void {
			Game::sfxEnabled {
				FlxG.loadSound(_batSFX, sfxVol, false, false, true);
			}
		}
		public function charge():void {
			Game::sfxEnabled {
				FlxG.loadSound(_chargeSFX, sfxVol, false, false, true);
			}
		}
		public function title():void {
			Game::sfxEnabled {
				FlxG.loadSound(_titleSFX, sfxVol, false, false, true);
			}
		}
		public function title_complete():void {
			Game::sfxEnabled {
				FlxG.loadSound(_titleCompleteSFX, sfxVol, false, false, true);
			}
		}
		
		public function init():void {
			Game::sfxEnabled {
				var tmp:String;
				var arr:Array;
				var buf:String;
				
				driver = new SiONDriver();
				driver.volume = songVol;
				
				// loads intro
				tmp = new vmml_intro;
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				song_intro = driver.compile(buf);
				// loads begin
				tmp = new vmml_begin;
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				song_begin = driver.compile(buf);
				// loads treasure
				tmp = new vmml_treasure;
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				song_treasure = driver.compile(buf);
				// loads getting harder
				tmp = new vmml_harder;
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				song_harder = driver.compile(buf);
				// loads last sprint
				tmp = new vmml_later;
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				song_later = driver.compile(buf);
				// loads menu
				tmp = new vmml_menu;
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				song_menu = driver.compile(buf);
				// loads bad end
				tmp = new vmml_badend;
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				song_badend = driver.compile(buf);
				// loads win
				tmp = new vmml_win
				buf = "";
				arr = tmp.split("\n");
				for each (tmp in arr) {
					if (tmp.indexOf("//") == 0)
						continue;
					buf += tmp;
				}
				song_win = driver.compile(buf);
			}
		}
	}
}
