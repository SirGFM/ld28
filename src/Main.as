package {
	
	import com.newgrounds.APIEvent;
	import com.newgrounds.Medal;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import org.flixel.FlxSave;
	import org.flixel.FlxU;
	import states.Menustate;
	import states.Musicboxstate;
	import states.NewEndstate;
	import states.NewPlaystate;
	import states.Teststate;
	import utils.Registry;
	import utils.Saver;
	import utils.SFX;
	
	Game::NG_API {
		import com.newgrounds.API;
		import com.newgrounds.components.MedalPopup;
	}
	
	Game::logoEnabled {
		import com.wordpress.gfmgamecorner.LogoGFM;
	}
	
	// Game link:
	// https://dl.dropboxusercontent.com/u/55733901/LD48/ld28/gfm_ld28.html
	
	[SWF(width="640",height="480",backgroundColor="0x000000")]
	[Frame(factoryClass="Preloader")]
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Main extends FlxGame {
		
		public static var self:Main;
		
		private const reg:Registry = Registry.self;
		private const sfx:SFX = SFX.self;
		
		Game::logoEnabled {
			private var logo:LogoGFM;
		}
		Game::filterEnabled {
			private var bm:Bitmap;
		}
		Game::NG_API {
			private var medalPopup:MedalPopup;
			private var failureCount:uint;
		}
		
		private var fxWasActive:Boolean;
		private var __stageWidth:int;
		private var __stageHeight:int;
		
		public function Main():void {
			Game::debug {
				forceDebugger = true;
				FlxG.debug = true;
			}
			
			super(320, 240, Menustate, 2, 60, 30, true);
			//super(320, 240, NewEndstate, 2, 60, 30, true);
			//super(320, 240, Musicboxstate, 2, 60, 30, true);
			
			fxWasActive = false;
			
			Game::filterEnabled {
				bm = null;
			}
			Game::logoEnabled {
				logo = new LogoGFM(true);
				logo.scaleX = 2;
				logo.scaleY = 2;
				logo.x = (640 - logo.width) / 2;
				logo.y = (480 - logo.height) / 2;
				addChild(logo);
			}
			
			Main.self = this;
		}
		
		override protected function create(FlashEvent:Event):void {
			Game::logoEnabled {
				if (logo) {
					if (logo.visible)
						return;
					else {
						removeChild(logo);
						logo.destroy();
						logo = null;
					}
				}
			}
			
			super.create(FlashEvent);
			
			stage.addEventListener(Event.RESIZE, onResize);
			
			Game::filterEnabled {
				addEventListener(Event.EXIT_FRAME, addFilter, false, -1);
			}
			
			/**
			saver.next = 23;
			saver.iniX = 0*16;
			saver.iniY = 13*16;
			/**/
			
			Game::NG_API {
				Game::release {
					API.debugMode = API.RELEASE_MODE;
				}
				Game::debug {
					API.debugMode = API.DEBUG_MODE_LOGGED_IN;
				}
				failureCount = 0;
				API.addEventListener(APIEvent.API_CONNECTED, NGAPI_onConnected);
				//=================================================================================
				// -- TODO -- Add NewGround API ID and key (which mustn't be commited)
				API.connect(root, "api-id", "enc-key");
				//=================================================================================
			}
			
			Saver.self.init();
			reg.initPlugins();
		}
		
		Game::NG_API {
			private function NGAPI_onConnected(e:APIEvent):void {
				if (e.success) {
					reg.apiConnected = true;
					
					medalPopup = new MedalPopup();
					addChild(medalPopup);
					
					FlxG.log("Connected successfully!");
					
					API.addEventListener(APIEvent.MEDAL_UNLOCKED, NGAPI_onMedal);
				}
				else {
					FlxG.log("Failed to connect!");
					FlxG.log(e.error);
					
					failureCount++;
					addEventListener(Event.ENTER_FRAME, NGAPI_retryConnect, false, -1);
				}
			}
			
			private function NGAPI_retryConnect(e:Event):void {
				removeEventListener(Event.ENTER_FRAME, NGAPI_retryConnect);
				
				//=================================================================================
				// -- TODO -- Add NewGround API ID and key (which mustn't be commited)
				API.connect(root, "api-id", "enc-key");
				//=================================================================================
				
				FlxG.log("Retrying to connected for the " + failureCount.toString() + " time...");
			}
			
			private function NGAPI_onMedal(e:APIEvent):void {
				if (e.success) {
					var medal:Medal;
					
					medal = Medal(e.data);
					FlxG.log("Unlocked medal \"" + medal.name +"\" successfully!");
				}
				else {
					FlxG.log("Failed to unlock a medal!");
					FlxG.log(e.error);
				}
			}
		}
		
		public static function addDebug():void {
			Main.self.gameAddDebug();
		}
		
		Game::filterEnabled {
			private function addFilter(e:Event):void {
				if (!FlxG.camera)
					return;
				if (hasEventListener(Event.EXIT_FRAME))
					removeEventListener(Event.EXIT_FRAME, addFilter);
				
				var z:int = FlxCamera.defaultZoom;
				var w:int = FlxG.width * z;
				var h:int = FlxG.height * z;
				
				var i:int = 0;
				var bmd:BitmapData = new BitmapData(w, h, true, 0);
				var vec:Vector.<uint> = bmd.getVector(bmd.rect);
				
				if (!bm)
					bm = new Bitmap(bmd);
				else {
					bm.bitmapData.dispose();
					bm.bitmapData = bmd;
				}
				
				/**
				var halfW:int = w / 2;
				var halfH:int = h / 2;
				var j:int = 0;
				while (j < h) {
					var alphaY:Number = FlxU.abs(halfH - j) / halfH;
					if (alphaY < halfH / 2)
						alphaY *= 0.75;
					alphaY *= alphaY;
					i = 0;
					while (i < w) {
						var alphaX:Number = FlxU.abs(halfW - i) / halfW;
						if (alphaX < halfW / 2)
							alphaX *= 0.75;
						var color:uint = FlxU.min((Math.sqrt(alphaX*alphaX + alphaY) * 0.8 + 0.15), 1.0) * 0xff;
						if (j % 2 == 1)
							color *= 3 / 4;
						color = (color * 0x1000000) + 0x000000;
						vec[j * w + i] = color;
						i++;
					}
					j++;
				}
				/**/
				//a5f3f4
				//803f39
				const dark:uint =		0x6b803f39;//0x33000000 // 41%
				const middark:uint =	0x3f803f39;//0x22000000 // 24%
				const darkmid:uint =	0x19803f39;//0x22000000 // 9%
				const mid:uint =		0x00000000;//0x11000000 // 
				const lightmid:uint =	0x19a5f3f4;//0x11000000 // 9%
				const midlight:uint =	0x3fa5f3f4;//0x11000000 // 24%
				const light:uint =		0x6ba5f3f4;//0x11000000 // 41%
				
				while (i < 320) {
					var j:int = 0;
					var x:int = i * z;
					while (j < 240) {
						var y:int = j * z * w;
						if (z == 2) {
							vec[x+y]=darkmid;	vec[x+1+y]=light;
							vec[x+y+w]=dark;	vec[x+1+y+w]=lightmid;
						}
						else if (z == 3) {
							vec[x+y]=darkmid;	vec[x+1+y]=midlight;	vec[x+2+y]  =light;
							vec[x+y+w]=middark;	vec[x+1+y+w]=mid;		vec[x+2+y+w]=midlight;
							vec[x+y+2*w]=dark;	vec[x+1+y+2*w]=middark;	vec[x+2+y+2*w]=lightmid;
						}
						else if (z == 4) {
							vec[x+y]=darkmid;		vec[x+1+y]=lightmid;	vec[x+2+y]=midlight;	vec[x+3+y]=light;
							vec[x+y+w]=darkmid;		vec[x+1+y+w]=mid;		vec[x+2+y+w]=lightmid;	vec[x+3+y+w]=midlight;
							vec[x+y+2*w]=middark;	vec[x+1+y+2*w]=darkmid;	vec[x+2+y+2*w]=mid;		vec[x+3+y+2*w]=lightmid;
							vec[x+y+3*w]=dark;		vec[x+1+y+3*w]=middark;	vec[x+2+y+3*w]=darkmid;	vec[x+3+y+3*w]=darkmid;
						}
						j++;
					}
					i++;
				}
				/**/
				
				bmd.setVector(bmd.rect, vec);
				//bm.blendMode = BlendMode.ADD;		  	// my eyes!! it's too bright!!
				//bm.blendMode = BlendMode.ALPHA;	  	// didn't work, obviously
				//bm.blendMode = BlendMode.DARKEN;	  	// subtle effect... meh
				//bm.blendMode = BlendMode.DIFFERENCE;	// impressao de linhas/pontilhado (ugly)
				//bm.blendMode = BlendMode.ERASE;	  	// no differences
				//bm.blendMode = BlendMode.HARDLIGHT;  	// almost as good as overlay
				//bm.blendMode = BlendMode.INVERT;	  	// grey mess with diagonal pixels (._.)
				//bm.blendMode = BlendMode.LAYER;		// great effect, but darkens the camera
				//bm.blendMode = BlendMode.LIGHTEN;	  	// sucks
				//bm.blendMode = BlendMode.MULTIPLY;  	// squareish and boring
				bm.blendMode = BlendMode.NORMAL;	  	// LOL
				//bm.blendMode = BlendMode.OVERLAY;	  	// best so far
				//bm.blendMode = BlendMode.SCREEN;	  	// meh
				//bm.blendMode = BlendMode.SHADER;	  	// don't use!
				//bm.blendMode = BlendMode.SUBTRACT;  	// like many others, except too dark
				addChild(bm);
				
				reg.filter = bm;
				bm.visible = reg.filterVisibility;
				bm.visible = true;
			}
		}
		
		override protected function onFocus(FlashEvent:Event = null):void {
			super.onFocus(FlashEvent);
			if (!FlxG.mute)
				sfx.resumeMusic();
		}
		override protected function onFocusLost(FlashEvent:Event = null):void {
			var X:Number = x;
			var Y:Number = y;
			super.onFocusLost(FlashEvent);
			sfx.pauseMusic();
			x = X;
			y = Y;
		}
		override protected function showSoundTray(Silent:Boolean = false):void {
			super.showSoundTray(Silent);
			if (FlxG.mute) {
				sfx.pauseMusic();
			}
			else {
				sfx.resumeMusic();
				sfx.volume = FlxG.volume;
			}
		}
		
		private function onResize(e:Event):void {
			
			if (FlxG.camera.fxActive) {
				if (!fxWasActive) {
					addEventListener(Event.EXIT_FRAME, onResize);
					__stageWidth = stage.stageWidth;
					__stageHeight = stage.stageHeight;
					fxWasActive = true;
				}
				return;
			}
			else if (fxWasActive) {
				removeEventListener(Event.EXIT_FRAME, onResize);
				stage.stageWidth = __stageWidth;
				stage.stageHeight = __stageHeight;
				fxWasActive = false;
			}
			
			var z:int = FlxU.min(int(stage.stageWidth / 320), int(stage.stageHeight / 240));
			if (z > 4)
				z = 4;
			var w:int = 320 * z;
			var h:int = 240 * z;
			
			FlxG.width = 320;
			FlxG.height = 240;
			FlxCamera.defaultZoom = z;
			FlxG.resetCameras(new FlxCamera(0, 0, 320, 240, z));
			FlxG.worldBounds.make( -16, -16, 320 + 32, 240 + 32);
			
			Game::filterEnabled {
				if (z != 1) {
					if (bm)
						bm.visible = reg.filterVisibility;
					addFilter(null);
				}
				else {
					if (bm)
						bm.visible = false;
				}
			}
			
			removeChild(_focus);
			_focus.graphics.clear();
			_focus.removeChild(_focus.getChildAt(0));
			Game::filterEnabled {
				if (bm)
					removeChild(bm);
			}
			createFocusScreen();
			Game::filterEnabled {
				if (bm)
					addChild(bm);
			}
			
			if (w != stage.stageWidth)
				x = (stage.stageWidth - w) / 2;
			else
				x = 0;
			if (h != stage.stageHeight)
				y = (stage.stageHeight - h) / 2;
			else
				y = 0;
			
			if (reg.editor) {
				reg.editor.resize(stage.stageWidth, stage.stageHeight);
			}
		}
	}
}
