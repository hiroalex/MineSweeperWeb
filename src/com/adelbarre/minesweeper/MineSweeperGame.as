package com.adelbarre.minesweeper
{
	import com.adelbarre.minesweeper.event.GameEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	
	public class MineSweeperGame extends EventDispatcher
	{
		private var _boardContainer:Sprite;
		private var _uiContainer:Sprite;
		private var _squares:Vector.<Square>;	
		private var _squaresContainer:Sprite;
		
		private static const SQUARE_WIDTH:Number=25;
		private static const SQUARE_HEIGHT:Number=25;
		
		private var _gridWidth:int;
		private var _gridHeight:int;
		
		private var _remainingMines:int;
		
		public function MineSweeperGame(board:Sprite)
		{
			_boardContainer=board;
		}
		
		public function start(gridWidth:int=10,gridHeight:int=10, mines:int=10):void
		{
			_gridWidth=gridWidth;
			_gridHeight=gridHeight;
			_remainingMines=mines;
			createGrid(gridWidth,gridHeight,mines);
		}
		
		private function createGrid(gridWidth:int,gridHeight:int, mines:int):void
		{			
			if(_boardContainer) _boardContainer.removeChildren();			
			
			_squaresContainer=new Sprite();
			_squares=new Vector.<Square>();
						
			var squaresLength:int=gridWidth*gridHeight;
			
			//position the squares
			for(var i:int=0;i<squaresLength;i++)
			{
				var sq:Square=new Square(i,SQUARE_WIDTH,SQUARE_HEIGHT); 
				sq.x=Math.floor(i%gridWidth)*(sq.width+1);
				sq.y=Math.floor(i/gridWidth)*(sq.height+1);
				_squaresContainer.addChild(sq);
				_squares.push(sq);
			}
			
			generateRandomMines(_squares,mines);			
			
			_squaresContainer.addEventListener(Event.ADDED_TO_STAGE,onSquaresContainerAddedToStage);
			_boardContainer.addChild(_squaresContainer);			
		}
		
		private function generateRandomMines(_sq:Vector.<Square>,minesNb:int):void
		{
			var mineIndices:Object={};
			var randomNumber:int;
			for (var i:int=0;i<minesNb;i++)
			{
				//check that the index doesn't already exists in the dictionary
				do
				{					
					randomNumber=Math.floor(Math.random()*_sq.length);			
				}
				while(mineIndices.hasOwnProperty(randomNumber.toString()));
				mineIndices[randomNumber.toString()]=true;	
				_sq[randomNumber].hasBomb=true;
			}
		}
		
		public function recenter():void
		{
			_squaresContainer.x=_boardContainer.width*0.5-_squaresContainer.width*0.5;
			_squaresContainer.y=_boardContainer.height*0.5-_squaresContainer.height*0.5;
		}
		
		private function onSquaresContainerAddedToStage(evt:Event):void
		{
			_squaresContainer.removeEventListener(Event.ADDED_TO_STAGE,onSquaresContainerAddedToStage);
			_squaresContainer.addEventListener(Event.REMOVED_FROM_STAGE,onSquaresContainerRemovedFromStage);
			_squaresContainer.x=_boardContainer.width*0.5-_squaresContainer.width*0.5;
			_squaresContainer.y=_boardContainer.height*0.5-_squaresContainer.height*0.5;
						
			_squaresContainer.doubleClickEnabled=true;
			_squaresContainer.addEventListener(MouseEvent.RIGHT_CLICK,onBoardRightClick);
			_squaresContainer.addEventListener(MouseEvent.CLICK,onBoardClick);
			_squaresContainer.addEventListener(MouseEvent.DOUBLE_CLICK,onBoardDoubleClick);			
		}		
		
		private function onBoardDoubleClick(evt:MouseEvent):void
		{
			var clickedSquare:Square;
			
			if(evt.target is Square)
			{	
				clickedSquare=evt.target as Square;
			}
			
			if(clickedSquare)
			{
				trace("double click");
				revealZone(clickedSquare.index);
			}
		}
		
		private function onBoardRightClick(evt:MouseEvent):void
		{
			var clickedSquare:Square;
			
			if(evt.target is Square)
			{	
				clickedSquare=evt.target as Square;
			}
			
			
			if(clickedSquare)
			{
				if(clickedSquare.revealed) return;
				
				if(!clickedSquare.flagged && !clickedSquare.isPotential)
				{
					clickedSquare.addFlag();
					_remainingMines--;
				}
				else if(clickedSquare.flagged)
				{
					clickedSquare.removeFlag();
					clickedSquare.addPotential();
					_remainingMines++;
				}
				else
				{
					clickedSquare.removePotential();
				}
				
				var gameEvt:GameEvent=new GameEvent(GameEvent.MINE_FLAGGED_UPDATE);
				gameEvt.remainingMines=_remainingMines;
				dispatchEvent(gameEvt);
			}
		}
		
		//determine neighbors of sqId
		private function getNeighbors(sqId:int):Vector.<int>
		{		
			var sqIds:Vector.<int>=new Vector.<int>();
			
			var xpos:int=sqId%_gridWidth;
			var ypos:int=Math.floor(sqId/_gridWidth);
			
			trace(sqId+" : "+	xpos,ypos);		
			
			if(ypos<_gridHeight-1) sqIds.push(sqId+_gridWidth); //adding south
			if(ypos>0) sqIds.push(sqId-_gridWidth); //adding north
			if(xpos<_gridWidth-1) sqIds.push(sqId+1); //adding east
			if(xpos>0) sqIds.push(sqId-1); //adding west			
			if(ypos>0 && xpos<_gridWidth-1) sqIds.push(sqId-_gridWidth+1); //adding north east
			if(ypos<_gridHeight-1 && xpos<_gridWidth-1) sqIds.push(sqId+_gridWidth+1); //adding south east
			if(ypos>0 && xpos>0) sqIds.push(sqId-_gridWidth-1); //adding north west
			if(ypos<_gridHeight-1 && xpos>0) sqIds.push(sqId+_gridWidth-1); //adding south west
			
			return sqIds;
		}
		
		private function revealZone(sqId:int):void
		{
			var numNeighbors:int=0;
			var sqIdsToReveal:Vector.<int>=getNeighbors(sqId);
			var i:int;
			
			//count numbers of mines around sqId
			for(i=0;i<sqIdsToReveal.length;i++)
			{				
				if(!_squares[sqIdsToReveal[i]].revealed && _squares[sqIdsToReveal[i]].hasBomb)
				{
					_squares[sqId].addBombNearby();
				}
			}
			
			if(_squares[sqId].nearbyBombs!=0 && !_squares[sqId].revealed) _squares[sqId].reveal(false);
			else
			{
				if(!_squares[sqId].revealed) _squares[sqId].reveal(true);
				for(i=0;i<sqIdsToReveal.length;i++)
				{	
					if(!_squares[sqIdsToReveal[i]].revealed && 
						!_squares[sqIdsToReveal[i]].hasBomb) revealZone(sqIdsToReveal[i]);
				}
			}
		}
		
		private function onBoardClick(evt:MouseEvent):void
		{
			if(evt.target is Square) 
			{
				if((evt.target as Square).hasBomb) //GAME OVER
				{
					Alert.show("GAME OVER","BOOOM!");
				}
				else
				{
					revealZone((evt.target as Square).index);
				}
			}
		}
		
		private function onSquaresContainerRemovedFromStage(evt:Event):void
		{
			_squaresContainer.removeEventListener(MouseEvent.RIGHT_CLICK,onBoardRightClick);
			_squaresContainer.removeEventListener(MouseEvent.CLICK,onBoardClick);
			_squaresContainer.removeEventListener(MouseEvent.DOUBLE_CLICK,onBoardDoubleClick);
			
			_squaresContainer.removeEventListener(Event.REMOVED_FROM_STAGE,onSquaresContainerRemovedFromStage);
			_squaresContainer.removeChildren();
			_squaresContainer=null;
			while(_squares.length>1)
			{
				_squares[_squares.length-1]=null;
				_squares.pop();
			}
			_squares=null;
		}
		
	}
}