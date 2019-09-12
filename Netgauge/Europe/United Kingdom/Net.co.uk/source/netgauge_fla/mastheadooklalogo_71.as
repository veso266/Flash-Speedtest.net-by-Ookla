package netgauge_fla
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public dynamic class mastheadooklalogo_71 extends MovieClip
   {
       
      
      public function mastheadooklalogo_71()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function _onClick(param1:MouseEvent) : *
      {
         NetGaugeUI.ng.openOoklaLanding();
      }
      
      function frame1() : *
      {
         this.addEventListener(MouseEvent.CLICK,this._onClick);
         this.useHandCursor = true;
         this.buttonMode = true;
      }
   }
}
