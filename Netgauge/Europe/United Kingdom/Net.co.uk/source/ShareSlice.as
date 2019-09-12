package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public dynamic class ShareSlice extends MovieClip
   {
       
      
      public var sharemsg:MovieClip;
      
      public var copy:GeneralButton;
      
      public function ShareSlice()
      {
         super();
         addFrameScript(0,this.frame1,110,this.frame111);
      }
      
      public function _onClick(param1:MouseEvent) : *
      {
         gotoAndPlay("clicked");
      }
      
      function frame1() : *
      {
         stop();
         Translation.translateObject(this.copy,"sharetestresult");
         this.copy.addEventListener(MouseEvent.CLICK,this._onClick);
      }
      
      function frame111() : *
      {
         gotoAndStop(1);
      }
   }
}
