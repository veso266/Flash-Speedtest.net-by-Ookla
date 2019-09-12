package
{
   import flash.display.MovieClip;
   
   public dynamic class LatencyRingAnimation extends MovieClip
   {
       
      
      public function LatencyRingAnimation()
      {
         super();
         addFrameScript(30,this.frame31);
      }
      
      function frame31() : *
      {
         stop();
         parent.removeChild(this);
      }
   }
}
