package netgauge_fla
{
   import fl.text.RuntimeFontMapper;
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public dynamic class connectionIPandISP_7 extends MovieClip
   {
       
      
      public var ispname:TLFTextField;
      
      public var ip:TextField;
      
      public var __cacheXMLSettings:Object;
      
      public function connectionIPandISP_7()
      {
         super();
         RuntimeFontMapper.addFontMapEntry("[\'1Custom*\',\'normal\',\'normal\']",["HelveticaNeueLT Std","normal","normal"]);
         this.__cacheXMLSettings = XML.settings();
         try
         {
            XML.ignoreProcessingInstructions = false;
            XML.ignoreWhitespace = false;
            XML.prettyPrinting = false;
            RuntimeManager.getSingleton().addInstance(this,"ispname",new Rectangle(0,0,118,28.45),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#373d41" fontFamily="1Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="95.416667%" trackingRight="0%"></span></p></TextFlow></tlfTextObject>,null,undefined,0,0,"",false,true);
         }
         finally
         {
            XML.setSettings(this.__cacheXMLSettings);
         }
         RuntimeManager.getSingleton().addInstanceComplete(this);
      }
   }
}
