package utils {
	import editor.MainWindow;
	import flash.display.Bitmap;
	import flash.display.StageQuality;
	import objs.Hero;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxSave;
	import plugins.CamRecorder;
	import plugins.DeathCounter;
	import plugins.FullScreen;
	import plugins.GoldCounter;
	import plugins.MuteIcon;
	import plugins.Pause;
	import plugins.Reset;
	import plugins.TimeStore;
	import plugins.Transition;
	import plugins.TreasureGet;
	import plugins.TwitterIcon;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Registry {
		
		private const saver:Saver = Saver.self;
		static public const self:Registry = new Registry();
		
		public var editor:MainWindow;
		
		Game::filterEnabled {
			public var filter:Bitmap;
			private var _filterVisibility:Boolean;
		}
		
		public var apiConnected:Boolean = false;
		
		public var player:Hero;
		public var lavaEmitter:FlxEmitter;
		public var cloudEmitter:FlxEmitter;
		public var onHitEmitter:FlxEmitter;
		public var kirakiraEmitter:FlxEmitter;
		
		public var resetReq:Boolean;
		public var animatedTilemap:Boolean = false;
		public var lastLevel:Boolean;
		
		public var reset:Reset;
		public var fullscreen:FullScreen;
		public var transition:Transition;
		public var goldCounter:GoldCounter;
		public var deathCounter:DeathCounter;
		public var timeStore:TimeStore;
		public var treasureGet:TreasureGet;
		public var twitter:TwitterIcon;
		
		private var _didInitPart:Boolean = false;
		private var _quality:uint = 0xffffffff;
		private var _partEnabled:Boolean = true;
		private var _partQnt:int = 8;
		private var _partRND:int = 15;
		public var maxCloud:int = 32;
		public var maxLava:int = 64;
		
		public function get quality():uint {
			return _quality;
		}
		public function get particlesEnabled():Boolean {
			return _partEnabled;
		}
		public function get particlesQuantity():int {
			return _partQnt;
		}
		public function get particlesRandom():int {
			return _partRND;
		}
		
		public function initPlugins():void {
			reset = (FlxG.addPlugin(new Reset()) as Reset);
			Game::fullscreenEnabled {
				fullscreen = (FlxG.addPlugin(new FullScreen()) as FullScreen);
			}
			transition = (FlxG.addPlugin(new Transition()) as Transition);
			goldCounter = (FlxG.addPlugin(new GoldCounter()) as GoldCounter);
			deathCounter = (FlxG.addPlugin(new DeathCounter()) as DeathCounter);
			timeStore = (FlxG.addPlugin(new TimeStore(false)) as TimeStore);
			treasureGet = (FlxG.addPlugin(new TreasureGet()) as TreasureGet);
			
			Game::twitterIconEnabled {
				twitter = new TwitterIcon();
				FlxG.addPlugin(twitter);
			}
			
			Game::muteIconEnabled {
				FlxG.addPlugin(new MuteIcon());
			}
			FlxG.addPlugin(new Pause());
			Game::camRecorderEnabled {
				FlxG.addPlugin(new CamRecorder());
			}
			
			SFX.self.init();
		}
		
		public function setQuality():void {
			var val:String = saver.quality;
			var q:uint = 0;
			
			if (val == StageQuality.LOW.toLowerCase())
				q = 1;
			else if (val == StageQuality.MEDIUM.toLowerCase())
				q = 2;
			else if (val == StageQuality.HIGH.toLowerCase())
				q = 3;
			else
				return;
			
			if (q == _quality)
				return;
			_quality = q;
			
			if (q == 1) {
				_partEnabled = false;
				FlxG.framerate = 30;
				FlxG.flashFramerate = 30;
			}
			else if (q == 2) {
				_partEnabled = true;
				_partQnt = 8;
				_partRND = 15;
				if (cloudEmitter) {
					maxCloud = 32
					cloudEmitter.length = maxCloud;
					cloudEmitter._maxSize = maxCloud;
				}
				else {
					maxCloud = 32
				}
				if (lavaEmitter) {
					maxLava = 64;
					lavaEmitter.length = maxLava;
					lavaEmitter._maxSize = maxLava;
				}
				else {
					maxLava = 64;
				}
				FlxG.framerate = 60;
				FlxG.flashFramerate = 30;
			}
			else if (q == 3) {
				_partEnabled = true;
				_partQnt = 24;
				_partRND = 32;
				if (cloudEmitter) {
					maxCloud = 64;
					cloudEmitter.length = maxCloud;
					cloudEmitter._maxSize = maxCloud;
				}
				else {
					maxCloud = 64
				}
				if (lavaEmitter) {
					maxLava = 128;
					lavaEmitter.length = maxLava;
					lavaEmitter._maxSize = maxLava;
				}
				else {
					maxLava = 128;
				}
				// NOTE changed framerate to 90
				FlxG.framerate = 90;
				FlxG.flashFramerate = 60;
			}
		}
		
		Game::filterEnabled {
			public function set filterVisibility(val:Boolean):void {
				_filterVisibility = val;
				if (filter)
					filter.visible = val;
			}
			public function get filterVisibility():Boolean {
				return _filterVisibility;
			}
		}
		
		public function initParticles():void {
			if (_didInitPart)
				return;
			var em:FlxEmitter = new FlxEmitter();
			lavaEmitter = em;
			GFX.self.lava(em);
			
			em = new FlxEmitter();
			onHitEmitter = em;
			GFX.self.onHit(em);
			
			em = new FlxEmitter();
			cloudEmitter = em;
			GFX.self.cloud(em);
			
			em = new FlxEmitter();
			kirakiraEmitter = em;
			GFX.self.kirakira(em);
			
			_didInitPart = true;
			em = null;
		}
		public function doParticles():void {
			if (_partEnabled) {
				lavaEmitter.update();
				cloudEmitter.update();
				onHitEmitter.update();
				kirakiraEmitter.update();
			}
		}
		public function drawParticles():void {
			if (_partEnabled) {
				lavaEmitter.draw();
				cloudEmitter.draw();
				onHitEmitter.draw();
				kirakiraEmitter.draw();
			}
		}
		public function cleanParticles():void {
			lavaEmitter.kill();
			lavaEmitter.revive();
			cloudEmitter.kill();
			cloudEmitter.revive();
			onHitEmitter.kill();
			onHitEmitter.revive();
			kirakiraEmitter.kill();
			kirakiraEmitter.revive();
		}
		
		public function resetEmitters():void {
			cloudEmitter.length = 64;
			cloudEmitter._maxSize = 64;
			lavaEmitter.length = 128;
			lavaEmitter._maxSize = 128;
		}
		
		public function resetCloudEmitter():void {
			cloudEmitter.setXSpeed( -20, 20);
			cloudEmitter.setYSpeed( -20, 20);
		}
	}
}
