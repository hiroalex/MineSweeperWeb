package com.adelbarre.minesweeper
{
	import com.adelbarre.minesweeper.event.SelectorEvent;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LevelSelector extends Sprite
	{
		public static const LEVEL_EASY:String="level_easy";
		public static const LEVEL_MEDIUM:String="level_medium";
		public static const LEVEL_HARD:String="level_hard";
		
		private var _currentLevel:String;		
		private var _line:Sprite;
		
		public function LevelSelector()
		{
			super();
			
			var easyBmp:Bitmap = new Assets.easyLevel() as Bitmap;	
			var easySpr:Sprite=new Sprite();
			easySpr.addEventListener(MouseEvent.CLICK,onLevelClick);
			easySpr.addChild(easyBmp);
			this.addChild(easySpr);
			
			var mediumBmp:Bitmap = new Assets.mediumLevel() as Bitmap;			
			var mediumSpr:Sprite=new Sprite();
			mediumSpr.x=110
			mediumSpr.addEventListener(MouseEvent.CLICK,onLevelClick);
			mediumSpr.addChild(mediumBmp);
			this.addChild(mediumSpr);
			
			var hardBmp:Bitmap = new Assets.hardLevel() as Bitmap;				
			var hardSpr:Sprite=new Sprite();
			hardSpr.x=220;
			hardSpr.addEventListener(MouseEvent.CLICK,onLevelClick);
			hardSpr.addChild(hardBmp);
			this.addChild(hardSpr);
			
			_line=new Sprite();
			_line.graphics.beginFill(0xFF0000);
			_line.graphics.drawRect(0,0,80,3);
			_line.graphics.endFill();
			_line.y=26;
			
			_currentLevel=LEVEL_EASY;			
			this.addChild(_line);			
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}		
		
		public function getLevel():String
		{
			return _currentLevel;
		}
		
		private function onLevelClick(evt:MouseEvent):void
		{
			//not the cleanest way to affect _currentLevel but probably the fastest
			switch(evt.target.x)
			{
				case 0: _currentLevel=LEVEL_EASY;
					break;
				
				case 110: _currentLevel=LEVEL_MEDIUM;
					break;
				
				case 220: _currentLevel=LEVEL_HARD;
					break;				
			}
			
			TweenLite.to(_line, 0.2, {x:evt.target.x});
			
			var e:SelectorEvent=new SelectorEvent(SelectorEvent.LEVEL_CHANGE);
			e.selectedLevel=_currentLevel;
			dispatchEvent(e);
		}
		
		private function onAddedToStage(evt:Event):void
		{
			recenter();
		}
		
		public function recenter():void
		{
			if(this.parent)
			{
				this.x=this.parent.width*0.5-this.width*0.5;
			}
		}		
	}
}