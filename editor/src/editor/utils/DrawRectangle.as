package editor.utils {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class DrawRectangle extends Bitmap {
		
		private var _rect:Rectangle;
		
		public function DrawRectangle(Width:int, Height:int) {
			var bmd:BitmapData;
			
			bmd = new BitmapData(Width, Height, true, 0);
			_rect = new Rectangle();
			
			super(bmd);
		}
		
		public function destroy():void {
			_rect = null;
			if (bitmapData)
				bitmapData.dispose();
			bitmapData = null;
		}
		
		public function moveTo(X:int, Y:int):void {
			var dx:int = X - _rect.x;
			var dy:int = Y - _rect.y;
			_rect.x += dx;
			_rect.y += dy;
			
			drawRect(_rect.x, _rect.y, _rect.x+_rect.width, _rect.y+_rect.height);
		}
		
		public function drawRect(fromX:int, fromY:int, toX:int, toY:int):void {
			var bmd:BitmapData;
			var swt:int;
			
			bmd = bitmapData;
			
			if (fromX > toX) {
				swt = toX;
				toX = fromX;
				fromX = swt;
			}
			if (fromY > toY) {
				swt = toY;
				toY = fromY;
				fromY = swt;
			}
			
		bmd.lock();
			_rect.x = 0;
			_rect.y = 0;
			_rect.width = width;
			_rect.height = height;
			bmd.fillRect(_rect, 0);
			// draw vertical lines
			_rect.x = fromX;
			_rect.y = fromY;
			_rect.width = 1;
			_rect.height = toY - fromY + 1;
			bmd.fillRect(_rect, 0xaa888888);
			_rect.x = toX;
			bmd.fillRect(_rect, 0xaa888888);
			_rect.x = fromX + 1;
			_rect.y = fromY + 1;
			_rect.height = toY - fromY - 1;
			bmd.fillRect(_rect, 0xaacccccc);
			_rect.x = toX - 1;
			bmd.fillRect(_rect, 0xaacccccc);
			_rect.x = fromX + 2;
			_rect.y = fromY + 2;
			_rect.height = toY - fromY - 3;
			bmd.fillRect(_rect, 0xaa888888);
			_rect.x = toX - 2;
			bmd.fillRect(_rect, 0xaa888888);
			// draw horizontal lines
			_rect.x = fromX;
			_rect.y = fromY;
			_rect.width = toX - fromX + 1;
			_rect.height = 1;
			bmd.fillRect(_rect, 0xaa888888);
			_rect.y = toY;
			bmd.fillRect(_rect, 0xaa888888);
			_rect.x = fromX + 1;
			_rect.y = fromY + 1;
			_rect.width = toX - fromX - 1;
			bmd.fillRect(_rect, 0xaacccccc);
			_rect.y = toY - 1;
			bmd.fillRect(_rect, 0xaacccccc);
			_rect.x = fromX + 2;
			_rect.y = fromY + 2;
			_rect.width = toX - fromX - 3;
			bmd.fillRect(_rect, 0xaa888888);
			_rect.y = toY - 2;
			bmd.fillRect(_rect, 0xaa888888);
		bmd.unlock();
			
			_rect.x = fromX;
			_rect.y = fromY;
			_rect.width = toX - fromX;
			_rect.height = toY - fromY;
		}
		
		public function get rectangle():Rectangle {
			return _rect;
		}
	}
}
