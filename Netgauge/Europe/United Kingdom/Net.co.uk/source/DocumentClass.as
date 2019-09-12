package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.Font;
   
   public dynamic class DocumentClass extends MovieClip
   {
      
      public static var document:DocumentClass;
       
      
      public var testWidth:Number = 0;
      
      public var testHeight:Number = 0;
      
      protected var _netgauge:NetGaugeUI = null;
      
      protected var _controller:CustomSpeedTestController = null;
      
      protected var _config:CustomConfiguration = null;
      
      protected var _view:CustomSpeedTestView = null;
      
      public function DocumentClass()
      {
         super();
         document = this;
         loaderInfo.addEventListener(Event.COMPLETE,this._onComplete);
      }
      
      public function get netgauge() : NetGaugeUI
      {
         return this._netgauge;
      }
      
      protected function enumerateFonts() : void
      {
         var _loc2_:Font = null;
         var _loc1_:Array = Font.enumerateFonts();
         for each(_loc2_ in _loc1_)
         {
            trace(_loc2_.fontName + ":" + _loc2_.fontType + " " + _loc2_.fontStyle);
         }
      }
      
      public function get controller() : CustomSpeedTestController
      {
         return this._controller;
      }
      
      public function get config() : CustomConfiguration
      {
         return this._config;
      }
      
      public function get view() : CustomSpeedTestView
      {
         return this._view;
      }
      
      protected function _onComplete(param1:Event) : void
      {
         this.testWidth = loaderInfo.width;
         this.testHeight = loaderInfo.height;
      }
      
      public function getSize() : Point
      {
         var _loc1_:Point = new Point();
         if(this.testWidth == 0 && this.testHeight == 0)
         {
            trace("testLoader size not available yet");
         }
         if(this.testWidth != 0)
         {
            _loc1_.x = this.testWidth;
         }
         if(this.testHeight != 0)
         {
            _loc1_.y = this.testHeight;
         }
         return _loc1_;
      }
   }
}
