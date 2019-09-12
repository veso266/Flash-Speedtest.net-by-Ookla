package
{
   class SocketFirewallTest extends Test implements ProxyInterface
   {
      
      public static const PROXY_READY:Number = 1;
      
      public static const UDP_SENT:Number = 2;
      
      public static const PORTS_OPEN:Number = 3;
      
      public static const TEST_COMPLETE:Number = 4;
      
      public static const CLIENT_TO_SERVER:Number = 1;
      
      public static const SERVER_TO_CLIENT:Number = 2;
      
      public static const TYPE_TCP:Number = 1;
      
      public static const TYPE_UDP:Number = 2;
       
      
      private var testList:Array;
      
      private var currentTestId = 0;
      
      private var socketConnection:SocketConnection;
      
      private var estimatedLength:Number = 10;
      
      private var proxy:JSProxy;
      
      private var tcpPorts:Array;
      
      private var udpPorts:Array;
      
      private var testComplete:Number = 0;
      
      private var commandQueue:Array;
      
      private var currentCommand:String = "";
      
      private var successfulValue:Number = 0;
      
      private var successfulChecks:Array;
      
      function SocketFirewallTest()
      {
         this.testList = new Array("flashports","flashdisconnect");
         this.tcpPorts = new Array();
         this.udpPorts = new Array();
         this.commandQueue = new Array();
         this.successfulChecks = new Array();
         super();
         sampleSize = 50;
         testName = "socket-firewall";
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
            switch(_loc1_)
            {
               case "flashports":
                  this.proxy.startTest(_loc1_,[getSetting("port"),getSetting("port")]);
                  break;
               default:
                  this.proxy.startTest(_loc1_);
            }
         }
      }
      
      public function handleProxyTestEnd(param1:*, param2:*) : *
      {
         Logger.info("TestEnd: " + param1);
         switch(param1)
         {
            case "flashports":
               Logger.info("flashports result: " + param2);
               this.parseAppletResponse(param2);
               this.nextTest();
               break;
            case "flashdisconnect":
               this.testComplete++;
               if(this.testComplete == 2)
               {
                  this.sendComplete();
               }
         }
      }
      
      public function handleProxyTestPartial(param1:*, param2:*) : *
      {
         Logger.info("Test Partial: " + param1);
         switch(param2)
         {
            case "udpsent":
               this.commandQueue.push("GETUDP");
               this.sendProgress(UDP_SENT);
               this.nextCommand();
               break;
            case "open":
               this.commandQueue.push("UDPPORT " + getSetting("port"));
               this.commandQueue.push("TCPPORT " + getSetting("port"));
               this.commandQueue.push("ALLDONE");
               this.sendProgress(PORTS_OPEN);
               this.nextCommand();
         }
      }
      
      private function nextCommand() : *
      {
         if(this.commandQueue.length > 0)
         {
            this.currentCommand = this.commandQueue.shift();
            if(this.currentCommand == "ALLDONE")
            {
               Logger.info("ALLDONE");
               this.testComplete++;
               if(this.testComplete == 2)
               {
                  this.sendComplete();
               }
            }
            else
            {
               this.socketConnection.writeln(this.currentCommand);
            }
         }
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
            "code":"socket-firewall01"
         };
         SpeedTestController.getController().addResults("firewall-error","proxy-error");
         SpeedTestController.getController().addResults("firewall-errorcode",_loc3_.code);
         dispatchFatal(_loc3_);
      }
      
      public function getTypeString(param1:Number) : *
      {
         switch(param1)
         {
            case TYPE_TCP:
               return "TCP";
            case TYPE_UDP:
               return "UDP";
            default:
               return "UNKNOWN";
         }
      }
      
      public function getDirectionString(param1:Number) : *
      {
         switch(param1)
         {
            case CLIENT_TO_SERVER:
               return "C2S";
            case SERVER_TO_CLIENT:
               return "S2C";
            default:
               return "UNKNOWN";
         }
      }
      
      public function portCheckSuccessful(param1:Number, param2:Number, param3:Number) : *
      {
         Logger.info("PORT SUCCESSFUL: " + this.getTypeString(param1) + " " + param3 + " " + this.getDirectionString(param2));
         this.successfulChecks.push({
            "port":param3,
            "direction":param2,
            "type":param1
         });
         switch(param1 + "-" + param2)
         {
            case TYPE_TCP + "-" + CLIENT_TO_SERVER:
               this.successfulValue = this.successfulValue + 1;
               break;
            case TYPE_TCP + "-" + SERVER_TO_CLIENT:
               this.successfulValue = this.successfulValue + 2;
               break;
            case TYPE_UDP + "-" + CLIENT_TO_SERVER:
               this.successfulValue = this.successfulValue + 4;
               break;
            case TYPE_UDP + "-" + SERVER_TO_CLIENT:
               this.successfulValue = this.successfulValue + 8;
         }
      }
      
      public function parsePortResponse(param1:Number, param2:String) : *
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc3_:Array = param2.split(",");
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = TestConfigurator.getRangeInt(_loc4_,0,65535,0);
            if(_loc5_ > 0)
            {
               this.portCheckSuccessful(param1,CLIENT_TO_SERVER,_loc5_);
            }
         }
      }
      
      public function parseAppletResponse(param1:String) : *
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Array = param1.split(",");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.split("-");
            _loc5_ = 0;
            _loc6_ = TestConfigurator.getRangeInt(_loc4_[1],0,65535,0);
            if(_loc4_[0] == "tcp")
            {
               _loc5_ = TYPE_TCP;
            }
            if(_loc4_[0] == "udp")
            {
               _loc5_ = TYPE_UDP;
            }
            if(_loc6_ > 0 && _loc5_ > 0)
            {
               this.portCheckSuccessful(_loc5_,SERVER_TO_CLIENT,_loc6_);
            }
         }
      }
      
      public function proxyReady() : *
      {
         this.portCheckSuccessful(TYPE_TCP,CLIENT_TO_SERVER,getSetting("port"));
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
         super.start();
         this.tcpPorts.push(getSetting("port"));
         this.udpPorts.push(getSetting("port"));
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
      }
      
      protected function dataReceived(param1:SocketEvent) : *
      {
         var _loc2_:* = param1.data.data;
         var _loc3_:Array = _loc2_.split(" ");
         switch(_loc3_[0])
         {
            case "SEND":
               Logger.debug(this.currentCommand);
               Logger.debug(_loc3_);
               this.nextCommand();
               break;
            case "PORT":
               Logger.debug(this.currentCommand);
               Logger.debug(_loc3_);
               if(this.currentCommand == "GETUDP")
               {
                  this.parsePortResponse(TYPE_UDP,_loc3_[1]);
               }
               this.nextCommand();
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
            "code":"socket-firewall03",
            "event":param1
         };
         SpeedTestController.getController().addResults("firewall-error","socket-error");
         SpeedTestController.getController().addResults("firewall-errorcode",_loc2_.code);
         dispatchFatal(_loc2_);
      }
      
      protected function sendProgress(param1:Number) : *
      {
         var _loc2_:Object = {
            "current":0,
            "event":param1,
            "progress":param1 / 4,
            "done":false
         };
         dispatchProgress(_loc2_);
      }
      
      protected function sendComplete() : *
      {
         this.sendProgress(TEST_COMPLETE);
         var _loc1_:Object = {
            "final":this.successfulValue,
            "time":Tools.getTime() - startTime,
            "startTime":startTime,
            "details":this.successfulChecks
         };
         dispatchComplete(_loc1_);
      }
   }
}
