package
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public dynamic class GeneralButton extends GenericButton
   {
       
      
      public var framecolor:Color01;
      
      public var text:MovieClip;
      
      public var fillcolor:Color01;
      
      public function GeneralButton()
      {
         addFrameScript(0,this.frame1,35,this.frame36,49,this.frame50,92,this.frame93);
         super();
         trace("GeneralButton: " + this);
      }
      
      override public function set display(param1:String) : *
      {
         super.display = param1;
         (this.getChildByName("text") as MovieClip).txt.text = param1;
      }
      
      public function set flash(param1:String) : *
      {
         (this.getChildByName("text") as MovieClip).txt.text = param1;
         TweenLite.delayedCall(0.7,this.reset);
      }
      
      protected function reset() : *
      {
         (this.getChildByName("text") as MovieClip).txt.text = display;
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame36() : *
      {
         stop();
      }
      
      function frame50() : *
      {
         gotoAndStop("up");
      }
      
      function frame93() : *
      {
         gotoAndStop(1);
      }
   }
}
