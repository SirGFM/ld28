package editor.newer {
	
	import com.bit101.components.Panel;
	import com.bit101.components.ScrollPane;
	import editor.utils.DrawRectangle;
	import editor.utils.Grid;
	import editor.utils.Registry;
	import editor.utils.ScrollingTilemap;
	import editor.utils.Tilemap;
	import editor.utils.Utils;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class MapPanel extends Panel {
		
		private var _backgroundLayer:ScrollingTilemap;
		private var _floorLayer:ScrollingTilemap
		private var _foregroundLayer:ScrollingTilemap
		
		private var _grid:Grid;
		private var _selected:DrawRectangle;
		
		private var _widthInTiles:int;
		private var _heightInTiles:int;
		private var _widthInPx:int;
		private var _heightInPx:int;
		
		private var _curLayer:int;
		private var _isMoving:Boolean;
		private var _layerMode:int;
		private var _dstPoint:Point;
		
		private var _isRightDown:Boolean;
		private var _fromX:int;
		private var _fromY:int;
		private var _toX:int;
		private var _toY:int;
		
		private var _lastX:int;
		private var _lastY:int;
		private var _scrollX:int;
		private var _scrollY:int;
		
		public function MapPanel(X:Number, Y:Number, Width:int, Height:Number) {
			super(null, X, Y);
			width = Width;
			height = Height;
			
			_dstPoint = new Point();
			
			_isRightDown = false;
			_isMoving = false;
			_layerMode = 2;
		}
		
		public function clear():void {
			if (_grid) {
				content.removeChild(_grid);
				content.removeChild(_backgroundLayer);
				content.removeChild(_floorLayer);
				content.removeChild(_foregroundLayer);
				
				
				if (_foregroundLayer.widthInTiles * 32 > 640 ) {
					removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMiddleDown);
					removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMiddleUp);
				}
				
				_backgroundLayer = null;
				_floorLayer = null;
				_foregroundLayer = null;
				
				removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				removeEventListener(MouseEvent.CLICK, onClick);
				removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightDown);
				removeEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightUp);
				
				content.removeChild(_selected);
				_selected = null;
			}
			
		}
		public function createMap(widthInTiles:int, heightInTiles:int):void {
			var _w:int;
			var _h:int;
			
			_widthInTiles = widthInTiles;
			_heightInTiles = heightInTiles;
			_widthInPx = widthInTiles * 32;
			_heightInPx = heightInTiles * 32;
			
			_backgroundLayer = new ScrollingTilemap(widthInTiles, heightInTiles, 640, 480);
			_floorLayer = new ScrollingTilemap(widthInTiles, heightInTiles, 640, 480);
			_foregroundLayer = new ScrollingTilemap(widthInTiles, heightInTiles, 640, 480);
			
			
			if (widthInTiles <= 20 && heightInTiles <= 15) {
				_grid = new Grid(widthInTiles * 32, heightInTiles * 32);
			}
			else
				_grid = new Grid(672, 512);
			
			_w = widthInTiles * 32;
			_h = heightInTiles * 32;
			
			_selected = new DrawRectangle(_w, _h);
			_selected.drawRect(0, 0, 32, 32);
			_selected.visible = false;
			
			content.addChild(_backgroundLayer);
			content.addChild(_floorLayer);
			content.addChild(_foregroundLayer);
			content.addChild(_grid);
			content.addChild(_selected);
			
			if (_w > width || _h  > height) {
				addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMiddleDown);
				addEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMiddleUp);
			}
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightDown);
			addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightUp);
			
			_scrollX = 0;
			_scrollY = 0;
		}
		
		private function onMiddleDown(ev:MouseEvent):void {
			_isMoving = true;
		}
		private function onMiddleUp(ev:MouseEvent):void {
			_isMoving = false;
		}
		protected function onMouseMove(ev:MouseEvent):void {
			if (_isMoving) {
				var dx:int =  _lastX - ev.localX;
				var dy:int = _lastY - ev.localY;
				_backgroundLayer.scroll(dx, dy);
				_floorLayer.scroll(dx, dy);
				_foregroundLayer.scroll(dx, dy);
				
				_scrollX += dx;
				if (_scrollX < 0)
					_scrollX = 0;
				else if (_scrollX + 640 > _widthInPx)
					_scrollX = _widthInPx - 640;
				_scrollY += dy;
				if (_scrollY < 0)
					_scrollY = 0;
				else if (_scrollY + 480 > _heightInPx)
					_scrollY = _heightInPx - 480;
				
				_grid.x = -(_scrollX % 32);
				_grid.y = -(_scrollY % 32);
			}
			if (_isRightDown) {
				_toX = ev.localX;
				_toY = ev.localY;
				
				if (ev.localX >= width)
					_toX = width - 1;
				if (ev.localY >= height)
					_toY = height - 1;
				
				_selected.drawRect(_fromX, _fromY, _toX, _toY);
			}
			else if (_selected && _selected.visible && !ev.shiftKey) {
				var _x:int;
				var _y:int;
				_x = (_scrollX + ev.localX) / 32;
				_y = (_scrollY + ev.localY) / 32;
				if (_x >= _widthInTiles)
					_x = _widthInTiles - 1;
				if (_y >= _heightInTiles)
					_y  = _heightInTiles - 1;
				_x = _x * 32 - _scrollX;
				_y = _y * 32 - _scrollY;
				_selected.moveTo(_x, _y);
			}
			_lastX = ev.localX;
			_lastY = ev.localY;
		}
		private function onMouseOver(ev:MouseEvent):void {
			_selected.visible = true;
		}
		private function onMouseOut(ev:MouseEvent):void {
			if (_isMoving)
				onMiddleUp(null);
			if (_selected)
				_selected.visible = false;
		}
		private function onClick(ev:MouseEvent):void {
			var tm:ScrollingTilemap;
			
			var srcArr:Array;
			var tw:int;
			
			var bmd:BitmapData;
			var src:BitmapData;
			var srcRect:Rectangle;
			var dstRect:Rectangle;
			var _w:int;
			var _h:int;
			
			if (!_selected || !_selected.visible)
				return;
			
			src = Registry.paletteWindow.palette;
			srcRect = Registry.paletteWindow.rectangle;
			dstRect = _selected.rectangle;
			
			srcArr = Registry.paletteWindow.array;
			tw = srcRect.width / 32;
			
			if (_curLayer == 0) {
				bmd = _backgroundLayer.bitmapData;
				tm = _backgroundLayer;
			}
			else if (_curLayer == 1) {
				bmd = _floorLayer.bitmapData;
				tm = _floorLayer;
			}
			else if (_curLayer == 2) {
				bmd = _foregroundLayer.bitmapData;
				tm = _foregroundLayer;
			}
			
		bmd.lock();
			_w = 0;
			_dstPoint.x = dstRect.x;
			while (_w < dstRect.width) {
				var dx:int = 0;
				if (_w + srcRect.width > dstRect.width) {
					dx = _w + srcRect.width - dstRect.width;
					srcRect.width -= dx;
				}
				_dstPoint.y = dstRect.y;
				_h = 0;
				while (_h < dstRect.height) {
					var dy:int = 0;
					if (_h + srcRect.height > dstRect.height) {
						dy = _h + srcRect.height - dstRect.height;
						srcRect.height -= dy;
					}
					tm.editCSV(srcArr, _dstPoint.x/32, _dstPoint.y/32, srcRect.width/32, srcRect.height/32, tw);
					// bmd.copyPixels(src, srcRect, _dstPoint);
					if (dy != 0)
						srcRect.height += dy;
					_dstPoint.y += srcRect.height;
					_h += srcRect.height;
				}
				if (dx != 0)
					srcRect.width += dx;
				_dstPoint.x += srcRect.width;
				_w += srcRect.width;
			}
		bmd.unlock();
		}
		private function onRightDown(ev:MouseEvent):void {
			if (ev.shiftKey)
				return;
			else if (ev.localX >= width)
				return;
			else if (ev.localY >= height)
				return;
			
			_fromX = ev.localX;
			_fromY = ev.localY;
			_isRightDown = true;
		}
		private function onRightUp(ev:MouseEvent):void {
			var swt:int;
			
			if (ev.shiftKey) {
				_fromX = _selected.rectangle.x;
				_fromY = _selected.rectangle.y;
				_toX = ev.localX;
				_toY = ev.localY;
			}
			_toX = ev.localX;
			_toY = ev.localY;
			
			if (_fromX > _toX) {
				swt = _toX;
				_toX = _fromX;
				_fromX = swt;
			}
			if (_fromY > _toY) {
				swt = _toY;
				_toY = _fromY;
				_fromY = swt;
			}
			
			_fromX /= 32;
			_fromY /= 32;
			_fromX = _fromX*32;
			_fromY = _fromY*32;
			
			_toX = _toX / 32;
			_toY = _toY / 32;
			_toX = _toX*32 + 32;
			_toY = _toY*32 + 32;
			
			_isRightDown = false;
			_selected.drawRect(_fromX, _fromY, _toX, _toY);
		}
		
		public function set gridVisibility(val:Boolean):void {
			if (_grid)
				_grid.visible = val;
		}
		
		public function setCurrentLayer(layer:int):Boolean {
			if (!_grid)
				return false;
			
			_curLayer = layer;
			
			_backgroundLayer.visible = true;
			_floorLayer.visible = true;
			_foregroundLayer.visible = true;
			_backgroundLayer.alpha = 1;
			_floorLayer.alpha = 1;
			_foregroundLayer.alpha = 1;
			
			if (_layerMode == 0) {
				_backgroundLayer.visible = false;
				_floorLayer.visible = false;
				_foregroundLayer.visible = false;
			}
			else if (_layerMode == 1) {
				_backgroundLayer.alpha = 0.5;
				_floorLayer.alpha = 0.5;
				_foregroundLayer.alpha = 0.5;
			}
			
			if (_layerMode != 2) {
				if (_curLayer == 0) {
					_backgroundLayer.visible = true;
					_backgroundLayer.alpha = 1.0;
				}
				else if (_curLayer == 1) {
					_floorLayer.visible = true;
					_floorLayer.alpha = 1.0;
				}
				else if (_curLayer == 2) {
					_foregroundLayer.visible = true;
					_foregroundLayer.alpha = 1.0;
				}
			}
			
			return true;
		}
		
		public function setWorkingOnly():void {
			if (_layerMode == 0)
				return;
			_layerMode = 0;
			setCurrentLayer(_curLayer);
		}
		public function setTranslucent():void {
			if (_layerMode == 1)
				return;
			_layerMode = 1;
			setCurrentLayer(_curLayer);
		}
		public function setOpaque():void {
			if (_layerMode == 2)
				return;
			_layerMode = 2;
			setCurrentLayer(_curLayer);
		}
		
		public function get backgroundData():String {
			return _backgroundLayer.data;
		}
		public function setBackgroundData(val:Array):void {
			_backgroundLayer.setData(val);
		}
		public function get floorData():String {
			return _floorLayer.data;
		}
		public function setFloorData(val:Array):void {
			_floorLayer.setData(val);
		}
		public function get foregroundData():String {
			return _foregroundLayer.data;
		}
		public function setForegroundData(val:Array):void {
			_foregroundLayer.setData(val);
		}
		public function get widthInTiles():int {
			return _widthInTiles;
		}
		public function get heightInTiles():int {
			return _heightInTiles;
		}
	}
}
