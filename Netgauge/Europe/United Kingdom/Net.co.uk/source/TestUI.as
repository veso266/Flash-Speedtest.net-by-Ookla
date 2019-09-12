package
{
   import fl.text.TLFTextField;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.utils.getDefinitionByName;
   
   public class TestUI
   {
      
      private static var configuration:Configuration;
       
      
      public function TestUI()
      {
         super();
      }
      
      public static function init(param1:Configuration) : *
      {
         var _loc4_:* = undefined;
         configuration = param1;
         var _loc2_:* = configuration.getSettingArray("interface");
         var _loc3_:* = TestConfigurator.getBoolean(_loc2_.showborder,true);
         if(_loc3_)
         {
            drawBorder();
         }
         _loc4_ = TestConfigurator.getRangeInt(_loc2_.framerate,10,100,0);
         if(_loc4_ > 0)
         {
            DocumentClass.document.stage.frameRate = _loc4_;
         }
      }
      
      public static function drawBorder() : *
      {
         DocumentClass.document.graphics.lineStyle(0,0,1,false,LineScaleMode.NONE);
         Logger.info(DocumentClass.document.width);
         Logger.info(DocumentClass.document.height);
         DocumentClass.document.graphics.drawRect(0,0,DocumentClass.document.stage.stageWidth - 1,DocumentClass.document.stage.stageHeight - 1);
         Logger.info(DocumentClass.document.width);
         Logger.info(DocumentClass.document.height);
      }
      
      public static function getFontSize(param1:TLFTextField) : Number
      {
         var _loc2_:* = param1.selectable;
         param1.selectable = true;
         var _loc3_:* = param1.getTextFormat(0);
         param1.selectable = _loc2_;
         return _loc3_.size;
      }
      
      public static function drawPieMask(param1:Graphics, param2:Number, param3:Number = 50, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:int = 6) : void
      {
         var lineToRadians:Function = null;
         var sidesToDraw:int = 0;
         var i:int = 0;
         var graphics:Graphics = param1;
         var percentage:Number = param2;
         var radius:Number = param3;
         var x:Number = param4;
         var y:Number = param5;
         var rotation:Number = param6;
         var sides:int = param7;
         graphics.moveTo(x,y);
         if(sides < 3)
         {
            sides = 3;
         }
         radius = radius / Math.cos(1 / sides * Math.PI);
         lineToRadians = function(param1:Number):void
         {
            graphics.lineTo(Math.cos(param1) * radius + x,Math.sin(param1) * radius + y);
         };
         sidesToDraw = Math.floor(percentage * sides);
         i = 0;
         while(i <= sidesToDraw)
         {
            lineToRadians(i / sides * (Math.PI * 2) + rotation);
            i++;
         }
         if(percentage * sides != sidesToDraw)
         {
            lineToRadians(percentage * (Math.PI * 2) + rotation);
         }
      }
      
      public static function getColor(param1:String) : *
      {
         var _loc2_:Class = getDefinitionByName(param1) as Class;
         var _loc3_:* = new _loc2_();
         var _loc4_:* = new BitmapData(_loc3_.width,_loc3_.height);
         _loc4_.draw(_loc3_);
         var _loc5_:uint = _loc4_.getPixel(0,0);
         _loc4_ = null;
         var _loc6_:* = _loc5_ >> 16 & 255;
         var _loc7_:* = _loc5_ >> 8 & 255;
         var _loc8_:* = _loc5_ & 255;
         return _loc5_;
      }
   }
}
