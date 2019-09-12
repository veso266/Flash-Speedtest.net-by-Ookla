package netgauge_fla
{
   import fl.text.RuntimeFontMapper;
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public dynamic class speedtestresulttextdownload_50 extends MovieClip
   {
       
      
      public var txt:TLFTextField;
      
      public var __cacheXMLSettings:Object;
      
      public function speedtestresulttextdownload_50()
      {
         super();
         RuntimeFontMapper.addFontMapEntry("[\'2Custom*\',\'normal\',\'normal\']",["HelveticaNeueLT Std","bold","normal"]);
         this.__cacheXMLSettings = XML.settings();
         try
         {
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            XML.prettyPrinting = false;
            RuntimeManager.getSingleton().addInstance(this,"txt",new Rectangle(0,0,127,29),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="middle" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="false" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="explicit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#373d41" digitCase="default" fontFamily="2Custom*" fontSize="20" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="100%" trackingRight="0%"></span></p></TextFlow></tlfTextObject>,null,undefined,0,0,"",false,true);
         }
         finally
         {
            XML.setSettings(this.__cacheXMLSettings);
         }
         RuntimeManager.getSingleton().addInstanceComplete(this);
      }
   }
}
