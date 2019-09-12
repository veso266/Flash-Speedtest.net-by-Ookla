package
{
   import fl.text.RuntimeFontMapper;
   import fl.text.RuntimeManager;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.Font;
   import flash.text.TextFormat;
   import netgauge_fla._1Custom_0;
   import netgauge_fla._2Custom_1;
   
   public class Tile2x2 extends GenericTile
   {
       
      
      public var upload_measure:MovieClip;
      
      public var msg:TLFTextField;
      
      public var error:TLFTextField;
      
      public var upload_label:TLFTextField;
      
      public var uploadgraph:MovieClip;
      
      public var download_graph:MovieClip;
      
      public var download_label:TLFTextField;
      
      public var download_measure:MovieClip;
      
      public var title:TLFTextField;
      
      public var learnmore:GeneralButton;
      
      public var downloadgraph:MovieClip;
      
      public var skipped:TLFTextField;
      
      public var upload_graph:MovieClip;
      
      public var __checkFontName_:String;
      
      public var __cacheXMLSettings:Object;
      
      public function Tile2x2(param1:String, param2:Object)
      {
         var test:String = param1;
         var results:Object = param2;
         addFrameScript(0,this.frame1,20,this.frame21,40,this.frame41,60,this.frame61,80,this.frame81,99,this.frame100,115,this.frame116);
         super(2,2,test,results);
         trace("Tile2x2: " + this + " " + test);
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
            RuntimeManager.getSingleton().addInstance(this,"title",new Rectangle(0,0,193.7,33.1),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#383e42" fontFamily="2Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="103.333333%" trackingRight="0%">Title</span></p></TextFlow></tlfTextObject>,null,undefined,0,174,"",false,true);
            RuntimeManager.getSingleton().addInstance(this,"download_label",new Rectangle(0,0,177.25,16.6),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#858f95" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Download Speed</span></p></TextFlow></tlfTextObject>,null,undefined,80,98,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"upload_label",new Rectangle(0,0,177.25,16.6),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#858f95" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Upload Speed</span></p></TextFlow></tlfTextObject>,null,undefined,80,98,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"skipped",new Rectangle(0,0,175.2,167.25),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="middle" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#869096" fontFamily="2Custom*" fontSize="14" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Test Skipped</span></p></TextFlow></tlfTextObject>,null,undefined,99,114,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"error",new Rectangle(0,0,175.2,22.4),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#869096" fontFamily="2Custom*" fontSize="14" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Test Skipped</span></p></TextFlow></tlfTextObject>,null,undefined,115,174,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"msg",new Rectangle(0,0,172.15,114.25),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#869096" fontFamily="1Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" ligatureLevel="uncommon" lineHeight="101.818182%" trackingRight="0%">Message about why it was skipped or had an error</span></p></TextFlow></tlfTextObject>,null,undefined,115,174,"",true,false);
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
      
      override protected function doStuff(param1:Event) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         super.doStuff(param1);
         switch(test)
         {
            case "speed":
               if(results.download == undefined)
               {
                  doSkipped();
                  return;
               }
               Translation.translate(this.download_label,"tile_downloadspeed");
               Translation.translate(this.upload_label,"tile_uploadspeed");
               (getChildByName("download_measure") as MovieClip).icon.gotoAndStop("download");
               _loc2_ = new TextFormat();
               _loc2_.size = Math.floor(0.75 * TestUI.getFontSize((getChildByName("download_measure") as MovieClip).label));
               CustomUI.displayFinalSpeed2((getChildByName("download_measure") as MovieClip).label,CustomUI.displaySpeed(results.download,"final")," " + CustomUI.displaySpeedUnit(results.download,"final"),_loc2_,false);
               if(results.upload != undefined)
               {
                  _loc3_ = new TextFormat();
                  _loc3_.size = Math.floor(0.75 * TestUI.getFontSize((getChildByName("upload_measure") as MovieClip).label));
                  CustomUI.displayFinalSpeed2((getChildByName("upload_measure") as MovieClip).label,CustomUI.displaySpeed(results.upload,"final")," " + CustomUI.displaySpeedUnit(results.upload,"final"),_loc3_,false);
               }
               else
               {
                  (getChildByName("upload_measure") as MovieClip).label.text = "";
               }
               if(results["graph"] != undefined)
               {
                  results["graph"].redrawGraph((getChildByName("downloadgraph") as MovieClip).fill,null);
                  if(results.upload != undefined)
                  {
                     results["graph"].redrawGraph2((getChildByName("uploadgraph") as MovieClip).fill,null);
                  }
               }
               break;
            case "latency":
               break;
            case "firewall":
               break;
            case "packetloss":
               break;
            case "shareimage":
         }
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame21() : *
      {
         stop();
      }
      
      function frame41() : *
      {
         stop();
      }
      
      function frame61() : *
      {
         stop();
      }
      
      function frame81() : *
      {
         stop();
      }
      
      function frame100() : *
      {
         stop();
      }
      
      function frame116() : *
      {
         stop();
      }
   }
}
