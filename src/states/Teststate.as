package states {
	
	import editor.MainWindow;
	import flash.events.Event;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Teststate extends NewPlaystate {
		
		public function Teststate() {
			super(false);
			exists = false;
			
			reg.editor = new MainWindow(FlxG.stage, FlxG.stage.stageWidth, FlxG.stage.stageHeight, testLevel, testExit);
			reg.editor.visible = true;
		}
		override public function destroy():void {
			super.destroy();
			
			reg.editor.destroy();
			FlxG.stage.removeChild(reg.editor)
			reg.editor = null;
		}
		
		override public function update():void {
			if (FlxG.keys.justPressed("ESCAPE")) {
				if (exists) {
					exists = false;
					reg.editor.visible = true;
				}
				else
					FlxG.switchState(new Menustate());
				return;
			}
			if (exists) {
				if (FlxG.mouse.justPressed()) {
					iniX = reg.player.x = FlxG.mouse.x;
					iniY = reg.player.y = FlxG.mouse.y;
					reg.player.alive = true;
					reg.player.exists = true;
				}
				else if (reg.resetReq) {
					reg.player.kill();
					reg.resetReq = false;
				}
				else if (switching) {
					switching = false;
					exists = false;
					reg.editor.visible = true;
					reg.player.recycle(4, ["objs.Hero", 0, 13, "Hero"]);
					reg.player.x = iniX;
					reg.player.y = iniY;
				}
				super.update();
			}
		}
		
		override public function draw():void {
			if (exists)
				super.draw();
		}
		
		override public function onExit(doSave:Boolean = true):void {
			if (!reg.player.alive)
				super.onExit(false);
			else {
				exists = false;
				reg.editor.visible = true;
			}
		}
		
		public function testLevel(e:Event = null):void {
			map_loader.editorTilemap = reg.editor.tilemap;
			if (map_loader.editorTilemap == null)
				return;
			map_loader.editorObjects = reg.editor.objects;
			
			next = -10;
			reg.transition.kill();
			
			super.onExit(false);
			reg.editor.visible = false;
			exists = true;
		}
		
		public function testExit(e:Event = null):void {
			FlxG.switchState(new Menustate());
			FlxG.stage.focus = null;
		}
	}
}
