package
{
   import flash.display.MovieClip;
   
   public dynamic class StartButtonMulti extends GenericStartButton
   {
      
      public static var normalWidth:Number = 201;
      
      public static var normalHeight:Number = 52.3;
       
      
      public var labelText:MovieClip;
      
      public var base:MovieClip;
      
      public function StartButtonMulti()
      {
         addFrameScript(0,this.frame1,36,this.frame37,47,this.frame48,95,this.frame96);
         super();
         trace("StartButtonMulti: " + this);
         if(getChildByName("base") != null)
         {
            (getChildByName("base") as MovieClip).stop();
         }
      }
      
      override public function get width() : Number
      {
         return normalWidth * scaleX;
      }
      
      override public function get height() : Number
      {
         return normalHeight * scaleY;
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame37() : *
      {
         stop();
      }
      
      function frame48() : *
      {
         gotoAndStop("up");
      }
      
      function frame96() : *
      {
         gotoAndStop("up");
      }
   }
}
