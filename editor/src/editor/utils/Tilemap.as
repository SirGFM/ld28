package editor.utils {
	
	import editor.windows.PaletteWindow;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class Tilemap extends Bitmap {
		
		protected var _widthInTiles:int;
		protected var _heightInTiles:int;
		protected var _data:Vector.<uint>;
		protected var _rect:Rectangle;
		protected var _point:Point;
		
		public function Tilemap(WidthInTiles:int, HeightInTiles:int, Basic:uint = 29) {
			var bmd:BitmapData;
			var i:int;
			var l:int;
			
			_widthInTiles = WidthInTiles;
			_heightInTiles = HeightInTiles;
			
			bmd = new BitmapData(WidthInTiles*CONST::TILED, HeightInTiles*CONST::TILED, true, 0);
			super(bmd);
			
			_data = new Vector.<uint>();
			i = 0;
			l = _widthInTiles*_heightInTiles;
			while (i++ < l)
				_data.push(Basic);
			
			_rect = new Rectangle(0, 0, CONST::TILED, CONST::TILED);
			_point = new Point();
			
			var tmp:PaletteWindow = Registry.curPalette;
			Registry.curPalette = Registry.paletteWindow;
			redraw();
			Registry.curPalette = tmp;
		}
		public function destroy():void {
			while (_data.length > 0)
				_data.pop();
			_data = null;
			_rect = null
			_point = null;
			if (bitmapData)
				bitmapData.dispose();
			bitmapData = null;
		}
		
		public function editCSV(arr:Array, X:int, Y:int, Width:int, Height:int, WidthInTiles:int):void {
			var i:int;
			var j:int;
			var max:int = _widthInTiles * _heightInTiles;
			
			i = 0;
			while (i < Width) {
				j = 0;
				while (j < Height) {
					var pos:int = (X+i) + (Y+j)*_widthInTiles;
					if (pos < max)
						_data[pos] = arr[i + j*WidthInTiles];
					j++;
				}
				i++;
			}
		}
		
		public function updateAutotile():void {
			_rect.width = CONST::TILED;
			_rect.height = CONST::TILED;
			var j:uint;
			var pos:uint;
			var tmp:uint;
			var prev:uint;
			var cur:uint;
			var tmpArr:Array;
			var arr:Array = [];
			var i:uint = 0;
			while (i < _widthInTiles) {
				j = 0;
				while (j < _heightInTiles) {
					pos = i + j * _widthInTiles;
					tmp = _data[pos];
					if (tmp >= CONST::AUTOTILE) {
						prev = tmp;
						cur = CONST::AUTOTILE;
						tmp = 0;
						if ((j <= 0) || (_data[pos - _widthInTiles] >= CONST::AUTOTILE)) // UP
							tmp += 1;
						if ((i >= _widthInTiles - 1) || (_data[pos+1] >= CONST::AUTOTILE)) // RIGHT
							tmp += 2;
						if ((j >= _heightInTiles - 1) || (_data[pos+_widthInTiles] >= CONST::AUTOTILE)) // DOWN
							tmp += 4;
						if ((i <= 0) || (_data[pos-1] >= CONST::AUTOTILE)) // LEFT
							tmp += 8;
						tmp += CONST::AUTOTILE;
						
						// array = [pos, value]
						tmpArr = [pos, tmp];
						arr.push(tmpArr);
						
						if (tmp != prev) {
							_data[pos] = tmp;
							_point.x = i * CONST::TILED;
							_point.y = j * CONST::TILED;
							_rect.x = (tmp % CONST::TILESETW)*CONST::TILED;
							_rect.y = int(tmp / CONST::TILESETW)*CONST::TILED;
							bitmapData.copyPixels(Registry.paletteWindow.palette, _rect, _point);
						}
					}
					j++;
				}
				i++;
			}
			// detect corners
			while (arr.length > 0) {
				var up:uint;
				var right:uint;
				var down:uint;
				var left:uint;
				
				tmpArr = arr.pop();
				pos = int(tmpArr[0]);
				prev = _data[pos];
				i = pos % _widthInTiles;
				j = pos / _widthInTiles;
				var val:uint = uint(tmpArr[1]) - CONST::AUTOTILE;
				// up
				if (j <= 0)
					up = 0;
				else {
					up = _data[pos - _widthInTiles];
					if (up < CONST::AUTOTILE)
						up = 0;
					else
						up -= CONST::AUTOTILE;
				}
				// right
				if (i >= _widthInTiles - 1)
					right = 0;
				else
					right = _data[pos + 1];
					if (right < CONST::AUTOTILE)
						right = 0;
					else
						right -= CONST::AUTOTILE;
				// down
				if (j >= _heightInTiles - 1)
					down = 0;
				else
					down = _data[pos + _widthInTiles];
					if (down < CONST::AUTOTILE)
						down = 0;
					else
						down -= CONST::AUTOTILE;
				// left
				if (i <= 0)
					left = 0;
				else
					left = _data[pos - 1];
					if (left < CONST::AUTOTILE)
						left = 0;
					else
						left -= CONST::AUTOTILE;
				
				switch(down+CONST::AUTOTILE-CONST::CORNER) {
					case 1: down = 6; break;
					case 2:
					case 3:
					case 4: down = 7; break;
					case 9: down = 12; break;
					case 10: 
					case 11: 
					case 12: down = 13; break;
					case 13: 
					case 14: 
					case 15: down = 14; break;
				}
				switch(left+CONST::AUTOTILE-CONST::CORNER) {
					case 5: left = 9; break;
					case 6:
					case 7:
					case 8: left = 11; break;
					case 9: left = 12; break;
					case 10: 
					case 11: 
					case 12: left = 13; break;
					case 13: 
					case 14: 
					case 15: left = 14; break;
				}
				switch(up+CONST::AUTOTILE-CONST::CORNER) {
					case 0: up = 3; break;
					case 2:
					case 3:
					case 4: up = 7; break;
					case 5: up = 9; break;
					case 6:
					case 7:
					case 8: up = 11; break;
					case 10: 
					case 11: 
					case 12: up = 13; break;
				}
				switch(right+CONST::AUTOTILE-CONST::CORNER) {
					case 0: right = 3; break;
					case 1: right = 6; break;
					case 2:
					case 3:
					case 4: right = 7; break;
					case 6:
					case 7:
					case 8: right = 11; break;
					case 13: 
					case 14: 
					case 15: right = 14; break;
				}
				
				tmp = 0;
				var d:Boolean = (down == 1 || down == 5);
				var l:Boolean = (left == 2 || left == 10);
				var u:Boolean = (up == 4 || up == 5);
				var r:Boolean = (right == 8 || right == 10);
				switch(val) {
					case 3: {
						if (u && r)
							tmp = CONST::CORNER;
					} break;
					case 6: {
						if (d && r)
							tmp = CONST::CORNER + 1;
					}
					break;
					case 7: {
							if (d && !u && (right == 9 || right == 11))
								tmp = CONST::CORNER + 2;
							else if (!d && u && (right == 12 || right == 14))
								tmp = CONST::CORNER + 3;
							else if (d && u && r)
								tmp = CONST::CORNER + 4;
					}
					break;
					case 9: {
						if (l && u)
							tmp = CONST::CORNER + 5;
					}
					break;
					case 11: {
						if (l && !r && (up == 6 || up == 7))
							tmp = CONST::CORNER + 6;
						else if (!l && r && (up == 12 || up == 13))
							tmp = CONST::CORNER + 7;
						else if (l && r && u)
							tmp = CONST::CORNER + 8;
					}
					break;
					break;
					case 12: {
						if (d && l)
							tmp = CONST::CORNER + 9;
					}
					break;
					case 13: {
						if (d && !u && (left == 3 || left == 11))
							tmp = CONST::CORNER + 10;
						else if (!d && u && (left == 6 || left == 14))
							tmp = CONST::CORNER + 11;
						else if (d && u && l)
							tmp = CONST::CORNER + 12;
					}
					break;
					case 14:
						if (l && !r && (down == 3 || down == 7))
							tmp = CONST::CORNER + 13;
						else if (!l && r && (down == 9 || down == 13))
							tmp = CONST::CORNER + 14;
						else if (l && r && d)
							tmp = CONST::CORNER + 15;
					break;
					case 15:
						// 4 corners
						if (d && r && u && l)
							tmp = CONST::CORNER + 30;
						// 3 corners
						else if (d && r && (left == 3 || left == 11) && (up == 12 || up == 13))
							tmp = CONST::CORNER + 29;
						else if (d && l && (right == 9 || right == 11) && (up == 6 || up == 7))
							tmp = CONST::CORNER + 28;
						else if (u && r && (left == 6 || left == 14) && (down == 9 || down == 13))
							tmp = CONST::CORNER + 26;
						else if (u && l && (right == 12 || right == 14) && (down == 3 || down == 7))
							tmp = CONST::CORNER + 22;
						// 2 corners
						else if (d && (right == 9 || right == 11) && (left == 3 || left == 11))
							tmp = CONST::CORNER + 27;
						else if (r && (up == 12 || up == 13) && (down == 9 || down == 13))
							tmp = CONST::CORNER + 25;
						else if ((up == 6 || up == 7) && (left == 6 || left == 14) && (down == 9 || down == 13) && (right == 9 || right == 11))
							tmp = CONST::CORNER + 24;
						else if ((up == 12 || up == 13) && (left == 3 || left == 11) && (right == 12 || right == 14) && (down == 3 || down == 7))
							tmp = CONST::CORNER + 21;
						else if(l && (up == 6 || up == 7) && (down == 3 || down == 7))
							tmp = CONST::CORNER + 20;
						else if(u && (right == 12 || right == 14) && (left == 6 || left == 14))
							tmp = CONST::CORNER + 18;
						// 1 corner
						else if ((down == 9 || down == 13) && (right == 9 || right == 11))
							tmp = CONST::CORNER + 23;
						else if ((down == 3 || down == 7) && (left == 3 || left == 11))
							tmp = CONST::CORNER + 19;
						else if ((up == 12 || up == 13) && (right == 12 || right == 14))
							tmp = CONST::CORNER + 17;
						else if ((left == 6 || left == 14) && (up == 6 || up == 7))
							tmp = CONST::CORNER + 16;
					break;
				}
				if (tmp != 0 && tmp != prev) {
					_data[pos] = tmp;
					_point.x = i * CONST::TILED;
					_point.y = j * CONST::TILED;
					_rect.x = (tmp % CONST::TILESETW)*CONST::TILED;
					_rect.y = int(tmp / CONST::TILESETW)*CONST::TILED;
					bitmapData.copyPixels(Registry.paletteWindow.palette, _rect, _point);
				}
			}
		}
		
		public function redraw():void {
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
			
			src = Registry.curPalette.palette;
			pw = Registry.curPalette.widthInTiles;
			
			bmd = bitmapData;
			w = _widthInTiles;
			h = _heightInTiles;
			
			i = 0;
			_point.x = 0;
			while (_point.x < width) {
				j = 0;
				_point.y = 0;
				while (_point.y < height) {
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
		
		public function get exportData():String {
			var i:int;
			var l:int;
			var str:String = "";
			
			l = _data.length;
			i = 0;
			while (i < l) {
				str += _data[i].toString();
				i++;
				if (i < l) {
					if (i % _widthInTiles != 0)
						str += ",";
					else
						str += "\n";
				}
			}
			return str;
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
			
			var tmp:PaletteWindow = Registry.curPalette;
			Registry.curPalette = Registry.paletteWindow;
			redraw();
			Registry.curPalette = tmp;
		}
	}
}
