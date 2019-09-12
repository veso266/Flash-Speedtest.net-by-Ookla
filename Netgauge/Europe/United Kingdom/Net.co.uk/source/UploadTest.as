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
   
   class UploadTest extends Test
   {
       
      
      protected var _id:Number = 0;
      
      protected var threadsLoaded:Number = 0;
      
      protected var chunkCount = 1;
      
      protected var chunkLoaded = 0;
      
      protected var loaders:Array;
      
      protected var results:Array;
      
      protected var threadResults:Array;
      
      protected var threadStartTime:Number;
      
      protected var chunkEndTime:Number = 0;
      
      protected var unadjustedProgress:Number = 0;
      
      function UploadTest()
      {
         super();
         sampleSize = 100000;
         testName = "http-upload";
         autoTimeOut = false;
      }
      
      override public function init() : void
      {
         super.init();
      }
      
      override public function cancel() : Boolean
      {
         super.cancel();
         this.cleanup();
         this.reset();
         this.chunkCount = 0;
         this.clearEnterFrame();
         return true;
      }
      
      override public function reset() : void
      {
         super.reset();
         this._id = 0;
         this.chunkLoaded = 0;
         this.chunkEndTime = 0;
         this.chunkReset();
         this.clearLoaders();
         this.results = new Array();
         this.loaders = new Array();
      }
      
      override public function cleanup() : Boolean
      {
         super.cleanup();
         return true;
      }
      
      protected function chunkReset() : *
      {
         this.threadsLoaded = 0;
         this.threadResults = new Array();
         this.threadStartTime = 0;
      }
      
      protected function clearLoaders() : *
      {
         var _loc1_:* = null;
         var _loc2_:URLLoader = null;
         if(this.loaders == null)
         {
            return;
         }
         for(_loc1_ in this.loaders)
         {
            _loc2_ = this.loaders[_loc1_] as URLLoader;
            trace(_loc2_,_loc2_.bytesLoaded,_loc2_.bytesTotal);
            _loc2_.close();
            _loc2_ = null;
         }
      }
      
      protected function clearLoader(param1:URLLoader) : *
      {
         var _loc3_:URLLoader = null;
         if(this.loaders == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.loaders.length)
         {
            _loc3_ = this.loaders[_loc2_] as URLLoader;
            if(_loc3_ == param1)
            {
               _loc3_.close();
               this.loaders.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      override protected function setDefaults() : void
      {
         defaultSettings.estimatedUploadSpeed = 50000;
         defaultSettings.maximumSampleSize = 1000000;
         defaultSettings.maximumChunkCount = 10;
         defaultSettings.threadCount = 1;
         defaultSettings.threadPerURL = 2;
         defaultSettings.waitTime = 50;
      }
      
      override public function start() : Boolean
      {
         if(!settingDefined("fullUrl"))
         {
            return false;
         }
         if(isNaN(sampleSize))
         {
            return false;
         }
         this.reset();
         super.start();
         var _loc1_:* = getSetting("maximumSampleSize");
         var _loc2_:* = getSetting("maximumChunkCount");
         var _loc3_:* = getSetting("threadCount");
         var _loc4_:* = _loc1_ * _loc2_ * _loc3_;
         if(sampleSize > _loc4_)
         {
            Logger.error("Sample Size " + sampleSize + " too big - limitting to " + _loc4_);
            sampleSize = _loc4_;
         }
         if(sampleSize > _loc1_ * _loc3_)
         {
            this.chunkCount = Math.ceil(sampleSize / (_loc1_ * _loc3_));
         }
         else
         {
            this.chunkCount = Math.min(_loc2_,2);
         }
         Logger.debug("MTS: " + _loc4_ + "  MCC: " + _loc2_ + " MSS: " + _loc1_ + "  CC: " + this.chunkCount + "  SS: " + sampleSize + "  TC: " + _loc3_);
         this.nextChunk();
         if(getSetting("estimatedUploadSpeed") > 0)
         {
            DocumentClass.document.addEventListener(Event.ENTER_FRAME,this.sendIncompleteProgress);
         }
         return true;
      }
      
      protected function nextChunk() : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         Logger.info("Starting Chunk " + (this.chunkLoaded + 1) + " of " + this.chunkCount);
         this.chunkReset();
         var _loc1_:* = getSetting("threadCount");
         var _loc2_:URLVariables = new URLVariables();
         this.generateSample(_loc2_,Math.round(sampleSize / (_loc1_ * this.chunkCount)));
         var _loc3_:* = 1;
         while(_loc3_ <= _loc1_)
         {
            this.startThread(_loc2_,_loc3_);
            _loc3_++;
         }
         this.threadStartTime = Tools.getTime();
         if(this.chunkLoaded > 0 && settingDefined("testLength"))
         {
            _loc4_ = Tools.getTime();
            _loc5_ = (_loc4_ - startTime) / 1000;
            _loc6_ = getSetting("testLength");
            Logger.info("Estimated Length: " + _loc6_ + "  length so far" + _loc5_);
            if(_loc5_ > _loc6_)
            {
               if(this.chunkCount - this.chunkLoaded >= 2)
               {
                  _loc7_ = this.chunkCount;
                  this.chunkCount = this.chunkLoaded + 1;
                  sampleSize = Math.round(this.chunkCount / _loc7_ * sampleSize);
                  Logger.warning("Changing chunk count to " + this.chunkCount);
                  Logger.warning("Changing samplesize to " + sampleSize);
               }
            }
         }
      }
      
      protected function startThread(param1:URLVariables, param2:*) : *
      {
         var _loc6_:URLRequest = null;
         var _loc7_:URLLoader = null;
         var _loc3_:* = getSetting("threadCount");
         var _loc4_:* = Math.round(sampleSize / (_loc3_ * this.chunkCount));
         var _loc5_:* = getSetting("threadPerURL");
         if(param2 > 3 * _loc5_)
         {
            _loc6_ = new URLRequest(getSetting("fullUrl4") + "?x=" + Math.random());
         }
         else if(param2 > 2 * _loc5_)
         {
            _loc6_ = new URLRequest(getSetting("fullUrl3") + "?x=" + Math.random());
         }
         else if(param2 > _loc5_)
         {
            _loc6_ = new URLRequest(getSetting("fullUrl2") + "?x=" + Math.random());
         }
         else
         {
            _loc6_ = new URLRequest(getSetting("fullUrl") + "?x=" + Math.random());
         }
         _loc6_.method = URLRequestMethod.POST;
         _loc6_.data = param1;
         _loc7_ = new URLLoader();
         _loc7_.dataFormat = URLLoaderDataFormat.TEXT;
         _loc7_.addEventListener(Event.COMPLETE,Callback.create(this.onLoad,{
            "success":true,
            "startTime":Tools.getTime(),
            "thread":param2,
            "expectedSize":_loc4_
         }));
         _loc7_.addEventListener(IOErrorEvent.IO_ERROR,Callback.create(this.onLoad,{
            "success":false,
            "startTime":Tools.getTime(),
            "thread":param2,
            "expectedSize":_loc4_
         }));
         _loc7_.load(_loc6_);
         this.loaders.push(_loc7_);
      }
      
      protected function sendIncompleteProgress(param1:Event) : *
      {
         this.sendProgress(false);
         testForTimeOut();
      }
      
      protected function sendProgress(param1:*) : *
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         if(!param1)
         {
            _loc2_ = {
               "current":this.getEstimatedSpeed(),
               "best":0,
               "progress":this.getProgress(),
               "estimatedTime":this.getEstimatedTimeLeft(),
               "done":false
            };
            if(_loc2_.progress < 1)
            {
               update();
            }
            dispatchProgress(_loc2_);
         }
         else
         {
            _loc3_ = this.getFinalSpeed();
            _loc4_ = {
               "current":_loc3_,
               "best":0,
               "progress":1,
               "estimatedTime":0,
               "done":true
            };
            dispatchProgress(_loc4_);
            _loc5_ = {
               "final":_loc3_,
               "time":Tools.getTime() - startTime,
               "startTime":startTime,
               "extraSpeeds":this.results,
               "bytes":sampleSize
            };
            dispatchComplete(_loc5_);
         }
      }
      
      override public function getProgress() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         if(this.chunkLoaded == 0)
         {
            _loc3_ = getSetting("estimatedUploadSpeed");
            _loc4_ = startTime + sampleSize / _loc3_ * 1000;
            _loc2_ = Tools.getTime();
            _loc1_ = (_loc2_ - startTime) / (_loc4_ - startTime);
         }
         else
         {
            _loc5_ = this.chunkLoaded / this.chunkCount;
            _loc2_ = Tools.getTime();
            _loc6_ = (_loc2_ - startTime) / (this.chunkEndTime - startTime);
            _loc7_ = _loc5_ * _loc6_;
            _loc8_ = this.unadjustedProgress * _loc6_;
            if(_loc5_ == 1)
            {
               _loc1_ = 1;
            }
            else
            {
               _loc9_ = _loc5_ - this.unadjustedProgress;
               _loc10_ = _loc9_ / (this.chunkCount - this.chunkLoaded);
               _loc11_ = 1 / this.chunkCount;
               _loc12_ = this.unadjustedProgress;
               _loc13_ = _loc5_;
               _loc14_ = this.unadjustedProgress + _loc11_ + _loc10_;
               _loc15_ = _loc5_ + _loc11_;
               _loc16_ = (_loc7_ - _loc5_) / (1 / this.chunkCount);
               _loc1_ = _loc16_ * _loc14_ + (1 - _loc16_) * _loc12_;
            }
         }
         if(_loc1_ > 1)
         {
            _loc1_ = 1;
         }
         return _loc1_;
      }
      
      protected function getFinalSpeed() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.chunkLoaded == 0)
         {
            _loc1_ = getSetting("estimatedUploadSpeed");
         }
         else
         {
            _loc2_ = 0;
            _loc3_ = Math.ceil(this.results.length / 2);
            this.results.sort(Array.DESCENDING | Array.NUMERIC);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc2_ = _loc2_ + this.results[_loc4_];
               _loc4_++;
            }
            _loc1_ = Math.round(_loc2_ / _loc3_);
         }
         return _loc1_;
      }
      
      protected function getEstimatedSpeed() : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc1_:* = this.getFinalSpeed();
         var _loc2_:* = this.getProgress();
         var _loc3_:* = Math.round(_loc1_ * 0.02);
         if(_loc2_ < 1 || this.chunkLoaded > 0)
         {
            _loc4_ = Math.round((-Math.pow(_loc2_ - 1,4) + 1) * _loc1_) + Math.round((Math.random() - 1 / 2) * _loc3_);
         }
         else
         {
            _loc5_ = Tools.getTime();
            _loc6_ = startTime + sampleSize / _loc1_ * 1000;
            _loc7_ = (_loc5_ - startTime) / (_loc6_ - startTime);
            _loc4_ = Math.round(_loc1_ / _loc7_) + Math.round((Math.random() - 1 / 2) * _loc3_);
         }
         return _loc4_;
      }
      
      override public function getEstimatedTimeLeft() : Number
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this.chunkLoaded == 0)
         {
            _loc4_ = getSetting("estimatedUploadSpeed");
            _loc2_ = startTime + sampleSize / _loc4_ * 1000;
            _loc3_ = Tools.getTime();
            _loc1_ = _loc2_ - _loc3_;
         }
         else
         {
            _loc5_ = this.chunkLoaded / this.chunkCount;
            _loc3_ = Tools.getTime();
            _loc6_ = (_loc3_ - startTime) / (this.chunkEndTime - startTime);
            _loc7_ = _loc5_ * _loc6_;
            _loc2_ = startTime + (_loc3_ - startTime) / _loc7_;
            _loc1_ = _loc2_ - _loc3_;
         }
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         return Math.round(_loc1_);
      }
      
      public function onLoad(param1:Event, param2:Object) : *
      {
         var time:* = undefined;
         var size:* = undefined;
         var event:Event = param1;
         var obj:Object = param2;
         var success:* = obj.success;
         var threadCount:* = getSetting("threadCount");
         var loader:URLLoader = URLLoader(event.target);
         var result:URLVariables = new URLVariables();
         var uploadString:String = StringUtil.trim(loader.data);
         if(StringUtil.beginsWith(uploadString,"&"))
         {
            uploadString = uploadString.substr(1);
         }
         if(StringUtil.endsWith(uploadString,"&"))
         {
            uploadString = uploadString.substr(0,uploadString.length - 1);
         }
         uploadString = StringUtil.trim(uploadString);
         try
         {
            result.decode(uploadString);
         }
         catch(e:Error)
         {
            success = false;
         }
         this.clearLoader(loader);
         if(!success || isNaN(result.size))
         {
            this.clearEnterFrame();
            Logger.error("Error Opening URL!");
            obj = {"code":"upload01"};
            dispatchFatal(obj);
            return;
         }
         this.threadsLoaded++;
         time = (Tools.getTime() - this.threadStartTime) / 1000;
         if(success)
         {
            size = Number(result.size);
            if(size == -1)
            {
               size = Number(obj.expectedSize);
            }
         }
         else
         {
            size = Math.round(sampleSize / (threadCount * this.chunkCount));
         }
         Logger.debug("Thread" + obj.thread + " finished - size=" + size + " time=" + time + " starttime=" + obj.startTime + " stime=" + (Tools.getTime() - obj.startTime) / 1000);
         this.threadResults.push(size / time);
         if(this.threadsLoaded == threadCount)
         {
            this.unadjustedProgress = this.getProgress();
            this.chunkEndTime = Tools.getTime();
            this.chunkLoaded++;
            this.results.push(this.chunkSpeed());
            if(this.chunkLoaded >= this.chunkCount)
            {
               this.clearEnterFrame();
               Logger.info(this.results.sort(Array.DESCENDING | Array.NUMERIC));
               this.sendProgress(true);
            }
            else
            {
               TweenLite.delayedCall(getSetting("waitTime") / 1000,this.nextChunk);
            }
         }
         update(1);
      }
      
      protected function clearEnterFrame() : *
      {
         DocumentClass.document.removeEventListener(Event.ENTER_FRAME,this.sendIncompleteProgress);
      }
      
      protected function chunkSpeed() : *
      {
         var _loc1_:* = 0;
         var _loc2_:* = Number.MAX_VALUE;
         var _loc3_:* = 0;
         while(_loc3_ < this.threadResults.length)
         {
            _loc2_ = Math.min(this.threadResults[_loc3_],_loc2_);
            _loc3_++;
         }
         return Math.round(_loc2_ * this.threadResults.length);
      }
      
      protected function generateSample(param1:URLVariables, param2:*) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc3_:* = Math.max(1,Math.ceil(param2 / 65536));
         if(_loc3_ > 1)
         {
            _loc4_ = Math.round(param2 / (256 * _loc3_));
            _loc5_ = 8;
         }
         else
         {
            _loc5_ = Math.ceil(Math.max(1,Math.log(param2) / Math.log(2) - 8));
            _loc4_ = Math.round(param2 / Math.pow(2,_loc5_));
         }
         _loc6_ = this.generateString(_loc4_,_loc5_);
         _loc7_ = 0;
         while(_loc7_ < _loc3_)
         {
            param1["content" + _loc7_] = _loc6_;
            _loc7_++;
         }
      }
      
      protected function generateString(param1:*, param2:*) : *
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:* = "";
         _loc4_ = 1;
         while(_loc4_ <= param1)
         {
            _loc3_ = _loc3_ + String.fromCharCode(Math.floor(Math.random() * 26) + 65);
            _loc4_++;
         }
         _loc5_ = 1;
         while(_loc5_ <= param2)
         {
            _loc3_ = _loc3_.concat(_loc3_);
            _loc5_++;
         }
         return _loc3_;
      }
   }
}
