package netgauge_fla
{
   import flash.display.MovieClip;
   
   public dynamic class firewallasssembly_26 extends MovieClip
   {
       
      
      public var firewallfound:MovieClip;
      
      public var nofirewall:MovieClip;
      
      public var linezoom:MovieClip;
      
      public function firewallasssembly_26()
      {
         super();
         addFrameScript(15,this.frame16,45,this.frame46,61,this.frame62,68,this.frame69,125,this.frame126);
      }
      
      function frame16() : *
      {
         stop();
      }
      
      function frame46() : *
      {
         Translation.translate(this.nofirewall.txt,"firewallnotfound");
      }
      
      function frame62() : *
      {
         stop();
      }
      
      function frame69() : *
      {
         Translation.translate(this.firewallfound.txt,"firewallfound");
      }
      
      function frame126() : *
      {
         stop();
      }
   }
}
