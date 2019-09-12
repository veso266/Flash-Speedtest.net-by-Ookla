package netgauge_fla
{
   import flash.display.MovieClip;
   
   public dynamic class packetlossassembly_22 extends MovieClip
   {
       
      
      public var p1:MovieClip;
      
      public var p2:MovieClip;
      
      public var p3:MovieClip;
      
      public var p4:MovieClip;
      
      public var p5:MovieClip;
      
      public var p6:MovieClip;
      
      public var p7:MovieClip;
      
      public var p10:MovieClip;
      
      public var p8:MovieClip;
      
      public var meta:MovieClip;
      
      public var p9:MovieClip;
      
      public function packetlossassembly_22()
      {
         super();
         addFrameScript(0,this.frame1,10,this.frame11,19,this.frame20,29,this.frame30,40,this.frame41,49,this.frame50,59,this.frame60,69,this.frame70,79,this.frame80,89,this.frame90,98,this.frame99,290,this.frame291);
      }
      
      function frame1() : *
      {
         this.p10.gotoAndPlay("pulse");
      }
      
      function frame11() : *
      {
         this.p9.gotoAndPlay("pulse");
      }
      
      function frame20() : *
      {
         this.p8.gotoAndPlay("pulse");
      }
      
      function frame30() : *
      {
         this.p7.gotoAndPlay("pulse");
      }
      
      function frame41() : *
      {
         this.p6.gotoAndPlay("pulse");
      }
      
      function frame50() : *
      {
         this.p5.gotoAndPlay("pulse");
      }
      
      function frame60() : *
      {
         this.p4.gotoAndPlay("pulse");
      }
      
      function frame70() : *
      {
         this.p3.gotoAndPlay("pulse");
      }
      
      function frame80() : *
      {
         this.p2.gotoAndPlay("pulse");
      }
      
      function frame90() : *
      {
         this.p1.gotoAndPlay("pulse");
      }
      
      function frame99() : *
      {
         stop();
      }
      
      function frame291() : *
      {
         stop();
      }
   }
}
