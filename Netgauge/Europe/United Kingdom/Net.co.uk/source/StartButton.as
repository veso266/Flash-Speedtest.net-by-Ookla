package
{
   import flash.display.MovieClip;
   
   public dynamic class StartButton extends GenericStartButton
   {
      
      public static var normalWidth:Number = 201;
      
      public static var normalHeight:Number = 92.85;
       
      
      public var labelText:MovieClip;
      
      public var base:MovieClip;
      
      public function StartButton()
      {
         addFrameScript(20,this.frame21,71,this.frame72,82,this.frame83,122,this.frame123);
         super();
         trace("StartButton: " + this);
      }
      
      override public function get width() : Number
      {
         return normalWidth * scaleX;
      }
      
      override public function get height() : Number
      {
         return normalHeight * scaleY;
      }
      
      function frame21() : *
      {
         stop();
      }
      
      function frame72() : *
      {
         stop();
      }
      
      function frame83() : *
      {
         gotoAndStop("up");
      }
      
      function frame123() : *
      {
         gotoAndStop("up");
      }
   }
}
