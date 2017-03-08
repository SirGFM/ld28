package utils {
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class SFX {
		
		[Embed(source = "../../assets/sfx/songs/song01_eq-2.mp3")]		private var _song_1:Class;
		[Embed(source = "../../assets/sfx/songs/song02_eq.mp3")]		private var _song_2:Class;
		
		[Embed(source = "../../assets/sfx/button.mp3")]					private var _btSFX:Class;
		[Embed(source = "../../assets/sfx/climb.mp3")]					private var _climbSFX:Class;
		[Embed(source = "../../assets/sfx/explosion.mp3")]				private var _explosionSFX:Class;
		[Embed(source = "../../assets/sfx/fall.mp3")]					private var _fallSFX:Class;
		[Embed(source = "../../assets/sfx/hit1.mp3")]					private var _hitSFX:Class;
		[Embed(source = "../../assets/sfx/jump_ok.mp3")]				private var _jumpSFX:Class;
		[Embed(source="../../assets/sfx/lava.mp3")]						private var _lavaSFX:Class;
		[Embed(source = "../../assets/sfx/level_start.mp3")]			private var _levelSFX:Class;
		[Embed(source = "../../assets/sfx/platform2.mp3")]				private var _platSFX:Class;
		[Embed(source = "../../assets/sfx/spark1.mp3")]					private var _sparkSFX:Class;
		[Embed(source = "../../assets/sfx/walk.mp3")]					private var _walkSFX:Class;
		
		static public const self:SFX = new SFX();
		
		public var curSong:int = -1;
		public var sfxVol:Number = 0.8;
		private var rnd:Array = [0.25, 0.35, 0.45, 0.5, 0.65, 0.75, 0.8, 0.85];
		
		public function playSongFast():void {
			if (curSong == 1)
				return;
			curSong = 1;
			FlxG.playMusic(_song_1);
		}
		public function playSongSlow():void {
			if (curSong == 0)
				return;
			curSong = 0;
			FlxG.playMusic(_song_2);
		}
		
		public function button():void {
			FlxG.loadSound(_btSFX, sfxVol, false, false, true);
		}
		public function climb():void {
			FlxG.loadSound(_climbSFX, sfxVol, false, false, true);
		}
		public function explosion():void {
			FlxG.loadSound(_explosionSFX, sfxVol, false, false, true);
		}
		public function fall():void {
			FlxG.loadSound(_fallSFX, sfxVol, false, false, true);
		}
		public function hit():void {
			FlxG.loadSound(_hitSFX, sfxVol * Number(FlxG.getRandom(rnd)), false, false, true);
		}
		public function jump():void {
			FlxG.loadSound(_jumpSFX, sfxVol, false, false, true);
		}
		public function lava():void {
			FlxG.loadSound(_lavaSFX, sfxVol*0.75, false, false, true);
		}
		public function level_start():void {
			FlxG.loadSound(_levelSFX, sfxVol, false, false, true);
		}
		public function platform():void {
			FlxG.loadSound(_platSFX, sfxVol*0.75, false, false, true);
		}
		public function spark():void {
			FlxG.loadSound(_sparkSFX, sfxVol, false, false, true);
		}
		public function walk():void {
			FlxG.loadSound(_walkSFX, sfxVol * Number(FlxG.getRandom(rnd)), false, false, true);
		}
	}
}
