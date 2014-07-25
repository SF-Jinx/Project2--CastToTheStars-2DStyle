package  
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import Player;
	import net.flashpunk.graphics.Anim;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * ...
	 * @author Jinx
	 */
	public class PlayerShadow extends Entity 
	{
		private var shadowFade:VarTween;
		private var playerTest:Image;
		private var yOffset:Number;
		private var xOffset:Number;
				
		public function PlayerShadow(playerGraphic:Spritemap, direction:Number)//x:int, y:int)//, playerGraphic:Image) 
		{	
			Player.canMove = false;
			graphic = playerGraphic;
			playerGraphic.alpha = 1;
			playerGraphic.centerOrigin();
			layer = 10;
			playerGraphic.color = 000000;
			switch (direction)
			{
				case 0			: playerGraphic.angle = 70;	 xOffset = 5; yOffset = 16; 	break;	//right
				case(3.14)		: playerGraphic.angle = 300; xOffset = -32;yOffset = 16;		break;	//left
			}
			
			this.x = x;
			this.y = y;
//			playerGraphic.scaleY = 1.5;
			
			shadowFade = new VarTween(fade);
			shadowFade.tween(playerGraphic, "alpha", 0, .15);
			addTween(shadowFade, true);
		}
		
		public function fade():void 
		{
			world.remove(this);
			Player.canMove = true;
		}
		
		override public function update():void 
		{
			this.x = GameWorld.player.x - xOffset;
			this.y = GameWorld.player.y + yOffset;
			super.update();
		}
	}
}