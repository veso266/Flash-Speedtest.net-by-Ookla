package
{
   import com.adobe.crypto.MD5;
   import com.adobe.utils.StringUtil;
   import com.greensock.TweenLite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   class SpeedTestController extends EventDispatcher
   {
      
      protected static var controller:SpeedTestController;
      
      public static const TEST_UNLOCKED:String = "testUnlocked";
       
      
      protected var license:License;
      
      protected var challenge:String;
      
      protected var configuration:CustomConfiguration;
      
      protected var locked:Boolean = true;
      
      protected var testList:Array;
      
      protected var dontDieOnErrorTestList:Array;
      
      protected var subTestList:Array;
      
      protected var view:CustomSpeedTestView;
      
      protected var results:Object;
      
      protected var permaResults:Object;
      
      protected var logger:Logger;
      
      protected var testCount = 0;
      
      protected var testConfigurator:CustomTestConfigurator;
      
      protected var version = "3.0.7";
      
      protected var currentTestId:Number = 0;
      
      protected var currentTest:Test = null;
      
      protected var testInProgress = false;
      
      protected var serverSelector = "default";
      
      protected var serverCount = 1;
      
      protected var expiringSoonDays = -1;
      
      protected var currentSubTestId = 0;
      
      protected var _testFlag:String = "";
      
      protected var eventCounter:Number = 0;
      
      protected var javascriptFields:Array;
      
      protected var extraFields:Array;
      
      protected var apiHash = "lol";
      
      protected var _lastAPIResult:URLVariables = null;
      
      protected var _clientIp:String = null;
      
      protected var _clientIsp:String = null;
      
      protected var _clientLocation:Point;
      
      function SpeedTestController()
      {
         this.testList = new Array("throttling","latency","download","upload");
         this.dontDieOnErrorTestList = new Array("healthcheck");
         this.subTestList = new Array();
         this.javascriptFields = new Array("serverid","customer","testmethod","serverport","methodid");
         this.extraFields = new Array();
         super();
         SpeedTestController.controller = this;
         this.logger = new Logger();
         this.permaResults = new Object();
         this.results = new Object();
         this.license = new CustomLicense();
         this.view = new CustomSpeedTestView(this);
         this.testConfigurator = new CustomTestConfigurator();
         this.loadMenu();
      }
      
      static function getController() : SpeedTestController
      {
         return controller;
      }
      
      protected function loadMenu() : *
      {
         var doNothing:Function = function():*
         {
         };
         var compileDate:Date = new Date();
         compileDate.setTime(Version.compileDate * 1000);
         var menu:* = new ContextMenu();
         menu.hideBuiltInItems();
         var version:* = new ContextMenuItem("Speed Test v" + this.version);
         menu.customItems.push(version);
         var date:* = new ContextMenuItem(compileDate.getFullYear() + "-" + (compileDate.getMonth() + 1) + "-" + compileDate.getDate());
         menu.customItems.push(date);
         DocumentClass.document.contextMenu = menu;
         Logger.info("Speed Test v" + this.version + "  " + compileDate.getFullYear() + "-" + (compileDate.getMonth() + 1) + "-" + compileDate.getDate());
      }
      
      public function setConfiguration(param1:CustomConfiguration) : *
      {
         this.configuration = param1;
         this.view.setConfiguration(param1);
      }
      
      public function getConfiguration() : CustomConfiguration
      {
         return this.configuration;
      }
      
      public function getTestConfigurator() : CustomTestConfigurator
      {
         return this.testConfigurator;
      }
      
      public function get isTestInProgress() : Boolean
      {
         return this.testInProgress;
      }
      
      public function settingsLoaded(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:TestEvent = null;
         Logger.info("License Key: " + param1);
         var _loc2_:* = this.license.verifyKey(param1);
         if(_loc2_ == 0)
         {
            this.unlockTest();
            if(this.license.isTrial)
            {
               this.trialActive();
            }
         }
         else
         {
            switch(_loc2_)
            {
               case 5:
                  _loc3_ = "license06";
                  break;
               case 4:
                  _loc3_ = "license05";
                  break;
               case 2:
                  _loc3_ = "license02";
                  break;
               case 3:
                  _loc3_ = "license03";
                  break;
               case 1:
                  _loc3_ = "license04";
            }
            _loc4_ = {
               "type":"fatal",
               "test":"license",
               "code":_loc3_
            };
            _loc5_ = new TestEvent(TestEvent.FATAL,_loc4_);
            this.handleTestFatalEvent(_loc5_);
         }
      }
      
      protected function trialActive() : *
      {
      }
      
      public function getView() : *
      {
         return this.view;
      }
      
      protected function unlockTest() : *
      {
         Logger.info("Unlocking test");
         var _loc1_:* = this.license.getServerCount();
         if(_loc1_ > 0)
         {
            this.serverCount = _loc1_;
         }
         this.locked = false;
         this.configuration.testUnlocked();
         Translation.testUnlocked(this.configuration);
         Logger.testUnlocked(this.configuration);
         this.testUnlocked();
         this.view.testUnlocked();
         dispatchEvent(new Event(TEST_UNLOCKED));
      }
      
      public function reset() : *
      {
         var _loc1_:* = undefined;
         this.testInProgress = false;
         this.currentTestId = 0;
         this.currentTest = null;
         this.subTestList = new Array();
         this.currentSubTestId = 0;
         this.eventCounter = 0;
         this.configuration.setMethodId(0);
         this.results = new Object();
         for(_loc1_ in this.permaResults)
         {
            Logger.info("Vars: " + _loc1_ + "=" + this.permaResults[_loc1_]);
            this.addResults(_loc1_,this.permaResults[_loc1_]);
         }
      }
      
      protected function testUnlocked() : *
      {
         Logger.info("Test Unlocked");
      }
      
      public function setServerId(param1:*) : *
      {
         this.configuration.setServerId(param1);
      }
      
      public function start(param1:* = undefined) : *
      {
         TweenLite.killDelayedCallsTo(this.autoStart);
         if(this.locked || this.testInProgress)
         {
            return;
         }
         if(param1 != undefined)
         {
            this.configuration.setServerId(param1);
         }
         this.reset();
         this.testCount++;
         this.results.serverid = this.configuration.getServerId();
         this.results.serverindex = this.configuration.getId();
         this.results.customer = this.configuration.getCustomer();
         Logger.info("Starting test");
         this.handleTestStart(this.configuration.getId());
         this.testInProgress = true;
         this.nextTest();
      }
      
      public function autoStart() : *
      {
         this.view.handleTestStart("autostart");
         this.start();
      }
      
      function getTestCount() : *
      {
         return this.testCount;
      }
      
      function addResults(param1:*, param2:*) : *
      {
         this.results[param1] = param2;
      }
      
      function addPermaResults(param1:*, param2:*) : *
      {
         this.permaResults[param1] = param2;
         this.results[param1] = param2;
      }
      
      public function nextTest() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         if(this.locked)
         {
            Logger.error("Test locked");
            return;
         }
         if(!this.testInProgress)
         {
            Logger.error("No test in progress");
            _loc2_ = {
               "type":"complete",
               "test":"global-nexttest"
            };
            this.view.handleTestEnd("global-nexttest",_loc2_);
            return;
         }
         if(this.currentSubTestId < this.subTestList.length)
         {
            _loc1_ = this.subTestList[this.currentSubTestId];
            this.currentSubTestId++;
            this.eventCounter = 0;
            this.removeListeners();
            this.currentTest = null;
            this.startSubTest(_loc1_);
         }
         else if(this.currentTestId < this.testList.length)
         {
            _loc1_ = this.testList[this.currentTestId];
            this.currentTestId++;
            this.currentSubTestId = 0;
            this.subTestList = new Array();
            this.startTest(_loc1_);
         }
      }
      
      public function delayedNextTest(param1:Number = 1) : *
      {
         TweenLite.delayedCall(param1,this.nextTest);
      }
      
      public function redoLastTest() : *
      {
         this.currentTestId--;
         this.subTestList = new Array();
         this.currentSubTestId = 0;
         this.nextTest();
      }
      
      public function redoLastSubTest() : *
      {
         this.currentSubTestId--;
         this.nextTest();
      }
      
      protected function finishTest() : *
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         if(this.currentSubTestId >= this.subTestList.length && this.currentTestId >= this.testList.length)
         {
            this.testInProgress = false;
            SocketConnection.closeAll();
            Logger.info("Final Latency: " + this.results.latency + " ms");
            Logger.info("Final Download Speed: " + this.results.download);
            Logger.info("Final Download Speed: " + Tools.convertSpeed(this.results.download,Tools.UNIT_INPUT,Tools.UNIT_KILO + Tools.UNIT_BITS) + " Kbps");
            Logger.info("Final Upload Speed: " + this.results.upload);
            Logger.info("Final Upload Speed: " + Tools.convertSpeed(this.results.upload,Tools.UNIT_INPUT,Tools.UNIT_KILO + Tools.UNIT_BITS) + " Kbps");
            Logger.flushFullLog(this.configuration.getCustomer(),Logger.DEBUG);
            _loc1_ = {
               "type":"complete",
               "test":"global"
            };
            this.view.handleTestEnd("global",_loc1_);
            this.handleTestEnd(this.results);
            _loc2_ = TestConfigurator.getRangeInt(this.configuration.getSetting("extras","repeat"),0,3600,0);
            if(_loc2_ > 0)
            {
               TweenLite.delayedCall(_loc2_,this.autoStart);
            }
            return true;
         }
         return false;
      }
      
      public function getServerCount() : *
      {
         var _loc1_:* = Math.max(1,this.configuration.getServerCount());
         return Math.min(this.serverCount,_loc1_);
      }
      
      public function getButtonCount() : *
      {
         return this.getServerCount();
      }
      
      public function getServerSelector() : *
      {
         return this.serverSelector;
      }
      
      public function licenseExpiringSoon(param1:*) : *
      {
         Logger.warning("Expiring Soon: " + param1 + " days");
         this.expiringSoonDays = param1;
      }
      
      public function getResults() : *
      {
         return this.results;
      }
      
      public function getCurrentMethod() : *
      {
         return this.configuration.getMethodType();
      }
      
      public function get testFlag() : String
      {
         return this._testFlag;
      }
      
      public function get subTestActive() : Boolean
      {
         return this.currentTest != null;
      }
      
      protected function startTest(param1:*) : *
      {
         var _loc3_:* = undefined;
         Logger.info("Starting: " + param1);
         this.currentSubTestId = 0;
         var _loc2_:* = this.getCurrentMethod();
         if(param1.indexOf(":") >= 0)
         {
            this._testFlag = param1.substr(param1.indexOf(":") + 1);
            param1 = param1.substr(0,param1.indexOf(":"));
            Logger.info("Test Flag:" + this._testFlag);
         }
         else
         {
            this._testFlag = "";
         }
         switch(param1)
         {
            case "latency":
               switch(_loc2_.toString())
               {
                  case "socket":
                  case "tcp":
                     this.subTestList = new Array("socket-latency");
                     break;
                  case "http":
                  default:
                     this.subTestList = new Array("http-latency");
               }
               break;
            case "download":
               switch(_loc2_.toString())
               {
                  case "socket":
                  case "tcp":
                     this.subTestList = new Array("socket-download");
                     break;
                  case "http":
                  default:
                     this.subTestList = new Array("http-initialdownload","http-download");
               }
               break;
            case "upload":
               switch(_loc2_.toString())
               {
                  case "socket":
                  case "tcp":
                     this.subTestList = new Array("socket-upload");
                     break;
                  case "http":
                  default:
                     this.subTestList = new Array("http-initialupload","http-upload");
               }
               break;
            case "packetloss":
               this.subTestList = new Array("socket-packetloss");
               break;
            case "firewall":
               this.subTestList = new Array("socket-firewall");
               break;
            case "throttling":
               _loc3_ = this.testConfigurator.configureThrottlingTest(this.configuration,this.results);
               if(_loc3_.enabled == false)
               {
                  this.nextTest();
                  return;
               }
               this.subTestList = new Array("throttling");
               break;
            default:
               this.subTestList = new Array(param1);
         }
         this.view.handleTestStart(param1);
         this.extraJavascriptCalls(Tools.JS_TEST_COMPONENT_STARTED,[]);
         this.nextTest();
      }
      
      protected function startSubTest(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:TestEvent = null;
         Logger.info("Starting subtest: " + param1);
         var _loc2_:* = true;
         switch(param1)
         {
            case "throttling":
               _loc3_ = this.testConfigurator.configureThrottlingTest(this.configuration,this.results);
               if(_loc3_.enabled == false)
               {
                  this.nextTest();
                  return;
               }
               this.currentTest = new ThrottlingTest();
               break;
            case "http-latency":
               _loc3_ = this.testConfigurator.configureHTTPLatencyTest(this.configuration,this.results);
               if(_loc3_.enabled == false)
               {
                  this.nextTest();
                  return;
               }
               this.currentTest = new LatencyTest();
               break;
            case "http-initialdownload":
               _loc3_ = this.testConfigurator.configureHTTPInitialDownloadTest(this.configuration,this.results);
               if(_loc3_.enabled == false)
               {
                  this.nextTest();
                  return;
               }
               if(_loc3_.initialtestlength > 0)
               {
                  this.currentTest = new InitialDownloadTest();
               }
               else
               {
                  this.currentTest = new CustomDownloadTest();
               }
               break;
            case "http-download":
               _loc3_ = this.testConfigurator.configureHTTPDownloadTest(this.configuration,this.results);
               this.currentTest = new CustomDownloadTest();
               break;
            case "http-initialupload":
               _loc3_ = this.testConfigurator.configureHTTPInitialUploadTest(this.configuration,this.results);
               this.currentTest = new CustomUploadTest();
               break;
            case "http-upload":
               _loc3_ = this.testConfigurator.configureHTTPUploadTest(this.configuration,this.results);
               this.currentTest = new CustomUploadTest();
               break;
            case "healthcheck":
               _loc3_ = this.testConfigurator.configureHTTPHealthCheck(this.configuration,this.results);
               this.currentTest = new CustomUploadTest();
               break;
            case "socket-upload":
               _loc3_ = this.testConfigurator.configureSocketUploadTest(this.configuration,this.results);
               this.currentTest = new SocketUploadTest();
               break;
            case "socket-download":
               _loc3_ = this.testConfigurator.configureSocketDownloadTest(this.configuration,this.results);
               this.currentTest = new SocketDownloadTest();
               break;
            case "socket-latency":
               _loc3_ = this.testConfigurator.configureSocketLatencyTest(this.configuration,this.results);
               if(_loc3_.enabled == false)
               {
                  this.nextTest();
                  return;
               }
               this.currentTest = new SocketLatencyTest();
               break;
            case "socket-packetloss":
               _loc3_ = this.testConfigurator.configureSocketPacketLossTest(this.configuration,this.results);
               this.currentTest = new SocketPacketLossTest();
               break;
            case "socket-firewall":
               _loc3_ = this.testConfigurator.configureSocketFirewallTest(this.configuration,this.results);
               this.currentTest = new SocketFirewallTest();
               break;
            default:
               this.handleMissingTest(param1);
               _loc2_ = false;
         }
         if(_loc2_)
         {
            this.currentTest.configure(_loc3_);
            this.currentTest.setSampleSize(_loc3_.sampleSize);
         }
         this.currentTest.addEventListener(TestEvent.PROGRESS,this.handleTestProgressEvent);
         this.currentTest.addEventListener(TestEvent.COMPLETE,this.handleTestCompleteEvent);
         this.currentTest.addEventListener(TestEvent.FATAL,this.handleTestFatalEvent);
         _loc4_ = this.currentTest.start();
         if(_loc4_ == false)
         {
            _loc6_ = {
               "type":"fatal",
               "target":this.currentTest,
               "test":param1,
               "code":"settings01"
            };
            _loc7_ = new TestEvent(TestEvent.FATAL,_loc6_);
            this.handleTestFatalEvent(_loc7_);
            return;
         }
         _loc5_ = this.testList[this.currentTestId - 1];
         this.view.handleSubTestStart(_loc5_,param1);
      }
      
      public function setProgressCallBack(param1:Function) : *
      {
         this.currentTest.setProgressCallBack(param1);
      }
      
      public function handleTestFatalEvent(param1:TestEvent) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = param1.data;
         var _loc3_:* = this.testList[this.currentTestId - 1];
         var _loc4_:* = this.subTestList[this.currentSubTestId - 1];
         if(this.currentTest != null)
         {
            Logger.debug("test started: " + this.currentTest.hasStarted());
            if(!this.currentTest.hasStarted())
            {
               this.currentTest.cleanup();
               this.currentTest = null;
               if(_loc2_.code != "socket-packetloss01" && _loc2_.code != "socket-firewall01")
               {
                  _loc5_ = this.configuration.getMethodId();
                  _loc6_ = this.configuration.getServerMethodCount();
                  if(_loc6_ > _loc5_ + 1)
                  {
                     this.configuration.setMethodId(_loc5_ + 1);
                     this.view.handleTestStart("methodchange");
                     TweenLite.delayedCall(0.1,this.redoLastTest);
                     return;
                  }
               }
            }
            else
            {
               this.currentTest.cleanup();
               this.currentTest = null;
            }
         }
         if(_loc2_.error == undefined)
         {
            _loc2_.error = ErrorMessages.getErrorMessage(_loc2_.code);
            _loc2_.title = ErrorMessages.getErrorTitle(_loc2_.code);
         }
         this.handleFatalEvent(_loc3_,_loc4_,_loc2_);
         this.view.handleFatalError(_loc3_,_loc4_,_loc2_);
      }
      
      public function handleTestCompleteEvent(param1:TestEvent) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:* = param1.data;
         var _loc3_:* = this.testList[this.currentTestId - 1];
         var _loc4_:* = _loc3_;
         if(_loc4_.indexOf(":") >= 0)
         {
            _loc4_ = _loc4_.substr(0,_loc4_.indexOf(":"));
         }
         _loc5_ = this.subTestList[this.currentSubTestId - 1];
         _loc6_ = this.currentTestId;
         _loc7_ = this.currentSubTestId;
         Logger.info("final: " + _loc2_.final + "  time: " + _loc2_.time + "  starttime: " + _loc2_.startTime + "  test: " + _loc2_.test);
         this.results[_loc5_] = _loc2_.final;
         this.currentTest.cleanup();
         this.currentTest = null;
         _loc8_ = false;
         if(this.testInProgress && _loc7_ >= this.subTestList.length && _loc6_ >= this.testList.length)
         {
            _loc8_ = true;
         }
         Logger.info("SubTest " + _loc5_ + " complete");
         if(this.currentSubTestId >= this.subTestList.length)
         {
            Logger.info("Test " + _loc3_ + " complete");
            switch(_loc3_)
            {
               case "packetloss":
                  this.results["packetloss-received"] = _loc2_.received;
                  this.results["packetloss-sent"] = _loc2_.sent;
                  break;
               case "latency":
                  if(_loc5_ === "socket-latency")
                  {
                     this.results["jitter"] = _loc2_.jitter;
                     this.results["maxPing"] = _loc2_.maxPing;
                     this.results["averagePing"] = _loc2_.averagePing;
                     this.results["medianPing"] = _loc2_.medianPing;
                  }
            }
            this.results[_loc3_] = _loc2_.final;
            this.extraJavascriptCalls(Tools.JS_TEST_COMPONENT_COMPLETE,_loc2_);
            if(_loc4_ == "latency" || _loc4_ == "download" || _loc4_ == "upload")
            {
               this.results["testmethod"] = this.getCurrentMethod();
               this.results["methodid"] = this.configuration.getMethodId() + 1;
               this.results["serverport"] = this.configuration.getServerPort();
               this.results["serverurl"] = this.configuration.getServerUrl();
            }
         }
         this.view.handleSubTestEnd(_loc3_,_loc5_,_loc2_);
         if(_loc7_ >= this.subTestList.length)
         {
            this.view.handleTestEnd(_loc3_,_loc2_);
         }
         if(_loc8_)
         {
            this.finishTest();
         }
      }
      
      public function nextTestOrFinish() : *
      {
         var _loc1_:Object = null;
         if(this.testInProgress && this.currentSubTestId >= this.subTestList.length && this.currentTestId >= this.testList.length)
         {
            this.finishTest();
            _loc1_ = {
               "type":"complete",
               "test":"global-nexttest"
            };
            this.view.handleTestEnd("global-nexttest",_loc1_);
         }
         else
         {
            this.nextTest();
         }
      }
      
      public function handleTestProgressEvent(param1:TestEvent) : *
      {
         var _loc2_:* = param1.data;
         this.eventCounter++;
         var _loc3_:* = this.testList[this.currentTestId - 1];
         var _loc4_:* = this.subTestList[this.currentSubTestId - 1];
         if(this.eventCounter % 5 == 2 || _loc3_ == "latency" || _loc3_ == "linequality" || _loc3_ == "voiptest" || _loc3_ == "socket-latency")
         {
            Logger.info("progress: " + _loc2_.progress + "  current: " + _loc2_.current + "  time left: " + _loc2_.estimatedTime + "  test: " + _loc2_.test);
         }
         this.view.handleTestProgress(_loc3_,_loc4_,_loc2_);
      }
      
      protected function handleMissingTest(param1:*) : *
      {
         Logger.warning("Missing test!");
      }
      
      public function cancelCurrentTest() : *
      {
         this.removeListeners();
         if(this.currentTest != null)
         {
            this.currentTest.cancel();
         }
         this.currentTest = null;
      }
      
      public function removeListeners() : *
      {
         if(this.currentTest != null)
         {
            this.currentTest.removeEventListener(TestEvent.PROGRESS,this.handleTestProgressEvent);
            this.currentTest.removeEventListener(TestEvent.COMPLETE,this.handleTestCompleteEvent);
            this.currentTest.removeEventListener(TestEvent.FATAL,this.handleTestFatalEvent);
         }
      }
      
      public function isdontDieOnErrorTest(param1:String) : *
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.dontDieOnErrorTestList)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function handleFatalEvent(param1:*, param2:*, param3:*) : *
      {
         if(this.isdontDieOnErrorTest(param1))
         {
            return;
         }
         this.reset();
         this.extraJavascriptCalls(Tools.JS_TEST_ERROR,param3);
         SocketConnection.closeAll();
         Logger.flushFullLog(this.configuration.getCustomer(),Logger.ERROR);
      }
      
      public function handleTestStart(param1:*) : *
      {
         this.view.handleTestStart("global");
         this.view.handleTestStart("methodchange");
         this.extraJavascriptCalls(Tools.JS_TEST_STARTED,[]);
      }
      
      public function extraJavascriptCalls(param1:*, param2:*) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(!ExternalInterface.available)
         {
            return;
         }
         var _loc3_:* = TestConfigurator.getRangeInt(this.configuration.getSetting("extras","jscalls"),0,1024,0);
         _loc3_ = TestConfigurator.getRangeInt(this.configuration.getSetting("reporting","jscalls"),0,1024,_loc3_);
         if(_loc3_ & Tools.JS_TEST_STARTED && param1 & Tools.JS_TEST_STARTED)
         {
            ExternalInterface.call("test_started",this.testCount,this.configuration.getId());
         }
         if(_loc3_ & Tools.JS_TEST_ERROR && param1 & Tools.JS_TEST_ERROR)
         {
            ExternalInterface.call("test_error",param2.code);
         }
         if(_loc3_ & Tools.JS_TEST_COMPONENT_COMPLETE && param1 & Tools.JS_TEST_COMPONENT_COMPLETE)
         {
            _loc4_ = this.testList[this.currentTestId - 1];
            _loc5_ = param2.final;
            if(_loc4_ == "download" || _loc4_ == "upload")
            {
               _loc5_ = Tools.speedInKbps(_loc5_);
            }
            ExternalInterface.call("test_component_complete",_loc4_,_loc5_);
         }
         if(_loc3_ & Tools.JS_TEST_COMPONENT_STARTED && param1 & Tools.JS_TEST_COMPONENT_STARTED)
         {
            _loc6_ = this.testList[this.currentTestId - 1];
            ExternalInterface.call("test_component_started",_loc6_);
         }
      }
      
      public function handleTestEnd(param1:*) : *
      {
         var _loc3_:* = undefined;
         Logger.warning("REPLACE ME: Handle Test End");
         var _loc2_:* = TestConfigurator.getBoolean(this.configuration.getSetting("extras","apireporting"),true);
         _loc2_ = TestConfigurator.getBoolean(this.configuration.getSetting("reporting","apireporting"),_loc2_);
         if(_loc2_)
         {
            this.saveResults(param1);
         }
         _loc3_ = TestConfigurator.getRangeInt(this.configuration.getSetting("extras","jsreporting"),0,3,3);
         _loc3_ = TestConfigurator.getRangeInt(this.configuration.getSetting("reporting","jsreporting"),0,3,_loc3_);
         if(_loc3_ > 0)
         {
            this.javascriptHit(param1,_loc3_);
         }
      }
      
      public function javascriptHit(param1:*, param2:*) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc3_:* = Tools.speedInKbps(param1.upload);
         var _loc4_:* = Tools.speedInKbps(param1.download);
         if(param1.latency != undefined)
         {
            _loc5_ = param1.latency;
         }
         else
         {
            _loc5_ = 0;
         }
         if(!ExternalInterface.available)
         {
            return;
         }
         switch(param2)
         {
            case 1:
               ExternalInterface.call("download_completed",_loc4_,_loc3_,param1.serverid);
               break;
            case 2:
               ExternalInterface.call("test_completed",_loc4_,_loc3_,_loc5_,param1.serverid);
               break;
            case 3:
               _loc6_ = new Object();
               if(param1.clientip != undefined)
               {
                  _loc6_.clientip = param1.clientip;
               }
               if(param1.upload != undefined)
               {
                  _loc6_.upload = Tools.speedInKbps(param1.upload);
               }
               if(param1.download != undefined)
               {
                  _loc6_.download = Tools.speedInKbps(param1.download);
               }
               if(param1.latency != undefined)
               {
                  _loc6_.latency = param1.latency;
               }
               if(param1.jitter != undefined)
               {
                  _loc6_.jitter = param1.jitter;
               }
               if(param1.firewall != undefined)
               {
                  _loc6_.firewall = param1.firewall;
               }
               if(param1.packetloss != undefined)
               {
                  _loc6_.packetloss = param1.packetloss;
               }
               _loc6_.hash = MD5.hash(_loc6_.upload + "-" + _loc6_.download + "-" + this.apiHash);
               _loc8_ = 0;
               while(_loc8_ < this.extraFields.length)
               {
                  _loc7_ = this.extraFields[_loc8_];
                  _loc6_[_loc7_] = param1[_loc7_];
                  _loc8_++;
               }
               _loc9_ = 0;
               while(_loc9_ < this.javascriptFields.length)
               {
                  _loc7_ = this.javascriptFields[_loc9_];
                  _loc6_[_loc7_] = param1[_loc7_];
                  _loc9_++;
               }
               ExternalInterface.call("test_completed",_loc6_);
         }
      }
      
      public function saveResults(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:URLVariables = new URLVariables();
         if(param1.upload != undefined)
         {
            _loc2_.upload = Tools.speedInKbps(param1.upload);
         }
         if(param1.download != undefined)
         {
            _loc2_.download = Tools.speedInKbps(param1.download);
         }
         if(param1.latency != undefined)
         {
            _loc2_.latency = param1.latency;
         }
         if(param1.jitter != undefined)
         {
            _loc2_.jitter = param1.jitter;
         }
         if(param1.firewall != undefined)
         {
            _loc2_.firewall = param1.firewall;
         }
         if(param1.packetloss != undefined)
         {
            _loc2_.packetloss = param1.packetloss;
         }
         if(param1.clientip != undefined)
         {
            _loc2_.clientip = param1.clientip;
         }
         _loc2_.testmethod = param1.testmethod;
         _loc2_.serverid = param1.serverid;
         _loc2_.customer = param1.customer;
         _loc2_.methodid = param1.methodid;
         _loc2_.serverport = param1.serverport;
         _loc2_.serverurl = param1.serverurl;
         _loc2_.testurl = Configuration.removeDynamic(DocumentClass.document.loaderInfo.loaderURL);
         _loc2_.hash = MD5.hash(_loc2_.upload + "-" + _loc2_.download + "-" + this.apiHash);
         _loc3_ = 0;
         while(_loc3_ < this.extraFields.length)
         {
            _loc4_ = this.extraFields[_loc3_];
            _loc2_[_loc4_] = param1[_loc4_];
            _loc3_++;
         }
         Logger.debug(_loc2_);
         this.hitAPIs(_loc2_);
      }
      
      public function hitAPIs(param1:URLVariables) : *
      {
         var _loc3_:URLRequest = null;
         var _loc4_:URLLoader = null;
         var _loc5_:URLRequest = null;
         var _loc6_:URLLoader = null;
         this._lastAPIResult = null;
         var _loc2_:* = false;
         if(this.configuration.isAPIURLDefault())
         {
            _loc2_ = true;
         }
         _loc3_ = new URLRequest(this.configuration.getAPIURL());
         _loc3_.method = URLRequestMethod.POST;
         _loc3_.data = param1;
         _loc4_ = new URLLoader();
         _loc4_.dataFormat = URLLoaderDataFormat.TEXT;
         _loc4_.addEventListener(Event.COMPLETE,Callback.create(this.resultsSaved,{
            "success":true,
            "_default":_loc2_
         }));
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,Callback.create(this.resultsSaved,{
            "success":false,
            "_default":_loc2_
         }));
         _loc4_.load(_loc3_);
         if(this.configuration.hitDefaultAPI())
         {
            _loc5_ = new URLRequest(this.configuration.getDefaultAPIURL());
            _loc5_.method = URLRequestMethod.POST;
            _loc5_.data = param1;
            Logger.info("hit default:" + this.configuration.getDefaultAPIURL());
            _loc6_ = new URLLoader();
            _loc6_.dataFormat = URLLoaderDataFormat.TEXT;
            _loc6_.addEventListener(Event.COMPLETE,Callback.create(this.resultsSaved,{
               "success":true,
               "_default":true
            }));
            _loc6_.addEventListener(IOErrorEvent.IO_ERROR,Callback.create(this.resultsSaved,{
               "success":false,
               "_default":true
            }));
            _loc6_.load(_loc5_);
         }
      }
      
      public function get lastAPIResult() : URLVariables
      {
         return this._lastAPIResult;
      }
      
      public function resultsSaved(param1:Event, param2:Object) : *
      {
         var loader:URLLoader = null;
         var result:URLVariables = null;
         var returnString:String = null;
         var event:Event = param1;
         var obj:Object = param2;
         trace("result: " + event.toString());
         if(obj.success)
         {
            loader = URLLoader(event.target);
            result = new URLVariables();
            returnString = StringUtil.trim(loader.data);
            try
            {
               result.decode(returnString);
               if(obj._default)
               {
                  this._lastAPIResult = result;
               }
            }
            catch(e:Error)
            {
               Logger.error("Invalid result API format");
            }
            Logger.debug("ok on test end: " + obj.success + " " + result);
         }
         else
         {
            Logger.debug("ok on test end: " + obj.success);
         }
      }
      
      public function get clientIp() : String
      {
         return this._clientIp;
      }
      
      public function set clientIp(param1:String) : *
      {
         if(param1 != null)
         {
            Logger.info("IP is " + param1);
            this.addPermaResults("clientip",param1);
            this._clientIp = param1;
         }
         this.testAutoStart();
      }
      
      public function get clientIsp() : String
      {
         return this._clientIsp;
      }
      
      public function set clientIsp(param1:String) : *
      {
         if(param1 != null)
         {
            Logger.info("ISP is " + param1);
            this.addPermaResults("clientisp",param1);
         }
         this._clientIsp = param1;
      }
      
      public function set clientLocation(param1:Point) : *
      {
         trace("Location: " + param1);
         this._clientLocation = param1;
      }
      
      public function get clientLocation() : Point
      {
         return this._clientLocation;
      }
      
      public function isAutoStart() : Number
      {
         var _loc1_:* = TestConfigurator.getRangeInt(this.configuration.getSetting("extras","autostartdelay"),0,60,0);
         _loc1_ = TestConfigurator.getRangeInt(Configuration.getParameter("autostartdelay"),0,60,_loc1_);
         var _loc2_:* = TestConfigurator.getBoolean(this.configuration.getSetting("extras","autostart"),false);
         _loc2_ = TestConfigurator.getBoolean(Configuration.getParameter("autostart"),_loc2_);
         if(_loc2_)
         {
            return _loc1_;
         }
         return -1;
      }
      
      protected function testAutoStart() : *
      {
         var _loc1_:* = this.isAutoStart();
         if(_loc1_ == -1)
         {
            return;
         }
         if(_loc1_ > 0)
         {
            TweenLite.delayedCall(_loc1_,this.autoStart);
         }
         else
         {
            TweenLite.delayedCall(0.01,this.autoStart);
         }
      }
   }
}
