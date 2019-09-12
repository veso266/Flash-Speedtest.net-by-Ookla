package
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   class SocketUploadTest extends Test
   {
       
      
      private var data:Array;
      
      private var results:Array;
      
      private var threadResults:Array;
      
      private var threadSamples:Array;
      
      private var samples:Array;
      
      private var socketConnection:SocketConnection;
      
      private var socketConnections:Array;
      
      private var socketData:Dictionary;
      
      private var uploadStartTime = 0;
      
      private var lastDetailedProgress:Number = 0;
      
      private var lastPendingTransfer:Number = 0;
      
      private var lastPendingCleanup:Number = 0;
      
      private var lastCompleteRatio:Number = 0;
      
      protected var byteArray:ByteArray;
      
      protected var sendSize = 1000000;
      
      protected var dataUploaded:Number = 0;
      
      protected var samplesToSkip = 2;
      
      protected var samplesToKeep = 0.75;
      
      protected var socketsReady = 0;
      
      protected var maintenanceTimer:Timer = null;
      
      protected var timer:Timer = null;
      
      protected var maintenanceTimeOutBytes:Number = 0;
      
      private var threadResultSent = -1;
      
      function SocketUploadTest()
      {
         super();
         sampleSize = 10;
         testName = "socket-upload";
         autoTimeOut = false;
      }
      
      override public function init() : void
      {
         super.init();
         this.reset();
         this.socketConnection = SocketConnection.getSocketConnection();
         this.socketConnection.setRawMode(false);
         this.socketConnections.push(SocketConnection.getSocketConnection());
      }
      
      override public function cancel() : Boolean
      {
         super.cancel();
         this.cleanup();
         this.reset();
         sampleSize = 0;
         this.socketsReady = 0;
         return true;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.data = new Array();
         this.results = new Array();
         this.threadResults = new Array();
         this.threadSamples = new Array();
         this.samples = new Array();
         this.dataUploaded = 0;
         this.socketConnections = new Array();
         this.socketData = new Dictionary();
         this.maintenanceTimeOutBytes = 0;
      }
      
      public function cleanupSocket(param1:SocketConnection) : *
      {
         var _loc2_:* = undefined;
         if(param1 != null)
         {
            param1.removeEventListener(SocketEvent.DATA_RECEIVED,this.dataReceived);
            param1.removeEventListener(SocketEvent.SOCKET_READY,this.socketReady);
            param1.removeEventListener(SocketEvent.SOCKET_ERROR,this.socketError);
            _loc2_ = param1.getConnectionId();
            if(_loc2_ > 0)
            {
               Logger.info("Closing socket: " + _loc2_);
               param1.closeSocket();
            }
            else
            {
               Logger.info("Keeping socket open: " + _loc2_);
            }
            if(this.socketData[param1] != null)
            {
               this.socketData[param1].cleanedUp = true;
            }
            param1 = null;
         }
      }
      
      override public function cleanup() : Boolean
      {
         var _loc1_:SocketConnection = null;
         Logger.info("cleaning up: " + testName);
         super.cleanup();
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
         for each(_loc1_ in this.socketConnections)
         {
            this.cleanupSocket(_loc1_);
         }
         this.socketConnections = null;
         return true;
      }
      
      protected function handleExtraSockets(param1:int, param2:Boolean = false) : *
      {
         var _loc5_:* = undefined;
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
         this.generateByteArray();
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
         param1.addEventListener(SocketEvent.DATA_RECEIVED,this.dataReceived);
         param1.addEventListener(SocketEvent.SOCKET_READY,this.socketReady);
         param1.addEventListener(SocketEvent.SOCKET_ERROR,this.socketError);
         param1.isReady();
      }
      
      override public function getEstimatedTimeLeft() : Number
      {
         var _loc1_:* = this.uploadStartTime + 1000 * sampleSize;
         var _loc2_:* = Tools.getTime();
         if(_loc1_ > _loc2_)
         {
            return _loc1_ - _loc2_;
         }
         return 0;
      }
      
      protected function forceFinishSocket(param1:*) : *
      {
         Logger.info("Force cleanup of socket");
         this.cleanupSocket(param1);
         this.socketData[param1].bytesSent = this.socketData[param1].bytesReceived;
         this.socketData[param1].transferData.push({
            "clienttime":Tools.getTime(),
            "total":this.socketData[param1].bytesReceived
         });
      }
      
      override public function getProgress() : Number
      {
         var _loc9_:SocketConnection = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc1_:* = this.getEstimatedTimeLeft();
         var _loc2_:* = 1000 * sampleSize;
         var _loc3_:* = 1 - _loc1_ / _loc2_;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = _loc1_ == 0 && Tools.getTime() - this.lastDetailedProgress > 1000;
         for each(_loc9_ in this.socketConnections)
         {
            if(this.socketData[_loc9_] != null)
            {
               if(_loc8_)
               {
                  if(this.socketData[_loc9_].bytesSent != this.socketData[_loc9_].bytesReceived)
                  {
                     _loc7_++;
                     Logger.info("ID: " + this.socketData[_loc9_].connectionId + " sent: " + this.socketData[_loc9_].bytesSent + " received: " + this.socketData[_loc9_].bytesReceived);
                     if(this.lastPendingTransfer == 1 || this.lastCompleteRatio > 0.95)
                     {
                        _loc11_ = this.socketData[_loc9_].transferData.length;
                        _loc12_ = this.socketData[_loc9_].transferData[_loc11_ - 1];
                        _loc13_ = Tools.getTime() - _loc12_.clienttime;
                        _loc14_ = this.uploadStartTime + 1000 * sampleSize;
                        _loc15_ = Tools.getTime() - _loc14_;
                        if(_loc13_ > 5000 && _loc15_ > 5000)
                        {
                           this.forceFinishSocket(_loc9_);
                        }
                     }
                  }
               }
               if(this.socketData[_loc9_].cleanedUp == false)
               {
                  _loc6_++;
               }
               _loc4_ = _loc4_ + this.socketData[_loc9_].bytesReceived;
               _loc5_ = _loc5_ + this.socketData[_loc9_].bytesSent;
            }
            else if(_loc8_)
            {
               _loc16_ = _loc9_.getConnectionId();
               Logger.info("ID: " + _loc16_ + " - no data received - cleaning up");
               this.cleanupSocket(_loc9_);
            }
         }
         if(_loc8_)
         {
            Logger.info("test complete: " + _loc4_ + " " + _loc5_ + " " + _loc4_ / _loc5_);
            Logger.info("Sockets pending transfer: " + _loc7_);
            Logger.info("Sockets pending cleanup: " + _loc6_);
            this.lastDetailedProgress = Tools.getTime();
            this.lastPendingTransfer = _loc7_;
            this.lastPendingCleanup = _loc6_;
            this.lastCompleteRatio = _loc4_ / _loc5_;
         }
         _loc10_ = _loc4_ / _loc5_;
         return Math.min(_loc10_,_loc3_);
      }
      
      override protected function setDefaults() : void
      {
         defaultSettings.maxSampleSize = 1000000;
         defaultSettings.minSampleSize = 32000;
         defaultSettings.startSampleSize = 100000;
         defaultSettings.startBufferSize = 2;
         defaultSettings.bufferLength = 2000;
         defaultSettings.packetLength = 500;
      }
      
      protected function generateByteArray() : void
      {
         this.byteArray = new ByteArray();
         var _loc1_:* = getSetting("randomDataMethod");
         switch(_loc1_)
         {
            case 2:
               while(this.byteArray.length < getSetting("maxSampleSize"))
               {
                  this.byteArray.writeByte(65);
               }
               break;
            case 1:
            default:
               while(this.byteArray.length < getSetting("maxSampleSize"))
               {
                  this.byteArray.writeByte(Math.floor(Math.random() * 92) + 33);
               }
         }
      }
      
      protected function getCurrentSpeed() : *
      {
         if(this.data.length == 0)
         {
            return 0;
         }
         return this.getSpeed();
      }
      
      protected function getAverageSpeed() : *
      {
         var _loc1_:* = this.data[0];
         var _loc2_:* = this.dataUploaded;
         var _loc3_:* = Tools.getTime() - _loc1_.clienttime;
         var _loc4_:* = Math.round(1000 * _loc2_ / _loc3_);
         if(_loc4_ >= 0)
         {
            return _loc4_;
         }
         return 0;
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
      
      protected function getThreadSpeed() : *
      {
         if(this.threadSamples.length <= 4)
         {
            return 0;
         }
         var _loc1_:* = 0;
         var _loc2_:* = Math.min(Math.ceil(this.samplesToKeep * (this.threadSamples.length - this.samplesToSkip)),this.threadSamples.length - this.samplesToSkip);
         var _loc3_:* = this.samplesToSkip;
         while(_loc3_ < _loc2_ + this.samplesToSkip)
         {
            _loc1_ = _loc1_ + Math.floor(this.threadSamples[_loc3_]);
            _loc3_++;
         }
         return Math.round(_loc1_ / _loc2_);
      }
      
      protected function getSpeed() : *
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:Object = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc1_:Number = this.getProgress();
         var _loc2_:* = Tools.getTime();
         if(this.results.length == 0)
         {
            _loc3_ = {"progress":-Number.MAX_VALUE};
         }
         else
         {
            _loc3_ = this.results[this.results.length - 1];
         }
         if(Math.ceil(_loc1_ * 20) >= this.results.length && _loc1_ > _loc3_.progress + 0.04 || _loc1_ == 1 && _loc1_ > _loc3_.progress)
         {
            Logger.info("DL:  " + _loc1_ + "  t: " + _loc2_ + "  b: " + this.dataUploaded);
            _loc7_ = {
               "progress":_loc1_,
               "time":_loc2_,
               "bytes":this.dataUploaded
            };
            if(_loc1_ > 0 && this.results.length > 0)
            {
               _loc8_ = Math.round(1000 * (this.dataUploaded - _loc3_.bytes) / (_loc2_ - _loc3_.time));
               _loc9_ = Math.round((_loc1_ - _loc3_.progress) * 1000) / 1000;
               this.samples.push(_loc8_ + _loc9_);
               this.samples.sort(Array.DESCENDING | Array.NUMERIC);
               Logger.debug(this.samples);
            }
            this.results.push(_loc7_);
         }
         _loc4_ = 0;
         _loc5_ = this.getAverageSpeed();
         _loc6_ = this.getThreadSpeed();
         if(_loc6_ > 0 && _loc6_ > _loc5_)
         {
            _loc4_ = _loc1_ * _loc6_ + (1 - _loc1_) * _loc5_;
         }
         else
         {
            _loc4_ = _loc5_;
         }
         return Math.round(_loc4_);
      }
      
      protected function fillBuffer(param1:*, param2:Boolean = false) : *
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         if(param2)
         {
            _loc3_ = getSetting("startSampleSize");
            _loc4_ = getSetting("startBufferSize");
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc5_ = "UPLOAD " + _loc3_ + " " + param1.getConnectionId() + "\n";
               param1.writeUploadBytes(_loc5_,this.byteArray,_loc3_ - _loc5_.length - 1);
               this.socketData[param1].bytesSent = this.socketData[param1].bytesSent + _loc3_;
               _loc6_++;
            }
         }
         else
         {
            _loc7_ = this.getSpeed();
            _loc8_ = getSetting("packetLength") / this.socketConnections.length;
            _loc3_ = Math.min(Math.max(Math.round(_loc8_ / 1000 * _loc7_),getSetting("minSampleSize")),getSetting("maxSampleSize"));
            do
            {
               _loc4_ = this.socketData[param1].bytesSent - this.socketData[param1].bytesReceived;
               _loc9_ = 1000 * (_loc4_ / _loc7_);
               _loc10_ = Math.min(getSetting("bufferLength"),this.getEstimatedTimeLeft()) / this.socketConnections.length;
               if(_loc9_ < _loc10_)
               {
                  _loc5_ = "UPLOAD " + _loc3_ + " " + param1.getConnectionId() + "\n";
                  param1.writeUploadBytes(_loc5_,this.byteArray,_loc3_ - _loc5_.length - 1);
                  this.socketData[param1].bytesSent = this.socketData[param1].bytesSent + _loc3_;
               }
               if(_loc4_ == 0 && this.getEstimatedTimeLeft() == 0)
               {
                  this.cleanupSocket(param1);
               }
            }
            while(_loc9_ < _loc10_);
            
         }
      }
      
      protected function pushResults(param1:Number, param2:Number, param3:Number) : *
      {
         this.dataUploaded = this.dataUploaded + param1;
         var _loc4_:* = {
            "size":param1,
            "total":this.dataUploaded,
            "clienttime":Tools.getTime(),
            "servertime":param2
         };
         this.data.push(_loc4_);
         Logger.debug(this.data.length + ": " + _loc4_.size + " " + _loc4_.clienttime + " " + _loc4_.servertime + " " + _loc4_.total);
      }
      
      protected function threadBytesUploaded(param1:SocketConnection, param2:Number) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc3_:* = this.socketData[param1].transferData;
         if(param2 < _loc3_[0].clienttime)
         {
            return 0;
         }
         _loc4_ = 1;
         while(_loc4_ < _loc3_.length)
         {
            if(param2 < _loc3_[_loc4_].clienttime)
            {
               _loc5_ = _loc3_[_loc4_ - 1].clienttime;
               _loc6_ = _loc3_[_loc4_].clienttime;
               _loc7_ = _loc3_[_loc4_ - 1].total;
               _loc8_ = _loc3_[_loc4_].total;
               _loc9_ = (param2 - _loc5_) / (_loc6_ - _loc5_) * (_loc8_ - _loc7_) + _loc7_;
               return Math.round(_loc9_);
            }
            _loc4_++;
         }
         return _loc3_[_loc3_.length - 1].total;
      }
      
      protected function dataReceived(param1:SocketEvent) : *
      {
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:* = param1.data.data;
         var _loc3_:SocketConnection = param1.data.target;
         var _loc4_:int = _loc3_.getConnectionId();
         _loc5_ = _loc2_.split(" ");
         switch(_loc5_[0])
         {
            case "ERROR":
               Logger.error("SERVER ERROR: " + _loc2_);
               break;
            case "OK":
               _loc6_ = Number(_loc5_[1]);
               _loc7_ = Number(_loc5_[2]);
               this.socketData[_loc3_].bytesReceived = this.socketData[_loc3_].bytesReceived + _loc6_;
               this.socketData[_loc3_].transferData.push({
                  "clienttime":Tools.getTime(),
                  "total":this.socketData[_loc3_].bytesReceived
               });
               this.pushResults(_loc6_,_loc7_,_loc4_);
               this.fillBuffer(_loc3_);
         }
      }
      
      protected function socketReady(param1:SocketEvent) : *
      {
         Logger.info("Socket ready for use");
         var _loc2_:SocketConnection = param1.data.target;
         var _loc3_:int = _loc2_.getConnectionId();
         this.socketsReady++;
         this.socketData[_loc2_] = {
            "bytesReceived":0,
            "bytesSent":0,
            "connectionId":_loc3_,
            "transferData":new Array(),
            "cleanedUp":false
         };
         Logger.info(_loc3_ + "/" + this.socketConnections.length + "  " + this.socketsReady);
         if(this.uploadStartTime == 0)
         {
            if(this.socketsReady == this.socketConnections.length)
            {
               this.startUploads();
            }
         }
         else
         {
            this.socketData[_loc2_].transferData.push({
               "clienttime":Tools.getTime(),
               "total":0
            });
            this.fillBuffer(_loc2_);
         }
      }
      
      protected function startUploads() : *
      {
         var _loc2_:SocketConnection = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this.uploadStartTime = Tools.getTime();
         var _loc1_:int = getSetting("threadCount");
         for each(_loc2_ in this.socketConnections)
         {
            this.socketData[_loc2_].transferData.push({
               "clienttime":Tools.getTime(),
               "total":0
            });
            this.fillBuffer(_loc2_,true);
         }
         _loc3_ = {
            "size":0,
            "total":0,
            "clienttime":Tools.getTime(),
            "servertime":0
         };
         this.data.push(_loc3_);
         _loc4_ = {
            "total":0,
            "clienttime":Tools.getTime()
         };
         this.threadResults.push(_loc4_);
         Logger.info("Starting Timer");
         _loc5_ = getSetting("progressMethod");
         switch(_loc5_)
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
         var _loc3_:SocketConnection = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc2_:Number = 0;
         for each(_loc3_ in this.socketConnections)
         {
            if(this.socketData[_loc3_] != null)
            {
               _loc2_ = _loc2_ + this.socketData[_loc3_].bytesReceived;
            }
         }
         if(_loc2_ != this.maintenanceTimeOutBytes)
         {
            this.maintenanceTimeOutBytes = _loc2_;
            update(this.maintenanceTimeOutBytes);
         }
         _loc4_ = this.getProgress();
         if(_loc4_ < 0.5)
         {
            _loc7_ = this.socketConnections.length;
            _loc8_ = this.getDesiredThreads();
            if(_loc8_ > _loc7_)
            {
               this.handleExtraSockets(_loc8_,true);
            }
         }
         _loc5_ = Number.MAX_VALUE;
         for each(_loc3_ in this.socketConnections)
         {
            if(this.socketData[_loc3_] != null)
            {
               _loc9_ = this.socketData[_loc3_].transferData;
               if(_loc9_.length > 0)
               {
                  _loc5_ = Math.min(_loc9_[_loc9_.length - 1].clienttime,_loc5_);
               }
            }
         }
         _loc6_ = this.threadResults[this.threadResults.length - 1].clienttime + 500;
         while(_loc6_ < _loc5_)
         {
            _loc10_ = 0;
            for each(_loc3_ in this.socketConnections)
            {
               if(this.socketData[_loc3_] != null)
               {
                  _loc10_ = _loc10_ + this.threadBytesUploaded(_loc3_,_loc6_);
               }
            }
            this.addThreadResult(_loc10_,_loc6_);
            _loc6_ = _loc6_ + 500;
         }
         testForTimeOut();
      }
      
      protected function addThreadResult(param1:Number, param2:Number) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc3_:* = this.uploadStartTime + 1000 * sampleSize;
         var _loc4_:* = Math.min((param2 - this.uploadStartTime) / (1000 * sampleSize),1);
         this.threadResults.push({
            "total":param1,
            "bytes":param1,
            "time":param2,
            "clienttime":param2,
            "progress":_loc4_
         });
         if(this.threadResults.length >= 2)
         {
            _loc5_ = this.threadResults[this.threadResults.length - 2];
            _loc6_ = this.threadResults[this.threadResults.length - 1];
            if(_loc6_.clienttime > _loc5_.clienttime)
            {
               _loc7_ = Math.round(1000 * (_loc6_.total - _loc5_.total) / (_loc6_.clienttime - _loc5_.clienttime));
               if(_loc7_ > 0)
               {
                  this.threadSamples.push(_loc7_);
                  this.threadSamples.sort(Array.DESCENDING | Array.NUMERIC);
               }
            }
         }
      }
      
      protected function socketError(param1:SocketEvent) : *
      {
         Logger.error("Upload test returned an error: " + param1 + " " + param1.data + " " + param1.data.type);
         var _loc2_:* = {
            "code":"socket-upload01",
            "event":param1
         };
         dispatchFatal(_loc2_);
      }
      
      protected function sendProgress() : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc1_:* = this.getProgress();
         if(_loc1_ == 1)
         {
            this.handleMaintenance(null);
            this.addThreadResult(this.dataUploaded,Tools.getTime());
            do
            {
               this.threadResultSent = Math.min(this.threadResultSent + 1,this.threadResults.length - 1);
               _loc2_ = {
                  "current":this.getSpeed(),
                  "best":0,
                  "progress":1,
                  "time":Tools.getTime() - startTime,
                  "estimatedTime":0,
                  "done":true,
                  "bytes":this.dataUploaded,
                  "graphResult":this.threadResults[this.threadResultSent]
               };
               dispatchProgress(_loc2_);
            }
            while(this.threadResultSent < this.threadResults.length - 1);
            
            Logger.debug("TS Samples:");
            Logger.debug(this.threadSamples);
            Logger.info("FINAL - avgspeed: " + this.getAverageSpeed() + " ss2:" + this.getSuperSpeed2() + " ts:" + this.getThreadSpeed() + " bytes:" + this.dataUploaded);
            _loc3_ = {
               "final":this.getSpeed(),
               "time":Tools.getTime() - startTime,
               "startTime":startTime,
               "bytes":this.dataUploaded,
               "extraSpeeds":this.threadSamples,
               "rawSamples":this.threadResults
            };
            dispatchComplete(_loc3_);
         }
         else
         {
            this.threadResultSent = Math.min(this.threadResultSent + 1,this.threadResults.length - 1);
            _loc2_ = {
               "current":this.getSpeed(),
               "best":0,
               "progress":_loc1_,
               "time":Tools.getTime() - startTime,
               "estimatedTime":this.getEstimatedTimeLeft(),
               "done":false,
               "bytes":this.dataUploaded,
               "graphResult":this.threadResults[this.threadResultSent]
            };
            dispatchProgress(_loc2_);
         }
      }
   }
}
