package  
{
	import flash.text.GridFitType;
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.FP;
	import net.flashpunk.masks.Grid;
	/**
	 * ...
	 * @author Jinx
	 */
	public class Level extends Entity
	{
		private var _grid:Grid;
		protected var mapGrid:Grid;
		protected var mapData:Class;
		private var gridEntity:Entity;
		
		public function Level(mapData:Class = null) 
		{	
			if (mapData != null) 
			{	
				loadGrid(mapData);
			}
			type = "level";
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		private function loadGrid(xml:Class):void
		{
			//Create a byte array to store the raw data inside of a string via XML
			var rawData:ByteArray = new xml;
			
			//Everything comes through Flashdevelop as a string, so we're storing it
			//in a string type variable to put in an XML type shortly
			var dataString:String = rawData.readUTFBytes(rawData.length);
			
			//Put the String data into XML format
			var xmlData:XML = new XML(dataString);
			
			var dataList:XMLList;
			var dataElement:XML;
			
			//Set dataList equal to the data within the "levelData" section of the XML
			dataList = xmlData.levelData.tile;
			
			//NEW ADDITION:
			//programmatically pull level width and height from XML data
			//this enables _grid to be exactly the right size
			var levelWidth:Number  = xmlData.@width;
			var levelHeight:Number = xmlData.@height;
			trace ("Level Width: " + levelWidth + "\nLevel Height: " + levelHeight);
			
			//moved grid & mask creation down here from original location in main to account for XML input
			_grid = new Grid(levelWidth, levelHeight, 16, 16, 0, 0);
			mask = _grid;
			layer = 100;
			
			//Iterate through and setup the grid according to the XML
			for each (dataElement in dataList) {
				_grid.setTile(int(dataElement.@x), int(dataElement.@y), true);
			}
		}
	}
}