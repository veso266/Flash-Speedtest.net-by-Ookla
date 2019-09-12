package
{
   import flash.display.MovieClip;
   import flash.events.ErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.StatusEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.net.*;
   import flash.text.TextField;
   
   public class Logger
   {
      
      public static var DEBUG:Number = 10;
      
      public static var INFO:Number = 20;
      
      public static var WARNING:Number = 50;
      
      public static var ERROR:Number = 100;
      
      public static var maxLength = 35;
      
      private static var debugField:TextField;
      
      private static var recentMessages:Array = new Array();
      
      private static var enabled:Boolean = false;
      
      private static var fullLoggerEnabled:Boolean = false;
      
      private static var fullLoggerMode = 0;
      
      private static var fullLog:String = "";
      
      private static var logger:Logger;
      
      private static var remoteConn:LocalConnection = null;
       
      
      private var startKey = "debug";
      
      private var hotKey:HotKey;
      
      public function Logger()
      {
         super();
         this.hotKey = new HotKey(this.showField,this.startKey);
         Logger.logger = this;
         DocumentClass.document.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.handleGlobalErrors);
      }
      
      public static function debug(param1:*) : *
      {
         Logger.log(Logger.DEBUG,param1);
      }
      
      public static function enableFullLogger(param1:Number = 1) : *
      {
         fullLoggerEnabled = true;
         fullLoggerMode = param1;
      }
      
      public static function init() : *
      {
         var _loc1_:Logger = new Logger();
      }
      
      public static function warning(param1:*) : *
      {
         Logger.log(Logger.WARNING,param1);
      }
      
      public static function error(param1:*) : *
      {
         Logger.log(Logger.ERROR,param1);
      }
      
      public static function info(param1:*) : *
      {
         Logger.log(Logger.INFO,param1);
      }
      
      private static function log(param1:*, param2:*) : *
      {
         var label:* = undefined;
         var t:* = undefined;
         var line:* = undefined;
         var level:* = param1;
         var message:* = param2;
         switch(level)
         {
            case Logger.DEBUG:
               label = "DEBUG";
               break;
            case Logger.WARNING:
               label = "WARNING";
               break;
            case Logger.INFO:
               label = "INFO";
               break;
            case Logger.ERROR:
               label = "ERROR";
         }
         t = Tools.getTime() % 100000;
         line = t + "  " + label + ": " + message;
         trace(line);
         recentMessages.push(line);
         if(recentMessages.length > maxLength)
         {
            recentMessages.shift();
         }
         if(fullLoggerEnabled)
         {
            fullLog = fullLog + (line + "\n");
         }
         if(enabled)
         {
            addText(line);
         }
         if(remoteConn)
         {
            try
            {
               remoteConn.send("_netgauge_remotedebug","log",line);
               return;
            }
            catch(e:Error)
            {
               trace(e.toString());
               return;
            }
         }
      }
      
      public static function flushFullLog(param1:String, param2:Number = 10) : *
      {
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         if(fullLoggerEnabled)
         {
            if(fullLoggerMode == 1 || param2 == ERROR && fullLoggerMode == 2)
            {
               _loc3_ = new URLVariables();
               _loc3_.data = fullLog;
               _loc3_.from = param1;
               _loc4_ = new URLRequest("http://olivier.ookla.com/beta/log.php");
               _loc4_.method = URLRequestMethod.POST;
               _loc4_.data = _loc3_;
               _loc5_ = new URLLoader();
               _loc5_.dataFormat = URLLoaderDataFormat.VARIABLES;
               _loc5_.load(_loc4_);
               fullLog = "";
            }
         }
      }
      
      private static function addText(param1:*) : *
      {
         debugField.text = debugField.text + param1 + "\n";
         debugField.scrollV = debugField.maxScrollV;
      }
      
      public static function moveToTop() : *
      {
         if(enabled)
         {
            try
            {
               debugField.parent.parent.setChildIndex(debugField.parent,debugField.parent.parent.numChildren - 1);
               return;
            }
            catch(e:Error)
            {
               trace("couldn\'t move to top");
               return;
            }
         }
      }
      
      public static function enable() : *
      {
         var i:* = undefined;
         enabled = true;
         maxLength = 1000;
         trace("Debugging enabled!");
         var container:MovieClip = new MovieClip();
         container.name = "debug_container";
         container.x = 20;
         container.y = 20;
         DocumentClass.document.addChild(container);
         debugField = new TextField();
         debugField.x = debugField.y = 0;
         debugField.width = debugField.height = 250;
         debugField.background = true;
         debugField.border = true;
         container.addChild(debugField);
         var resize:MovieClip = new MovieClip();
         resize.name = "resize";
         resize.x = 250;
         resize.y = 250;
         with(resize.graphics)
         {
            
            beginFill(0,100);
            lineStyle(1,51,100);
            moveTo(0,0);
            lineTo(0,10);
            lineTo(10,10);
            lineTo(10,0);
            endFill();
         }
         container.addChild(resize);
         var move:MovieClip = new MovieClip();
         move.name = "move";
         with(move.graphics)
         {
            
            beginFill(0,100);
            lineStyle(1,51,100);
            moveTo(0,0);
            lineTo(0,10);
            lineTo(10,10);
            lineTo(10,0);
            endFill();
         }
         move.x = 0;
         move.y = 250;
         container.addChild(move);
         var resizeDown:Function = function(param1:MouseEvent):*
         {
            param1.target.startDrag();
         };
         var resizeUp:Function = function(param1:MouseEvent):*
         {
            param1.target.stopDrag();
            var _loc2_:* = Logger.getDebugField();
            _loc2_.width = param1.target.x;
            _loc2_.height = param1.target.y;
            var _loc3_:* = param1.target.parent.getChildByName("move");
            _loc3_.y = _loc2_.height;
         };
         var moveDown:Function = function(param1:MouseEvent):*
         {
            param1.target.parent.startDrag();
         };
         var moveUp:Function = function(param1:MouseEvent):*
         {
            param1.target.parent.stopDrag();
         };
         resize.addEventListener(MouseEvent.MOUSE_DOWN,resizeDown);
         resize.addEventListener(MouseEvent.MOUSE_UP,resizeUp);
         move.addEventListener(MouseEvent.MOUSE_DOWN,moveDown);
         move.addEventListener(MouseEvent.MOUSE_UP,moveUp);
         if(recentMessages.length)
         {
            i = 0;
            while(i < recentMessages.length)
            {
               addText(recentMessages[i]);
               i++;
            }
         }
      }
      
      public static function getDebugField() : *
      {
         return debugField;
      }
      
      public static function testUnlocked(param1:Configuration) : *
      {
         var _loc3_:* = undefined;
         maxLength = Math.max(maxLength,TestConfigurator.getRangeInt(param1.getSetting("errors","predebuglength"),10,1000,35));
         var _loc2_:* = TestConfigurator.getRangeInt(param1.getSetting("errors","fulllogger"),0,2,0);
         if(_loc2_ > 0)
         {
            enableFullLogger(_loc2_);
         }
         _loc3_ = TestConfigurator.getRangeInt(param1.getSetting("errors","remotedebug"),0,1,0);
         if(_loc3_)
         {
            remoteConn = new LocalConnection();
            remoteConn.addEventListener(StatusEvent.STATUS,onStatus);
         }
      }
      
      private static function onStatus(param1:StatusEvent) : void
      {
         switch(param1.level)
         {
            case "status":
               trace("LocalConnection.send() succeeded");
               break;
            case "error":
               trace("LocalConnection.send() failed");
         }
      }
      
      public function handleGlobalErrors(param1:UncaughtErrorEvent) : *
      {
         var _loc2_:* = undefined;
         if(param1.error is Error)
         {
            _loc2_ = Error(param1.error).message;
         }
         else if(param1.error is ErrorEvent)
         {
            _loc2_ = ErrorEvent(param1.error).text;
         }
         else
         {
            _loc2_ = param1.error.toString();
         }
         Logger.error("UNCAUGHT ERROR");
         Logger.error(_loc2_);
      }
      
      private function showField() : *
      {
         Logger.enable();
      }
   }
}
