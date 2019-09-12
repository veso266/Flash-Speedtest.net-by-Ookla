package netgauge_fla
{
   import fl.text.RuntimeFontMapper;
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.Font;
   
   public dynamic class shareresultmsg_74 extends MovieClip
   {
       
      
      public var header:TLFTextField;
      
      public var __checkFontName_:String;
      
      public var __cacheXMLSettings:Object;
      
      public function shareresultmsg_74()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__checkFontName_ = "netgauge_fla._2Custom_1";
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
            RuntimeManager.getSingleton().addInstance(this,"header",new Rectangle(0,0,130,42.75),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="1" columnGap="20" verticalAlign="middle" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow blockProgression="tb" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0.6" textAlign="start" textAlignLast="start" textIndent="0" textJustify="interWord"><span color="#333333" fontFamily="2Custom*" fontSize="14" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="107.916667%" textAlpha="1" textRotation="auto" trackingRight="0%">Share URL Copied</span></p><p direction="ltr" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0.6" textAlign="start" textAlignLast="start" textIndent="0" textJustify="interWord"><span color="#333333" fontFamily="2Custom*" fontSize="14" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="107.916667%" textAlpha="1" textRotation="auto" trackingRight="0%">to Clipboard</span></p></TextFlow></tlfTextObject>,null,undefined,0,69,"",false,true);
         }
         finally
         {
            XML.setSettings(this.__cacheXMLSettings);
         }
         RuntimeManager.getSingleton().addInstanceComplete(this);
      }
      
      public function __registerTLFFonts() : void
      {
         Font.registerFont(_2Custom_1);
         RuntimeFontMapper.addFontMapEntry("[\'2Custom*\',\'normal\',\'normal\']",["HelveticaNeueLT Std","bold","normal"]);
      }
      
      function frame1() : *
      {
         Translation.translate(this.header,"shareurlcopied");
      }
   }
}
