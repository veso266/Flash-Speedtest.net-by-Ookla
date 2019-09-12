package
{
   import com.greensock.TweenLite;
   
   class SocketLatencyTest extends Test
   {
       
      
      private var results:Array;
      
      private var socketConnection:SocketConnection;
      
      private var serverTimes:Array;
      
      function SocketLatencyTest(param1:SocketConnection = null)
      {
         super();
         sampleSize = 25;
         testName = "socket-latency";
         if(param1 == null)
         {
            this.socketConnection = SocketConnection.getSocketConnection();
         }
         else
         {
            this.socketConnection = param1;
         }
         autoTimeOut = true;
      }
      
      override public function init() : void
      {
         super.init();
         this.reset();
      }
      
      override public function cancel() : Boolean
      {
         super.cancel();
         this.cleanup();
         this.reset();
         sampleSize = 0;
         return true;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.results = new Array();
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
         return true;
      }
      
      override public function getEstimatedTimeLeft() : Number
      {
         var _loc1_:* = this.getProgress();
         var _loc2_:* = Tools.getTime() + 100;
         return Math.round((1 - _loc1_) * (_loc2_ - startTime) / _loc1_);
      }
      
      override public function getProgress() : Number
      {
         return this.results.length / sampleSize;
      }
      
      override protected function setDefaults() : void
      {
         defaultSettings.waitTime = 50;
      }
      
      protected function nextTest() : *
      {
         this.serverTimes = new Array();
         this.socketConnection.writeln("PING " + Tools.getTime());
      }
      
      protected function dataReceived(param1:SocketEvent) : *
      {
         var _loc2_:* = param1.data.data;
         var _loc3_:Array = _loc2_.split(" ");
         switch(_loc3_[0])
         {
            case "PONG":
               this.serverTimes.push(Number(_loc3_[1]));
               if(this.serverTimes.length == 2)
               {
                  this.saveResults();
               }
               else
               {
                  this.socketConnection.writeln("PING " + Tools.getTime());
               }
         }
      }
      
      protected function socketReady(param1:SocketEvent) : *
      {
         Logger.info("Socket ready for use");
         this.nextTest();
      }
      
      protected function socketError(param1:SocketEvent) : *
      {
         Logger.error("Latency test returned an error: " + param1 + " " + param1.data.type);
         var _loc2_:* = {
            "code":"socket-latency01",
            "event":param1
         };
         dispatchFatal(_loc2_);
      }
      
      protected function saveResults() : *
      {
         var _loc1_:* = Math.max(1,this.serverTimes[1] - this.serverTimes[0]);
         this.results.push(_loc1_);
         update(this.results.length);
         if(this.results.length >= sampleSize || isNaN(sampleSize))
         {
            this.sendProgress(true);
         }
         else
         {
            TweenLite.delayedCall(getSetting("waitTime") / 1000,this.nextTest);
            this.sendProgress(false);
         }
      }
      
      protected function calculateAverage() : Number
      {
         return Math.round(Tools.getAverage(this.results));
      }
      
      protected function calculateJitter() : *
      {
         var _loc1_:* = 0;
         var _loc2_:* = this.results.length - 1;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = _loc1_ + Math.abs(this.results[_loc3_] - this.results[_loc3_ + 1]);
            _loc3_++;
         }
         if(_loc2_ > 0)
         {
            return Math.round(_loc1_ / _loc2_);
         }
         return 0;
      }
      
      protected function calculateBestEntry() : *
      {
         return Tools.getMinimum(this.results);
      }
      
      protected function sendProgress(param1:Boolean) : *
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Object = null;
         var _loc2_:* = this.results[this.results.length - 1];
         var _loc3_:* = this.calculateBestEntry();
         var _loc4_:Number = this.calculateAverage();
         var _loc5_:Number = this.calculateJitter();
         if(!param1)
         {
            _loc6_ = {
               "current":_loc2_,
               "best":_loc3_,
               "progress":this.getProgress(),
               "estimatedTime":this.getEstimatedTimeLeft(),
               "done":false,
               "averagePing":_loc4_,
               "jitter":_loc5_
            };
            dispatchProgress(_loc6_);
         }
         else
         {
            _loc7_ = {
               "current":_loc2_,
               "best":_loc3_,
               "progress":1,
               "estimatedTime":0,
               "done":true,
               "averagePing":_loc4_,
               "jitter":_loc5_
            };
            dispatchProgress(_loc7_);
            _loc8_ = Math.round(Tools.getMedian(this.results));
            _loc9_ = Tools.getMaximum(this.results);
            _loc10_ = {
               "final":_loc3_,
               "time":Tools.getTime() - startTime,
               "startTime":startTime,
               "best":_loc3_,
               "jitter":_loc5_,
               "all":this.results,
               "maxPing":_loc9_,
               "averagePing":_loc4_,
               "medianPing":_loc8_
            };
            dispatchComplete(_loc10_);
         }
      }
   }
}
