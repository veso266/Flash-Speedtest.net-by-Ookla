package
{
   import fl.text.RuntimeFontMapper;
   import fl.text.RuntimeManager;
   import fl.text.TCMRuntimeManager;
   import fl.text.TCMText;
   import fl.text.TLFTextField;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.Font;
   import flash.text.TextFormat;
   import netgauge_fla._1Custom_0;
   import netgauge_fla._2Custom_1;
   
   public class Tile2x1 extends GenericTile
   {
       
      
      public var received:TLFTextField;
      
      public var sent:TLFTextField;
      
      public var icon:MovieClip;
      
      public var server_label:TLFTextField;
      
      public var client_tcp:TLFTextField;
      
      public var received_label:TLFTextField;
      
      public var msg:TLFTextField;
      
      public var error:TLFTextField;
      
      public var client_icon:MovieClip;
      
      public var client_udp:TLFTextField;
      
      public var jitter:MovieClip;
      
      public var __id6_:TCMText;
      
      public var __id7_:TCMText;
      
      public var server_udp:TLFTextField;
      
      public var __id4_:TCMText;
      
      public var latency:MovieClip;
      
      public var __id5_:TCMText;
      
      public var packetloss_label:TLFTextField;
      
      public var title:TLFTextField;
      
      public var server_icon:MovieClip;
      
      public var learnmore:GeneralButton;
      
      public var packetloss:MovieClip;
      
      public var sent_label:TLFTextField;
      
      public var server_tcp:TLFTextField;
      
      public var skipped:TLFTextField;
      
      public var client_label:TLFTextField;
      
      public var __checkFontName_:String;
      
      public var __cacheXMLSettings:Object;
      
      public function Tile2x1(param1:String, param2:Object)
      {
         var test:String = param1;
         var results:Object = param2;
         addFrameScript(0,this.frame1,20,this.frame21,40,this.frame41,60,this.frame61,80,this.frame81,99,this.frame100,115,this.frame116);
         super(2,1,test,results);
         trace("Tile2x1: " + this + " " + test);
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
            RuntimeManager.getSingleton().addInstance(this,"title",new Rectangle(0,0,193.7,22.4),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#383e42" fontFamily="2Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="103.333333%" trackingRight="0%">Title</span></p></TextFlow></tlfTextObject>,null,undefined,0,152,"",false,true);
            RuntimeManager.getSingleton().addInstance(this,"server_label",new Rectangle(0,0,62.95,29.05),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="middle" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#393f43" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">To Server:</span></p></TextFlow></tlfTextObject>,null,undefined,40,59,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"client_label",new Rectangle(0,0,63.75,31.55),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="middle" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#393f43" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">To Client:</span></p></TextFlow></tlfTextObject>,null,undefined,40,59,"",true,false);
            TCMRuntimeManager.getSingleton().addInstance(this,"__id4_",new Rectangle(0,0,26.2,15),<tlfTextObject type="Point" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="explicit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#869096" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">TCP</span></p></TextFlow></tlfTextObject>,null,undefined,40,59,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"server_tcp",new Rectangle(0,0,49.7,14.3),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#393f43" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Open</span></p></TextFlow></tlfTextObject>,null,undefined,40,59,"",true,false);
            TCMRuntimeManager.getSingleton().addInstance(this,"__id5_",new Rectangle(0,0,27.6,15),<tlfTextObject type="Point" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="explicit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#869096" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">UDP</span></p></TextFlow></tlfTextObject>,null,undefined,40,59,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"server_udp",new Rectangle(0,0,50.5,14.3),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#393f43" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Closed</span></p></TextFlow></tlfTextObject>,null,undefined,40,59,"",true,false);
            TCMRuntimeManager.getSingleton().addInstance(this,"__id6_",new Rectangle(0,0,26.2,15),<tlfTextObject type="Point" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="explicit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#869096" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">TCP</span></p></TextFlow></tlfTextObject>,null,undefined,40,59,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"client_tcp",new Rectangle(0,0,50.5,14.3),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#393f43" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Open</span></p></TextFlow></tlfTextObject>,null,undefined,40,59,"",true,false);
            TCMRuntimeManager.getSingleton().addInstance(this,"__id7_",new Rectangle(0,0,27.6,15),<tlfTextObject type="Point" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="explicit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#869096" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">UDP</span></p></TextFlow></tlfTextObject>,null,undefined,40,59,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"client_udp",new Rectangle(0,0,50.5,14.3),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="start" textIndent="0"><span baselineShift="0" color="#393f43" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Closed</span></p></TextFlow></tlfTextObject>,null,undefined,40,59,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"received_label",new Rectangle(0,0,80.3,20.7),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="bottom" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#858f95" fontFamily="2Custom*" fontSize="9" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Packets Received</span></p></TextFlow></tlfTextObject>,null,undefined,60,79,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"sent_label",new Rectangle(0,0,80.3,20.7),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="bottom" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#858f95" fontFamily="2Custom*" fontSize="9" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Packets Sent</span></p></TextFlow></tlfTextObject>,null,undefined,60,79,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"sent",new Rectangle(0,0,82.9,20),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="middle" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="false" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="explicit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#383e42" fontFamily="2Custom*" fontSize="16" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="87.5%" trackingRight="0%">100</span></p></TextFlow></tlfTextObject>,null,undefined,60,79,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"received",new Rectangle(0,0,82.9,20.05),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="middle" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="false" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="explicit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#383e42" fontFamily="2Custom*" fontSize="16" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="87.5%" trackingRight="0%">100</span></p></TextFlow></tlfTextObject>,null,undefined,60,79,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"packetloss_label",new Rectangle(0,0,92.75,33.95),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="bottom" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#858f95" fontFamily="2Custom*" fontSize="11" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Packet Loss</span></p></TextFlow></tlfTextObject>,null,undefined,60,79,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"skipped",new Rectangle(0,0,176.9,69.55),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="middle" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#869096" fontFamily="2Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Test Skipped</span></p></TextFlow></tlfTextObject>,null,undefined,99,114,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"error",new Rectangle(0,0,176.9,18.2),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#869096" fontFamily="2Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" lineHeight="101.818182%" trackingRight="0%">Test Error</span></p></TextFlow></tlfTextObject>,null,undefined,115,152,"",true,false);
            RuntimeManager.getSingleton().addInstance(this,"msg",new Rectangle(0,0,175.55,35.6),<tlfTextObject type="Paragraph" editPolicy="readOnly" columnCount="auto" columnGap="20" verticalAlign="top" firstBaselineOffset="auto" paddingLeft="2" paddingTop="2" paddingRight="2" paddingBottom="2" background="false" backgroundColor="#ffffff" backgroundAlpha="1" border="false" borderColor="#000000" borderAlpha="1" borderWidth="1" paddingLock="false" multiline="true" antiAliasType="advanced" embedFonts="true"><TextFlow lineBreak="toFit" locale="en_US" whiteSpaceCollapse="preserve" version="2.0.0" xmlns="http://ns.adobe.com/textLayout/2008"><p direction="ltr" paragraphEndIndent="0" paragraphStartIndent="0" textAlign="center" textIndent="0"><span baselineShift="0" color="#869096" fontFamily="1Custom*" fontSize="12" fontStyle="normal" fontWeight="normal" kerning="auto" ligatureLevel="uncommon" lineHeight="101.818182%" trackingRight="0%">Message about why it was skipped or had an error</span></p></TextFlow></tlfTextObject>,null,undefined,115,152,"",true,false);
         }
         finally
         {
            XML.setSettings(this.__cacheXMLSettings);
         }
         RuntimeManager.getSingleton().addInstanceComplete(this);
         TCMRuntimeManager.getSingleton().addInstanceComplete(this);
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
               break;
            case "latency":
               if(results.latency == undefined)
               {
                  doSkipped();
                  return;
               }
               _loc2_ = new TextFormat();
               _loc2_.size = Math.floor(0.75 * TestUI.getFontSize((getChildByName("latency") as MovieClip).label));
               CustomUI.displayFinalSpeed2((getChildByName("latency") as MovieClip).label,results.latency," ms",_loc2_,false);
               break;
            case "jitter":
               if(results.jitter == undefined)
               {
                  doSkipped();
                  return;
               }
               (getChildByName("icon") as MovieClip).gotoAndStop("jitter");
               _loc3_ = new TextFormat();
               _loc3_.size = Math.floor(0.75 * TestUI.getFontSize((getChildByName("jitter") as MovieClip).label));
               CustomUI.displayFinalSpeed2((getChildByName("jitter") as MovieClip).label,results.jitter," ms",_loc3_,false);
               break;
            case "firewall":
               if(results.firewall == undefined)
               {
                  doSkipped();
                  return;
               }
               if(results.firewall == -1)
               {
                  if(results["firewall-errorcode"] == undefined && results["firewall-error"] == undefined)
                  {
                     doSkipped();
                  }
                  else
                  {
                     doError(results["firewall-errorcode"],results["firewall-error"]);
                  }
                  return;
               }
               Translation.translate(this.server_label,"tile_toserver");
               Translation.translate(this.client_label,"tile_toclient");
               (getChildByName("server_icon") as MovieClip).gotoAndStop(CustomUI.getIcon("server"));
               (getChildByName("client_icon") as MovieClip).gotoAndStop(CustomUI.getIcon("client"));
               (this as MovieClip).server_tcp.text = !!(results.firewall & 1)?Translation.getText("open"):Translation.getText("closed");
               (this as MovieClip).server_udp.text = !!(results.firewall & 4)?Translation.getText("open"):Translation.getText("closed");
               (this as MovieClip).client_tcp.text = !!(results.firewall & 2)?Translation.getText("open"):Translation.getText("closed");
               (this as MovieClip).client_udp.text = !!(results.firewall & 8)?Translation.getText("open"):Translation.getText("closed");
               break;
            case "packetloss":
               if(results.packetloss == undefined)
               {
                  doSkipped();
                  return;
               }
               if(results.packetloss == -1)
               {
                  if(results["packetloss-errorcode"] == undefined && results["packetloss-error"] == undefined)
                  {
                     doSkipped();
                  }
                  else
                  {
                     doError(results["packetloss-errorcode"],results["packetloss-error"]);
                  }
                  return;
               }
               Translation.translate(this.packetloss_label,"tile_packetloss");
               Translation.translate(this.sent_label,"tile_packetssent");
               Translation.translate(this.received_label,"tile_packetsreceived");
               (this as MovieClip).received.text = results["packetloss-received"];
               (this as MovieClip).sent.text = results["packetloss-sent"];
               (getChildByName("packetloss") as MovieClip).label.text = Math.round(100 - 100 * results["packetloss-received"] / results["packetloss-sent"]) + "%";
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