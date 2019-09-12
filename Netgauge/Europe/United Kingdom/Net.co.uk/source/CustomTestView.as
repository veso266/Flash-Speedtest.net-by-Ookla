package
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFormat;
   
   class CustomTestView extends SpeedTestView
   {
       
      
      protected var netgauge:NetGaugeUI;
      
      protected var errorsFound = 0;
      
      protected var speedCounter:int = 0;
      
      protected var downloadSG:SpeedGraph = null;
      
      protected var uploadSG:SpeedGraph = null;
      
      function CustomTestView(param1:*)
      {
         super(param1);
         trace("CustomTestView");
         BarrierManager.addListener(this);
         this.netgauge = DocumentClass.document.netgauge;
      }
      
      override public function testUnlocked() : *
      {
         super.testUnlocked();
         CustomUI.configureIcons(DocumentClass.document.dash.client.icon,DocumentClass.document.dash.server.icon);
         CustomUI.setInterfaceSettings(configuration);
         this.configureButtons();
         this.displayInitialBeginTest();
      }
      
      protected function displayInitialBeginTest() : *
      {
         if(!controller.isTestInProgress && controller.isAutoStart() != 0)
         {
            this.loadServers("normal");
         }
      }
      
      protected function configureButtons() : *
      {
         if(this.netgauge.getChild("form"))
         {
            ButtonPlacement.forceMultiButton = true;
            ButtonPlacement.offsetY = ButtonPlacement.offsetY + 82;
            ButtonPlacement.standardScale = 0.85;
         }
      }
      
      override public function handleFatalError(param1:String, param2:String, param3:Object) : *
      {
         var error:ErrorMessage = null;
         var data:* = undefined;
         var button:GeneralButton = null;
         var f:Function = null;
         var testType:String = param1;
         var subTestType:String = param2;
         var obj:Object = param3;
         if(controller.isdontDieOnErrorTest(testType))
         {
            switch(testType)
            {
               case "firewall":
                  ProgressBar.getProgressBar("firewall").state = ProgressBar.STATE_SKIPPED;
                  ProgressBar.getProgressBar("firewall").skipMessage = obj.error;
                  break;
               case "packetloss":
                  ProgressBar.getProgressBar("packetloss").state = ProgressBar.STATE_SKIPPED;
                  ProgressBar.getProgressBar("packetloss").skipMessage = obj.error;
            }
            controller.addResults(testType,"-1");
            controller.nextTestOrFinish();
            return;
         }
         if(!this.errorsFound)
         {
            error = new ErrorMessage();
            DocumentClass.document.addChild(error);
            Logger.moveToTop();
            error.content.text = obj.error;
            error.title.text = obj.title;
            data = configuration.getSettingArray("errors");
            if(TestConfigurator.getBoolean(data.linktodocs,false) == true)
            {
               button = new GeneralButton();
               error.addChild(button);
               button.x = 234.8;
               button.y = 348.45;
               button.display = Translation.getText("documentation");
               f = function():*
               {
                  var _loc1_:URLRequest = new URLRequest("http://api.ookla.com/netgauge/documentation.php?code=" + obj.code);
                  navigateToURL(_loc1_);
               };
               button.addEventListener(MouseEvent.CLICK,f,false,0,false);
            }
         }
         this.errorsFound++;
      }
      
      override public function handleTestStart(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         switch(param1)
         {
            case "autostart":
               GenericStartButton.destroyButtons();
               if(this.netgauge.getChild("form"))
               {
                  Tools.fadeOutAndDelete(this.netgauge.getChild("form"),1);
               }
               TiledEndOfTest.removeEndOfTest();
               ResultMeta.removeResultMeta();
               this.netgauge.removeShareSlice();
               break;
            case "throttling":
               this.netgauge.translateStatus("measuringserverusage");
               break;
            case "global":
               ProgressBar.reset();
               ProgressBar.fadeIn();
               _loc2_ = controller.clientIp;
               if(_loc2_ != null)
               {
                  DocumentClass.document.dash.ipisp.ip.text = this.netgauge.handleDashIP(_loc2_);
                  Tools.fadeIn(DocumentClass.document.dash.ipisp);
                  _loc5_ = controller.clientIsp;
                  if(_loc5_ != null)
                  {
                     DocumentClass.document.dash.ipisp.ispname.text = _loc5_;
                  }
                  else
                  {
                     DocumentClass.document.dash.ipisp.ispname.text = "";
                  }
               }
               break;
            case "methodchange":
               _loc3_ = TestConfigurator.getRangeInt(configuration.getSetting("interface","displayserver"),0,2,2);
               _loc4_ = controller.getServerSelector() == "geoip" && controller.getServerCount() > 1;
               if(_loc3_ == 1 || _loc3_ == 2 && (controller.getButtonCount() > 1 || _loc4_))
               {
                  Logger.error(configuration.getServerName());
                  DocumentClass.document.dash.serverlocation.servername.text = configuration.getServerName();
                  DocumentClass.document.dash.serverlocation.serverlocation.text = configuration.getServerLocation();
                  Tools.fadeIn(DocumentClass.document.dash.serverlocation);
               }
               break;
            case "latency":
               this.netgauge.setDashTest("latency");
               ProgressBar.getProgressBar("latency").state = ProgressBar.STATE_PROGRESS;
               this.netgauge.translateStatus("testinglatency");
               break;
            case "download":
               this.netgauge.setDashTest("download");
               ProgressBar.getProgressBar("download").state = ProgressBar.STATE_PROGRESS;
               this.netgauge.setGaugeMetric(CustomUI.displaySpeedUnit(1024,"gauge"));
               break;
            case "upload":
               this.netgauge.setDashTest("upload");
               ProgressBar.getProgressBar("upload").state = ProgressBar.STATE_PROGRESS;
               this.netgauge.setGaugeMetric(CustomUI.displaySpeedUnit(1024,"gauge"));
               break;
            case "packetloss":
               this.netgauge.setDashTest("packetloss");
               ProgressBar.getProgressBar("packetloss").state = ProgressBar.STATE_PROGRESS;
               this.netgauge.translateStatus("testingpacketloss");
               break;
            case "firewall":
               this.netgauge.setDashTest("firewall");
               ProgressBar.getProgressBar("firewall").state = ProgressBar.STATE_PROGRESS;
               this.netgauge.translateStatus("testingfirewall");
         }
      }
      
      override protected function handleSpeedUpdate(param1:String, param2:Object) : *
      {
         if(this.speedCounter++ % 2 == 0 && !param2.done)
         {
            return;
         }
         this.netgauge.speedSpeed = param2.current;
         if(param1 == "upload" || param1 == "socket-upload" || param1 == "http-upload")
         {
            ProgressBar.getProgressBar("upload").progress = param2.progress;
            this.netgauge.setSpeedProgress(param2.progress,"upload");
            if(this.downloadSG != null && param1 != "http-upload")
            {
               this.downloadSG.updateGraph2(param2,SpeedGraph.UPDATE_LINE);
            }
         }
         else
         {
            ProgressBar.getProgressBar("download").progress = param2.progress;
            this.netgauge.setSpeedProgress(param2.progress,"download");
            if(this.downloadSG != null)
            {
               this.downloadSG.updateGraph(param2,SpeedGraph.UPDATE_MASK);
            }
         }
      }
      
      override protected function handleLatencyUpdate(param1:String, param2:Object) : *
      {
         this.netgauge.latencyProgress(param2.progress);
         ProgressBar.getProgressBar("latency").progress = param2.progress;
      }
      
      override public function handleSubTestStart(param1:String, param2:String) : *
      {
         switch(param2)
         {
            case "throttling":
               break;
            case "http-latency":
            case "socket-latency":
               break;
            case "http-initialdownload":
               this.netgauge.translateStatus("preparingdownload");
               break;
            case "socket-download":
            case "http-download":
               this.netgauge.iconPulse("server");
               controller.setProgressCallBack(this.handleSpeedUpdate);
               if(TestConfigurator.getBoolean(configuration.getSetting("netgauge","showgraphs"),true) == true)
               {
                  this.downloadSG = new SpeedGraph((this.netgauge.getChild("dash") as MovieClip).speed.liveresult.downloadgraph.fill,(this.netgauge.getChild("dash") as MovieClip).speed.liveresult.downloadgraph.line);
               }
               this.netgauge.translateStatus("testingdownload");
               break;
            case "http-initialupload":
               this.netgauge.translateStatus("preparingupload");
               break;
            case "socket-upload":
            case "http-upload":
               this.netgauge.iconPulse("client");
               controller.setProgressCallBack(this.handleSpeedUpdate);
               if(param2 == "socket-upload" && TestConfigurator.getBoolean(configuration.getSetting("netgauge","showgraphs"),true) == true)
               {
                  this.downloadSG.fadeMaskTo(0.5);
               }
               this.netgauge.translateStatus("testingupload");
         }
      }
      
      override public function handleSubTestEnd(param1:String, param2:String, param3:Object) : *
      {
         Logger.info("handleSubTestEnd " + param2);
         switch(param2)
         {
            case "http-initialdownload":
               controller.nextTest();
               break;
            case "http-initialupload":
               controller.nextTest();
         }
      }
      
      override protected function handleThrottingUpdate(param1:String, param2:Object) : *
      {
         var _loc4_:* = undefined;
         var _loc3_:* = Math.ceil(param2.estimatedTime / 1000);
         if(_loc3_ > 0)
         {
            if(_loc3_ == 1)
            {
               this.netgauge.translateStatus("teststartingin1");
            }
            else
            {
               _loc4_ = Tools.stringReplace(Translation.getText("teststartingin"),"{SECONDS}",_loc3_);
               this.netgauge.updateStatus(_loc4_);
            }
         }
      }
      
      override protected function handleGenericProgress(param1:String, param2:String, param3:Object) : *
      {
         switch(param1)
         {
            case "firewall":
               ProgressBar.getProgressBar("firewall").progress = param3.progress;
               break;
            case "packetloss":
               ProgressBar.getProgressBar("packetloss").progress = param3.progress;
               if(param3.event == 2)
               {
                  Logger.info("sent " + param3.sent);
                  this.netgauge.packetLossAnimation(param3.sent,"sent");
               }
         }
      }
      
      protected function endOfTest() : *
      {
         BarrierManager.barrierTouch("postAPIHit",2);
         this.netgauge.updateStatus("");
         this.netgauge.setDashTest("hide");
         ProgressBar.fadeOut();
         var _loc1_:* = TestConfigurator.getRangeInt(configuration.getSetting("endoftest","columns"),2,5,5);
         TiledEndOfTest.setColumn(_loc1_);
         TiledEndOfTest.addEndOfTest(controller.getResults(),TestConfigurator.getString(configuration.getSetting("endoftest","toprow"),""),TestConfigurator.getString(configuration.getSetting("endoftest","bottomrow"),""));
         ResultMeta.addResultMeta(configuration,controller);
         this.loadServers("restart");
      }
      
      override public function handleTestEnd(param1:String, param2:Object) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         Logger.info("handleTestEnd " + param1);
         switch(param1)
         {
            case "packetloss":
               ProgressBar.getProgressBar("packetloss").state = ProgressBar.STATE_COMPLETE;
               TweenLite.delayedCall(1,this.packetLossEndOfTestAnimation,[param2]);
               break;
            case "firewall":
               ProgressBar.getProgressBar("firewall").state = ProgressBar.STATE_COMPLETE;
               this.firewallEndOfTestAnimation(param2);
               break;
            case "latency":
               ProgressBar.getProgressBar("latency").state = ProgressBar.STATE_COMPLETE;
               controller.delayedNextTest(0.5);
               break;
            case "download":
               ProgressBar.getProgressBar("download").state = ProgressBar.STATE_COMPLETE;
               this.netgauge.iconPulse("client");
               _loc3_ = new TextFormat();
               if(NetGaugeUI.ng.template == "classic")
               {
                  _loc3_.size = Math.floor(0.75 * TestUI.getFontSize(DocumentClass.document.dash.speed.liveresult.downloadspeed.txt));
                  CustomUI.displayFinalSpeed2(DocumentClass.document.dash.speed.liveresult.downloadspeed.txt,CustomUI.displaySpeed(param2.final,"final")," " + CustomUI.displaySpeedUnit(param2.final,"final"),_loc3_,false);
               }
               else
               {
                  _loc3_.size = Math.floor(0.75 * TestUI.getFontSize(DocumentClass.document.dash.speed.liveresult.download.downloadspeed.txt));
                  CustomUI.displayFinalSpeed2(DocumentClass.document.dash.speed.liveresult.download.downloadspeed.txt,CustomUI.displaySpeed(param2.final,"final")," " + CustomUI.displaySpeedUnit(param2.final,"final"),_loc3_,false);
               }
               controller.addResults("graph",this.downloadSG);
               this.needleAnimation(controller.nextTest);
               break;
            case "upload":
               ProgressBar.getProgressBar("upload").state = ProgressBar.STATE_COMPLETE;
               this.netgauge.iconPulse("server");
               _loc4_ = new TextFormat();
               if(NetGaugeUI.ng.template == "classic")
               {
                  _loc4_.size = Math.floor(0.75 * TestUI.getFontSize(DocumentClass.document.dash.speed.liveresult.uploadspeed.txt));
                  CustomUI.displayFinalSpeed2(DocumentClass.document.dash.speed.liveresult.uploadspeed.txt,CustomUI.displaySpeed(param2.final,"final")," " + CustomUI.displaySpeedUnit(param2.final,"final"),_loc4_,false);
               }
               else
               {
                  _loc4_.size = Math.floor(0.75 * TestUI.getFontSize(DocumentClass.document.dash.speed.liveresult.upload.uploadspeed.txt));
                  CustomUI.displayFinalSpeed2(DocumentClass.document.dash.speed.liveresult.upload.uploadspeed.txt,CustomUI.displaySpeed(param2.final,"final")," " + CustomUI.displaySpeedUnit(param2.final,"final"),_loc4_,false);
               }
               controller.addResults("graph",this.downloadSG);
               this.needleAnimation(controller.nextTest);
               break;
            case "global":
               break;
            case "global-nexttest":
               TweenLite.delayedCall(1,this.endOfTest);
               break;
            default:
               controller.nextTest();
         }
      }
      
      protected function firewallEndOfTestAnimation(param1:Object) : *
      {
         this.netgauge.firewallEndOfTestAnimation(param1);
         if(param1.firewall == 15)
         {
            controller.delayedNextTest(1.5);
         }
         else
         {
            controller.delayedNextTest(2.5);
         }
      }
      
      protected function packetLossEndOfTestAnimation(param1:Object) : *
      {
         this.netgauge.packetLossEndOfTestAnimation(param1);
         TweenLite.delayedCall(3,controller.nextTest);
      }
      
      public function barrierHit(param1:String) : *
      {
         var _loc2_:* = undefined;
         trace("BarrierHit: " + param1);
         switch(param1)
         {
            case "startUpload":
               controller.nextTest();
               break;
            case "postAPIHit":
               if(TestConfigurator.getBoolean(configuration.getSetting("share","enabled"),false))
               {
                  _loc2_ = controller.lastAPIResult;
                  if(_loc2_ != null && Number(_loc2_.resultid) > 0)
                  {
                     this.netgauge.addShareSlice(Number(_loc2_.resultid));
                  }
               }
         }
      }
      
      protected function handleForm(param1:MovieClip) : *
      {
      }
      
      override public function startTest(param1:*) : *
      {
         trace("start:" + param1);
         controller.setServerId(param1);
         GenericStartButton.fadeOutButtons();
         if(this.netgauge.getChild("form"))
         {
            this.handleForm(this.netgauge.getChild("form") as MovieClip);
            Tools.fadeOutAndDelete(this.netgauge.getChild("form"),1);
         }
         TiledEndOfTest.removeEndOfTest();
         ResultMeta.removeResultMeta();
         this.netgauge.removeShareSlice();
         if(param1 >= 0)
         {
            controller.start();
         }
         else
         {
            TweenLite.delayedCall(1,this.loadServers,["normal"]);
         }
      }
      
      protected function needleAnimation(param1:Function) : *
      {
         TweenLite.to(this.netgauge,2,{
            "speedSpeed":0,
            "ease":SpeedTestView.easeOut,
            "onComplete":param1
         });
      }
      
      public function loadServers(param1:String) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = TestConfigurator.getBoolean(configuration.getSetting("extras","allowinteractions"),true);
         if(!_loc2_)
         {
            return;
         }
         _loc3_ = controller.getButtonCount();
         if(param1 == "restart" && _loc3_ > 2)
         {
            ButtonPlacement.placeItems(ButtonPlacement.multipleButtons(),param1);
            return;
         }
         ButtonPlacement.placeItems(ButtonPlacement.dropButtons(param1,_loc3_,configuration,controller),param1);
      }
   }
}
