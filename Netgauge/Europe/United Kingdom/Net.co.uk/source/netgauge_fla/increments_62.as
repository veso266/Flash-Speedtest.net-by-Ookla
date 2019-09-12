package netgauge_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class increments_62 extends MovieClip
   {
       
      
      public var inc1:TextField;
      
      public var inc2:TextField;
      
      public var inc3:TextField;
      
      public var inc4:TextField;
      
      public var inc5:TextField;
      
      public var inc6:TextField;
      
      public var inc7:TextField;
      
      public var inc8:TextField;
      
      public var inc0:TextField;
      
      public function increments_62()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      function frame1() : *
      {
         CustomUI.setIncrements(this);
      }
   }
}
