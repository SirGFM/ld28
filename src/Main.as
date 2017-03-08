package {
	
	import com.wordpress.gfmgamecorner.LogoGFM;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.flixel.FlxGame;
	import states.Introstate;
	import states.Playstate;
	import utils.Registry;
	
	// Game link:
	// https://dl.dropboxusercontent.com/u/55733901/LD48/ld28/gfm_ld28.html
	
	[SWF(width="640",height="480",backgroundColor="0x000000")]
	[Frame(factoryClass="Preloader")]
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Main extends FlxGame {
		
		private var logo:LogoGFM;
		
		public function Main():void {
			super(320, 240, Introstate, 2, 60, 30, true);
			
			logo = null;
			//return;
			
			logo = new LogoGFM(true);
			logo.scaleX = 2;
			logo.scaleY = 2;
			logo.x = (640 - logo.width) / 2;
			logo.y = (480 - logo.height) / 2;
			addChild(logo);
		}
		
		override protected function create(FlashEvent:Event):void {
			if (logo)
				if (logo.visible)
					return;
				else {
					removeChild(logo);
					logo.destroy();
					logo = null;
				}
			
			super.create(FlashEvent);
			
			addEventListener(Event.ENTER_FRAME, addFilter, false, -1);
			
			Registry.self.initPlugins();
		}
		
		private function addFilter(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, addFilter);
			
			var i:int = 0;
			var bmd:BitmapData = new BitmapData(640, 480, true, 0);
			var bm:Bitmap = new Bitmap(bmd);
			var vec:Vector.<uint> = bmd.getVector(bmd.rect);
			
			while (i < 320) {
				var j:int = 0;
				while (j < 240) {
					// squared
					/**/
					vec[i*2 + (j*2 + 1)*640] = 0x11000000;
					vec[i*2 + 1 + (j*2)*640] = 0x22000000;
					vec[i*2 + (j*2)*640] = 0x33000000;
					/**/
					// lines
					/**
					vec[i*2 + 1 + (j*2)*640] = 0x22000000;
					vec[i*2 + (j*2)*640] = 0x22000000;
					/**/
					j++;
				}
				i++;
			}
			
			bmd.setVector(bmd.rect, vec);
			addChild(bm);
		}
	}
}
