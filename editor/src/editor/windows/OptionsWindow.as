package editor.windows {
	
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import editor.utils.Registry;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class OptionsWindow extends Window {
		
		private var __i__:uint = 0;
		private const GRID:uint = __i__++;
		private const WORKING:uint = __i__++;
		private const TRANSLUCENT:uint = __i__++;
		private const OPAQUE:uint = __i__++;
		private const LENGTH:uint = __i__++;
		
		private var _buttons:Vector.<PushButton>;
		
		public function OptionsWindow() {
			var _x:Number;
			var _y:Number;
			var i:int;
			
			super(null, 0, 0, "Options");
			hasCloseButton = true;
			visible = false;
			
			_buttons = new Vector.<PushButton>();
			
			i = 0;
			_y = 10;
			while (i < LENGTH) {
				var bt:PushButton;
				var label:Label;
				switch(i) {
					case GRID: {
						_x = 10;
						label = new Label(this, _x, _y, "Grid visibility");
						_x += label.width + 5;
						bt = new PushButton(this, _x, _y, "ON", onGrid);
						bt.width /= 3;
						if (width < _x + bt.width + 10)
							width = _x + bt.width + 10;
						_y += bt.height + 10;
					} break;
					case WORKING: {
						_x = 10;
						label = new Label(this, _x, _y, "Layer visibility:");
						_x = 16;
						_y += label.height + 5;
						bt = new PushButton(this, _x, _y, "Only current", onCurrent);
						if (width < _x + bt.width + 10)
							width = _x + bt.width + 10;
						bt.toggle = true;
						_y += bt.height + 5;
					} break;
					case TRANSLUCENT: {
						bt = new PushButton(this, _x, _y, "Translucent layers", onTranslucent);
						bt.toggle = true;
						_y += bt.height + 5;
					} break;
					case OPAQUE: {
						bt = new PushButton(this, _x, _y, "Opaque layers", onOpaque);
						bt.toggle = true;
						_y += bt.height + 5;
					} break;
				}
				_buttons.push(bt);
				i++;
			}
			height = _y + 25;
			
			_buttons[OPAQUE].selected = true;
		}
		public function destroy():void {
			if (numChildren > 0)
				removeChildren();
			while (_buttons.length > 0)
				_buttons.pop();
		}
		
		public function open():void {
			visible = true;
		}
		override protected function onClose(event:MouseEvent):void {
			super.onClose(event);
			visible = false;
		}
		
		public function get isGridVisible():Boolean {
			return _buttons[GRID].label == "ON";
		}
		
		private function onGrid(ev:MouseEvent):void {
			if (_buttons[GRID].label == "ON")
				_buttons[GRID].label = "OFF";
			else if (_buttons[GRID].label == "OFF")
				_buttons[GRID].label = "ON";
			
			Registry.mapPanel.gridVisibility = isGridVisible;
		}
		private function onCurrent(ev:MouseEvent):void {
			_buttons[WORKING].selected = true;
			_buttons[TRANSLUCENT].selected = false;
			_buttons[OPAQUE].selected = false;
			Registry.mapPanel.setWorkingOnly();
		}
		private function onTranslucent(ev:MouseEvent):void {
			_buttons[WORKING].selected = false;
			_buttons[TRANSLUCENT].selected = true;
			_buttons[OPAQUE].selected = false;
			Registry.mapPanel.setTranslucent();
		}
		public function onOpaque(ev:MouseEvent):void {
			_buttons[WORKING].selected = false;
			_buttons[TRANSLUCENT].selected = false;
			_buttons[OPAQUE].selected = true;
			Registry.mapPanel.setOpaque();
		}
	}
}
