package com.adelbarre.minesweeper
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class FaceButton extends Sprite
	{
		public static const PLAYING:String="playing";
		public static const VICTORY:String="victory";
		public static const GAMEOVER:String="gameover";		
		
		public function FaceButton(face:String=PLAYING)
		{
			super();
			var bmp:Bitmap = new Assets.playingFace() as Bitmap;
			this.addChild(bmp);	
		}
		
		public function setFace(face:String):void
		{
			this.removeChildren();
			var bmp:Bitmap;
			switch(face)
			{
				case PLAYING: bmp = new Assets.playingFace() as Bitmap;
					break;
				
				case VICTORY: bmp = new Assets.victoryFace() as Bitmap;
					break;
				
				case GAMEOVER: bmp = new Assets.gameoverFace() as Bitmap;
					break;
				
				default: bmp = new Assets.playingFace() as Bitmap;
			}
			this.addChild(bmp);
		}
	}
}