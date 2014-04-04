package
{
	import flash.display.*;
	import flash.text.TextField;

	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.effects.Move;

	import util.ColorUtil;

	public class Pie3D2 extends UIComponent
	{
		public function Pie3D2()
		{
			this.draw();
		}


		public function redraw():void
		{
			this.draw();
		}


		private var DEGREES:Number = 15;

		private var radians:Number = DEGREES * Math.PI / 180;

		private var DIVIDER_VALUE:Number = 200;

		private var _x:int = 0;

		private var _y:int = 0;

		private var center_x:Number = 100; //チャット中心のx値

		private var center_y:Number = 100; //チャット中心のy値

		private var ellipse_a:Number = 150; //椭圆的长半径

		private var ellipse_b:Number = ellipse_a * Math.sin(radians); //椭圆的短半径



		private var ellipse_height:Number = 20;

		private var _width:Number = 2 * ellipse_a;

		private var _height:Number = 2 * ellipse_b;


		private var penWidth:Number = 1; // 描画ペンの太さ

		private var penAlpha:Number = penWidth / 2; // アルファ値(0～1を指定)



		public var data:Array = [ 30, 10, 40, 50, 20 ]; //测试用数据

		private var colors:Array = ColorUtil.getColor(data.length);


		private function draw():void
		{
			var sprite:Sprite = new Sprite();
			sprite.alpha = 0.8;
			var beginDegree:int = 0;
			var endDegree:int = 0;

			var total:Number = this.sum(data);
			var degreePeriod:Number;

			for (var i:int = 0; i < data.length; i++)
			{
				degreePeriod = (data[i] * 360) / total;
				this.drawShape(sprite, beginDegree, beginDegree + degreePeriod, colors[i]);
				beginDegree += degreePeriod;
			}



			addChild(sprite);
		}

		/**
		 * 数据求和计算
		 */
		private function sum(d:Array):Number
		{
			var result:Number = 0;
			for (var i:int = 0; i < d.length; i++)
			{
				result += d[i];
			}
			return result;
		}

		private function drawShape(obj:Sprite, beginDegree:Number, endDegree:Number, color:Number):void
		{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(penWidth, 0xcccccc, penAlpha);
			var color:Number = color;

			//			//左面:角度在180-360之间的shape，不需要画左侧面
			//			if (beginDegree < 180)
			//			{
			//				drawFace(shape, beginDegree, color);
			//			}
			//			//右面
			//			drawFace(shape, endDegree, color);
			//
			//			//下面
			//			if (beginDegree < 180)
			//			{
			//				drawCircular(shape, beginDegree, endDegree, color, this.ellipse_height);
			//			}
			//側面
			if ((endDegree >= 90 && endDegree <= 270) || (beginDegree >= 90 && beginDegree <= 270))
			{
				drawSideFace(shape, beginDegree < 90 ? 90 : beginDegree, endDegree > 270 ? 270 : endDegree, color);
			}

			//上面
			drawCircular(shape, beginDegree, endDegree, color, 0);

			obj.addChild(shape);
		}



		/**
		 * 计算圆弧上点的X坐标，圆弧对应椭圆的中心坐标为(0,0),与Flex的sprite坐标系不同
		 */
		private function caculateCoordinateX(degrees:Number):Number
		{
			var _radians:Number = caculateRadiansByDegree(degrees);
			return this.ellipse_a * Math.cos(_radians);
		}

		/**
		 * 计算圆弧上点的Y坐标，圆弧对应椭圆的中心坐标为(0,0),与Flex的sprite坐标系不同
		 */
		private function caculateCoordinateY(degrees:Number):Number
		{
			var _radians:Number = caculateRadiansByDegree(degrees);
			return this.ellipse_b * Math.sin(_radians);
		}

		/**
		 * 根据度数计算弧度(PI)
		 */
		private function caculateRadiansByDegree(degree:Number):Number
		{
			return Math.PI / 2 - degree * Math.PI / 180;
		}

		//********************************************************
		/**
		 *画侧面线框
		 */
		private function drawFace(obj:Shape, degree:Number, color:Number):void
		{
			obj.graphics.beginFill(color, 1);
			var coordinate_x:Number = this.caculateCoordinateX(degree);
			var coordinate_y:Number = this.caculateCoordinateY(degree);

			var flex_x:Number = this.center_x + coordinate_x;
			var flex_y:Number = this.center_y - coordinate_y;

			obj.graphics.moveTo(this.center_x, this.center_y);
			obj.graphics.lineTo(flex_x, flex_y);
			obj.graphics.lineTo(flex_x, flex_y + ellipse_height);
			obj.graphics.lineTo(this.center_x, this.center_y + ellipse_height);
			obj.graphics.lineTo(this.center_x, this.center_y);
			obj.graphics.endFill();
		}

		/**
		 *画弧线
		 */
		private function drawCircular(obj:Shape, beginDegree:Number, endDegree:Number, color:Number, offset:Number):void
		{
			var degree_dimension:Number = (endDegree - beginDegree) / this.DIVIDER_VALUE;

			var begin_coordinate_x:Number;
			var begin_coordinate_y:Number;
			var begin_flex_x:Number;
			var begin_flex_y:Number;
			var end_coordinate_x:Number;
			var end_coordinate_y:Number;
			var end_flex_x:Number;
			var end_flex_y:Number;


			obj.graphics.beginFill(color, 1);

			begin_coordinate_x = this.caculateCoordinateX(beginDegree);
			begin_coordinate_y = this.caculateCoordinateY(beginDegree);

			begin_flex_x = this.center_x + begin_coordinate_x;
			begin_flex_y = this.center_y - begin_coordinate_y;

			obj.graphics.moveTo(this.center_x, this.center_y + offset);
			obj.graphics.lineTo(begin_flex_x, begin_flex_y + offset);

			for (var m:Number = 0; m < this.DIVIDER_VALUE; m++)
			{

				//直线起点
				begin_coordinate_x = this.caculateCoordinateX(beginDegree + m * degree_dimension);
				begin_coordinate_y = this.caculateCoordinateY(beginDegree + m * degree_dimension);

				begin_flex_x = this.center_x + begin_coordinate_x;
				begin_flex_y = this.center_y - begin_coordinate_y;

				if (m == (DIVIDER_VALUE - 1))
				{
					//直线终点
					end_coordinate_x = this.caculateCoordinateX(endDegree);
					end_coordinate_y = this.caculateCoordinateY(endDegree);
				}
				else
				{
					//直线终点
					end_coordinate_x = this.caculateCoordinateX(beginDegree + (m + 1) * degree_dimension);
					end_coordinate_y = this.caculateCoordinateY(beginDegree + (m + 1) * degree_dimension);
				}

				end_flex_x = this.center_x + end_coordinate_x;
				end_flex_y = this.center_y - end_coordinate_y;

				obj.graphics.lineTo(end_flex_x, end_flex_y + offset);
			}

			end_coordinate_x = this.caculateCoordinateX(endDegree);
			end_coordinate_y = this.caculateCoordinateY(endDegree);

			end_flex_x = this.center_x + end_coordinate_x;
			end_flex_y = this.center_y - end_coordinate_y;

			obj.graphics.lineTo(this.center_x, this.center_y + offset);

			obj.graphics.endFill();
		}

		/**
		 *画侧柱面
		 */
		private function drawSideFace(obj:Shape, beginDegree:Number, endDegree:Number, color:Number):void
		{
			//角度在90到270之间的需要画侧面
			//首先根据角度计算侧柱面的起始角度
			if (beginDegree < 90)
			{
				beginDegree = 90;
			}
			if (endDegree > 270)
			{
				endDegree = 270;
			}

			var degree_dimension:Number = (endDegree - beginDegree) / this.DIVIDER_VALUE;

			var begin_coordinate_x:Number;
			var begin_coordinate_y:Number;
			var begin_flex_x:Number;
			var begin_flex_y:Number;

			var end_coordinate_x:Number;
			var end_coordinate_y:Number;
			var end_flex_x:Number;
			var end_flex_y:Number;


			obj.graphics.beginFill(color, 1);


			//上弧线
			begin_coordinate_x = this.caculateCoordinateX(beginDegree);
			begin_coordinate_y = this.caculateCoordinateY(beginDegree);

			begin_flex_x = this.center_x + begin_coordinate_x;
			begin_flex_y = this.center_y - begin_coordinate_y;

			obj.graphics.moveTo(begin_flex_x, begin_flex_y);

			for (var m:Number = 0; m < this.DIVIDER_VALUE; m++)
			{

				//直线起点
				begin_coordinate_x = this.caculateCoordinateX(beginDegree + m * degree_dimension);
				begin_coordinate_y = this.caculateCoordinateY(beginDegree + m * degree_dimension);

				begin_flex_x = this.center_x + begin_coordinate_x;
				begin_flex_y = this.center_y - begin_coordinate_y;

				if (m == (DIVIDER_VALUE - 1))
				{
					//直线终点
					end_coordinate_x = this.caculateCoordinateX(endDegree);
					end_coordinate_y = this.caculateCoordinateY(endDegree);
				}
				else
				{
					//直线终点
					end_coordinate_x = this.caculateCoordinateX(beginDegree + (m + 1) * degree_dimension);
					end_coordinate_y = this.caculateCoordinateY(beginDegree + (m + 1) * degree_dimension);
				}
				end_flex_x = this.center_x + end_coordinate_x;
				end_flex_y = this.center_y - end_coordinate_y;

				obj.graphics.lineTo(end_flex_x, end_flex_y);
			}

			//上弧线终点到下弧线终点连线
			obj.graphics.lineTo(end_flex_x, end_flex_y + this.ellipse_height);

			//下弧线
			for (var n:Number = 0; n < this.DIVIDER_VALUE; n++)
			{
				//直线起点
				begin_coordinate_x = this.caculateCoordinateX(endDegree - n * degree_dimension);
				begin_coordinate_y = this.caculateCoordinateY(endDegree - n * degree_dimension);

				begin_flex_x = this.center_x + begin_coordinate_x;
				begin_flex_y = this.center_y - begin_coordinate_y;

				if (n == (DIVIDER_VALUE - 1))
				{
					//直线终点
					end_coordinate_x = this.caculateCoordinateX(beginDegree);
					end_coordinate_y = this.caculateCoordinateY(beginDegree);
				}
				else
				{
					//直线终点
					end_coordinate_x = this.caculateCoordinateX(endDegree - (n + 1) * degree_dimension);
					end_coordinate_y = this.caculateCoordinateY(endDegree - (n + 1) * degree_dimension);
				}
				end_flex_x = this.center_x + end_coordinate_x;
				end_flex_y = this.center_y - end_coordinate_y;

				obj.graphics.lineTo(end_flex_x, end_flex_y + this.ellipse_height);
			}
			//下弧线起点到上弧线终点连线
			begin_coordinate_x = this.caculateCoordinateX(beginDegree);
			begin_coordinate_y = this.caculateCoordinateY(beginDegree);

			begin_flex_x = this.center_x + begin_coordinate_x;
			begin_flex_y = this.center_y - begin_coordinate_y;

			obj.graphics.lineTo(begin_flex_x, begin_flex_y);

			obj.graphics.endFill();
		}
	}
}
