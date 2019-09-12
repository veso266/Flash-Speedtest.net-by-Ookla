package
{
   import flash.display.MovieClip;
   
   public dynamic class Color01 extends MovieClip
   {
       
      
      public function Color01()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      function frame1() : *
      {
         if(NetGaugeUI.ng)
         {
            NetGaugeUI.ng.trackColor(this);
         }
      }
   }
}
