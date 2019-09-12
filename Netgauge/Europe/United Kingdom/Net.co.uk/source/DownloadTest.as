package
{
   class DownloadTest extends Test
   {
       
      
      private var ml:MultiLoader;
      
      protected var testLength:Number = 10;
      
      protected var groupBytesTotal = 0;
      
      protected var groupBytesLoaded = 0;
      
      protected var waitTime:Number = 0;
      
      protected var speeds:Array;
      
      protected var samples:Array;
      
      protected var maxAccuracyScore = 25;
      
      protected var weightedSuperSpeed = false;
      
      protected var weightedSuperSpeedScore = 5;
      
      protected var samplesToSkip = 2;
      
      protected var samplesToKeep = 0.6666666666666666;
      
      protected var images;
      
      function DownloadTest()
      {
         this.images = new Array({
            "size":129145,
            "name":"random250x250.jpg"
         },{
            "size":245388,
            "name":"random350x350.jpg"
         },{
            "size":505544,
            "name":"random500x500.jpg"
         },{
            "size":1118012,
            "name":"random750x750.jpg"
         },{
            "size":1986284,
            "name":"random1000x1000.jpg"
         },{
            "size":4468241,
            "name":"random1500x1500.jpg"
         },{
            "size":7907740,
            "name":"random2000x2000.jpg"
         },{
            "size":12407926,
            "name":"random2500x2500.jpg"
         },{
            "size":17816816,
            "name":"random3000x3000.jpg"
         },{
            "size":24262167,
            "name":"random3500x3500.jpg"
         },{
            "size":31625365,
            "name":"random4000x4000.jpg"
         },{
            "size":49454450,
            "name":"random5000x5000.jpg"
         },{
            "size":71154024,
            "name":"random6000x6000.jpg"
         },{
            "size":96912152,
            "name":"random7000x7000.jpg"
         });
         super();
         sampleSize = 1000000;
         testName = "http-download";
         autoTimeOut = false;
      }
      
      override protected function setDefaults() : void
      {
         defaultSettings.maxImageSize = 40000000;
         defaultSettings.minImageSize = 240000;
         defaultSettings.threadCount = 2;
         defaultSettings.threadPerURL = 2;
      }
      
      override public function init() : void
      {
         super.init();
      }
      
      override public function cancel() : Boolean
      {
         super.cancel();
         this.cleanup();
         this.groupBytesTotal = 0;
         if(this.ml != null)
         {
            this.ml.clearClips();
            this.ml.clearEnterFrame();
         }
         this.speeds = new Array();
         this.samples = new Array();
         return true;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.groupBytesTotal = 0;
         if(this.ml != null)
         {
            this.ml.clearEnterFrame();
         }
         this.ml = new MultiLoader();
         this.speeds = new Array();
         this.samples = new Array();
      }
      
      override public function start() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(!settingDefined("fullUrl"))
         {
            return false;
         }
         if(!settingDefined("threadCount"))
         {
            return false;
         }
         if(isNaN(sampleSize))
         {
            return false;
         }
         this.reset();
         super.start();
         if(settingDefined("testLength"))
         {
            this.testLength = getSetting("testLength");
         }
         _loc1_ = getSetting("threadCount");
         _loc2_ = this.getImage(sampleSize / _loc1_);
         this.downloadImage(_loc2_,_loc1_);
         return true;
      }
      
      override public function cleanup() : Boolean
      {
         super.cleanup();
         this.ml.removeEventListener(MultiLoaderEvent.GROUP_PROGRESS,this.onGroupProgress);
         this.ml.removeEventListener(MultiLoaderEvent.LOAD_ERROR,this.loadError);
         return true;
      }
      
      protected function downloadImage(param1:*, param2:*) : *
      {
         var _loc5_:* = undefined;
         this.ml.addEventListener(MultiLoaderEvent.GROUP_PROGRESS,this.onGroupProgress);
         this.ml.addEventListener(MultiLoaderEvent.LOAD_ERROR,this.loadError);
         this.groupBytesTotal = param1.size * param2;
         this.groupBytesLoaded = 0;
         this.waitTime = 0;
         var _loc3_:* = getSetting("threadPerURL");
         var _loc4_:* = 1;
         while(_loc4_ <= param2)
         {
            if(_loc4_ > 3 * _loc3_)
            {
               _loc5_ = Tools.getBasePath(getSetting("fullUrl4")) + param1.name + "?x=" + Tools.getTime() + "&y=" + _loc4_;
            }
            else if(_loc4_ > 2 * _loc3_)
            {
               _loc5_ = Tools.getBasePath(getSetting("fullUrl3")) + param1.name + "?x=" + Tools.getTime() + "&y=" + _loc4_;
            }
            else if(_loc4_ > _loc3_)
            {
               _loc5_ = Tools.getBasePath(getSetting("fullUrl2")) + param1.name + "?x=" + Tools.getTime() + "&y=" + _loc4_;
            }
            else
            {
               _loc5_ = Tools.getBasePath(getSetting("fullUrl")) + param1.name + "?x=" + Tools.getTime() + "&y=" + _loc4_;
            }
            Logger.info(_loc5_);
            this.ml.addClip(_loc5_,_loc4_);
            _loc4_++;
         }
         this.ml.loadClips();
      }
      
      override protected function update(param1:int = 0) : void
      {
         var _loc2_:* = Tools.getTime();
         if(_loc2_ - lastUpdate > 100)
         {
            this.waitTime = this.waitTime + (_loc2_ - lastUpdate - 100);
            if(this.groupBytesLoaded == 0)
            {
               this.waitTime = this.waitTime + (_loc2_ - lastUpdate - 100);
            }
         }
         super.update(param1);
      }
      
      protected function onGroupProgress(param1:MultiLoaderEvent) : *
      {
         var _loc2_:* = param1.data;
         if(_loc2_.groupBytesLoaded != this.groupBytesLoaded)
         {
            this.groupBytesLoaded = _loc2_.groupBytesLoaded;
            this.update(this.groupBytesLoaded);
         }
         this.sendProgress(param1);
         testForTimeOut();
      }
      
      protected function loadError(param1:MultiLoaderEvent) : *
      {
         Logger.error("Error Opening URL!");
         var _loc2_:* = {"code":"download01"};
         dispatchFatal(_loc2_);
         this.ml.clearEnterFrame();
      }
      
      protected function sendProgress(param1:MultiLoaderEvent) : *
      {
         var _loc5_:Object = null;
         var _loc6_:* = undefined;
         var _loc7_:Object = null;
         var _loc8_:* = undefined;
         var _loc9_:Object = null;
         var _loc2_:* = param1.data;
         var _loc3_:* = _loc2_.done;
         var _loc4_:* = _loc2_.groupBytesLoaded / this.groupBytesTotal;
         if(!_loc3_)
         {
            _loc5_ = {
               "current":this.getSpeed(_loc2_),
               "best":0,
               "progress":_loc4_,
               "time":Tools.getTime() - startTime,
               "estimatedTime":this.getEstimatedTimeLeft(),
               "bytes":_loc2_.groupBytesLoaded,
               "done":false
            };
            dispatchProgress(_loc5_);
         }
         else
         {
            _loc6_ = this.getFinalSpeed(_loc2_);
            Logger.debug("OLD SUPER SPEED: " + this.getSuperSpeed() + "  superspeed2: " + this.getSuperSpeed2() + "   firstspeed: " + this.getFirstSpeed(_loc2_) + "   avgspeed: " + this.getAverageSpeed(_loc2_));
            _loc7_ = {
               "current":_loc6_,
               "best":0,
               "progress":1,
               "estimatedTime":0,
               "time":Tools.getTime() - startTime,
               "bytes":_loc2_.groupBytesLoaded,
               "done":true
            };
            dispatchProgress(_loc7_);
            _loc8_ = this.getAccuracyScore(_loc2_);
            _loc9_ = {
               "final":_loc6_,
               "time":Tools.getTime() - startTime,
               "startTime":startTime,
               "extraSpeeds":this.samples,
               "bytes":this.groupBytesTotal,
               "rawSamples":this.speeds,
               "accuracyScore":_loc8_
            };
            dispatchComplete(_loc9_);
         }
      }
      
      protected function getSpeed(param1:*) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:Object = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = Tools.getTime();
         var _loc4_:* = param1.groupBytesLoaded / this.groupBytesTotal;
         if(this.speeds.length == 0)
         {
            _loc5_ = {"progress":-Number.MAX_VALUE};
         }
         else
         {
            _loc5_ = this.speeds[this.speeds.length - 1];
         }
         if(Math.ceil(_loc4_ * 20) >= this.speeds.length && _loc4_ > _loc5_.progress + 0.04 || param1.done)
         {
            Logger.info("DL:  " + _loc4_ + "  t: " + _loc3_ + "  b: " + param1.groupBytesLoaded);
            _loc9_ = {
               "progress":_loc4_,
               "time":_loc3_,
               "bytes":param1.groupBytesLoaded
            };
            if(_loc4_ > 0 && this.speeds.length > 0)
            {
               _loc10_ = Math.round(1000 * (param1.groupBytesLoaded - _loc5_.bytes) / (_loc3_ - _loc5_.time));
               _loc11_ = Math.round((_loc4_ - _loc5_.progress) * 1000) / 1000;
               this.samples.push(_loc10_ + _loc11_);
               this.samples.sort(Array.DESCENDING | Array.NUMERIC);
               Logger.debug(this.samples);
            }
            this.speeds.push(_loc9_);
         }
         _loc6_ = this.getSuperSpeed();
         _loc7_ = this.getSuperSpeed2();
         _loc8_ = this.getFirstSpeed(param1);
         if(_loc7_ > 0 && _loc7_ > _loc8_)
         {
            _loc2_ = _loc4_ * _loc7_ + (1 - _loc4_) * _loc8_;
         }
         else
         {
            _loc2_ = _loc8_;
         }
         return Math.round(_loc2_);
      }
      
      protected function getAccuracyScore(param1:*) : *
      {
         var _loc2_:* = this.getAverageSpeed(param1);
         var _loc3_:* = this.getSuperSpeed2();
         var _loc4_:* = this.getFirstSpeed(param1);
         var _loc5_:* = {
            "averageSpeed":_loc2_,
            "superSpeed":_loc3_,
            "firstSpeed":_loc4_
         };
         var _loc6_:* = this.calculateAccuracyScore(_loc5_);
         return _loc6_;
      }
      
      protected function getFinalSpeed(param1:*) : *
      {
         var _loc2_:* = 0;
         var _loc3_:* = this.getAverageSpeed(param1);
         var _loc4_:* = this.getSuperSpeed2();
         var _loc5_:* = this.getFirstSpeed(param1);
         var _loc6_:* = {
            "averageSpeed":_loc3_,
            "superSpeed":_loc4_,
            "firstSpeed":_loc5_
         };
         var _loc7_:* = this.calculateAccuracyScore(_loc6_);
         if(_loc7_ > this.maxAccuracyScore)
         {
            return _loc3_;
         }
         if(_loc4_ > 0 && _loc4_ > _loc5_)
         {
            if(this.weightedSuperSpeed && _loc7_ > this.weightedSuperSpeedScore)
            {
               _loc2_ = _loc3_ * ((_loc7_ - this.weightedSuperSpeedScore) / (this.maxAccuracyScore - this.weightedSuperSpeedScore)) + _loc4_ * (1 - (_loc7_ - this.weightedSuperSpeedScore) / (this.maxAccuracyScore - this.weightedSuperSpeedScore));
            }
            else
            {
               _loc2_ = _loc4_;
            }
         }
         else
         {
            _loc2_ = _loc5_;
         }
         return Math.round(_loc2_);
      }
      
      protected function calculateAccuracyScore(param1:Object) : *
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         if(param1.firstSpeed > param1.averageSpeed)
         {
            _loc3_ = 10 * (param1.firstSpeed / param1.averageSpeed - 1);
         }
         if(param1.superSpeed > param1.averageSpeed)
         {
            _loc4_ = 10 * (param1.superSpeed / param1.averageSpeed - 1);
         }
         _loc5_ = 3 * (this.waitTime / 1000);
         _loc2_ = _loc3_ + _loc4_ + _loc5_;
         Logger.info("Score: " + _loc3_ + " " + _loc4_ + " " + _loc5_ + " = " + _loc2_);
         return _loc2_;
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
         var _loc3_:* = param1.groupBytesLoaded / this.groupBytesTotal;
         var _loc4_:* = 1000 * param1.groupBytesLoaded / (_loc2_ - startTime + 1);
         if(this.speeds.length > 4)
         {
            _loc5_ = this.speeds[2];
            _loc6_ = 1000 * (param1.groupBytesLoaded - _loc5_.bytes) / (_loc2_ - _loc5_.time);
            if(_loc3_ > 0.5)
            {
               return _loc6_;
            }
            return (_loc4_ * (0.5 - _loc3_) + _loc6_ * _loc3_) * 2;
         }
         return _loc4_;
      }
      
      protected function getAverageSpeed(param1:*) : *
      {
         var _loc2_:* = Tools.getTime();
         var _loc3_:* = param1.groupBytesLoaded / this.groupBytesTotal;
         var _loc4_:* = 1000 * param1.groupBytesLoaded / (_loc2_ - startTime + 1);
         return _loc4_;
      }
      
      protected function getSuperSpeed() : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this.speeds.length <= 4)
         {
            return 0;
         }
         var _loc1_:* = 0;
         var _loc2_:* = this.speeds.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc3_ + 1;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = this.speeds[_loc3_];
               _loc6_ = this.speeds[_loc4_];
               if(_loc6_.progress - _loc5_.progress >= 0.5)
               {
                  _loc7_ = Math.round(1000 * (_loc6_.bytes - _loc5_.bytes) / (_loc6_.time - _loc5_.time));
                  if(_loc7_ > _loc1_)
                  {
                     _loc1_ = _loc7_;
                  }
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      override public function getEstimatedTimeLeft() : Number
      {
         var _loc1_:* = Math.min((this.groupBytesLoaded + 1) / this.groupBytesTotal,1);
         var _loc2_:* = 1000 * this.testLength * (1 - _loc1_);
         var _loc3_:* = Tools.getTime() - startTime + 1;
         var _loc4_:* = _loc3_ / _loc1_ * (1 - _loc1_);
         var _loc5_:* = _loc1_ * _loc4_ + (1 - _loc1_) * _loc2_;
         return Math.round(_loc5_);
      }
      
      protected function getImage(param1:Number) : Object
      {
         var _loc5_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:* = getSetting("maxImageSize");
         var _loc3_:* = getSetting("minImageSize");
         var _loc4_:* = Number.MAX_VALUE;
         var _loc6_:* = 0;
         while(_loc6_ < this.images.length)
         {
            if(this.images[_loc6_].size <= _loc2_)
            {
               if(this.images[_loc6_].size >= _loc3_)
               {
                  _loc7_ = Math.abs(this.images[_loc6_].size - param1);
                  if(_loc7_ < _loc4_)
                  {
                     _loc4_ = _loc7_;
                     _loc5_ = this.images[_loc6_];
                  }
               }
            }
            _loc6_++;
         }
         return _loc5_;
      }
   }
}
