package
{
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   class SocketDownloadTest extends Test
   {
       
      
      private var results:Array;
      
      private var samples:Array;
      
      private var socketConnections:Array;
      
      private var sockets:Array;
      
      private var socketActive:Array;
      
      private var socketData:Dictionary;
      
      protected var samplesToSkip = 2;
      
      protected var samplesToKeep = 0.75;
      
      private var lastDetailedProgress:Number = 0;
      
      private var lastPendingTransfer:Number = 0;
      
      private var lastCompleteRatio:Number = 0;
      
      private var downloadStartTime = 0;
      
      protected var socketsReady = 0;
      
      protected var maintenanceTimer:Timer = null;
      
      protected var timer:Timer = null;
      
      protected var maintenanceTimeOutBytes:Number = 0;
      
      function SocketDownloadTest()
      {
         super();
         sampleSize = 10;
         testName = "socket-download";
         autoTimeOut = false;
      }
      
      override public function init() : void
      {
         super.init();
         this.reset();
         this.socketConnections.push(SocketConnection.getSocketConnection());
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
         this.samples = new Array();
         this.sockets = new Array();
         this.socketActive = new Array();
         this.socketConnections = new Array();
         this.socketsReady = 0;
         this.socketData = new Dictionary();
         this.maintenanceTimeOutBytes = 0;
      }
      
      override public function cleanup() : Boolean
      {
         var _loc1_:Socket = null;
         var _loc2_:SocketConnection = null;
         var _loc3_:* = undefined;
         Logger.info("cleaning up: " + testName);
         super.cleanup();
         this.emptyBuffers();
         if(this.timer != null)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.sendIncompleteProgress);
            this.timer.stop();
            this.timer = null;
         }
         if(this.maintenanceTimer != null)
         {
            this.maintenanceTimer.removeEventListener(TimerEvent.TIMER,this.handleMaintenance);
            this.maintenanceTimer.stop();
            this.maintenanceTimer = null;
         }
         DocumentClass.document.removeEventListener(Event.ENTER_FRAME,this.sendIncompleteProgress);
         for each(_loc1_ in this.sockets)
         {
            if(_loc1_ != null)
            {
               _loc1_.removeEventListener(Event.CLOSE,this.closeHandler);
               _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
               _loc1_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
               _loc1_.removeEventListener(ProgressEvent.SOCKET_DATA,this.readResponse);
               _loc1_ = null;
            }
         }
         this.sockets = null;
         for each(_loc2_ in this.socketConnections)
         {
            if(_loc2_ != null)
            {
               _loc2_.setRawMode(false);
               _loc3_ = _loc2_.getConnectionId();
               if(_loc3_ > 0)
               {
                  Logger.info("Closing socket: " + _loc3_);
                  _loc2_.closeSocket();
               }
               _loc2_.removeEventListener(SocketEvent.SOCKET_READY,this.socketReady);
               _loc2_.removeEventListener(SocketEvent.SOCKET_ERROR,this.socketError);
               _loc2_ = null;
               Logger.info("socket closed " + _loc3_);
            }
         }
         Logger.info("all sockets closed " + testName);
         this.socketConnections = null;
         this.reset();
         Logger.info("cleanup complete " + testName);
         return true;
      }
      
      protected function handleExtraSockets(param1:int, param2:Boolean = false) : *
      {
         var _loc5_:* = undefined;
         Logger.info("threads:" + param1);
         var _loc3_:* = this.socketConnections.length;
         var _loc4_:* = _loc3_;
         while(_loc4_ < param1)
         {
            _loc5_ = SocketConnection.getSocketConnection(_loc4_);
            this.socketConnections.push(_loc5_);
            if(param2)
            {
               this.prepareSocket(_loc5_);
            }
            _loc4_++;
         }
      }
      
      override public function start() : Boolean
      {
         var _loc1_:SocketConnection = null;
         if(!settingDefined("host"))
         {
            return false;
         }
         if(!settingDefined("port"))
         {
            return false;
         }
         if(!settingDefined("initialThreadCount"))
         {
            return false;
         }
         if(isNaN(sampleSize))
         {
            return false;
         }
         super.start();
         this.handleExtraSockets(getSetting("initialThreadCount"));
         for each(_loc1_ in this.socketConnections)
         {
            this.prepareSocket(_loc1_);
         }
         return true;
      }
      
      protected function prepareSocket(param1:SocketConnection) : *
      {
         var _loc2_:* = param1.getConnectionId();
         Logger.info("prepare socket: " + _loc2_);
         if(_loc2_ % 2 == 1 && settingDefined("host2",false))
         {
            param1.socketConnect(getSetting("host2"),getSetting("port2"));
         }
         else
         {
            param1.socketConnect(getSetting("host"),getSetting("port"));
         }
         param1.addEventListener(SocketEvent.SOCKET_READY,this.socketReady);
         param1.addEventListener(SocketEvent.SOCKET_ERROR,this.socketError);
         param1.isReady();
      }
      
      override public function getEstimatedTimeLeft() : Number
      {
         var _loc1_:* = this.downloadStartTime + 1000 * sampleSize;
         var _loc2_:* = Tools.getTime();
         if(_loc1_ > _loc2_)
         {
            return _loc1_ - _loc2_;
         }
         return 0;
      }
      
      protected function getBytesReceived() : Number
      {
         var _loc2_:Socket = null;
         var _loc1_:* = 0;
         for each(_loc2_ in this.sockets)
         {
            _loc1_ = _loc1_ + this.socketData[_loc2_].bytesReceived;
         }
         return _loc1_;
      }
      
      protected function getAverageSpeed() : Number
      {
         var _loc1_:* = this.results[0];
         var _loc2_:* = this.getBytesReceived();
         var _loc3_:* = Tools.getTime() - _loc1_.time;
         var _loc4_:* = Math.round(1000 * _loc2_ / _loc3_);
         if(_loc4_ >= 0)
         {
            return _loc4_;
         }
         return 0;
      }
      
      protected function getSpeed() : Number
      {
         var _loc4_:Object = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:Object = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc1_:* = Tools.getTime() - this.downloadStartTime;
         var _loc2_:* = Tools.getTime();
         var _loc3_:Number = this.getProgress();
         if(this.results.length == 0)
         {
            _loc4_ = {"progress":-Number.MAX_VALUE};
         }
         else
         {
            _loc4_ = this.results[this.results.length - 1];
         }
         _loc5_ = this.getBytesReceived();
         if(Math.ceil(_loc3_ * 20) >= this.results.length && _loc3_ > _loc4_.progress + 0.04 || _loc3_ == 1)
         {
            Logger.info("DL:  " + _loc3_ + "  t: " + _loc2_ + "  b: " + _loc5_);
            _loc9_ = {
               "progress":_loc3_,
               "time":_loc2_,
               "bytes":_loc5_
            };
            if(_loc3_ > 0 && this.results.length > 0)
            {
               _loc10_ = Math.round(1000 * (_loc5_ - _loc4_.bytes) / (_loc2_ - _loc4_.time));
               _loc11_ = Math.round((_loc3_ - _loc4_.progress) * 1000) / 1000;
               this.samples.push(_loc10_ + _loc11_);
               this.samples.sort(Array.DESCENDING | Array.NUMERIC);
               Logger.debug(this.samples);
            }
            this.results.push(_loc9_);
         }
         _loc6_ = 0;
         _loc7_ = this.getSuperSpeed2();
         _loc8_ = this.getFirstSpeed(_loc5_);
         if(_loc7_ > 0 && _loc7_ > _loc8_)
         {
            _loc6_ = _loc3_ * _loc7_ + (1 - _loc3_) * _loc8_;
         }
         else
         {
            _loc6_ = _loc8_;
         }
         return Math.round(_loc6_);
      }
      
      protected function getSuperSpeed2() : *
      {
         if(this.samples.length <= 4)
         {
            return 0;
         }
         var _loc1_:* = 0;
         var _loc2_:* = Math.min(Math.ceil(this.samplesToKeep * (this.samples.length - this.samplesToSkip)),this.samples.length - this.samplesToSkip);
         var _loc3_:* = this.samplesToSkip;
         while(_loc3_ < _loc2_ + this.samplesToSkip)
         {
            _loc1_ = _loc1_ + Math.floor(this.samples[_loc3_]);
            _loc3_++;
         }
         return Math.round(_loc1_ / _loc2_);
      }
      
      protected function getFirstSpeed(param1:*) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = Tools.getTime();
         var _loc3_:* = this.getProgress();
         var _loc4_:* = 1000 * param1 / (_loc2_ - this.downloadStartTime + 1);
         if(this.results.length > 4)
         {
            _loc5_ = this.results[2];
            _loc6_ = 1000 * (param1 - _loc5_.bytes) / (_loc2_ - _loc5_.time);
            if(_loc3_ > 0.5)
            {
               return _loc6_;
            }
            return (_loc4_ * (0.5 - _loc3_) + _loc6_ * _loc3_) * 2;
         }
         return _loc4_;
      }
      
      override public function getProgress() : Number
      {
         var _loc9_:Socket = null;
         var _loc10_:* = undefined;
         var _loc1_:* = this.getEstimatedTimeLeft();
         var _loc2_:* = 1000 * sampleSize;
         var _loc3_:* = 1 - _loc1_ / _loc2_;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = _loc1_ == 0 && Tools.getTime() - this.lastDetailedProgress > 1000;
         var _loc8_:* = 0;
         for each(_loc9_ in this.sockets)
         {
            _loc5_ = _loc5_ + this.socketData[_loc9_].bytesRequested;
            _loc4_ = _loc4_ + this.socketData[_loc9_].bytesReceived;
            _loc6_ = _loc6_ + this.socketData[_loc9_].bytesRead;
            if(_loc7_)
            {
               if(this.socketData[_loc9_].bytesRequested != this.socketData[_loc9_].bytesReceived)
               {
                  _loc8_++;
                  Logger.info("ID: " + this.socketData[_loc9_].connectionId + " requested: " + this.socketData[_loc9_].bytesRequested + " received: " + this.socketData[_loc9_].bytesReceived + " connected: " + _loc9_.connected);
               }
            }
         }
         if(_loc7_)
         {
            Logger.debug("progress info - requested: " + _loc5_ + " received: " + _loc4_ + " read: " + _loc6_ + " " + _loc4_ / _loc5_);
            Logger.info("Sockets pending transfer: " + _loc8_);
            this.lastDetailedProgress = Tools.getTime();
            this.lastPendingTransfer = _loc8_;
            this.lastCompleteRatio = _loc4_ / _loc5_;
         }
         _loc10_ = _loc4_ / _loc5_;
         return Math.min(_loc10_,_loc3_);
      }
      
      override protected function setDefaults() : void
      {
         defaultSettings.maxSampleSize = 10000000;
         defaultSettings.minSampleSize = 32000;
         defaultSettings.startSampleSize = 100000;
         defaultSettings.startBufferSize = 2;
         defaultSettings.bufferLength = 5000;
         defaultSettings.packetLength = 1000;
         defaultSettings.readBuffer = 65536;
      }
      
      protected function fillBuffer(param1:Socket, param2:Boolean = false) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         if(param2)
         {
            _loc3_ = getSetting("startSampleSize");
            _loc4_ = getSetting("startBufferSize");
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.writeln(param1,"DOWNLOAD " + _loc3_);
               this.socketData[param1].bytesRequested = this.socketData[param1].bytesRequested + _loc3_;
               _loc5_++;
            }
         }
         else
         {
            _loc6_ = this.getSpeed();
            _loc7_ = Math.max(this.getDesiredThreads(),this.sockets.length);
            _loc8_ = getSetting("packetLength") / _loc7_;
            _loc3_ = Math.min(Math.max(Math.round(_loc8_ / 1000 * _loc6_),getSetting("minSampleSize")),getSetting("maxSampleSize"));
            do
            {
               _loc4_ = this.socketData[param1].bytesRequested - this.socketData[param1].bytesReceived;
               _loc9_ = 1000 * (_loc4_ / _loc6_);
               _loc10_ = Math.min(getSetting("bufferLength"),this.getEstimatedTimeLeft()) / _loc7_;
               if(_loc9_ < _loc10_)
               {
                  this.writeln(param1,"DOWNLOAD " + _loc3_);
                  this.socketData[param1].bytesRequested = this.socketData[param1].bytesRequested + _loc3_;
               }
            }
            while(_loc9_ < _loc10_);
            
         }
      }
      
      public function writeln(param1:Socket, param2:String) : void
      {
         var socket:Socket = param1;
         var str:String = param2;
         str = str + "\n";
         try
         {
            socket.writeUTFBytes(str);
            socket.flush();
            return;
         }
         catch(e:IOError)
         {
            trace(e);
            return;
         }
      }
      
      private function readResponse(param1:ProgressEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:Socket = param1.target as Socket;
         var _loc3_:Number = _loc2_.bytesAvailable;
         this.socketData[_loc2_].bytesReceived = this.socketData[_loc2_].bytesRead + _loc3_;
         if(_loc3_ < 65536 && this.socketData[_loc2_].bytesRequested > this.socketData[_loc2_].bytesReceived)
         {
            return;
         }
         _loc4_ = _loc2_.readUTFBytes(_loc3_);
         this.socketData[_loc2_].bytesRead = this.socketData[_loc2_].bytesRead + _loc3_;
         if(this.getEstimatedTimeLeft() > 0)
         {
            this.fillBuffer(_loc2_);
         }
         else
         {
            this.emptyBuffers();
         }
      }
      
      private function emptyBuffers() : *
      {
         var _loc1_:Socket = null;
         var _loc2_:Number = NaN;
         var _loc3_:* = undefined;
         for each(_loc1_ in this.sockets)
         {
            if(_loc1_.connected)
            {
               _loc2_ = _loc1_.bytesAvailable;
               if(_loc2_ > 0)
               {
                  _loc3_ = _loc1_.readUTFBytes(_loc2_);
                  this.socketData[_loc1_].bytesRead = this.socketData[_loc1_].bytesRead + _loc2_;
               }
            }
         }
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         trace("ioErrorHandler: " + param1);
         var _loc2_:SocketEvent = new SocketEvent(SocketEvent.SOCKET_ERROR,{
            "event":param1,
            "type":"ioerror"
         });
         this.socketError(_loc2_);
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         trace("securityErrorHandler: " + param1);
         var _loc2_:SocketEvent = new SocketEvent(SocketEvent.SOCKET_ERROR,{
            "event":param1,
            "type":"security"
         });
         this.socketError(_loc2_);
      }
      
      private function closeHandler(param1:Event) : void
      {
         trace("closeHandler: " + param1);
      }
      
      protected function socketReady(param1:SocketEvent) : *
      {
         var _loc2_:SocketConnection = param1.data.target;
         _loc2_.removeEventListener(SocketEvent.SOCKET_ERROR,this.socketError);
         var _loc3_:Socket = _loc2_.setRawMode(true);
         var _loc4_:int = _loc2_.getConnectionId();
         Logger.info("Socket " + _loc4_ + " ready for use");
         this.sockets[_loc4_] = _loc3_;
         _loc3_.addEventListener(Event.CLOSE,this.closeHandler);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         _loc3_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         _loc3_.addEventListener(ProgressEvent.SOCKET_DATA,this.readResponse);
         this.socketData[_loc3_] = {
            "bytesReceived":0,
            "bytesRequested":0,
            "bytesRead":0,
            "connectionId":_loc4_
         };
         this.socketsReady++;
         if(this.downloadStartTime == 0)
         {
            if(this.socketsReady == this.socketConnections.length)
            {
               this.startDownloads();
            }
         }
         else
         {
            this.fillBuffer(_loc3_);
         }
      }
      
      protected function startDownloads() : *
      {
         var _loc1_:Socket = null;
         var _loc2_:* = undefined;
         this.downloadStartTime = Tools.getTime();
         this.results.push({
            "progress":0,
            "bytes":0,
            "time":this.downloadStartTime
         });
         for each(_loc1_ in this.sockets)
         {
            this.fillBuffer(_loc1_,true);
         }
         Logger.info("Starting Timer");
         _loc2_ = getSetting("progressMethod");
         switch(_loc2_)
         {
            case 2:
               DocumentClass.document.addEventListener(Event.ENTER_FRAME,this.sendIncompleteProgress);
               break;
            case 1:
            default:
               this.timer = new Timer(getSetting("progressTimerLength"));
               this.timer.addEventListener(TimerEvent.TIMER,this.sendIncompleteProgress);
               this.timer.start();
         }
         this.maintenanceTimer = new Timer(getSetting("maintenanceTimerLength"));
         this.maintenanceTimer.addEventListener(TimerEvent.TIMER,this.handleMaintenance);
         this.maintenanceTimer.start();
      }
      
      protected function sendIncompleteProgress(param1:Event) : *
      {
         this.sendProgress();
      }
      
      protected function getDesiredThreads() : *
      {
         var _loc1_:* = this.getSpeed();
         var _loc2_:* = getSetting("maximumThreadCount");
         var _loc3_:* = getSetting("threadRatio");
         var _loc4_:* = Math.min(_loc2_,Math.round(_loc1_ / _loc3_));
         return _loc4_;
      }
      
      protected function handleMaintenance(param1:Event) : *
      {
         var _loc4_:Socket = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         for each(_loc4_ in this.sockets)
         {
            _loc2_ = _loc2_ + this.socketData[_loc4_].bytesReceived;
            _loc3_ = _loc3_ + this.socketData[_loc4_].bytesRead;
         }
         if(_loc3_ != this.maintenanceTimeOutBytes)
         {
            this.maintenanceTimeOutBytes = _loc3_;
            update(this.maintenanceTimeOutBytes);
         }
         _loc5_ = this.getProgress();
         if(_loc5_ < 0.5)
         {
            _loc6_ = this.socketConnections.length;
            _loc7_ = getSetting("threadAddRate");
            _loc8_ = this.getDesiredThreads();
            if(_loc7_ > 0)
            {
               _loc8_ = Math.min(_loc8_,_loc6_ + _loc7_);
            }
            if(_loc8_ > _loc6_)
            {
               this.handleExtraSockets(_loc8_,true);
            }
         }
         testForTimeOut();
      }
      
      protected function socketError(param1:SocketEvent) : *
      {
         Logger.error("Download test returned an error: " + param1 + " " + param1.data.type);
         var _loc2_:* = {
            "code":"socket-download01",
            "event":param1
         };
         dispatchFatal(_loc2_);
      }
      
      protected function sendProgress() : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc1_:* = this.getProgress();
         var _loc2_:* = this.getSpeed();
         var _loc3_:* = this.getBytesReceived();
         if(_loc1_ == 1)
         {
            _loc4_ = {
               "current":_loc2_,
               "best":0,
               "progress":_loc1_,
               "time":Tools.getTime() - startTime,
               "estimatedTime":0,
               "done":true,
               "bytes":_loc3_
            };
            dispatchProgress(_loc4_);
            Logger.info("FINAL - avgspeed: " + this.getAverageSpeed() + " ss2:" + this.getSuperSpeed2() + " first:" + this.getFirstSpeed(_loc3_) + " bytes:" + _loc3_);
            _loc5_ = {
               "final":_loc2_,
               "time":Tools.getTime() - startTime,
               "startTime":startTime,
               "extraSpeeds":this.samples,
               "bytes":_loc3_,
               "rawSamples":this.results
            };
            dispatchComplete(_loc5_);
         }
         else
         {
            _loc6_ = {
               "current":_loc2_,
               "best":0,
               "progress":_loc1_,
               "time":Tools.getTime() - startTime,
               "estimatedTime":this.getEstimatedTimeLeft(),
               "done":false,
               "bytes":_loc3_
            };
            dispatchProgress(_loc6_);
         }
      }
   }
}
