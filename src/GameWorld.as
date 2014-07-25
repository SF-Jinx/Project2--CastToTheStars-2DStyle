package  
{
	import flash.display.InteractiveObject;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Jinx
	 */
	public class GameWorld extends World 
	{
		
		[Embed(source = "assets/Sossusvlei.jpg")] public static const background_Desert:Class;
		
		private var levelName: String = "Shrine";
		public static var player:Player = new Player();
		private var background:Backdrop;
		private var footpath:Backdrop;
		private var blocker:Backdrop;
		private var e_backdrop:Entity = new Entity;
		private var e_blocker:Entity = new Entity;
		private var goal:Entity = new Entity;
		private var spawnX:int = 0;
		private var spawnY:int = 0;
		
		private var cameraTweenX:VarTween = new VarTween();
		private var cameraTweenY:VarTween = new VarTween();
		
		public function GameWorld() 
		{
			add(player);
			player.x = 0;
			player.y = 0;
			levelLoader();
			
			//create dem tweens
			addTween(cameraTweenX, true);
			addTween(cameraTweenY, true);
			
/*			music1.play();
			music2.play();
			music2.volume = 0;*/
//			music3.loop();
		}
		
		private var pan:Number = 0;
		
		override public function update():void
		{
			super.update();
			musicPlayer();
			cameraHandler();
			
			pan = ((background.width/2) - player.x)/background.width;
			music3.pan = pan;
			//trace(background.width);
			trace(pan);
		}
		
		private var camX:int = 0;
		private var camY:int = 0;
		private var cameraOffset:int = 0//50;
		private var cameraSpeed: int = 2;
		
		private function cameraHandler():void
		{
			//create variables to monitor the camera position for the player
			camX = player.x - (FP.width / 2);
			camY = player.y - (FP.height);
			
			//HORIZONTAL CAMERA CONTROLS
			//if the camera should move no further to sides, stop it
			if (camX < (footpath.width - FP.width / 2) - cameraOffset && camX > 0) { 
				//camera.x = (player.x - cameraOffset) - (FP.width / 2); 
				cameraTweenX.tween(camera, "x", (player.x - cameraOffset) - (FP.width / 2), .25);
				} 
			else if (camX > footpath.width) { cameraTweenX.tween(camera, "x", (footpath.width - FP.width / 2), .25); }
			else if (camX < 0) cameraTweenX.tween(camera, "x", -cameraOffset, .25);
			
			//VERTICAL CAMERA CONTROLS
			//Repeat camX for camY
			if (camY > 0 && camY < footpath.height) 
			{ 
				//camera.y = (player.y + cameraOffset) - (FP.height / 2);
				cameraTweenY.tween(camera, "y", (player.y + cameraOffset) - (FP.height / 2), .25);
			}
			else if (camY > footpath.height) { camera.y = (footpath.height + cameraOffset) - (FP.height / 2); }
		}
		
		private function backGroundLoader(drop:Class, path:Class, block:Class):void
		{		
			//Create backdrop elements to so they can be added to a list
			background 	= new Backdrop (drop, true, true);
			footpath 	= new Backdrop (path, false, false);
			blocker 	= new Backdrop (block, false, false);
			
			//Reduce scroll factor for backgrounds which are further recessed
			//to create parallax effect
			background.scrollX = 1.5;
			background.scrollY = 1.5;
			
			//Shift the unwalkable stuff so that it matches - fix this graphically
			//in the future
			blocker.y = -85;
			
			//Create backgrop GraphicList, put on bottom layer, and add to GameWorld
			e_backdrop.graphic = new Graphiclist(background, footpath);
			add(e_backdrop);
			e_backdrop.layer = 10;
			
			//Add second entity to handle miscellaneous backdrop stuff, adjust the layers separately, etc.
			e_blocker.graphic = blocker;
			add(e_blocker);
			e_blocker.layer = -10;
		}
		
		[Embed(source="assets/Mourning 1.Mp3")] public static const asset_music1:Class;
		[Embed(source = "assets/Mourning 2.Mp3")] public static const asset_music2:Class;
		[Embed(source = "assets/Mourning Star.Mp3")] public static const asset_music3:Class;
		
		public var music1:Sfx = new Sfx(asset_music1);
		public var music2:Sfx = new Sfx(asset_music2);
		public var music3:Sfx = new Sfx(asset_music3);
		
		private function musicPlayer():void
		{
			if (Input.check(Key.J)) {
				music1.volume = 0;
				music2.volume = 1;
			}
			if (Input.check(Key.K)) {
				music1.volume = 1;
				music2.volume = 0;
			}
		}
		
		private function levelLoader():void
		{	
			add(new Level(Assets.OGMOTEST));
			backGroundLoader(Assets.TestLevelBG, Assets.TestLevel1, null);
		}
	}
}