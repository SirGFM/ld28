package editor.utils {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class ScrollingTilemap extends Bitmap {
		
		private var _widthInTiles:int;
		private var _heightInTiles:int;
		private var _widthInPx:int;
		private var _heightInPx:int;
		private var _screenWidth:int;
		private var _screenHeight:int;
		
		private var _data:Vector.<uint>;
		private var _rect:Rectangle;
		private var _point:Point;
		
		private var _scrollX:int;
		private var _dx:int;
		private var _scrollY:int;
		private var _dy:int;
		
		private var _dirty:Boolean;
		
		public function ScrollingTilemap(WidthInTiles:int, HeightInTiles:int, ScreenWidth:int, ScreenHeight:int) {
			var bmd:BitmapData;
			var i:int;
			var l:int;
			
			_widthInTiles = WidthInTiles;
			_heightInTiles = HeightInTiles;
			_widthInPx = _widthInTiles * CONST::TILED;
			_heightInPx = _heightInTiles * CONST::TILED;
			_screenWidth = ScreenWidth;
			_screenHeight = ScreenHeight;
			
			bmd = new BitmapData(ScreenWidth, ScreenHeight, true, 0);
			super(bmd);
			
			_data = new Vector.<uint>();
			i = 0;
			l = _widthInTiles*_heightInTiles;
			while (i++ < l)
				_data.push(Math.random()*10+4);
			
			_rect = new Rectangle(0, 0, CONST::TILED, CONST::TILED);
			_point = new Point();
			
			fillBuffer();
		}
		
		public function editCSV(arr:Array, X:int, Y:int, Width:int, Height:int, WidthInTiles:int):void {
			var i:int;
			var j:int;
			
			i = 0;
			while (i < Width) {
				j = 0;
				while (j < Height) {
					_data[(X+i) + (Y+j)*_widthInTiles] = arr[i + j*WidthInTiles];
					j++;
				}
				i++;
			}
		}
		
		private function draw():void {
			var src:BitmapData;
			var bmd:BitmapData;
			// horizontal iterator
			var i:int;
			// vertical iterator
			var j:int;
			// width of the first tile
			var w:int;
			// height of the first tile
			var h:int;
			// absolute horizontal movement
			var absdx:int;
			// absolute vertical movement
			var absdy:int;
			
			absdx = Math.abs(_dx);
			absdy = Math.abs(_dy);
			
			src = Registry.paletteWindow.palette;
			bmd = bitmapData;
			
			// preparing to copy (move) current buffer
			_rect.width = _screenWidth - absdx;
			if (_dx > 0) {
				_rect.x = _dx;
				_point.x = 0;
			}
			else if (_dx < 0) {
				_rect.x = 0;
				_point.x = -_dx;
			}
			else {
				_rect.x = 0;
				_point.x = 0;
			}
			_rect.height = _screenHeight -absdy;
			if (_dy > 0) {
				_rect.y = _dy;
				_point.y = 0;
			}
			else if (_dy < 0) {
				_rect.y = 0;
				_point.y = -_dy;
			}
			else {
				_rect.y = 0;
				_point.y = 0;
			}
			
		bmd.lock();
			// copy (move) the immutable part
			bmd.copyPixels(bmd, _rect, _point);
			
			var newPosX:int = _scrollX + _dx;
			var newPosY:int = _scrollY + _dy;
			
			// render the updated horizontal part
			if (_dx != 0) {
				var dstX:int;
				var maxH:int;
				var offX:int;
				
				j = newPosY / CONST::TILED;
				maxH = Math.ceil((newPosY + _screenHeight) / CONST::TILED);
				h = CONST::TILED - (newPosY % CONST::TILED);
				if (!((newPosX == 0 || _scrollX % CONST::TILED == 0 ) && _dx >= -CONST::TILED) && _scrollX % CONST::TILED + _dx < 0) {
					// multiples tile to the left
					i = _scrollX / CONST::TILED;
					offX = 0;
					w = _scrollX % CONST::TILED;
					dstX = absdx - w;
					while (dstX >= 0) {
						fillColumn(bmd, src, i, j, dstX, w, h, maxH, offX);
						i--;
						if (dstX != 0 && dstX - CONST::TILED < 0) {
							w = dstX;
							offX = CONST::TILED - w;
							dstX = 0;
						}
						else {
							dstX -= CONST::TILED;
							offX = 0;
							w = CONST::TILED;
						}
					}
				}
				else if (_scrollX % CONST::TILED + _dx > CONST::TILED) {
					// multiples tile to the right
					i = (_scrollX + _screenWidth) / CONST::TILED;
					offX = _scrollX % CONST::TILED;
					w = CONST::TILED - offX;
					dstX = _screenWidth - absdx;
					while (dstX < _screenWidth) {
						fillColumn(bmd, src, i, j, dstX, w, h, maxH, offX);
						i++;
						dstX += w;
						offX = 0;
						if (dstX + CONST::TILED >= _screenWidth)
							w = _screenWidth - dstX;
					}
				}
				else if (_dx  > 0) {
					// one tile to the right
					i = (_scrollX + _screenWidth) / CONST::TILED;
					fillColumn(bmd, src, i, j, _screenWidth - _dx, _dx, h, maxH, (_scrollX + _screenWidth) % CONST::TILED);
				}
				else if (_dx < 0) {
					// one tile to the left
					i = _scrollX / CONST::TILED;
					if (_scrollX % CONST::TILED == 0)
						i--;
					fillColumn(bmd, src, i, j, 0, absdx, h, maxH, newPosX % CONST::TILED);
				}
			}
			
			// render the updated vertical part
			if (_dy != 0) {
				var dstY:int;
				var maxW:int;
				var offY:int;
				
				i = newPosX / CONST::TILED;
				maxW = Math.ceil((newPosX + _screenWidth) / CONST::TILED);
				w = CONST::TILED - (newPosX % CONST::TILED);
				if (!((newPosY == 0 || _scrollY % CONST::TILED == 0 ) && _dy >= -CONST::TILED) && _scrollY % CONST::TILED + _dy < 0) {
					// multiples tile to the left
					j = _scrollY / CONST::TILED;
					offY = 0;
					h = _scrollY % CONST::TILED;
					dstY = absdy - h;
					while (dstY >= 0) {
						fillRow(bmd, src, i, j, dstY, w, h, maxW, offY);
						j--;
						if (dstY != 0 && dstY - CONST::TILED < 0) {
							h = dstY;
							offY = CONST::TILED - h;
							dstY = 0;
						}
						else {
							dstY -= CONST::TILED;
							offY = 0;
							h = CONST::TILED;
						}
					}
				}
				else if (_scrollY % CONST::TILED + _dy > CONST::TILED) {
					// multiples tile to the right
					j = (_scrollY + _screenHeight) / CONST::TILED;
					offY = _scrollY % CONST::TILED;
					h = CONST::TILED - offY;
					dstY = _screenHeight - absdy;
					while (dstY < _screenHeight) {
						fillRow(bmd, src, i, j, dstY, w, h, maxW, offY);
						j++;
						dstY += h;
						offY = 0;
						if (dstY + CONST::TILED >= _screenHeight)
							h = _screenHeight - dstY;
					}
				}
				else if (_dy > 0) {
					// one tile to the right
					j = (_scrollY + _screenHeight) / CONST::TILED;
					fillRow(bmd, src, i, j, _screenHeight - _dy, w, _dy, maxW, (_scrollY + _screenHeight) % CONST::TILED);
				}
				else if (_dy < 0) {
					// one tile to the left
					j = _scrollY / CONST::TILED;
					if (_scrollY % CONST::TILED == 0)
						j--;
					fillRow(bmd, src, i, j, 0, w, absdy, maxW, newPosY % CONST::TILED);
				}
			}
		bmd.unlock();
		}
		
		/**
		 * ...
		 * 
		 * @param	bmd		Destiny bitmap
		 * @param	src		Source bitmap
		 * @param	i		Horizontal tile
		 * @param	j		Vertical starting tile
		 * @param	x		Destiny horizontal position
		 * @param	w		Source rect width
		 * @param	h		Source rect height
		 * @param	maxh	Vertical max tile
		 * @param	offx	Horizontal offset on source tile
		 */
		private function fillColumn(bmd:BitmapData, src:BitmapData, i:int, j:int, x:int, w:int, h:int, maxh:int, offx:int):void {
			var tile:uint;
			var pw:int = Registry.paletteWindow.widthInTiles;
			
			_rect.width = w;
			_rect.height = h;
			_point.x = x;
			_point.y = 0;
			while (j < maxh) {
				tile = _data[i + j*_widthInTiles];
				_rect.x = int(tile % pw) * CONST::TILED;
				_rect.y = int(tile / pw) * CONST::TILED;
				_rect.x += offx;
				bmd.copyPixels(src, _rect, _point);
				j++;
				_point.y += _rect.height;
				if (j != maxh-1)
					_rect.height = CONST::TILED;
				else
					_rect.height = _screenHeight - _point.y;
			}
		}
		
		/**
		 * ...
		 * 
		 * @param	bmd		Destiny bitmap
		 * @param	src		Source bitmap
		 * @param	i		Horizontal tile
		 * @param	j		Vertical starting tile
		 * @param	y		Destiny horizontal position
		 * @param	w		Source rect width
		 * @param	h		Source rect height
		 * @param	maxw	Vertical max tile
		 * @param	offy	Horizontal offset on source tile
		 */
		private function fillRow(bmd:BitmapData, src:BitmapData, i:int, j:int, y:int, w:int, h:int, maxw:int, offy:int):void {
			var tile:uint;
			var pw:int = Registry.paletteWindow.widthInTiles;
			
			_rect.width = w;
			_rect.height = h;
			_point.x = 0;
			_point.y = y;
			while (i < maxw) {
				tile = _data[i + j*_widthInTiles];
				_rect.x = int(tile % pw) * CONST::TILED;
				_rect.y = int(tile / pw) * CONST::TILED;
				_rect.y += offy;
				bmd.copyPixels(src, _rect, _point);
				i++;
				_point.x += _rect.width;
				if (i != maxw-1)
					_rect.width = CONST::TILED;
				else
					_rect.width = _screenWidth - _point.x;
			}
		}
		
		public function scroll(dx:int, dy:int):void {
			if (_scrollX + dx < 0)
				_dx = -_scrollX;
			else if (_scrollX + dx > _widthInPx - _screenWidth)
				_dx = (_widthInPx - _screenWidth) - _scrollX;
			else
				_dx = dx;
			
			if (_scrollY + dy < 0)
				_dy = -_scrollY;
			else if (_scrollY + dy >= _heightInPx - _screenHeight)
				_dy = (_heightInPx - _screenHeight) - _scrollY;
			else
				_dy = dy;
			
			if (_dx != 0 || _dy != 0) {
				draw();
				_scrollX += _dx;
				_scrollY += _dy;
			}
		}
		
		public function fillBuffer():void {
			var src:BitmapData;
			var bmd:BitmapData;
			// palette width in tiles
			var pw:int;
			// horizontal iterator
			var i:int;
			// vertical iterator
			var j:int;
			// horizontal limit
			var w:int;
			// vertical limit
			var h:int;
			
			var X:int = 0;
			var Y:int = 0;
			
			src = Registry.paletteWindow.palette;
			pw = Registry.paletteWindow.widthInTiles;
			
			bmd = bitmapData;
			w = _widthInTiles;
			h = _heightInTiles;
			
			i = 0;
			_point.x = 0;
			while (_point.x < width && i < _widthInTiles) {
				j = 0;
				_point.y = 0;
				while (_point.y < height && j < heightInTiles) {
					var tile:uint;
					tile = _data[i + j*_widthInTiles];
					_rect.x = int(tile % pw) * CONST::TILED;
					_rect.y = int(tile / pw) * CONST::TILED;
					bmd.copyPixels(src, _rect, _point);
					_point.y += CONST::TILED;
					j++;
				}
				_point.x += CONST::TILED;
				i++;
			}
		}
		
		public function get widthInTiles():int {
			return _widthInTiles;
		}
		public function get heightInTiles():int {
			return _heightInTiles;
		}
		
		public function get data():String {
			var i:int;
			var l:int;
			var str:String = "";
			
			l = _data.length;
			i = 0;
			while (i < l) {
				str += "\"" + _data[i].toString() + "\"";
				i++;
				if (i < l)
					str += ",";
			}
			return str;
		}
		public function setData(val:Array):void {
			var i:int;
			var l:int;
			
			l = val.length;
			i = -1;
			while (++i < l)
				_data[i] = val[i];
			
			// redraw();
		}
	}
}
