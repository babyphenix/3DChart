package
{
	import flash.display.*;
	import mx.core.UIComponent;

	public class Pie3D  extends UIComponent
	{
		private var _x:int = 0;
		private var _y:int = 0 ;
		private var radius:Number = 100 ;
		private var degrees:Number = 15;
		private var radians:Number = degrees * Math.PI / 180;

		private var ellipse_height:Number = 15;

		private var _width:Number = 2 *  radius;
		private var _height:Number = 2 * radius * Math.sin(radians);


        private var penWidth:Number = 1;// 描画ペンの太さ
        private var penAlpha:Number = penWidth / 3;// アルファ値(0～1を指定)


		public function Pie3D()
		{
			this.draw();
		}





		private function draw():void{
			var shape:Sprite = new Sprite();

			shape.graphics.lineStyle(penWidth, 0x000000, penAlpha);



        	shape.graphics.beginFill(0xdc8045, 1);
        	shape.graphics.drawEllipse(_x,_y,_width,_height);
        	shape.graphics.endFill();



        	shape.graphics.moveTo(0,radius * Math.sin(radians));
        	shape.graphics.lineTo(0,radius * Math.sin(radians) + ellipse_height);

        	shape.graphics.moveTo(_width,radius * Math.sin(radians));
        	shape.graphics.lineTo(_width,radius * Math.sin(radians) + ellipse_height);


        	for(var m:Number = 0;m < 500 ; m++ ){
        		var eX:Number = radius - (radius * 2 /500 ) * m ;
        		var eY:Number = getEllipseY(eX);

        		var eXN:Number = radius - (radius * 2 /500 ) * (m+1) ;
        		var eYN:Number = getEllipseY(eX);

                if(m==0){
                	shape.graphics.moveTo(0,radius * Math.sin(radians) + ellipse_height);
 					shape.graphics.lineTo((radius * 2 /500 ) * (m+1),eYN+radius * Math.sin(radians)+ellipse_height);
                }else if(m==499){
     				shape.graphics.moveTo((radius * 2 /500 ) * m,eY+radius * Math.sin(radians)+ellipse_height);
 					shape.graphics.lineTo(_width,radius * Math.sin(radians) + ellipse_height);
                }else{
                	shape.graphics.moveTo((radius * 2 /500 ) * m,eY+radius * Math.sin(radians)+ellipse_height);
 					shape.graphics.lineTo((radius * 2 /500 ) * (m+1),eYN+radius * Math.sin(radians)+ellipse_height);
                }

        	}
			addChild(shape);
		}

		private function getEllipseY(EllipseX:Number):Number{
			var EllipseHeight:Number = radius * Math.sin(radians);
			var EllipseY2:Number = (1 - EllipseX *EllipseX /(radius * radius )) * EllipseHeight * EllipseHeight;
			return Math.sqrt(EllipseY2);
		}

	}
}