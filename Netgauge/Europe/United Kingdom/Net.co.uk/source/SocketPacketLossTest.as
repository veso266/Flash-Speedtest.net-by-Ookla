package
{
   class SocketPacketLossTest extends Test implements ProxyInterface
   {
      
      public static const PROXY_READY:Number = 1;
      
      public static const PACKETS_SENT:Number = 2;
      
      public static const TEST_COMPLETE:Number = 3;
       
      
      private var testList:Array;
      
      private var currentTestId = 0;
      
      private var socketConnection:SocketConnection;
      
      private var estimatedLength:Number = 5;
      
      private var proxy:JSProxy;
      
      function SocketPacketLossTest()
      {
         this.testList = new Array("flashpacketloss","flashdisconnect");
         super();
         sampleSize = 50;
         testName = "socket-packetloss";
         this.socketConnection = SocketConnection.getSocketConnection();
         autoTimeOut = true;
      }
      
      public function nextTest() : *
      {
         var _loc1_:* = undefined;
         if(this.currentTestId >= this.testList.length)
         {
            Logger.info("done!");
         }
         else
         {
            _loc1_ = this.testList[this.currentTestId];
            Logger.info("Starting: " + _loc1_);
            this.currentTestId++;
            if(_loc1_ == "flashpacketloss")
            {
               this.proxy.startTest(_loc1_,[sampleSize,getSetting("waitTime")]);
            }
            else
            {
               this.proxy.startTest(_loc1_);
            }
         }
      }
      
      public function handleProxyTestEnd(param1:*, param2:*) : *
      {
         Logger.info("TestEnd: " + param1);
         if(param1 == "flashpacketloss")
         {
            this.nextTest();
            this.socketConnection.writeln("PLOSS");
            this.sendProgress(PACKETS_SENT);
         }
      }
      
      public function handleProxyTestPartial(param1:*, param2:*) : *
      {
         Logger.info("Test Partial: " + param1);
      }
      
      public function unknownProxyCall(param1:*, param2:*) : *
      {
         Logger.info("unknown proxy call: " + param1);
      }
      
      public function proxyError(param1:*, param2:*) : *
      {
         var _loc3_:* = {
            "error":param2,
            "title":param1,
            "code":"socket-packetloss01"
         };
         SpeedTestController.getController().addResults("packetloss-error","proxy-error");
         SpeedTestController.getController().addResults("packetloss-errorcode",_loc3_.code);
         dispatchFatal(_loc3_);
      }
      
      public function proxyReady() : *
      {
         this.socketConnection.writeln("ME " + this.proxy.getUniqueId() + " 0 settings");
         this.nextTest();
         this.sendProgress(PROXY_READY);
      }
      
      override public function init() : void
      {
         super.init();
         this.reset();
      }
      
      override public function cancel() : Boolean
      {
         super.cancel();
         this.reset();
         sampleSize = 0;
         return true;
      }
      
      override public function reset() : void
      {
         super.reset();
      }
      
      override public function cleanup() : Boolean
      {
         Logger.info("cleaning up: " + testName);
         super.cleanup();
         this.socketConnection.removeEventListener(SocketEvent.DATA_RECEIVED,this.dataReceived);
         this.socketConnection.removeEventListener(SocketEvent.SOCKET_READY,this.socketReady);
         this.socketConnection.removeEventListener(SocketEvent.SOCKET_ERROR,this.socketError);
         this.socketConnection = null;
         return true;
      }
      
      override public function start() : Boolean
      {
         if(!settingDefined("host"))
         {
            return false;
         }
         if(!settingDefined("port"))
         {
            return false;
         }
         if(!settingDefined("waitTime"))
         {
            return false;
         }
         if(isNaN(sampleSize))
         {
            return false;
         }
         super.start();
         this.socketConnection.socketConnect(getSetting("host"),getSetting("port"));
         this.socketConnection.addEventListener(SocketEvent.DATA_RECEIVED,this.dataReceived);
         this.socketConnection.addEventListener(SocketEvent.SOCKET_READY,this.socketReady);
         this.socketConnection.addEventListener(SocketEvent.SOCKET_ERROR,this.socketError);
         this.socketConnection.isReady();
         this.proxy = JSProxy.init(SpeedTestController.getController(),getSetting("applet"));
         this.proxy.clearWaits();
         this.proxy.setTest(this);
         return true;
      }
      
      override public function getEstimatedTimeLeft() : Number
      {
         var _loc1_:* = Tools.getTime() - startTime;
         var _loc2_:* = this.estimatedLength - _loc1_;
         return Math.max(0,_loc2_);
      }
      
      override public function getProgress() : Number
      {
         var _loc1_:* = Tools.getTime() - startTime;
         var _loc2_:* = _loc1_ / this.estimatedLength;
         return Math.min(1,_loc2_);
      }
      
      override protected function setDefaults() : void
      {
         defaultSettings.waitTime = 150;
      }
      
      protected function dataReceived(param1:SocketEvent) : *
      {
         var _loc2_:* = param1.data.data;
         var _loc3_:Array = _loc2_.split(" ");
         switch(_loc3_[0])
         {
            case "PLOSS":
               this.sendComplete(param1);
         }
      }
      
      protected function socketReady(param1:SocketEvent) : *
      {
         Logger.info("Socket ready for use");
         this.proxy.configure(settings);
         this.proxy.initJava(getSetting("clientversion"));
      }
      
      protected function socketError(param1:SocketEvent) : *
      {
         Logger.error("Packetloss test returned an error: " + param1 + " " + param1.data.type);
         var _loc2_:* = {
            "code":"socket-packetloss03",
            "event":param1
         };
         SpeedTestController.getController().addResults("packetloss-error","socket-error");
         SpeedTestController.getController().addResults("packetloss-errorcode",_loc2_.code);
         dispatchFatal(_loc2_);
      }
      
      protected function sendProgress(param1:Number) : *
      {
         var _loc2_:Object = {
            "current":0,
            "event":param1,
            "progress":param1 / 3,
            "done":false,
            "sent":sampleSize
         };
         dispatchProgress(_loc2_);
      }
      
      protected function sendComplete(param1:SocketEvent) : *
      {
         var _loc5_:Number = NaN;
         var _loc6_:Object = null;
         var _loc2_:* = param1.data.data;
         Logger.debug(_loc2_);
         var _loc3_:Array = _loc2_.split(" ");
         var _loc4_:Number = Number(_loc3_[1]);
         if(_loc4_ > sampleSize)
         {
            _loc4_ = 0;
         }
         _loc5_ = 1 - _loc4_ / sampleSize;
         Logger.info("Packet Loss - received: " + _loc4_ + " sent: " + sampleSize);
         this.sendProgress(TEST_COMPLETE);
         _loc6_ = {
            "final":_loc5_,
            "sent":sampleSize,
            "received":_loc4_,
            "time":Tools.getTime() - startTime,
            "startTime":startTime
         };
         dispatchComplete(_loc6_);
      }
   }
}
