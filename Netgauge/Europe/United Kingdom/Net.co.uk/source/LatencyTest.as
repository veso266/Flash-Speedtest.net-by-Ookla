package
{
   import com.greensock.TweenLite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.getTimer;
   
   class LatencyTest extends Test
   {
       
      
      private var results:Array;
      
      private var currentLoader:URLLoader;
      
      function LatencyTest()
      {
         super();
         sampleSize = 10;
         testName = "http-latency";
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
         this.reset();
         sampleSize = 0;
         if(this.currentLoader != null)
         {
            trace(this.currentLoader.bytesLoaded);
            trace(this.currentLoader.bytesTotal);
            this.currentLoader.close();
            this.currentLoader = null;
         }
         return true;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.results = new Array();
      }
      
      override public function start() : Boolean
      {
         if(!settingDefined("fullUrl"))
         {
            return false;
         }
         if(getSetting("fullUrl") == "")
         {
            return false;
         }
         if(isNaN(sampleSize))
         {
            return false;
         }
         super.start();
         this.nextTest();
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
         defaultSettings.waitTime = 100;
      }
      
      protected function nextTest() : *
      {
         var _loc1_:* = getTimer();
         var _loc2_:URLVariables = new URLVariables();
         _loc2_.x = Tools.getTime();
         var _loc3_:URLRequest = new URLRequest(Tools.getBasePath(getSetting("fullUrl")) + "latency.txt");
         _loc3_.method = URLRequestMethod.GET;
         _loc3_.data = _loc2_;
         var _loc4_:URLLoader = new URLLoader();
         _loc4_.dataFormat = URLLoaderDataFormat.TEXT;
         _loc4_.addEventListener(Event.COMPLETE,Callback.create(this.saveResults,{
            "success":true,
            "time":_loc1_
         }));
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,Callback.create(this.saveResults,{
            "success":false,
            "time":_loc1_
         }));
         _loc4_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,Callback.create(this.saveResults,{
            "success":false,
            "time":_loc1_
         }));
         _loc4_.load(_loc3_);
         this.currentLoader = _loc4_;
      }
      
      protected function saveResults(param1:Event, param2:Object) : *
      {
         var _loc5_:* = undefined;
         var _loc3_:* = param2.success;
         var _loc4_:* = param2.time;
         if(!_loc3_)
         {
            trace("Error loading/parsing LoadVars.");
            Logger.error("Latency test returned an error while trying to read the latency file.");
            param2 = {"code":"latency01"};
            dispatchFatal(param2);
            return;
         }
         _loc5_ = getTimer() - _loc4_;
         this.results.push(_loc5_);
         update(this.results.length);
         this.currentLoader = null;
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
      
      protected function sendProgress(param1:Boolean) : *
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc2_:* = this.results[this.results.length - 1];
         this.results.sort(Array.NUMERIC);
         var _loc3_:* = this.results[0];
         var _loc4_:* = 0;
         var _loc5_:* = Math.ceil(this.results.length * 0.5);
         var _loc6_:* = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = _loc4_ + this.results[_loc6_];
            _loc6_++;
         }
         _loc7_ = this.adjust(this.results[0]);
         _loc8_ = this.results[0];
         _loc9_ = Math.round(_loc4_ / _loc5_);
         if(!param1)
         {
            _loc10_ = {
               "current":this.adjust(_loc2_),
               "best":this.adjust(_loc3_),
               "progress":this.getProgress(),
               "estimatedTime":this.getEstimatedTimeLeft(),
               "done":false
            };
            dispatchProgress(_loc10_);
         }
         else
         {
            _loc11_ = {
               "current":this.adjust(_loc2_),
               "best":this.adjust(_loc3_),
               "progress":1,
               "estimatedTime":0,
               "done":true
            };
            dispatchProgress(_loc11_);
            _loc12_ = {
               "final":this.adjust(_loc3_),
               "time":Tools.getTime() - startTime,
               "startTime":startTime
            };
            dispatchComplete(_loc12_);
         }
      }
      
      protected function adjust(param1:Number) : *
      {
         var _loc2_:* = undefined;
         if(param1 > 10)
         {
            _loc2_ = 5;
         }
         else
         {
            _loc2_ = Math.floor(param1 / 2);
         }
         return Math.round(param1 - _loc2_);
      }
   }
}
