package com.adelbarre.minesweeper.event
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const MINE_FLAGGED_UPDATE:String="mine_flagged_update";
		public static const GAMEOVER:String="gameover";	
		public static const VICTORY:String="victory";	
		
		public var remainingMines:int;
		
		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}