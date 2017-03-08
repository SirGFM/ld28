package editor.bkup {
	
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
	public class MapPanel extends ScrollPane {
		
		private var _innerPanel:Panel;
		private var _backgroundLayer:Tilemap;
		private var _floorLayer:Tilemap;
		private var _foregroundLayer:Tilemap;
		
		private var _grid:Grid;
		private var _selected:DrawRectangle;
		
		private var _widthInTiles:int;
		private var _heightInTiles:int;
		
		private var _curLayer:int;
		private var _isMoving:Boolean;
		private var _layerMode:int;
		private var _dstPoint:Point;
		
		private var _isRightDown:Boolean;
		private var _fromX:int;
		private var _fromY:int;
		private var _toX:int;
		private var _toY:int;
		
		public function MapPanel(X:Number, Y:Number, Width:int, Height:Number) {
			super(null, X, Y);
			width = Width;
			height = Height;
			
			dragContent = false;
			autoHideScrollBar = true;
			_dstPoint = new Point();
			
			_isRightDown = false;
			_isMoving = false;
			_layerMode = 2;
			_innerPanel = new Panel(this, 0, 0);
			_innerPanel.visible = false;
		}
		
		public function clear():void {
			if (_grid) {
				_innerPanel.content.removeChild(_grid);
				_innerPanel.content.removeChild(_backgroundLayer);
				_innerPanel.content.removeChild(_floorLayer);
				_innerPanel.content.removeChild(_foregroundLayer);
				
				if (_hScrollbar.visible) {
					removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMiddleDown);
					removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMiddleUp);
				}
				removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				_innerPanel.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				_innerPanel.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				_innerPanel.removeEventListener(MouseEvent.CLICK, onClick);
				_innerPanel.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightDown);
				_innerPanel.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightUp);
				
				_innerPanel.content.removeChild(_selected);
				_selected = null;
			}
			_innerPanel.visible = false;
		}
		public function createMap(widthInTiles:int, heightInTiles:int):void {
			var _w:int;
			var _h:int;
			
			_innerPanel.visible = true;
			_widthInTiles = widthInTiles;
			_heightInTiles = heightInTiles;
			
			_backgroundLayer = new Tilemap(widthInTiles, heightInTiles);
			_floorLayer = new Tilemap(widthInTiles, heightInTiles);
			_foregroundLayer = new Tilemap(widthInTiles, heightInTiles);
			
			_grid = new Grid(widthInTiles * 32, heightInTiles * 32);
			
			_w = widthInTiles * 32;
			if (_w > width)
				_innerPanel.x = 0;
			else {
				var _x:int = (width - _w) / 2;
				_innerPanel.x = _x;
			}
			_h = heightInTiles * 32;
			if (_h > height)
				_innerPanel.y = 0;
			else {
				var _y:int = (height - _h) / 2;
				_innerPanel.y = _y;
			}
			
			_innerPanel.width = _w;
			_innerPanel.height = _h;
			
			_selected = new DrawRectangle(_w, _h);
			_selected.drawRect(0, 0, 32, 32);
			_selected.visible = false;
			
			_innerPanel.content.addChild(_backgroundLayer);
			_innerPanel.content.addChild(_floorLayer);
			_innerPanel.content.addChild(_foregroundLayer);
			_innerPanel.content.addChild(_grid);
			_innerPanel.content.addChild(_selected);
			
			if (_w > width || _h  > height) {
				update();
				addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMiddleDown);
				addEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMiddleUp);
			}
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_innerPanel.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_innerPanel.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_innerPanel.addEventListener(MouseEvent.CLICK, onClick);
			_innerPanel.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightDown);
			_innerPanel.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightUp);
			
		}
		
		private function onMiddleDown(ev:MouseEvent):void {
			_isMoving = true;
			content.startDrag(false, new Rectangle(0, 0, Math.min(0, _width - content.width - 10), Math.min(0, _height - content.height - 10)));
		}
		private function onMiddleUp(ev:MouseEvent):void {
			_isMoving = false;
			content.stopDrag();
		}
		override protected function onMouseMove(ev:MouseEvent):void {
			if (_isMoving)
				super.onMouseMove(ev);
			if (_isRightDown) {
				_toX = ev.localX;
				_toY = ev.localY;
				
				if (ev.localX >= _innerPanel.width)
					_toX = _innerPanel.width - 1;
				if (ev.localY >= _innerPanel.height)
					_toY = _innerPanel.height - 1;
				
				_selected.drawRect(_fromX, _fromY, _toX, _toY);
			}
			else if (_selected && _selected.visible && !ev.shiftKey) {
				var _x:int;
				var _y:int;
				_x = ev.localX / 32;
				_y = ev.localY / 32;
				if (_x >= _widthInTiles)
					_x--;
				if (_y >= _heightInTiles)
					_y--;
				_x = _x * 32;
				_y = _y * 32;
				_selected.moveTo(_x, _y);
			}
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
			var tm:Tilemap;
			
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
					bmd.copyPixels(src, srcRect, _dstPoint);
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
			else if (ev.localX >= _innerPanel.width)
				return;
			else if (ev.localY >= _innerPanel.height)
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
