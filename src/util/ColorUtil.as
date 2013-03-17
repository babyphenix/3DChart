package util
{
	public class ColorUtil
	{
		private static var MIN_COLOR:Number = 0x0000ff;
		private static var MAX_COLOR:Number = 0xff0000;
		private static var RANGE:Number = MAX_COLOR-MIN_COLOR;

		public static function getColor(n:Number):Array{
			return getAverageColor(n);
		}

		private static function getAverageColor(n:Number):Array{
			var colors:Array = new Array();
			for(var i:int= 0;i<n;i++){
            	colors.push(MIN_COLOR + RANGE * i /n);
			}
			return colors;
		}
	}
}