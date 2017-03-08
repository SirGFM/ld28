package editor.windows {
	
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author GFM
	 */
	public class ObjectListWindow extends Window {
		
		private var _list:ObjectList;
		private var _text:Text;
		private var _objects:Vector.<MyListItem>;
		
		private var xLabel:Label;
		private var yLabel:Label;
		private var strid:InputText;
		private var commonArr:Array;	// left | right
		private var helpArr:Array;		// left | right | he | she
		private var facingArr:Array;	// left | right | up | down
		private var platformArr:Array;	// width | time
		private var exitArr:Array;		// width | height | next
		
		private var _defArr:Array;
		private var _tmp:MyListItem;
		private var _curObject:MyListItem;
		
		public function ObjectListWindow() {
			super(null, 0, 0, "Objects");
			
			var w:int;
			var i:int;
			var _x:Number = 10;
			var _y:Number = 10;
			var tmpW:int;
			var tmpComponent:Component;
			var tmpLabel:Component;
			
			_list = new ObjectList(this, _x, _y);
			_list.autoHideScrollBar = true;
			_list.parentCallback = onSelected;
			w = _list.width;
			_list.width *= 1.5;
			_list.height += 40;
			
			_tmp = new MyListItem();
			
			_x += _list.width + 10;
			_y += 10;
			
			xLabel = new Label(this, _x, _y, "X: ");
			yLabel = new Label(this, _x, _y, "Y: ");
			_y += xLabel.height + 10;
			tmpW = (new Label(this, _x, _y, "ID: ")).width;
			strid = new InputText(this, _x + tmpW, _y, "", onStrID);
			strid.width = 100;
			yLabel.x = strid.x + strid.width / 2 - 10;
			_y += strid.height + 10;
			
			commonArr = [];		// left | right
			helpArr = [];		// left | right | he | she
			facingArr = [];		// left | right | up | down
			platformArr = [];	// width | time
			exitArr = [];		// width | height | next
			
			tmpComponent = new Label(this, xLabel.x, _y, "Left: ");
			tmpComponent.visible = false;
			commonArr.push(tmpComponent);
			helpArr.push(tmpComponent);
			facingArr.push(tmpComponent);
			exitArr.push(tmpComponent);
			platformArr.push(tmpComponent);
			
			tmpComponent = new Label(this, yLabel.x, _y, "Right: ");
			tmpComponent.visible = false;
			commonArr.push(tmpComponent);
			helpArr.push(tmpComponent);
			facingArr.push(tmpComponent);
			exitArr.push(tmpComponent);
			platformArr.push(tmpComponent);
			
			tmpComponent = new Label(this, xLabel.x, _y+10+tmpComponent.height, "He: ");
			tmpComponent.visible = false;
			helpArr.push(tmpComponent);
			
			tmpComponent = new Label(this, xLabel.x, _y+10+tmpComponent.height, "Up: ");
			tmpComponent.visible = false;
			facingArr.push(tmpComponent);
			exitArr.push(tmpComponent);
			
			tmpComponent = new Label(this, yLabel.x, _y+10+tmpComponent.height, "She: ");
			tmpComponent.visible = false;
			helpArr.push(tmpComponent);
			
			tmpComponent = new Label(this, yLabel.x, _y+10+tmpComponent.height, "Down: ");
			tmpComponent.visible = false;
			facingArr.push(tmpComponent);
			exitArr.push(tmpComponent);
			
			tmpComponent = new Label(this, xLabel.x, _y+(10+tmpComponent.height)*2, "Next: ");
			tmpComponent.visible = false;
			exitArr.push(tmpComponent);
			
			i = 0;
			while (i < 4) {
				tmpLabel = facingArr[i];
				var bt:PushButton = new PushButton(this, tmpLabel.x + tmpLabel.width, tmpLabel.y, "", onButton);
				bt.visible = false;
				bt.toggle = true;
				bt.width = bt.height;
				if (i < 2) {
					commonArr.push(bt);
					platformArr.push(bt);
				}
				helpArr.push(bt);
				facingArr.push(bt);
				exitArr.push(bt);
				i++;
			}
			
			tmpComponent = new Label(this, xLabel.x, _y+10+tmpComponent.height, "Width: ");
			tmpComponent.visible = false;
			platformArr.push(tmpComponent);
			
			tmpComponent = new Label(this, xLabel.x, _y+(10+tmpComponent.height)*2, "Time: ");
			tmpComponent.visible = false;
			platformArr.push(tmpComponent);
			
			i = 0;
			while (i < 3) {
				var tmpNS:NumericStepper;
				if (i == 0) {
					tmpLabel = platformArr[4];
					tmpNS = new NumericStepper(this, tmpLabel.x + tmpLabel.width, tmpLabel.y, onWidth);
				}
				else if (i == 1) {
					tmpLabel = platformArr[5];
					tmpNS = new NumericStepper(this, tmpLabel.x + tmpLabel.width, tmpLabel.y, onTime);
				}
				else if (i == 2) {
					tmpLabel = exitArr[4];
					tmpNS = new NumericStepper(this, tmpLabel.x + tmpLabel.width, tmpLabel.y, onNext);
				}
				tmpNS.visible = false;
				tmpNS.minimum = 0;
				if (i < 2)
					platformArr.push(tmpNS);
				else
					exitArr.push(tmpNS);
				i++;
			}
			
			width = strid.x + strid.width + 10;
			height = _list.height + 20 + _titleBar.height;
			hasCloseButton = true;
			visible = false;
			
			_objects = new Vector.<MyListItem>();
			_curObject = null;
		}
		public function destroy():void {
			if (numChildren > 0)
				removeChildren();
			_list.destroy();
			_list = null;
			_text = null;
			while (_objects.length > 0)
				_objects.pop().destroy();
			_objects = null;
			
			xLabel = null;
			yLabel = null;
			strid = null;
			
			while (commonArr.length > 0)
				commonArr.pop();
			commonArr = null;
			while (helpArr.length > 0)
				helpArr.pop();
			helpArr = null;
			while (facingArr.length > 0)
				facingArr.pop();
			facingArr = null;
			while (platformArr.length > 0)
				platformArr.pop();
			platformArr = null;
			while (exitArr.length > 0)
				exitArr.pop();
			exitArr = null;
			
			if (_defArr)
				while (_defArr.length > 0)
					_defArr.pop();
			_defArr = null;
			
			if (_tmp)
				_tmp.destroy();
			_tmp = null;
			
			if (_curObject)
				_curObject.destroy();
			_curObject = null;
		}
		
		override protected function onClose(event:MouseEvent):void {
			super.onClose(event);
			visible = false;
			_curObject = null
		}
		
		public function get exportData():String {
			var str:String = "";
			var i:int = 0;
			var l:int = _objects.length;
			
			while (i < l) {
				var obj:MyListItem = _objects[i];
				
				str += obj.data;
				
				i++;
				if (i < l)
					str += "\n";
			}
			
			return str;
		}
		public function get data():String {
			var str:String = "";
			var i:int = 0;
			var l:int = _objects.length;
			
			while (i < l) {
				var obj:MyListItem = _objects[i];
				
				str += obj.data;
				
				i++;
				if (i < l)
					str += ",";
			}
			
			return str;
		}
		public function setData(val:Array):void {
			var i:int = 0;
			var j:int = -1;
			var l:int = val.length;
			var obj:MyListItem;
			
			var Name:String = null;
			var X:int = int.MIN_VALUE;
			var Y:int = int.MIN_VALUE;
			
			while (i < l) {
				var str:String = val[i];
				
				if (str.substr(0, (("objs.").length)) == "objs.") {
					if (j != -1)
						_list.addItem(obj.name);
					
					Name = str;
					X = int.MIN_VALUE;
					Y = int.MIN_VALUE;
					j++;
				}
				else if (X == int.MIN_VALUE)
					X = int(str);
				else if (Y == int.MIN_VALUE) {
					Y = int(str);
					addObject(Name, X, Y, false, true);
					obj = _objects[j];
				}
				else
					obj.addDetail(str);
				i++;
			}
			if (j != -1)
				_list.addItem(obj.name);
		}
		
		public function clear():void {
			_list.removeAll();
			while (_objects.length > 0)
				_objects.pop().destroy();
		}
		
		public function addObject(Name:String, X:int, Y:int, doAdd:Boolean = true, doLoad:Boolean = false):void {
			var li:MyListItem = new MyListItem(doLoad);
			li.name = Name;
			li.x = X;
			li.y = Y;
			
			_objects.push(li);
			if (doAdd)
				_list.addItem(li.name);
		}
		public function removeObject(Name:String, X:int, Y:int):void {
			var i:int = -1;
			while (++i < _objects.length) {
				var _obj:MyListItem = _objects[i];
				if (_obj.name == Name && _obj.x == X && _obj.y == Y)
					break;
			}
			if (i >= _objects.length)
				return;
			
			_objects.splice(i, 1);
			_list.removeItemAt(i);
		}
		
		private function onNext(e:Event):void {
			if (_curObject == null)
				return;
			var ns:NumericStepper = e.target as NumericStepper;
			_curObject.next = ns.value;
		}
		private function onTime(e:Event):void {
			if (_curObject == null)
				return;
			var ns:NumericStepper = e.target as NumericStepper;
			_curObject.time = ns.value;
		}
		private function onWidth(e:Event):void {
			if (_curObject == null)
				return;
			var ns:NumericStepper = e.target as NumericStepper;
			_curObject.width = ns.value;
		}
		private function onButton(e:Event):void {
			if (_curObject == null)
				return;
			var bt:PushButton = e.target as PushButton;
			var max:int = 4;
			if (_defArr == commonArr || _defArr == platformArr)
				max = 2;
			var i:int = 0;
			while (i < max) {
				if (_defArr == exitArr) {
					if (bt != _defArr[max + i + 1]) {
						(_defArr[max + i + 1] as PushButton).selected = false;
						i++;
						continue;
					}
					else if (i == 0)
						_curObject.frame = "left";
					else if (i == 1)
						_curObject.frame = "right";
					else if (i == 2)
						_curObject.frame = "up";
					else if (i == 3)
						_curObject.frame = "down";
					(_defArr[max + i + 1] as PushButton).selected = true;
				}
				else if (bt == _defArr[max + i]) {
					if (i == 0)
						_curObject.frame = "left";
					else if (i == 1)
						_curObject.frame = "right";
					else if (i == 2) {
						if (_defArr == helpArr)
							_curObject.frame = "he";
						else if (_defArr == facingArr)
							_curObject.frame = "up";
					}
					else if (i == 3) {
						if (_defArr == helpArr)
							_curObject.frame = "she";
						else if (_defArr == facingArr)
							_curObject.frame = "down";
					}
					(_defArr[max + i] as PushButton).selected = true;
				}
				else
					(_defArr[max + i] as PushButton).selected = false;
				i++;
			}
		}
		private function onStrID(e:Event):void {
			if (_curObject == null)
				return;
			var id:String = (e.target as InputText).text;
			_curObject.id = id;
			e.stopImmediatePropagation();
		}
		private function onSelected(i:int):Boolean {
			if (_objects.length == 0 || i == -1 || i >= _objects.length)
				return false;
			
			i += _list.scrollValue;
			
			_curObject = _objects[i];
			var arr:Array = null;
			
			xLabel.text = "X: " + _curObject.x.toString();
			yLabel.text = "Y: " + _curObject.y.toString();
			strid.text = _curObject.id;
			
			var name:String = _curObject.name;
			if (name.indexOf("Bat") >= 0 || name.indexOf("RedSnake") >= 0 || name.indexOf("Snake") >= 0 || name.indexOf("Turn") >= 0) {
				arr = commonArr;
			}
			else if (name.indexOf("Spark") >= 0) {
				arr = facingArr;
			}
			else if (name.indexOf("Help") >= 0) {
				arr = helpArr;
			}
			else if (name.indexOf("Exit") >= 0) {
				arr = exitArr;
			}
			else if (name.indexOf("Platform") >= 0) {
				arr = platformArr;
			}
			
			var cmp:Component;
			if (arr != _defArr)
				for each (cmp in _defArr) {
					cmp.visible = false;
				}
			if (arr == commonArr) {
				(arr[3] as PushButton).selected = false;
				(arr[2] as PushButton).selected = false;
				if (_curObject.frame == "left")
					(arr[2] as PushButton).selected = true;
				else if (_curObject.frame == "right")
					(arr[3] as PushButton).selected = true;
			}
			else if (arr == facingArr) {
				(arr[4] as PushButton).selected = false;
				(arr[5] as PushButton).selected = false;
				(arr[6] as PushButton).selected = false;
				(arr[7] as PushButton).selected = false;
				if (_curObject.frame == "left")
					(arr[4] as PushButton).selected = true;
				else if (_curObject.frame == "right")
					(arr[5] as PushButton).selected = true;
				else if (_curObject.frame == "up")
					(arr[6] as PushButton).selected = true;
				else if (_curObject.frame == "down")
					(arr[7] as PushButton).selected = true;
			}
			else if (arr == helpArr) {
				(arr[4] as PushButton).selected = false;
				(arr[5] as PushButton).selected = false;
				(arr[6] as PushButton).selected = false;
				(arr[7] as PushButton).selected = false;
				if (_curObject.frame == "left")
					(arr[4] as PushButton).selected = true;
				else if (_curObject.frame == "right")
					(arr[5] as PushButton).selected = true;
				else if (_curObject.frame == "he")
					(arr[6] as PushButton).selected = true;
				else if (_curObject.frame == "she")
					(arr[7] as PushButton).selected = true;
			}
			else if (arr == exitArr) {
				(arr[5] as PushButton).selected = false;
				(arr[6] as PushButton).selected = false;
				(arr[7] as PushButton).selected = false;
				(arr[8] as PushButton).selected = false;
				if (_curObject.frame == "left")
					(arr[5] as PushButton).selected = true;
				else if (_curObject.frame == "right")
					(arr[6] as PushButton).selected = true;
				else if (_curObject.frame == "up")
					(arr[7] as PushButton).selected = true;
				else if (_curObject.frame == "down")
					(arr[8] as PushButton).selected = true;
				(arr[9] as NumericStepper).value = _curObject.next;
			}
			else if (arr == platformArr) {
				(arr[2] as PushButton).selected = false;
				(arr[3] as PushButton).selected = false;
				if (_curObject.frame == "left")
					(arr[2] as PushButton).selected = true;
				else if (_curObject.frame == "right")
					(arr[3] as PushButton).selected = true;
				(arr[6] as NumericStepper).value = _curObject.width;
				(arr[7] as NumericStepper).value = _curObject.time;
			}
			if (arr != _defArr)
				for each (cmp in arr) {
					cmp.visible = true;
				}
			
			_defArr = arr;
			
			return true;
		}
	}
}

