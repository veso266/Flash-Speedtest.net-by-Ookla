package
{
   import com.greensock.TweenLite;
   import fl.text.RuntimeFontMapper;
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.Font;
   import netgauge_fla._1Custom_0;
   
   public class TestStatus extends MovieClip
   {
       
      
      public var status:TLFTextField;
      
      public var __checkFontName_:String;
      
      public var __cacheXMLSettings:Object;
      
      private var _label:String = "";
      
      public function TestStatus()
      {
         super();
         trace("TestStatus: " + this);
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
            RuntimeManager.getSingleton().addInstance(this,"status",new Rectangle(0,0,287.05,19.25),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="explicit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0.6" textAlign="center" textIndent="0"><span baselineShift="0" color="#373d41" digitCase="oldStyle" fontFamily="1Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="107.916667%" textAlpha="1" trackingRight="0%"></span></p><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0.6" textAlign="center" textIndent="0"><span baselineShift="0" color="#373d41" digitCase="oldStyle" fontFamily="1Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="107.916667%" textAlpha="1" trackingRight="0%"></span></p></TextFlow></tlfTextObject>,null,undefined,0,0,"",false,true);
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
      
      public function get display() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : *
      {
         this._label = param1;
         (this.getChildByName("status") as TLFTextField).text = this._label;
      }
      
      public function set display(param1:String) : *
      {
         var _loc2_:* = this._label;
         this._label = param1;
         if(_loc2_ == "")
         {
            this.doDisplay();
         }
         else
         {
            TweenLite.to(this.getChildByName("status"),0.2,{
               "alpha":0,
               "onComplete":this.doDisplay
            });
         }
      }
      
      public function doDisplay() : *
      {
         (this.getChildByName("status") as TLFTextField).alpha = 0;
         (this.getChildByName("status") as TLFTextField).text = this._label;
         TweenLite.to(this.getChildByName("status"),0.2,{"alpha":1});
      }
   }
}
