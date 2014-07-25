package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * ...
	 * @author Jinx
	 */
	public class Player extends Entity 
	{
		public static var canMove:Boolean = true;
		
		private var spr_gabriel:Spritemap = new Spritemap(img_Gabriel, 29, 32);
		private var spr_gabrielCopy:Spritemap = new Spritemap(img_Gabriel, 29, 32);
		private var currentAnim:String;
		private var playerSpeedX:Number = 7;
		private var playerSpeedY:Number = 0;
		private	var dir:Number;
		
		public function Player() 
		{
			graphic = spr_gabriel;
			layer = 0;
			createSpriteFromSpritemap(spr_gabriel);
			createSpriteFromSpritemap(spr_gabrielCopy);
			
			Input.define("Left", 	Key.A, Key.LEFT);
			Input.define("Right", 	Key.D, Key.RIGHT);
			Input.define("Up", 		Key.W, Key.UP);
			Input.define("Down", 	Key.S, Key.DOWN);
			Input.define("Shoot",   Key.SPACE);
			Input.define("Jump", 	Key.X);
			
			currentAnim = "face right";
			
//			trace (FP.height);
//			trace (y);
		}
		
		private function createSpriteFromSpritemap(sm:Spritemap):void 
		{
			sm.add("walk right", [1, 0, 2, 0], 8, true);
			sm.add("walk left",  [4, 5, 3, 5], 8, true);
			sm.add("face right", [0], 0, false);
			sm.add("face left",  [5], 0, false);
		}
		
		private function setDirection():void
		{
//			dir = Math.atan2(world.mouseY-y, world.mouseX-x); //follow the mouse
			switch(currentAnim) {
				case "walk right"	: dir = 0; break;
				case "walk left" 	: dir = 3.14; break;
				case "face right"	: dir = 0; break;
				case "face left" 	: dir = 3.14; break;
			}
		}
		
		override public function update():void
		{			
			setDirection();
			
			var verticalMovement:Boolean = false;
			var horizontalMovement:Boolean = true;
			
			spr_gabriel.play(currentAnim);
			spr_gabrielCopy.play(currentAnim);
			
			//Set the copy to the same index as the original
			spr_gabrielCopy.setAnimFrame(currentAnim, spr_gabriel.index);
			
			
			if (canMove)
			{
				//inputs for motion and moving animations
				if (Input.check("Left"))  { 
					//if (collide("level", x - width, y)) x -= playerSpeed;
					
					x -= playerSpeedX;
					currentAnim = "walk left";
				}
				else if (Input.check("Right")) { 
					//if (collide("level", x + width, y))	x += playerSpeed; 
					x += playerSpeedX;
					currentAnim = "walk right";
				}
				else horizontalMovement = false;
				
				if (!horizontalMovement) {
					switch (currentAnim) {
						case "walk left": currentAnim = "face left"; break;
						case "walk right": currentAnim = "face right"; break;
					}
				}
				
				///////SHOOTIN' STUFF////////////
				
				if (Input.pressed("Shoot"))
				{
					//Initialize shadow
					if (dir == 0) {
						x -= 30;
					}
					else x += 30;
					playerSpeedY = -5;
					
					spr_gabrielCopy.clear();
					world.add(new PlayerShadow(spr_gabrielCopy, dir));
				}
			}	
			///////VERTICAL MOVEMENT/////////
			
			if (y < (FP.height - spr_gabriel.height)) verticalMovement = true;
			
			if (Input.pressed("Up") && !verticalMovement && canMove) {
				playerSpeedY = -15;
				verticalMovement = true;
			}
			
			if (!verticalMovement) {			
				playerSpeedY = 0; 
				y = 600 - spr_gabriel.height;
			}
			
			else if (verticalMovement) {
				playerSpeedY += .7;
				y += playerSpeedY;
			}
		}
	}
}