import com.bit101.components.List;
import com.bit101.components.ListItem;
import flash.display.DisplayObjectContainer;
import flash.events.Event;

class ObjectList extends List {
	
	public var parentCallback:Function = null;
	
	public function ObjectList(parent:DisplayObjectContainer, xpos:Number, ypos:Number) {
		super(parent, xpos, ypos);
	}
	public function destroy():void {
		parentCallback = null;
		while (_items.length > 0)
			_items.pop();
		_items = null;
		if (_itemHolder.numChildren > 0)
			_itemHolder.removeChildren();
		_itemHolder = null;
	}
	
	public function modifyIndex(i:int, str:String):void {
		_items[i] = str;
		return;
		
		var li:ListItem = _items.getChildAt(i) as ListItem;
		
		if (!li)
			return;
		
		li.data = str;
		invalidate();
	}
	
	override protected function onSelect(event:Event):void {
		var li:ListItem = event.target as ListItem;
		if (li == null)
			return;
		
		var i:int = _itemHolder.getChildIndex(li);
		
		// Yup, I created a class only for this =D
		if (parentCallback != null)
			if (!parentCallback(i))
				return;
		
		// YEEEEEEAAAAAAHHHHHHHHHHHHHHHHH
		super.onSelect(event);
	}
}

class MyListItem extends Object {
	
