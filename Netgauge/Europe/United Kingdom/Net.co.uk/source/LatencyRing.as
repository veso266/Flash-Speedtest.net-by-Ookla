package
{
   import flash.display.MovieClip;
   
   public dynamic class LatencyRing extends MovieClip
   {
       
      
      public function LatencyRing()
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
