package
{
   import com.adobe.utils.StringUtil;
   import com.greensock.TweenLite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   class ThrottlingTest extends Test
   {
       
      
      protected var apiUrl = "http://speedtest.ookla.com/api/throttle.php";
      
      protected var testEnd:Number;
      
      protected var progressInterval:Number;
      
      function ThrottlingTest()
      {
         super();
         sampleSize = 0;
         testName = "throttling";
         autoTimeOut = true;
      }
      
      override public function init() : void
      {
         super.init();
      }
      
      override public function cancel() : Boolean
      {
         super.cancel();
         this.reset();
         this.clearEnterFrame();
         return true;
      }
      
      override public function reset() : void
      {
         super.reset();
         sampleSize = 0;
         this.testEnd = 0;
      }
      
      override public function start() : Boolean
      {
         if(!settingDefined("serverid"))
         {
            return false;
         }
         if(!settingDefined("customer"))
         {
            return false;
         }
         if(settingDefined("apiurl"))
         {
            this.apiUrl = getSetting("apiurl");
         }
         this.reset();
         super.start();
         this.testEnd = Tools.getTime();
         if(getSetting("testlimit") == 0 && getSetting("dailylimit") == 0)
         {
            TweenLite.delayedCall(25 / 1000,this.sendProgress);
         }
         else
         {
            this.getThrottleData();
         }
         return true;
      }
      
      protected function getThrottleData() : *
      {
         var _loc2_:URLRequest = null;
         var _loc3_:URLLoader = null;
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.testlimit = getSetting("testlimit");
         _loc1_.testlength = getSetting("testlength");
         _loc1_.dailylimit = getSetting("dailylimit");
         _loc1_.serverid = getSetting("serverid");
         _loc1_.customer = getSetting("customer");
         if(getSetting("uselocalip") && settingDefined("clientip"))
         {
            _loc1_.clientip = getSetting("clientip");
         }
         Logger.debug(_loc1_);
         _loc2_ = new URLRequest(this.apiUrl);
         _loc2_.method = URLRequestMethod.POST;
         _loc2_.data = _loc1_;
         _loc3_ = new URLLoader();
         _loc3_.dataFormat = URLLoaderDataFormat.VARIABLES;
         _loc3_.addEventListener(Event.COMPLETE,Callback.create(this.throttleDataReceived,{
            "success":true,
            "_default":false
         }));
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,Callback.create(this.throttleDataReceived,{
            "success":false,
            "_default":false
         }));
         _loc3_.load(_loc2_);
      }
      
      protected function throttleDataReceived(param1:Event, param2:Object) : *
      {
         var delay:* = undefined;
         var event:Event = param1;
         var obj:Object = param2;
         var loader:URLLoader = URLLoader(event.target);
         var result:URLVariables = new URLVariables();
         var resultString:String = StringUtil.trim(loader.data);
         try
         {
            result.decode(resultString);
         }
         catch(e:Error)
         {
            obj.success = false;
         }
         Logger.debug("ok on throttling received: " + obj.success + " " + result);
         if(obj.success)
         {
            delay = Number(result.delay);
            if(result.access == "denied")
            {
               this.testEnd = Tools.getTime();
            }
            else
            {
               if(delay == -1)
               {
                  this.limitExceeded();
                  return;
               }
               this.testEnd = Tools.getTime() + delay * 1000;
            }
         }
         else
         {
            this.testEnd = Tools.getTime();
         }
         this.sendProgress();
         if(delay > 0)
         {
            DocumentClass.document.addEventListener(Event.ENTER_FRAME,this.sendEventProgress);
         }
      }
      
      protected function limitExceeded() : *
      {
         Logger.error("Limit Exceeded!");
         var _loc1_:* = getSetting("dailylimit");
         var _loc2_:* = Tools.stringReplace(ErrorMessages.getErrorMessage("throttle01"),"{DAILYLIMIT}",_loc1_);
         var _loc3_:* = {
            "error":_loc2_,
            "title":ErrorMessages.getErrorTitle("throttle01"),
            "code":"throttle01"
         };
         dispatchFatal(_loc3_);
      }
      
      override public function getEstimatedTimeLeft() : Number
      {
         var _loc1_:* = this.testEnd - Tools.getTime();
         return Math.max(0,_loc1_);
      }
      
      override public function getProgress() : Number
      {
         var _loc1_:* = (Tools.getTime() - startTime) / (this.testEnd - startTime);
         return Math.min(1,_loc1_);
      }
      
      protected function clearEnterFrame() : *
      {
         DocumentClass.document.removeEventListener(Event.ENTER_FRAME,this.sendProgress);
      }
      
      override protected function setDefaults() : void
      {
      }
      
      protected function sendEventProgress(param1:Event) : void
      {
         this.sendProgress();
      }
      
      protected function sendProgress() : *
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc1_:* = this.getProgress();
         if(_loc1_ < 1)
         {
            _loc2_ = {
               "current":1,
               "progress":_loc1_,
               "estimatedTime":this.getEstimatedTimeLeft(),
               "done":false
            };
            dispatchProgress(_loc2_);
         }
         else
         {
            this.clearEnterFrame();
            _loc3_ = {
               "current":1,
               "progress":1,
               "estimatedTime":0,
               "done":true
            };
            dispatchProgress(_loc3_);
            _loc4_ = {
               "final":1,
               "time":Tools.getTime() - startTime,
               "startTime":startTime
            };
            dispatchComplete(_loc4_);
         }
      }
   }
}
