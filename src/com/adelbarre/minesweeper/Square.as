package com.adelbarre.minesweeper
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class Square extends Sprite
	{
		private var _index:int;
		private var _hasMine:Boolean=false;
		private var _status:String;
		private var _revealed:Boolean=false;
		
		private var _w:int;
		private var _h:int;
		private var _nearbyMines:int;
		private var _flagged:Boolean=false;
		private var _isPotential:Boolean=false;
		
		public function Square(ind:int,w:Number,h:Number)
		{
			super();
			_index=ind; 
			_w=w;
			_h=h;
			
			_nearbyMines=0;
			this.doubleClickEnabled=true;
			
			var initBmp:Bitmap = new Assets.initSquare() as Bitmap;
			initBmp.width=_w;
			initBmp.height=_h;
			this.addChild(initBmp);
		}
		
		
		public function addMineNearby():void
		{
			_nearbyMines++;
		}
		
		public function get nearbyMines():int
		{
			return _nearbyMines;
		}
		
		public function addFlag():void
		{
			_flagged=true;			
			this.removeChildren();			
			var flagBmp:Bitmap = new Assets.flagSquare() as Bitmap;
			flagBmp.width=_w;
			flagBmp.height=_h;
			this.addChild(flagBmp);
		}
		
		public function removeFlag():void
		{
			_flagged=false;
			this.removeChildren();			
			var initBmp:Bitmap = new Assets.initSquare() as Bitmap;
			initBmp.width=_w;
			initBmp.height=_h;
			this.addChild(initBmp);	
		}
		
		public function showMistake():void
		{
			var crossSprite:Sprite=new Sprite();
			crossSprite.graphics.lineStyle(3,0xFF0000);
			crossSprite.graphics.moveTo(0,0);
			crossSprite.graphics.lineTo(_w,_h);
			crossSprite.graphics.moveTo(0,_h);
			crossSprite.graphics.lineTo(_w,0);
			this.addChild(crossSprite);
		}
		
		public function showMine():void
		{
			this.removeChildren();			
			var mineBmp:Bitmap = new Assets.mineSquare() as Bitmap;
			mineBmp.width=_w;
			mineBmp.height=_h;
			this.addChild(mineBmp);	
		}
		
		public function get isPotential():Boolean
		{
			return _isPotential;
		}
		
		public function addPotential():void
		{
			_isPotential=true;
			this.removeChildren();			
			var potentialBmp:Bitmap = new Assets.potentialSquare() as Bitmap;
			potentialBmp.width=_w;
			potentialBmp.height=_h;
			this.addChild(potentialBmp);
		}
		
		public function removePotential():void
		{
			_isPotential=false;
			this.removeChildren();
			
			var initBmp:Bitmap = new Assets.initSquare() as Bitmap;
			initBmp.width=_w;
			initBmp.height=_h;
			this.addChild(initBmp);
		}
		
		public function reveal(zeroMineAround:Boolean):void
		{
			_revealed=true;
			
			var sqBmp:Bitmap;
			
			if(zeroMineAround)
			{
				sqBmp=new Assets.emptySquare() as Bitmap;
			}
			else
			{			
				switch(_nearbyMines)
				{
					case 1: sqBmp=new Assets.oneSquare() as Bitmap;
						break;
					
					case 2: sqBmp=new Assets.twoSquare() as Bitmap;
						break;
					
					case 3: sqBmp=new Assets.threeSquare() as Bitmap;
						break;
					
					case 4: sqBmp=new Assets.fourSquare() as Bitmap;
						break;
					
					case 5: sqBmp=new Assets.fiveSquare() as Bitmap;
						break;
					
					case 6: sqBmp=new Assets.sixSquare() as Bitmap;
						break;
					
					case 7: sqBmp=new Assets.sevenSquare() as Bitmap;
						break;
					
					case 8: sqBmp=new Assets.eightSquare() as Bitmap;
						break;
				}
			}			
			
			sqBmp.width=_w;
			sqBmp.height=_h;
			this.addChild(sqBmp);
		}
		
		public function get flagged():Boolean
		{
			return _flagged;
		}
		
		public function get revealed():Boolean
		{
			return _revealed;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function get hasMine():Boolean
		{
			return _hasMine;
		}
		
		public function set hasMine(val:Boolean):void
		{
			_hasMine=val;
		}
	}
}