package com.adelbarre.minesweeper.event
{
	import flash.events.Event;
	
	public class SelectorEvent extends Event
	{
		public static const LEVEL_CHANGE:String="level_change";
		public var selectedLevel:String;
		
		public function SelectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}