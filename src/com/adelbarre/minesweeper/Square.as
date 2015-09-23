package com.adelbarre.minesweeper
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class Square extends Sprite
	{
		private var _index:int;
		private var _hasBomb:Boolean=false;
		private var _status:String;
		private var _revealed:Boolean=false;
		
		private var _w:int;
		private var _h:int;
		private var _cornerRadius:int;
		private var _nearbyBombs:int;
		private var _flagged:Boolean=false;
		private var _isPotential:Boolean=false;
		
		public function Square(ind:int,w:Number,h:Number,cornerRadius:int=5)
		{
			super();
			_index=ind; 
			_w=w;
			_h=h;
			_cornerRadius=cornerRadius;
			
			_nearbyBombs=0;
			
			this.graphics.beginFill(0xCCCCCC);
			this.graphics.drawRoundRect(0,0,w,h,cornerRadius,cornerRadius);
			this.graphics.endFill();	
		}
		
		
		public function addBombNearby():void
		{
			_nearbyBombs++;
		}
		
		public function get nearbyBombs():int
		{
			return _nearbyBombs;
		}
		
		public function addFlag():void
		{
			_flagged=true;
			this.graphics.beginFill(0xFF3333);
			this.graphics.drawCircle(this.width*0.5,this.height*0.5,5);
			this.graphics.endFill();
		}
		
		public function removeFlag():void
		{
			_flagged=false;
			this.graphics.clear();
			this.graphics.beginFill(0xCCCCCC);
			this.graphics.drawRoundRect(0,0,_w,_h,_cornerRadius,_cornerRadius);
			this.graphics.endFill();	
		}
		
		public function get isPotential():Boolean
		{
			return _isPotential;
		}
		
		public function addPotential():void
		{
			_isPotential=true;
			var textfield:TextField=new TextField();
			//textfield.  .touchable=false
			textfield.text="?";
			textfield.selectable=false;
			this.addChild(textfield);
		}
		
		public function removePotential():void
		{
			_isPotential=false;
			this.removeChildren();
			this.graphics.clear();
			this.graphics.beginFill(0xCCCCCC);
			this.graphics.drawRoundRect(0,0,_w,_h,_cornerRadius,_cornerRadius);
			this.graphics.endFill();
		}
		
		public function reveal(zeroMineAround:Boolean):void
		{
			_revealed=true;
			this.graphics.beginFill(0x00ff00);
			this.graphics.drawRoundRect(0,0,_w,_h,_cornerRadius,_cornerRadius);
			this.graphics.endFill();
			
			if(!zeroMineAround)
			{
				var textfield:TextField=new TextField();
				textfield.text=_nearbyBombs.toString();
				this.addChild(textfield);
			}			
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
		
		public function get hasBomb():Boolean
		{
			return _hasBomb
		}
		
		public function set hasBomb(val:Boolean):void
		{
			_hasBomb=val;
		}
	}
}