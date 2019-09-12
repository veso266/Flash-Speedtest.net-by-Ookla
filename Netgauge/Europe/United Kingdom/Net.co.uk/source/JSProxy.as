package
{
   import com.adobe.crypto.MD5;
   import flash.external.ExternalInterface;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   class JSProxy
   {
      
      public static var proxy:JSProxy = null;
      
      private static var isInit:Boolean = false;
       
      
      private var controller:CustomSpeedTestController;
      
      private var test:ProxyInterface;
      
      private var currentTest:Number = -1;
      
      private var fullWait = true;
      
      private var configuration:Object;
      
      var javaTimeout:Number = 0;
      
      var javaPresent = false;
      
      var resendUnlockTimeout:Number = 0;
      
      protected var uniqueId:String;
      
      private var clientJavaVersion:Number = -1;
      
      function JSProxy(param1:*)
      {
         var controller:* = param1;
         super();
         this.controller = controller;
         proxy = this;
         isInit = true;
         this.uniqueId = String(Math.round(Math.random() * 10000000));
         if(ExternalInterface.available)
         {
            try
            {
               ExternalInterface.addCallback("fromJS",this.fromJS);
            }
            catch(error:SecurityError)
            {
               Logger.error("A SecurityError occurred: " + error.message);
            }
            catch(error:Error)
            {
               Logger.error("An Error occurred: " + error.message);
            }
         }
         else
         {
            Logger.error("ExternalInterface NOT READY - JS callbacks disabled");
         }
      }
      
      public static function init(param1:*, param2:String = "") : *
      {
         var _loc3_:* = undefined;
         if(!isInit)
         {
            _loc3_ = new JSProxy(param1);
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("loadJava",param2);
         }
         return proxy;
      }
      
      function setTest(param1:*) : *
      {
         this.test = param1;
      }
      
      function clearWaits() : *
      {
         var _loc1_:* = this.controller.getTestCount();
         if(this.currentTest != _loc1_)
         {
            this.currentTest = _loc1_;
            this.clientJavaVersion = -1;
            this.fullWait = true;
         }
         else
         {
            this.fullWait = false;
         }
         this.javaPresent = false;
      }
      
      function startTest(param1:String, param2:Array = null) : *
      {
         if(param2 == null)
         {
            this.jsCall("start",param1);
         }
         else
         {
            param2.unshift(param1);
            this.jsCall("start",param2.join(" "));
         }
      }
      
      function initJava(param1:Number = NaN) : *
      {
         Logger.info("initJava: " + param1);
         if(this.fullWait)
         {
            this.javaTimeout = setTimeout(this.testJava,10000);
            this.resendUnlockTimeout = setTimeout(this.resendUnlock,8000);
         }
         else
         {
            this.javaTimeout = setTimeout(this.testJava,2000);
         }
         this.unlockJava();
      }
      
      function configure(param1:*) : *
      {
         this.configuration = param1;
      }
      
      private function testJava() : *
      {
         Logger.info("Testing for java presence");
         clearTimeout(this.javaTimeout);
         this.javaTimeout = 0;
         if(this.javaPresent == false)
         {
            this.test.proxyError("Test cannot be completed","The Java portion of the test could not be started. Please ensure that Java 5 or better is installed and setup correctly then try again.");
            this.controller.addResults("proxy-error","timeout");
            return;
         }
         this.controller.addResults("proxy-javaloaded",this.clientJavaVersion);
      }
      
      function resendUnlock() : *
      {
         clearTimeout(this.resendUnlockTimeout);
         this.resendUnlockTimeout = 0;
         if(this.javaPresent == false)
         {
            this.unlockJava();
         }
      }
      
      public function getUniqueId() : String
      {
         return this.uniqueId;
      }
      
      function fromJS(param1:String, param2:String) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         Logger.info("JS Call: " + param1);
         switch(param1)
         {
            case "javaLoaded":
               Logger.info("Java loaded: " + param2);
               this.clientJavaVersion = Number(param2);
               break;
            case "unlockReceived":
               this.unlockJava2(param2);
               break;
            case "unlock2Received":
               this.setServer();
               break;
            case "serverReceived":
               Logger.info("old uniqueId: " + this.uniqueId);
               Logger.info("new uniqueId: " + param2);
               this.uniqueId = param2;
               this.javaPresent = true;
               this.clientJavaVersion = Math.max(this.clientJavaVersion,0);
               this.test.proxyReady();
               break;
            case "testend":
               _loc3_ = param2.split(" ",2);
               _loc4_ = _loc3_[0];
               _loc5_ = _loc3_[1];
               this.test.handleProxyTestEnd(_loc4_,_loc5_);
               break;
            case "partial":
               _loc6_ = param2.split(" ",2);
               _loc7_ = _loc6_[0];
               _loc8_ = _loc6_[1];
               this.test.handleProxyTestPartial(_loc7_,_loc8_);
               break;
            default:
               if(this.test != null)
               {
                  this.test.unknownProxyCall(param1,param2);
               }
         }
      }
      
      private function setServer() : *
      {
         this.jsCall("udpserver",this.configuration.host + ":" + this.configuration.port);
      }
      
      private function jsCall(param1:String, param2:String) : void
      {
         var functionName:String = param1;
         var args:String = param2;
         if(ExternalInterface.available)
         {
            try
            {
               ExternalInterface.call("toJava",functionName,args);
               return;
            }
            catch(error:SecurityError)
            {
               Logger.error("A SecurityError occurred: " + error.message);
               return;
            }
            catch(error:Error)
            {
               Logger.error("An Error occurred: " + error.message);
               return;
            }
         }
      }
      
      private function unlockJava() : *
      {
         Logger.info("Unlock Java");
         this.jsCall("unlock",this.configuration.customer + "|" + this.getSettings());
      }
      
      private function unlockJava2(param1:*) : *
      {
         var _loc2_:* = MD5.hash("lol-" + param1 + "-voip").substr(0,16);
         this.jsCall("unlock2",_loc2_);
      }
      
      private function getSettings() : *
      {
         var _loc1_:* = "connection" + "=" + this.configuration.connection + "&" + "connectionIp" + "=" + this.configuration.connectionCustomIp + "&" + "connectionPort" + "=" + this.configuration.connectionCustomPort + "&" + "uniqueId" + "=" + this.uniqueId;
         return _loc1_;
      }
   }
}
