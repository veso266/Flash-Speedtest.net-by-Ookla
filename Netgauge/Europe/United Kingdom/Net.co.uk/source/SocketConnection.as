package
{
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   class SocketConnection extends EventDispatcher
   {
      
      private static var socketConnections:Array = new Array();
       
      
      private var socket:Socket;
      
      private var timer:Timer;
      
      private var currentHost:String = null;
      
      private var currentPort:uint = 0;
      
      private var rawMode:Boolean = false;
      
      private var connectionId:int = 0;
      
      private var sayWhenReady:Boolean = false;
      
      private var version:Number = 0;
      
      function SocketConnection(param1:int, param2:* = false)
      {
         super();
         this.rawMode = param2;
         this.connectionId = param1;
         this.socket = new Socket();
         if(this.rawMode == false)
         {
            this.configureListeners();
         }
      }
      
      public static function getSocketConnection(param1:int = 0) : SocketConnection
      {
         if(socketConnections[param1] == null)
         {
            socketConnections[param1] = new SocketConnection(param1);
         }
         return socketConnections[param1];
      }
      
      public static function closeAll() : *
      {
         Logger.info("Closing all TCP connections");
         var _loc1_:Number = 0;
         var _loc2_:* = 0;
         while(_loc2_ < socketConnections.length)
         {
            if(socketConnections[_loc2_] != null)
            {
               socketConnections[_loc2_].closeSocket();
               _loc1_++;
            }
            _loc2_++;
         }
         Logger.info("Connections closed: " + _loc1_);
      }
      
      public function setRawMode(param1:Boolean) : Socket
      {
         if(param1 == this.rawMode)
         {
            if(param1)
            {
               return this.socket;
            }
            return null;
         }
         this.rawMode = param1;
         if(param1)
         {
            this.removeListeners();
            return this.socket;
         }
         this.configureListeners();
         return null;
      }
      
      public function getConnectionId() : int
      {
         return this.connectionId;
      }
      
      public function socketConnect(param1:String = null, param2:uint = 0) : *
      {
         if(this.currentHost == param1 && this.currentPort == param2)
         {
            if(!this.socket.connected)
            {
               trace("connecting");
               this.doConnect(param1,param2);
            }
         }
         else
         {
            if(this.socket.connected)
            {
               this.socket.close();
            }
            this.doConnect(param1,param2);
         }
         this.currentHost = param1;
         this.currentPort = param2;
      }
      
      private function doConnect(param1:*, param2:*) : *
      {
         this.socket.connect(param1,param2);
      }
      
      function fireTimeout(param1:TimerEvent) : void
      {
         this.clearTimeout();
         var _loc2_:SocketEvent = new SocketEvent(SocketEvent.SOCKET_ERROR,{
            "event":param1,
            "type":"timeout"
         });
         dispatchEvent(_loc2_);
         this.closeConnection();
      }
      
      private function clearTimeout() : *
      {
         if(this.timer != null)
         {
            this.timer.reset();
            this.timer.removeEventListener(TimerEvent.TIMER,this.fireTimeout);
            this.timer = null;
         }
      }
      
      private function configureListeners() : void
      {
         this.socket.addEventListener(Event.CLOSE,this.closeHandler);
         this.socket.addEventListener(Event.CONNECT,this.connectHandler);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
      }
      
      private function removeListeners() : void
      {
         this.socket.removeEventListener(Event.CLOSE,this.closeHandler);
         this.socket.removeEventListener(Event.CONNECT,this.connectHandler);
         this.socket.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         this.socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
      }
      
      public function isReady() : *
      {
         if(this.socket.connected)
         {
            this.sayWhenReady = true;
            this.doHi();
         }
         else
         {
            this.sayWhenReady = true;
         }
         this.timer = new Timer(15000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.fireTimeout);
         this.timer.start();
      }
      
      private function doHi() : *
      {
         this.writeln("HI");
      }
      
      public function writeln(param1:String) : void
      {
         var str:String = param1;
         str = str + "\n";
         try
         {
            this.socket.writeUTFBytes(str);
            this.socket.flush();
            return;
         }
         catch(e:IOError)
         {
            trace(e);
            return;
         }
      }
      
      public function writeBytes(param1:ByteArray, param2:uint = 0) : void
      {
         var bytes:ByteArray = param1;
         var length:uint = param2;
         try
         {
            this.socket.writeBytes(bytes,0,length);
            this.socket.writeUTFBytes("\n");
            this.socket.flush();
            return;
         }
         catch(e:IOError)
         {
            trace(e);
            return;
         }
      }
      
      public function writeUploadBytes(param1:String, param2:ByteArray, param3:uint = 0) : void
      {
         var prefix:String = param1;
         var bytes:ByteArray = param2;
         var length:uint = param3;
         try
         {
            this.socket.writeUTFBytes(prefix);
            this.socket.writeBytes(bytes,0,length);
            this.socket.writeUTFBytes("\n");
            this.socket.flush();
            return;
         }
         catch(e:IOError)
         {
            trace(e);
            return;
         }
      }
      
      public function getVersion() : Number
      {
         return this.version;
      }
      
      private function readResponse() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:SocketEvent = null;
         var _loc5_:String = null;
         var _loc6_:SocketEvent = null;
         var _loc1_:String = this.socket.readUTFBytes(this.socket.bytesAvailable);
         _loc1_ = _loc1_.substr(0,_loc1_.length - 1);
         var _loc2_:Array = _loc1_.split(" ");
         if(this.sayWhenReady && _loc2_[0] == "HELLO")
         {
            if(_loc2_.length > 1)
            {
               this.version = Number(_loc2_[1]);
            }
            else
            {
               this.version = 0;
            }
            if(_loc2_.length > 2)
            {
               Logger.info("server protocol: " + this.version + " build version: " + _loc2_[2]);
            }
            else
            {
               Logger.info("server protocol: " + this.version);
            }
            _loc4_ = new SocketEvent(SocketEvent.SOCKET_READY,{"target":this});
            dispatchEvent(_loc4_);
            this.clearTimeout();
            this.sayWhenReady = false;
            return;
         }
         _loc3_ = 0;
         do
         {
            _loc3_++;
            if(_loc1_.indexOf("\n") != -1)
            {
               _loc5_ = _loc1_.substring(0,_loc1_.indexOf("\n"));
               _loc1_ = _loc1_.substring(_loc1_.indexOf("\n") + 1);
            }
            else
            {
               _loc5_ = _loc1_;
               _loc1_ = "";
            }
            _loc6_ = new SocketEvent(SocketEvent.DATA_RECEIVED,{
               "data":_loc5_,
               "target":this
            });
            dispatchEvent(_loc6_);
         }
         while(_loc1_.length > 0);
         
      }
      
      public function closeSocket() : *
      {
         if(this.socket != null)
         {
            if(this.socket.connected)
            {
               this.writeln("QUIT");
            }
            this.closeConnection();
         }
      }
      
      private function closeHandler(param1:Event) : void
      {
         trace("closeHandler: " + param1);
         this.closeConnection();
      }
      
      function closeConnection(param1:Boolean = false) : *
      {
         var cleanupListeners:Boolean = param1;
         if(this.socket != null)
         {
            if(this.socket.connected)
            {
               try
               {
                  this.socket.close();
               }
               catch(e:IOError)
               {
                  Logger.error("closing " + connectionId + ":" + e);
               }
            }
            if(!this.rawMode && cleanupListeners)
            {
               this.removeListeners();
            }
         }
         this.currentHost = null;
         this.currentPort = 0;
         this.version = 0;
         socketConnections[this.connectionId] = null;
         this.socket = null;
      }
      
      private function connectHandler(param1:Event) : void
      {
         trace("connectHandler: " + param1);
         if(this.sayWhenReady)
         {
            this.doHi();
         }
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         Logger.error("SocketConnection " + this.connectionId + " ioErrorHandler: " + param1);
         var _loc2_:SocketEvent = new SocketEvent(SocketEvent.SOCKET_ERROR,{
            "event":param1,
            "type":"ioerror",
            "target":this
         });
         dispatchEvent(_loc2_);
         this.closeConnection(true);
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         Logger.error("SocketConnection " + this.connectionId + " securityErrorHandler: " + param1);
         var _loc2_:SocketEvent = new SocketEvent(SocketEvent.SOCKET_ERROR,{
            "event":param1,
            "type":"security",
            "target":this
         });
         dispatchEvent(_loc2_);
         this.closeConnection(true);
      }
      
      private function socketDataHandler(param1:ProgressEvent) : void
      {
         this.readResponse();
      }
   }
}
