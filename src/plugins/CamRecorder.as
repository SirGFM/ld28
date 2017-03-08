package plugins {
	
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author 
	 */
	public class CamRecorder extends FlxBasic {
		
		private var max:int;
		private var pos:int;
		private var ba:ByteArray;
		
		public function CamRecorder() {
			super();
			
			ba = new ByteArray();
			pos = 0;
			max = 550;
			
			visible = false;
			
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onSave);
		}
		
		override public function update():void {
			visible = FlxG.keys.SHIFT;
		}
		
		override public function draw():void {
			if (pos >= max) {
				FlxG.log("[CamRecorder] Maximum number of frames reached!");
				active = false;
				visible = false;
				return;
			}
			
			var b:BitmapData = FlxG.camera.buffer;
			
			ba.writeObject(b.getVector(b.rect));
			pos++;
		}
		
		private function onSave(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.F2) {
				var fr:Number = FlxG.framerate;
				var ffr:Number = FlxG.flashFramerate;
				
				FlxG.framerate = 0.5;
				FlxG.flashFramerate = 0.5;
				
				var file:FileReference = new FileReference();
				file.save(ba, "record");
				
				FlxG.framerate = fr;
				FlxG.flashFramerate = ffr;
				
				ba.clear();
				pos = 0;
				active = true;
			}
		}
	}
}
