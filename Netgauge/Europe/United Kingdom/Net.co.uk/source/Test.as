package
{
   import com.greensock.TweenLite;
   import flash.events.EventDispatcher;
   
   class Test extends EventDispatcher
   {
       
      
      protected var settings:Object;
      
      protected var defaultSettings:Object;
      
      protected var sampleSize:Number;
      
      protected var testName:String = "test";
      
      protected var startTime:Number = 0;
      
      protected var timeOut:Number = 0;
      
      protected var lastUpdate:Number = 0;
      
      protected var errored:Boolean = false;
      
      protected var cancelled:Boolean = false;
      
      protected var autoTimeOut:Boolean = false;
      
      protected var startedValue:Number = 0;
      
      protected var progressCallBack:Function;
      
      function Test()
      {
         this.settings = new Object();
         this.defaultSettings = new Object();
         super();
         this.init();
      }
      
      public function init() : void
      {
         this.setDefaults();
      }
      
      public function hasStarted() : Boolean
      {
         return this.startedValue > 0;
      }
      
      protected function setDefaults() : void
      {
      }
      
      public function reset() : void
      {
         this.startedValue = 0;
      }
      
      public function configure(param1:Object) : void
      {
         this.settings = param1;
         var _loc2_:* = this.getSetting("timeOut");
         if(_loc2_ != undefined)
         {
            this.timeOut = _loc2_;
         }
      }
      
      public function setProgressCallBack(param1:Function) : *
      {
         this.progressCallBack = param1;
      }
      
      public function setOption(param1:String, param2:String) : void
      {
         this.settings[param1] = param2;
      }
      
      protected function update(param1:int = 0) : void
      {
         if(param1 > 0)
         {
            this.startedValue = param1;
         }
         this.lastUpdate = Tools.getTime();
      }
      
      public function start() : Boolean
      {
         this.startTime = Tools.getTime();
         this.lastUpdate = this.startTime;
         Logger.info(this.testName + " Test started at " + this.startTime);
         if(this.timeOut > 0 && this.autoTimeOut)
         {
            TweenLite.delayedCall(1,this.testForTimeOut);
         }
         return false;
      }
      
      private function clearAutoTimeOut() : *
      {
         TweenLite.killDelayedCallsTo(this.testForTimeOut);
      }
      
      public function cancel() : Boolean
      {
         Logger.info("Test cancelled");
         this.cancelled = true;
         this.clearAutoTimeOut();
         return false;
      }
      
      public function cleanup() : Boolean
      {
         this.progressCallBack = null;
         this.clearAutoTimeOut();
         return true;
      }
      
      public function getProgress() : Number
      {
         return 0;
      }
      
      public function getEstimatedTimeLeft() : Number
      {
         var _loc2_:* = undefined;
         var _loc1_:* = this.getProgress();
         if(_loc1_ == 0)
         {
            return -1;
         }
         _loc2_ = Tools.getTime();
         return Math.round((1 - _loc1_) * (_loc2_ - this.startTime) / _loc1_);
      }
      
      public function setSampleSize(param1:Number) : void
      {
         this.sampleSize = param1;
      }
      
      protected function getSetting(param1:*) : *
      {
         if(this.settings[param1] != undefined)
         {
            return this.settings[param1];
         }
         return this.defaultSettings[param1];
      }
      
      protected function settingDefined(param1:*, param2:Boolean = true) : *
      {
         var _loc3_:* = this.getSetting(param1);
         if(_loc3_ != undefined)
         {
            return true;
         }
         if(param2)
         {
            Logger.warning("setting: " + param1 + " not defined");
         }
         return false;
      }
      
      protected function dispatchProgress(param1:*) : *
      {
         if(this.errored || this.cancelled)
         {
            return false;
         }
         param1.target = this;
         param1.type = "progress";
         param1.test = this.testName;
         if(this.progressCallBack != null)
         {
            this.progressCallBack(this.testName,param1);
            return;
         }
         var _loc2_:TestEvent = new TestEvent(TestEvent.PROGRESS,param1);
         dispatchEvent(_loc2_);
      }
      
      protected function dispatchComplete(param1:*) : *
      {
         if(this.errored || this.cancelled)
         {
            return false;
         }
         param1.target = this;
         param1.type = "complete";
         param1.test = this.testName;
         var _loc2_:TestEvent = new TestEvent(TestEvent.COMPLETE,param1);
         dispatchEvent(_loc2_);
         this.clearAutoTimeOut();
      }
      
      protected function testForTimeOut() : *
      {
         var _loc1_:* = undefined;
         if(this.timeOut == 0)
         {
            return;
         }
         if(this.lastUpdate + this.timeOut * 1000 < Tools.getTime())
         {
            _loc1_ = {"code":"timeout01"};
            this.dispatchFatal(_loc1_);
         }
         else if(this.autoTimeOut)
         {
            TweenLite.delayedCall(1,this.testForTimeOut);
         }
      }
      
      protected function dispatchFatal(param1:*) : *
      {
         if(this.errored || this.cancelled)
         {
            return false;
         }
         param1.target = this;
         param1.type = "fatal";
         param1.test = this.testName;
         var _loc2_:TestEvent = new TestEvent(TestEvent.FATAL,param1);
         dispatchEvent(_loc2_);
         this.errored = true;
         this.clearAutoTimeOut();
      }
   }
}
