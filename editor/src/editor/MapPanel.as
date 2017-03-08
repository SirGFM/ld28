package editor {
	
	import com.bit101.components.Panel;
	import com.bit101.components.ScrollPane;
	import editor.utils.DrawRectangle;
	import editor.utils.Grid;
	import editor.utils.Objectmap;
	import editor.utils.Registry;
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
		
		private var _zoom:int;
		private var _innerPanel:Panel;
		private var _backgroundLayer:Tilemap;
		private var _objectLayer:Tilemap;
		
		private var _grid:Grid;
		private var _selected:DrawRectangle;
		
		private var _widthInTiles:int;
		private var _heightInTiles:int;
		
		private var _curLayer:int;
		private var _isMoving:Boolean;
		private var _layerMode:int;
		private var _dstPoint:Point;
		
		private var _isLeftDown:Boolean;
		private var _alreadyPut:Boolean;
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
			
			_isLeftDown = false;
			_alreadyPut = false;
			_isRightDown = false;
			_isMoving = false;
			_layerMode = 2;
			_innerPanel = new Panel(this, 0, 0);
			_innerPanel.visible = false;
		}
		public function destroy():void {
			if (_grid) {
				_innerPanel.content.removeChild(_grid);
				_innerPanel.content.removeChild(_backgroundLayer);
				_innerPanel.content.removeChild(_objectLayer);
				
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
			_innerPanel = null;
			if (_backgroundLayer)
				_backgroundLayer.destroy();
			_backgroundLayer = null;
			if (_objectLayer)
				_objectLayer.destroy();
			_objectLayer = null;
			
			if (_grid)
				_grid.destroy();
			_grid = null;
			if (_selected)
				_selected.destroy();
			_selected = null;
			_dstPoint = null;
			
			if (numChildren > 0)
				removeChildren();
		}
		
		public function clear():void {
			if (_grid) {
				_innerPanel.content.removeChild(_grid);
				_innerPanel.content.removeChild(_backgroundLayer);
				_innerPanel.content.removeChild(_objectLayer);
				
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
			Registry.objectListWindow.clear();
		}
		public function createMap(widthInTiles:int, heightInTiles:int):void {
			var _w:int;
			var _h:int;
			
			//_zoom = 1;
			_innerPanel.visible = true;
			_widthInTiles = widthInTiles;
			_heightInTiles = heightInTiles;
			
			_backgroundLayer = new Tilemap(widthInTiles, heightInTiles);
			_objectLayer = new Objectmap(widthInTiles, heightInTiles);
			
			_grid = new Grid(widthInTiles * CONST::TILED, heightInTiles * CONST::TILED);
			
			_w = widthInTiles * CONST::TILED;
			if (_w > width)
				_innerPanel.x = 0;
			else {
				var _x:int = (width - _w) / 2;
				_innerPanel.x = _x;
			}
			_h = heightInTiles * CONST::TILED;
			if (_h > height)
				_innerPanel.y = 0;
			else {
				var _y:int = (height - _h) / 2;
				_innerPanel.y = _y;
			}
			
			_innerPanel.width = _w;
			_innerPanel.height = _h;
			
			_selected = new DrawRectangle(_w, _h);
			_selected.drawRect(0, 0, CONST::TILED, CONST::TILED);
			_selected.visible = false;
			
			_innerPanel.content.addChild(_backgroundLayer);
			_innerPanel.content.addChild(_objectLayer);
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
			_innerPanel.addEventListener(MouseEvent.MOUSE_DOWN, onLeftDown);
			_innerPanel.addEventListener(MouseEvent.MOUSE_UP, onLeftUp);
			_innerPanel.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightDown);
			_innerPanel.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightUp);
			
			zoom = Registry.zoom;
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
			else if (_isLeftDown && _selected.visible && _selected.rectangle.contains(ev.localX, ev.localY)) {
				if (!_alreadyPut)
					onClick(ev);
				_alreadyPut = true;
			}
			else if (_selected && _selected.visible && !ev.shiftKey) {
				var _x:int;
				var _y:int;
				_x = ev.localX / CONST::TILED;
				_y = ev.localY / CONST::TILED;
				if (_x >= _widthInTiles)
					_x--;
				if (_y >= _heightInTiles)
					_y--;
				_x = _x * CONST::TILED;
				_y = _y * CONST::TILED;
				_selected.moveTo(_x, _y);
				_alreadyPut = false;
			}
		}
		private function onMouseOver(ev:MouseEvent):void {
			_selected.visible = true;
			if (ev.buttonDown)
				_isLeftDown = true;
		}
		private function onMouseOut(ev:MouseEvent):void {
			if (_isMoving)
				onMiddleUp(null);
			if (_selected)
				_selected.visible = false;
			_isLeftDown = false;
			_alreadyPut = false;
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
			
			src = Registry.curPalette.palette;
			srcRect = Registry.curPalette.rectangle;
			dstRect = _selected.rectangle;
			
			srcArr = Registry.curPalette.array;
			tw = srcRect.width / CONST::TILED;
			
			if (_curLayer == 0) {
				bmd = _backgroundLayer.bitmapData;
				tm = _backgroundLayer;
			}
			else if (_curLayer == 1) {
				bmd = _objectLayer.bitmapData;
				tm = _objectLayer;
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
					tm.editCSV(srcArr, _dstPoint.x/CONST::TILED, _dstPoint.y/CONST::TILED, srcRect.width/CONST::TILED, srcRect.height/CONST::TILED, tw);
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
			if (!(tm is Objectmap))
				tm.updateAutotile();
		bmd.unlock();
		}
		private function onLeftDown(ev:MouseEvent):void {
			if (!_isLeftDown) {
				_isLeftDown = true;
				onClick(ev);
			}
		}
		private function onLeftUp(ev:MouseEvent):void {
			_isLeftDown = false;
			_alreadyPut = false;
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
			
			_fromX /= CONST::TILED;
			_fromY /= CONST::TILED;
			_fromX = _fromX*CONST::TILED;
			_fromY = _fromY*CONST::TILED;
			
			_toX = _toX / CONST::TILED;
			_toY = _toY / CONST::TILED;
			_toX = _toX*CONST::TILED + CONST::TILED;
			_toY = _toY*CONST::TILED + CONST::TILED;
			
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
			_objectLayer.visible = true;
			_backgroundLayer.alpha = 1;
			_objectLayer.alpha = 1;
			
			if (_layerMode == 0) {
				_backgroundLayer.visible = false;
				_objectLayer.visible = false;
			}
			else if (_layerMode == 1) {
				_backgroundLayer.alpha = 0.5;
				_objectLayer.alpha = 0.5;
			}
			
			if (_layerMode != 2) {
				if (_curLayer == 0) {
					_backgroundLayer.visible = true;
					_backgroundLayer.alpha = 1.0;
				}
				else if (_curLayer == 1) {
					_objectLayer.visible = true;
					_objectLayer.alpha = 1.0;
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
		
		public function get backgroundExportData():String {
			if (!_backgroundLayer)
				return null;
			return _backgroundLayer.exportData;
		}
		public function get backgroundData():String {
			if (!_backgroundLayer)
				return null;
			return _backgroundLayer.data;
		}
		public function setBackgroundData(val:Array):void {
			_backgroundLayer.setData(val);
		}
		public function get objectData():String {
			return _objectLayer.data;
		}
		public function setObjectData(val:Array):void {
			_objectLayer.setData(val);
		}
		public function get widthInTiles():int {
			return _widthInTiles;
		}
		public function get heightInTiles():int {
			return _heightInTiles;
		}
		
		public function set zoom(val:int):void {
			_innerPanel.scaleX = val;
			_innerPanel.scaleY = val;
			_zoom = val;
			
			centerOnScreen();
		}
		public function centerOnScreen():void {
			var _w:int;
			var _h:int;
			var val:int = _zoom;
			
			_w = widthInTiles * CONST::TILED * val;
			if (_w > width)
				_innerPanel.x = 0;
			else {
				var _x:int = (width - _w) / 2;
				_innerPanel.x = _x;
			}
			_h = heightInTiles * CONST::TILED * val;
			if (_h > height)
				_innerPanel.y = 0;
			else {
				var _y:int = (height - _h) / 2;
				_innerPanel.y = _y;
			}
			
			update();
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			if (_innerPanel)
				zoom = _zoom;
		}
		override public function set height(value:Number):void {
			super.height = value;
			if (_innerPanel)
				zoom = _zoom;
		}
	}
}
