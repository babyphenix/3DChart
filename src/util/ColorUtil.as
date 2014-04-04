package util
{

	public class ColorUtil
	{
		private static var MIN_COLOR:Number = 0x0000ff;

		private static var MAX_COLOR:Number = 0xff0000;

		private static var RANGE:Number = MAX_COLOR - MIN_COLOR;

		private static const C_ARRAY:Array = [ 0xe74c3c, 0xe67e22, 0xf1c40f, 0x1abc9c, 0x2ecc71, 0x3498db, 0x9b59b6 ];

		public static function getColor(n:Number):Array
		{
			return C_ARRAY;
			//			var colors:Array = new Array();
			//			for (var i:int = 0; i < n; i++)
			//			{
			//				colors.push(C_ARRAY[Math.round(Math.random() * 100) % C_ARRAY.length]);
			//			}
			//
			//			return colors;
			//			return getAverageColor(n);
		}

		private static function getAverageColor(n:Number):Array
		{
			var colors:Array = new Array();
			for (var i:int = 0; i < n; i++)
			{
				colors.push(MIN_COLOR + RANGE * i / n);
			}
			return colors;
		}
	}
}
