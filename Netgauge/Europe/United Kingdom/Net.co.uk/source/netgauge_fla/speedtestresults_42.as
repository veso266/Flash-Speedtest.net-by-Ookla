package netgauge_fla
{
   import fl.text.RuntimeFontMapper;
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.Font;
   
   public dynamic class speedtestresults_42 extends MovieClip
   {
       
      
      public var uploadlabel:MovieClip;
      
      public var connectiongraph:TLFTextField;
      
      public var downloadlabel:MovieClip;
      
      public var uploadspeed:MovieClip;
      
      public var uploadgraph:MovieClip;
      
      public var uploadicon:ProgressBar;
      
      public var downloadspeed:MovieClip;
      
      public var downloadicon:ProgressBar;
      
      public var downloadgraph:MovieClip;
      
      public var __checkFontName_:String;
      
      public var __cacheXMLSettings:Object;
      
      public function speedtestresults_42()
      {
         super();
         addFrameScript(0,this.frame1,39,this.frame40);
         this.__checkFontName_ = "netgauge_fla._1Custom_0";
         if(!RuntimeManager.checkTLFFontsLoaded(null,this.__checkFontName_,this.__registerTLFFonts))
         {
            addEventListener(Event.FRAME_CONSTRUCTED,RuntimeManager.checkTLFFontsLoaded,false,1);
         }
         this.__cacheXMLSettings = XML.settings();
         try
         {
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            XML.prettyPrinting = false;
            RuntimeManager.getSingleton().addInstance(this,"connectiongraph",new Rectangle(0,0,149.75,15.25),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#373d41" fontFamily="1Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="136.666667%" trackingRight="0%">CONNECTION GRAPH</span></p></TextFlow></tlfTextObject>,null,undefined,0,117,"",false,true);
         }
         finally
         {
            XML.setSettings(this.__cacheXMLSettings);
         }
         RuntimeManager.getSingleton().addInstanceComplete(this);
      }
      
      public function __registerTLFFonts() : void
      {
         Font.registerFont(_1Custom_0);
         RuntimeFontMapper.addFontMapEntry("[\'1Custom*\',\'normal\',\'normal\']",["HelveticaNeueLT Std","normal","normal"]);
      }
      
      function frame1() : *
      {
         stop();
         this.downloadicon.icon.gotoAndStop("download");
         this.uploadicon.icon.gotoAndStop("upload");
         Translation.translate(this.connectiongraph);
      }
      
      function frame40() : *
      {
         stop();
         this.downloadicon.icon.gotoAndStop("download");
         Translation.translate(this.connectiongraph);
      }
   }
}