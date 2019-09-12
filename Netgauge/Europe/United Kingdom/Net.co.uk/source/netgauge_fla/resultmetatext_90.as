package netgauge_fla
{
   import fl.text.RuntimeFontMapper;
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.Font;
   
   public dynamic class resultmetatext_90 extends MovieClip
   {
       
      
      public var metadata:TLFTextField;
      
      public var label:TLFTextField;
      
      public var __checkFontName_:String;
      
      public var __cacheXMLSettings:Object;
      
      public function resultmetatext_90()
      {
         super();
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
            RuntimeManager.getSingleton().addInstance(this,"label",new Rectangle(0,0,60,17),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="1" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow blockProgression="tb" lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0" textAlign="start" textAlignLast="start" textIndent="0" textJustify="interWord"><span color="#869096" fontFamily="2Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" textAlpha="1" textRotation="auto" trackingRight="0%">Client:</span></p></TextFlow></tlfTextObject>,null,undefined,0,0,"",false,true);
            RuntimeManager.getSingleton().addInstance(this,"metadata",new Rectangle(0,0,348.75,18.2),<tlfTextObject type="Paragraph" editPolicy="readSelect" columnCount="1" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow blockProgression="tb" lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphSpaceAfter="0" paragraphSpaceBefore="0" paragraphStartIndent="0" textAlign="start" textAlignLast="start" textIndent="0" textJustify="interWord"><span color="#383e42" fontFamily="1Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" textAlpha="1" textRotation="auto" trackingRight="0%">2001:0db8:..... Comcast Communications </span></p></TextFlow></tlfTextObject>,null,undefined,0,0,"",false,true);
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
         Font.registerFont(_2Custom_1);
         RuntimeFontMapper.addFontMapEntry("[\'1Custom*\',\'normal\',\'normal\']",["HelveticaNeueLT Std","normal","normal"]);
         RuntimeFontMapper.addFontMapEntry("[\'2Custom*\',\'normal\',\'normal\']",["HelveticaNeueLT Std","bold","normal"]);
      }
   }
}
