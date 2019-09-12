package
{
   class InitialDownloadTest extends Test
   {
       
      
      private var downloadTest:DownloadTest = null;
      
      private var bytes = 0;
      
      private var timeElapsed:Number = 0;
      
      function InitialDownloadTest()
      {
         super();
         sampleSize = 1000000;
         testName = "http-download";
         autoTimeOut = false;
         this.setupDownloadTest();
      }
      
      protected function setupDownloadTest() : *
      {
         this.downloadTest = new DownloadTest();
         this.downloadTest.addEventListener(TestEvent.PROGRESS,this.handleTestProgressEvent);
         this.downloadTest.addEventListener(TestEvent.COMPLETE,this.handleTestCompleteEvent);
         this.downloadTest.addEventListener(TestEvent.FATAL,this.handleTestFatalEvent);
      }
      
      protected function unsetupDownloadTest() : *
      {
         if(this.downloadTest != null)
         {
            this.downloadTest.cleanup();
            this.downloadTest.removeEventListener(TestEvent.PROGRESS,this.handleTestProgressEvent);
            this.downloadTest.removeEventListener(TestEvent.COMPLETE,this.handleTestCompleteEvent);
            this.downloadTest.removeEventListener(TestEvent.FATAL,this.handleTestFatalEvent);
         }
         this.downloadTest = null;
      }
      
      protected function handleTestProgressEvent(param1:TestEvent) : *
      {
         var _loc2_:* = param1.data;
         if(this.bytes != _loc2_.bytes)
         {
            update(_loc2_.bytes);
            this.bytes = _loc2_.bytes;
         }
         dispatchEvent(param1);
      }
      
      protected function handleTestCompleteEvent(param1:TestEvent) : *
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         this.unsetupDownloadTest();
         var _loc2_:* = param1.data;
         var _loc3_:* = getSetting("initialtestlength") * 1000;
         var _loc4_:* = Math.max(_loc2_.time,200);
         this.timeElapsed = this.timeElapsed + _loc4_;
         Logger.info("final: " + _loc2_.final + " length: " + _loc2_.time + " total:" + this.timeElapsed);
         if(this.timeElapsed > _loc3_ / 2)
         {
            if(this.timeElapsed > _loc4_)
            {
               param1.data.time = this.timeElapsed;
            }
            dispatchEvent(param1);
         }
         else
         {
            _loc5_ = _loc2_.final;
            _loc6_ = _loc3_ - this.timeElapsed;
            _loc7_ = Math.round(_loc5_ * (_loc6_ / 1000));
            Logger.info("Setting initialtest to: " + _loc7_ + " desired length: " + _loc6_);
            _loc8_ = SpeedTestController.getController();
            _loc9_ = _loc8_.getResults();
            _loc10_ = _loc8_.getConfiguration();
            _loc10_.addSetting("http-download.initialtest",_loc7_);
            _loc11_ = _loc8_.getTestConfigurator();
            _loc12_ = _loc11_.configureHTTPInitialDownloadTest(_loc10_,_loc9_);
            this.setupDownloadTest();
            this.downloadTest.configure(_loc12_);
            this.downloadTest.setSampleSize(_loc12_.sampleSize);
            this.downloadTest.start();
         }
      }
      
      protected function handleTestFatalEvent(param1:TestEvent) : *
      {
         this.unsetupDownloadTest();
         dispatchEvent(param1);
      }
      
      override public function start() : Boolean
      {
         if(this.downloadTest)
         {
            this.setupDownloadTest();
            this.downloadTest.configure(settings);
            this.downloadTest.setSampleSize(settings.sampleSize);
            this.downloadTest.start();
         }
         return true;
      }
      
      override public function cancel() : Boolean
      {
         super.cancel();
         if(this.downloadTest)
         {
            this.downloadTest.cancel();
            this.unsetupDownloadTest();
         }
         return true;
      }
      
      override public function cleanup() : Boolean
      {
         if(this.downloadTest)
         {
            this.unsetupDownloadTest();
         }
         return true;
      }
   }
}
