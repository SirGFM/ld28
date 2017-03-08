package editor.utils {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Grid extends Bitmap {
		
		public function Grid(Width:int, Height:int) {
			var i:int;
			var rect:Rectangle = new Rectangle();
			var bmd:BitmapData = new BitmapData(Width, Height, true, 0);
			
			// draw vertical lines
			rect.x = 0;
			rect.y = 0;
			rect.width = 1;
			rect.height = Height;
			i = 0;
			while (i < Width / CONST::TILED) {
				bmd.fillRect(rect, 0xff000000);
				i++;
				rect.x += CONST::TILED;
			}
			// draw horizontal lines
			rect.x = 0;
			rect.y = 0;
			rect.width = Width;
			rect.height = 1;
			i = 0;
			while (i < Height / CONST::TILED) {
				bmd.fillRect(rect, 0xff000000);
				i++;
				rect.y += CONST::TILED;
			}
			super(bmd);
		}
		
		public function destroy():void {
			if (bitmapData)
				bitmapData.dispose();
			bitmapData = null;
		}
	}
}