	private var _name:String;
	public var x:int;
	public var y:int;
	public var id:String;
	private var _frame:String;
	public var width:int;
	public var time:int;
	public var next:int;
	
	public var loading:int;
	
	public function MyListItem(load:Boolean = false):void {
		super();
		width = 0;
		time = 0;
		next = 0;
		frame = "left";
		
		if (load)
			loading = 0;
		else
			loading = -1;
	}
	public function destroy():void {
		_name = null;
		id = null;
		_frame = null;
	}
	
	public function addDetail(val:String):void {
		switch(loading) {
			case -1: return;
			case 0: id = val; break;
			case 1:
				frame = val;
				if (name.indexOf("Exit") >= 0) {
					if (frame == "left")
						x++;
					else if (frame == "right")
						x--;
					else if (frame == "up")
						y++;
					else if (frame == "down")
						y--;
				}
			break;
			case 2:
				if (name.indexOf("Platform") >= 0)
					width = int(val);
			break;
			case 3:
				if (name.indexOf("Platform") >= 0)
					time = int(val);
			break;
			case 4:
				if (name.indexOf("Exit") >= 0)
					next = int(val);
			break;
			default:
				return;
		}
		loading++;
	}
	
	public function get exitX():int {
		if (frame == "left")
			return x-1;
		else if (frame == "right")
			return x+1;
		return x;
	}
	public function get exitY():int {
		if (frame == "up")
			return y-1;
		else if (frame == "down")
			return y+1;
		return y;
	}
	
	public function set frame(val:String):void {
		_frame = val;
	}
	public function get frame():String {
		return _frame;
	}
	
	public function set name(val:String):void {
		_name = val;
		if (name.indexOf("helper") >= 0)
			id = name.split(".")[2];
		else
			id = name.split(".")[1];
	}
	public function get name():String {
		return _name;
	}
	
	public function get data():String {
		var str:String = "";
		
		str += name+","+x.toString()+","+y.toString()+","+id;
		
		if (name.indexOf("Bat") >= 0 || name.indexOf("Help") >= 0 || name.indexOf("RedSnake") >= 0 || name.indexOf("Snake") >= 0 || name.indexOf("Spark") >= 0 || name.indexOf("Turn") >= 0) {
			str += ","+frame;
		}
		else if (name.indexOf("Exit") >= 0) {
			str = name+","+exitX.toString()+","+exitY.toString()+","+id;
			str += ","+frame;
			if (frame == "left" || frame == "right")
				str += ",1,3,";
			else if (frame == "up" || frame == "down")
				str += ",3,1,";
			str += next.toString();
		}
		else if (name.indexOf("Platform") >= 0) {
			str += ","+frame+","+width.toString()+","+time.toString();
		}
		
		return str;
	}
}
