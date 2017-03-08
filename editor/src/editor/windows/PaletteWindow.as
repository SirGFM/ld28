package editor.windows {
	
	import com.bit101.components.Panel;
	import com.bit101.components.Window;
	import editor.utils.DrawRectangle;
	import editor.utils.Grid;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import utils.GFX;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class PaletteWindow extends Window {
		
		private var __panel:Panel
		private var _tileset:Bitmap;
		private var _selected:DrawRectangle;
		private var _grid:Grid;
		private var _isMouseDown:Boolean;
		private var _fromX:int;
		private var _fromY:int;
		private var _toX:int;
		private var _toY:int;
		
		private var _offset:int;
		private var _zoom:int;
		
		public function PaletteWindow(gfx:Bitmap = null, Offset:int = 6) {
			var tmp:Panel;
			var rect:Rectangle;
			var bmd:BitmapData;
			var i:int;
			
			super(null, 0, 0, "Palette");
			
			// load tileset
			if (!gfx)
				_tileset = new GFX.tileset;
			else
				_tileset = gfx;
			
			// create holder for bitmap(tileset)
			__panel = new Panel(this, 0, 0);
			__panel.x = 10;
			__panel.y = 10;
			__panel.width = _tileset.width;
			__panel.height = _tileset.height;
			
			_offset = Offset;
			if (!gfx)
				__panel.height -= _offset * CONST::TILED;
			
			// resize window to fit the bitmap
			width = __panel.width + 20;
			height = __panel.height + 20 + titleBar.height;
			// add close button
			hasCloseButton = true;
			// set invisible
			visible = false;
			
			__panel.addChild(_tileset);
			
			// create grid
			_grid = new Grid(_tileset.width, _tileset.height - _offset * CONST::TILED);
			// add grid
			__panel.addChild(_grid);
			
			// create selected
			_selected = new DrawRectangle(__panel.width, __panel.height);
			_selected.drawRect(0, 0, CONST::TILED, CONST::TILED);
			// add grid
			__panel.addChild(_selected);
			// add events for selecting from palette
			_isMouseDown = false;
			
			_zoom = 1;
		}
		public function destroy():void {
			if (numChildren > 0)
				removeChildren();
			if (__panel) {
				if (__panel.hasEventListener(MouseEvent.CLICK))
					__panel.removeEventListener(MouseEvent.CLICK, onMouseClick);
				if (__panel.hasEventListener(MouseEvent.RIGHT_MOUSE_DOWN))
					__panel.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseDown);
				if (__panel.hasEventListener(MouseEvent.RIGHT_MOUSE_UP))
					__panel.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, onMouseUp);
				if (__panel.hasEventListener(MouseEvent.MOUSE_MOVE))
					__panel.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				__panel = null;
			}
			if (_tileset) {
				_tileset.bitmapData.dispose();
				_tileset.bitmapData = null;
				_tileset = null;
			}
			if (_selected)
				_selected.destroy();
			_selected = null;
			if (_grid)
				_grid.destroy();
			_grid = null;
		}
		
		public function open():void {
			visible = true;
			_selected.drawRect(0, 0, CONST::TILED, CONST::TILED);
			_isMouseDown = false;
			__panel.addEventListener(MouseEvent.CLICK, onMouseClick);
			__panel.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseDown);
			__panel.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onMouseUp);
			__panel.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		override protected function onClose(event:MouseEvent):void {
			super.onClose(event);
			visible = false;
			__panel.removeEventListener(MouseEvent.CLICK, onMouseClick);
			__panel.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMouseDown);
			__panel.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, onMouseUp);
			__panel.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseClick(ev:MouseEvent):void {
			var _x:int;
			var _y:int;
			
			if (ev.localX >= _tileset.width)
				return;
			else if (ev.localY >= (_tileset.height - _offset*CONST::TILED))
				return;
			
			_x = ev.localX / CONST::TILED;
			_x *= CONST::TILED;
			_y = ev.localY / CONST::TILED;
			_y *= CONST::TILED;
			
			_selected.drawRect(_x, _y, _x+CONST::TILED, _y+CONST::TILED);
		}
		private function onMouseDown(ev:MouseEvent):void {
			if (ev.localX >= _tileset.width)
				return;
			else if (ev.localY >= (_tileset.height - _offset*CONST::TILED))
				return;
			
			_fromX = ev.localX;
			_fromY = ev.localY;
			_isMouseDown = true;
		}
		private function onMouseUp(ev:MouseEvent):void {
			var swt:int;
			
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
			
			_isMouseDown = false;
			_selected.drawRect(_fromX, _fromY, _toX, _toY);
		}
		private function onMouseMove(ev:MouseEvent):void {
			_toX = ev.localX;
			_toY = ev.localY;
			
			if (ev.localX >= _tileset.width)
				_toX = _tileset.width - 1;
			if (ev.localY >= (_tileset.height - _offset*CONST::TILED))
				_toY = _tileset.height - 1;
			
			if (_isMouseDown)
				_selected.drawRect(_fromX, _fromY, _toX, _toY);
		}
		
		public function get array():Array {
			var i:int;
			var j:int;
			var rect:Rectangle = _selected.rectangle;
			var arr:Array = [];
			
			j = 0;
			while (j < rect.height / CONST::TILED) {
				i = 0;
				while (i < rect.width  / CONST::TILED) {
					var item:int;
					item = (j + int(rect.y / CONST::TILED)) * widthInTiles;
					item += i + int(rect.x / CONST::TILED);
					arr.push(item);
					i++;
				}
				j++;
			}
			
			return arr;
		}
		public function get palette():BitmapData {
			return _tileset.bitmapData;
		}
		public function get rectangle():Rectangle {
			return _selected.rectangle;
		}
		public function get widthInTiles():int {
			return _tileset.width / CONST::TILED;
		}
		public function get heightInTiles():int {
			return _tileset.height / CONST::TILED;
		}
		
		public function set zoom(val:int):void {
			__panel.scaleX = val;
			__panel.scaleY = val;
			
			width = __panel.width*val + 20;
			height = __panel.height*val + 20 + titleBar.height;
			_zoom = val;
		}
		
		public function moveSelection(x:int, y:int):void {
			_isMouseDown = false;
			
			var _x:int = _selected.rectangle.x;
			var _y:int = _selected.rectangle.y;
			var _w:int = _selected.rectangle.width;
			var _h:int = _selected.rectangle.height;
			
			if (x < 0)
				if (_x >= 16) {
					_x -= 16;
				}
				else {
					_x = _tileset.width - _w;
				}
			else if (x > 0)
				if (_x + _w <= _tileset.width - 16) {
					_x += 16;
				}
				else {
					_x = 0;
				}
			if (y < 0)
				if (_y >= 16) {
					_y -= 16;
				}
				else {
					_y = _grid.height - _h;
				}
			else if (y > 0)
				if (_y + _h <= _grid.height - 16) {
					_y += 16;
				}
				else {
					_y = 0;
				}
			
			_selected.drawRect(_x, _y, _x+_w, _y+_h);
		}
	}
}
