package netgauge_fla
{
   import fl.text.RuntimeFontMapper;
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.Font;
   
   public dynamic class firewallnotice_37 extends MovieClip
   {
       
      
      public var txt:TLFTextField;
      
      public var __checkFontName_:String;
      
      public var __cacheXMLSettings:Object;
      
      public function firewallnotice_37()
      {
         super();
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
            RuntimeManager.getSingleton().addInstance(this,"txt",new Rectangle(0,0,211.2,28),<tlfTextObject type="Point" editPolicy="readOnly" columnCount="1" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow blockProgression="tb" lineBreak="explicit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0.6" textAlign="center" textAlignLast="start" textIndent="0" textJustify="interWord"><span color="#333333" fontFamily="2Custom*" fontSize="24" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="100%" textAlpha="1" textRotation="auto" trackingRight="0%">No Firewall Found</span></p></TextFlow></tlfTextObject>,null,undefined,0,0,"",false,true);
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
   }
}
