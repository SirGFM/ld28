package states {
	import objs.AnimatedBG;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import utils.GFX;
	import utils.SFX;
	import utils.textmenu.Option;
	import utils.textmenu.TextMenu;
	
	/**
	 * ...
	 * @author 
	 */
	public class Musicboxstate extends FlxState {
		
		private const sfx:SFX = SFX.self;
		private const MENU:String = "01 - Menu";
		private const INTRO:String = "02 - Intro";
		private const BEGIN:String = "03 - Beggining";
		private const HARDER:String = "04 - The bat";
		private const LATER:String = "05 - Torward the exit";
		private const TREASURE:String = "06 - Treasure";
		private const BADEND:String = "07 - Bad End";
		private const WIN:String = "08 - Win";
		private const BACK:String = "Back";
		
		private var desc:FlxText;
		
		private var animBG:AnimatedBG;
		
		public function Musicboxstate(AnimBG:AnimatedBG = null):void {
			super();
			animBG = AnimBG;
		}
		
		override public function create():void {
			FlxG.bgColor = 0xff736585;
			FlxG.flash(0xffffffff, 0.5);
			super.create();
			
			animBG.setBG(AnimatedBG.MUSICBOX);
			
			var s:FlxSprite = new FlxSprite(109, 15+8, GFX.self.musicboxGFX);
			var tm:TextMenu = new TextMenu(64+8, textmenuCallback);
			
			var X:Number = 18;
			var o:Option;
			o = new Option(MENU, 8, 0xffedde8d, 0x88b48e6d);
			o.x = X;
			o.alignment = "left";
			tm.addOption(o);
			o = new Option(INTRO, 8, 0xffedde8d, 0x88b48e6d);
			o.x = X;
			o.alignment = "left";
			tm.addOption(o);
			o = new Option(BEGIN, 8, 0xffedde8d, 0x88b48e6d);
			o.x = X;
			o.alignment = "left";
			tm.addOption(o);
			o = new Option(HARDER, 8, 0xffedde8d, 0x88b48e6d);
			o.x = X;
			o.alignment = "left";
			tm.addOption(o);
			o = new Option(LATER, 8, 0xffedde8d, 0x88b48e6d);
			o.x = X;
			o.alignment = "left";
			tm.addOption(o);
			o = new Option(TREASURE, 8, 0xffedde8d, 0x88b48e6d);
			o.x = X;
			o.alignment = "left";
			tm.addOption(o);
			o = new Option(BADEND, 8, 0xffedde8d, 0x88b48e6d);
			o.x = X;
			o.alignment = "left";
			tm.addOption(o);
			o = new Option(WIN, 8, 0xffedde8d, 0x88b48e6d);
			o.x = X;
			o.alignment = "left";
			tm.addOption(o);
			o = new Option(BACK, 8, 0xffedde8d, 0x88b48e6d);
			o.x = X;
			o.alignment = "left";
			tm.addOption(o);
			
			desc = new FlxText(185-16, 73, 94+16, "");
			desc.setFormat(null, 8, 0xffedde8d, null, 0x88b48e6d);
			desc.visible = false;
			
			add(animBG);
			add(s);
			add(tm);
			add(desc);
		}
		override public function destroy():void {
			remove(animBG);
			super.destroy();
			desc = null;
		}
		
		override public function update():void {
			if (FlxG.keys.justPressed("ESCAPE")) {
				FlxG.switchState(new Menustate(true));
				active = false;
				return;
			}
			super.update();
		}
		
		private function textmenuCallback(tm:TextMenu):void {
			if (!tm.selected || !active) {
				sfx.bep();
				return;
			}
			sfx.beeep();
			if (tm.currentOpt == MENU)
				sfx.playMenuSong();
			else if (tm.currentOpt == INTRO)
				sfx.playIntroSong();
			else if (tm.currentOpt == BEGIN)
				sfx.playBeginSong();
			else if (tm.currentOpt == HARDER)
				sfx.playHarderSong();
			else if (tm.currentOpt == LATER)
				sfx.playLaterSong();
			else if (tm.currentOpt == TREASURE)
				sfx.playTreasureSong();
			else if (tm.currentOpt == BADEND)
				sfx.playBadendSong();
			else if (tm.currentOpt == WIN)
				sfx.playWinSong();
			else if (tm.currentOpt == BACK) {
				FlxG.switchState(new Menustate(true, animBG));
				active = false;
				tm.active = false;
			}
			showDescription(tm.currentOpt);
		}
		
		private function showDescription(option:String):void {
			if (option == MENU)
				desc.text = "Almost last songs to be written, since I was going to use the \"game over\" in it's place.\nThis one worked out a lot better.  It's just a short loop, but I find it great.";
			else if (option == INTRO)
				desc.text = "This is a calm song with a too long intro. I though it was better to keep the \"first levels\"'s melody simple, since I wanted the player to focus on the timing (and a fast drum could annoy).";
			else if (option == BEGIN)
				desc.text = "I simply find this bass somewhat funny. It may not fit too well, but I went for a exploratory felling mixed with a \"those are the first few real steps\"... Does this make any sense?";
			else if (option == HARDER)
				desc.text = "A mod of the previous theme, befitting that damn bat! They have appeared before, but I think that they get so much more annoying from this point onward.";
			else if (option == LATER)
				desc.text = "This is it. From here on things get way more hectic, though there's just a little more ahead. And that fast drum! It really pushes you forward, right?";
			else if (option == TREASURE)
				desc.text = "\"Is this really a song?\" is my own reaction to this. Since there's nothing to do in those rooms, I thought it was fitting to make it a calm theme... Maybe it's too calm?";
			else if (option == BADEND)
				desc.text = "You did it! You escaped the dungeon alive... but without the treasure you wanted. :( It's really this kind of song, right? It could also be used for a game over screen (if there was one).";
			else if (option == WIN)
				desc.text = "This one isn't much of a fanfare, but it delivers the message. The game is over and you got what you wanted... but I wish this song were longer... I find it really cool!";
			desc.visible = true;
		}
	}
}
