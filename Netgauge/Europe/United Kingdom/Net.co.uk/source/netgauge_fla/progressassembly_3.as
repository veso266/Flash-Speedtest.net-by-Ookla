package netgauge_fla
{
   import flash.display.MovieClip;
   
   public dynamic class progressassembly_3 extends MovieClip
   {
       
      
      public var status:TestStatus;
      
      public function progressassembly_3()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      function frame1() : *
      {
         stop();
      }
   }
}
