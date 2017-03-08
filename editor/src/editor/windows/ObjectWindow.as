package editor.windows {
	
	import flash.display.Bitmap;
	import utils.GFX;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class ObjectWindow extends PaletteWindow {
		
		public function ObjectWindow() {
			super(new GFX.objects, 0);
		}
	}
}