package
{
   import com.adobe.utils.StringUtil;
   import com.greensock.OverwriteManager;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.TintPlugin;
   import com.greensock.plugins.TweenPlugin;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class NetGaugeUI
   {
      
      private static var _ng:NetGaugeUI = null;
       
      
      protected var _template:String = "";
      
      protected var shareURL:String = "http://netgauge.ookla.com/share/{RESULTID}.png";
      
      private var sg:SpeedGraph;
      
      private var sg2:SpeedGraph;
      
      protected var _speedSpeed = 0;
      
      protected var defaultColors:Object;
      
      protected var recolorList:Object;
      
      public function NetGaugeUI()
      {
         super();
         _ng = this;
         this.init();
      }
      
      public static function get ng() : NetGaugeUI
      {
         return _ng;
      }
      
      public function get template() : String
      {
         return this._template;
      }
      
      public function init() : *
      {
         OverwriteManager.init(OverwriteManager.AUTO);
         TweenPlugin.activate([AutoAlphaPlugin,TintPlugin]);
         this.recolorList = new Object();
         this.defaultColors = new Object();
      }
      
      public function testUnlocked(param1:Configuration) : *
      {
         var _loc4_:* = undefined;
         this.fadeFade();
         var _loc2_:* = param1.getSettingArrays("recolor.color");
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.prefix.length > 0 && _loc4_.color.length == 6 && !isNaN(parseInt(_loc4_.color,16)))
            {
               this.recolorList[_loc4_.prefix] = parseInt(_loc4_.color,16);
               Logger.info("recolor: " + _loc4_.prefix + "  " + _loc4_.color + "  " + parseInt(_loc4_.color,16));
            }
            _loc3_++;
         }
      }
      
      public function getChild(param1:String) : DisplayObject
      {
         return DocumentClass.document.getChildByName(param1);
      }
      
      public function simulateAddButtons() : *
      {
         var _loc3_:* = undefined;
         var _loc1_:Array = new Array();
         var _loc2_:* = 1;
         while(_loc2_ <= 11)
         {
            _loc3_ = new StartButtonMulti();
            _loc3_.display = "Server " + _loc2_;
            _loc3_.scaleX = _loc3_.scaleY = 0.6;
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         ButtonPlacement.placeItems(_loc1_);
      }
      
      public function simulateTest() : *
      {
         this.simulateAddButtons();
         ProgressBar.createProgress(new Array("latency","firewall","packetloss","download","upload"));
         this.setIcon("client","user");
         this.setIcon("server","office");
         TweenLite.delayedCall(2,GenericStartButton.fadeOutButtons);
      }
      
      public function removeShareSlice() : *
      {
         if(this.getChild("slice") != null)
         {
            Tools.fadeOutAndDelete(this.getChild("slice"),1);
         }
      }
      
      public function addShareSlice(param1:Number) : *
      {
         var shareurl:* = undefined;
         var resultId:Number = param1;
         shareurl = Tools.stringReplace(this.shareURL,"{RESULTID}",String(resultId));
         var slice:* = new ShareSlice();
         slice.name = "slice";
         slice.x = 440;
         slice.y = 365;
         slice.copy.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):*
         {
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,shareurl);
         });
         DocumentClass.document.addChild(slice);
      }
      
      public function fadeFade() : *
      {
         TweenLite.to(this.getChild("fade"),1,{"autoAlpha":0});
      }
      
      public function hideDash() : *
      {
         TweenLite.to(this.getChild("dash") as MovieClip,0.5,{"alpha":0});
      }
      
      public function setIcon(param1:String, param2:String) : *
      {
         var type:String = param1;
         var icon:String = param2;
         try
         {
            ((this.getChild("dash") as MovieClip).getChildByName(type) as MovieClip).icon.gotoAndStop(icon);
            return;
         }
         catch(e:ArgumentError)
         {
            Logger.error("Could not set icon to: " + icon);
            return;
         }
      }
      
      public function iconPulse(param1:String) : *
      {
         ((this.getChild("dash") as MovieClip).getChildByName(param1) as MovieClip).icon.pulse.gotoAndPlay("fire");
      }
      
      public function setGaugeMetric(param1:String) : *
      {
         DocumentClass.document.dash.speed.gauge.metric.label.txt.text = param1;
      }
      
      public function updateStatus(param1:String) : *
      {
         (this.getChild("progress") as MovieClip).status.label = param1;
      }
      
      public function translateStatus(param1:String) : *
      {
         Translation.translateObject((this.getChild("progress") as MovieClip).status,param1);
      }
      
      public function openOoklaLanding() : *
      {
         Tools.openOoklaLanding();
      }
      
      public function openOoklaSupport() : *
      {
         Tools.openOoklaSupport();
      }
      
      public function licenseExpiringSoon(param1:Number, param2:Boolean) : *
      {
         (this.getChild("masthead") as MovieClip).notice.alpha = 1;
         if(param2)
         {
            (this.getChild("masthead") as MovieClip).notice.msg.txt.text = "TRIAL MODE: This Application expires in " + param1 + " days.";
         }
         else
         {
            (this.getChild("masthead") as MovieClip).notice.msg.txt.text = "Warning: Your Application expires in " + param1 + " days.";
         }
      }
      
      public function trialMode() : *
      {
         (this.getChild("masthead") as MovieClip).notice.alpha = 1;
         (this.getChild("masthead") as MovieClip).notice.msg.txt.text = "TRIAL MODE";
      }
      
      public function setDashTestSimulated(param1:String) : *
      {
         var _loc2_:* = undefined;
         this.setDashTest(param1);
         this.updateStatus(param1 + " running");
         switch(param1)
         {
            case "latency":
               TweenLite.to(ProgressBar.getProgressBar("latency"),0,{"state":ProgressBar.STATE_PROGRESS});
               TweenLite.to(ProgressBar.getProgressBar("latency"),2,{
                  "progress":1,
                  "ease":Linear.easeNone
               });
               TweenLite.to(ProgressBar.getProgressBar("latency"),0,{
                  "state":ProgressBar.STATE_COMPLETE,
                  "delay":2
               });
               _loc2_ = 1;
               while(_loc2_ <= 9)
               {
                  TweenLite.delayedCall(0.15 * _loc2_,this.latencyProgress,[_loc2_ * 0.1]);
                  _loc2_++;
               }
               TweenLite.delayedCall(3,this.setDashTestSimulated,["firewall"]);
               break;
            case "firewall":
               TweenLite.to(ProgressBar.getProgressBar("firewall"),0,{"state":ProgressBar.STATE_PROGRESS});
               TweenLite.to(ProgressBar.getProgressBar("firewall"),5,{
                  "progress":1,
                  "ease":Linear.easeNone
               });
               TweenLite.to(ProgressBar.getProgressBar("firewall"),0,{
                  "state":ProgressBar.STATE_COMPLETE,
                  "delay":5
               });
               TweenLite.delayedCall(5,this.firewallEnd,[true]);
               TweenLite.delayedCall(7,this.setDashTestSimulated,["packetloss"]);
               break;
            case "packetloss":
               TweenLite.to(ProgressBar.getProgressBar("packetloss"),0,{"state":ProgressBar.STATE_PROGRESS});
               TweenLite.to(ProgressBar.getProgressBar("packetloss"),7,{
                  "progress":1,
                  "ease":Linear.easeNone
               });
               TweenLite.to(ProgressBar.getProgressBar("packetloss"),0,{
                  "state":ProgressBar.STATE_COMPLETE,
                  "delay":7
               });
               TweenLite.delayedCall(8,this.setDashTestSimulated,["speed"]);
               break;
            case "jitter":
               (this.getChild("dash") as MovieClip).latencyani.gotoAndPlay("jitter");
               break;
            case "speed":
               TweenLite.to(ProgressBar.getProgressBar("speed"),0,{"state":ProgressBar.STATE_PROGRESS});
               TweenLite.to(ProgressBar.getProgressBar("speed"),4,{"progress":1});
               TweenLite.to(ProgressBar.getProgressBar("speed"),0,{
                  "state":ProgressBar.STATE_COMPLETE,
                  "delay":4
               });
               TweenLite.delayedCall(0,this.iconPulse,["server"]);
               TweenLite.delayedCall(2,this.iconPulse,["client"]);
               this.sg = new SpeedGraph((this.getChild("dash") as MovieClip).speed.liveresult.downloadgraph.fill,(this.getChild("dash") as MovieClip).speed.liveresult.downloadgraph.line);
               this.sg2 = new SpeedGraph((this.getChild("dash") as MovieClip).speed.liveresult.uploadgraph.fill,(this.getChild("dash") as MovieClip).speed.liveresult.uploadgraph.line);
               TweenLite.delayedCall(0,this.sg.updateGraph,[{
                  "progress":0,
                  "time":0,
                  "bytes":0
               }]);
               TweenLite.delayedCall(0.4,this.sg.updateGraph,[{
                  "progress":0.2,
                  "time":1,
                  "bytes":1000000
               }]);
               TweenLite.delayedCall(0.8,this.sg.updateGraph,[{
                  "progress":0.4,
                  "time":2,
                  "bytes":2000000
               }]);
               TweenLite.delayedCall(1.2,this.sg.updateGraph,[{
                  "progress":0.6,
                  "time":3,
                  "bytes":3500000
               }]);
               TweenLite.delayedCall(1.6,this.sg.updateGraph,[{
                  "progress":0.8,
                  "time":4,
                  "bytes":5000000
               }]);
               TweenLite.delayedCall(2,this.sg.updateGraph,[{
                  "progress":1,
                  "time":5,
                  "bytes":6000000
               }]);
               TweenLite.delayedCall(2,this.sg2.updateGraph,[{
                  "progress":0,
                  "time":0,
                  "bytes":0
               }]);
               TweenLite.delayedCall(2.4,this.sg2.updateGraph,[{
                  "progress":0.2,
                  "time":1,
                  "bytes":1000000
               }]);
               TweenLite.delayedCall(2.8,this.sg2.updateGraph,[{
                  "progress":0.4,
                  "time":2,
                  "bytes":2000000
               }]);
               TweenLite.delayedCall(3.2,this.sg2.updateGraph,[{
                  "progress":0.6,
                  "time":3,
                  "bytes":3500000
               }]);
               TweenLite.delayedCall(3.6,this.sg2.updateGraph,[{
                  "progress":0.8,
                  "time":4,
                  "bytes":5000000
               }]);
               TweenLite.delayedCall(4,this.sg2.updateGraph,[{
                  "progress":1,
                  "time":5,
                  "bytes":6000000
               }]);
               TweenLite.delayedCall(4.5,this.setDashTestSimulated,["endoftest"]);
               break;
            case "endoftest":
               TweenLite.delayedCall(1,this.updateStatus,[""]);
               TiledEndOfTest.addEndOfTest({});
         }
      }
      
      public function set speedSpeed(param1:Number) : *
      {
         this._speedSpeed = param1;
      }
      
      public function get speedSpeed() : Number
      {
         return this._speedSpeed;
      }
      
      public function packetLossAnimation(param1:Number, param2:String) : *
      {
         var _loc3_:* = {"value":0};
         TweenLite.to(_loc3_,1,{
            "value":param1,
            "onUpdate":this.packetLossUpdateAnimation,
            "onUpdateParams":[_loc3_,param2]
         });
      }
      
      public function packetLossUpdateAnimation(param1:Object, param2:String) : *
      {
         var _loc3_:* = Math.round(param1.value);
         if(param2 == "sent")
         {
            DocumentClass.document.dash.packetloss.meta.sent.txt.text = _loc3_;
         }
         if(param2 == "received")
         {
            DocumentClass.document.dash.packetloss.meta.received.txt.text = _loc3_;
         }
      }
      
      public function firewallEndOfTestAnimation(param1:Object) : *
      {
         if(param1.firewall == 15)
         {
            DocumentClass.document.dash.firewall.gotoAndPlay("nofirewall");
         }
         else
         {
            DocumentClass.document.dash.firewall.gotoAndPlay("firewall");
         }
      }
      
      public function packetLossEndOfTestAnimation(param1:Object) : *
      {
         var _loc4_:* = undefined;
         if(param1.received > 0)
         {
            this.packetLossAnimation(param1.received,"received");
         }
         else
         {
            DocumentClass.document.dash.packetloss.meta.received.txt.text = "N/A";
         }
         DocumentClass.document.dash.packetloss.gotoAndPlay("finish");
         Logger.info("received " + param1.received);
         var _loc2_:Array = new Array("p4","p8","p6","p3","p9","p7","p5","p1","p10","p2");
         var _loc3_:* = Math.ceil(param1.final / 10);
         if(_loc3_ <= 0)
         {
            return;
         }
         _loc4_ = 0;
         _loc4_ = 0;
         while(_loc4_ < 10)
         {
            DocumentClass.document.dash.packetloss.getChildByName(_loc2_[_loc4_]).gotoAndStop(1);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            TweenLite.to(DocumentClass.document.dash.packetloss.getChildByName(_loc2_[_loc4_]),0.5,{
               "alpha":0,
               "tint":0
            });
            _loc4_++;
         }
      }
      
      public function speedToDegrees(param1:*) : *
      {
         var _loc2_:* = Tools.speedInKbps(param1);
         var _loc3_:* = new Array(-120,-90,-60,-30,0,30,60,90,120);
         return Tools.valueToDegreesCustom(_loc2_,CustomUI.incrementSpeeds,_loc3_);
      }
      
      public function firewallEnd(param1:Boolean) : *
      {
         if(param1)
         {
            (this.getChild("dash") as MovieClip).firewall.gotoAndPlay("firewall");
         }
         else
         {
            (this.getChild("dash") as MovieClip).firewall.gotoAndPlay("nofirewall");
         }
      }
      
      public function trackColor(param1:MovieClip) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = Tools.fullPath(param1);
         for(_loc3_ in this.recolorList)
         {
            _loc4_ = this.recolorList[_loc3_];
            if(StringUtil.beginsWith(_loc2_,_loc3_))
            {
               this.recolor(param1,_loc4_);
            }
         }
      }
      
      public function colorClip(param1:MovieClip, param2:String) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:ColorTransform = null;
         var _loc7_:* = undefined;
         var _loc3_:uint = 0;
         if(this.defaultColors[param2])
         {
            _loc3_ = this.defaultColors[param2];
         }
         else
         {
            _loc3_ = TestUI.getColor(param2);
         }
         _loc4_ = Tools.fullPath(param1);
         for(_loc5_ in this.recolorList)
         {
            _loc7_ = this.recolorList[_loc5_];
            if(StringUtil.beginsWith(_loc4_,_loc5_))
            {
               _loc3_ = _loc7_;
            }
         }
         _loc6_ = new ColorTransform();
         _loc6_.color = _loc3_;
         param1.transform.colorTransform = _loc6_;
      }
      
      public function recolor(param1:MovieClip, param2:Number) : *
      {
         var _loc3_:* = param1.getChildAt(0);
         _loc3_.graphics.clear();
         _loc3_.graphics.lineStyle();
         _loc3_.graphics.beginFill(param2);
         _loc3_.graphics.drawRect(-31.75,-31.75,63.45,63.45);
         _loc3_.graphics.endFill();
      }
      
      public function handleDashIP(param1:String) : *
      {
         if(param1.length >= 16 && param1.lastIndexOf(":") >= 0)
         {
            param1 = "IPv6";
         }
         return param1;
      }
      
      public function latencyProgress(param1:Number) : *
      {
      }
      
      public function setDashTest(param1:String) : *
      {
      }
      
      public function setSpeedProgress(param1:Number, param2:String) : *
      {
      }
   }
}
