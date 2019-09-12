package netgauge_fla
{
   import flash.display.MovieClip;
   
   public dynamic class speedtestgraph_51 extends MovieClip
   {
       
      
      public var fill:MovieClip;
      
      public var line:MovieClip;
      
      public var fillcolor:Color01;
      
      public function speedtestgraph_51()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      function frame1() : *
      {
         stop();
         NetGaugeUI.ng.colorClip(this.line,"Color01");
      }
   }
}
