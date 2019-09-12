package
{
   import fl.transitions.easing.Regular;
   
   class SpeedTestView
   {
      
      protected static var view;
       
      
      protected var controller:CustomSpeedTestController;
      
      protected var configuration:CustomConfiguration;
      
      function SpeedTestView(param1:CustomSpeedTestController)
      {
         super();
         SpeedTestView.view = this;
         this.controller = param1;
      }
      
      static function getView() : *
      {
         return view;
      }
      
      static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:* = 0.3;
         if(param1 > _loc5_)
         {
            return Regular.easeOut(param1 - _loc5_,param2,param3,param4 - _loc5_);
         }
         return param2;
      }
      
      public function setConfiguration(param1:CustomConfiguration) : *
      {
         this.configuration = param1;
      }
      
      public function handleTestProgress(param1:String, param2:String, param3:Object) : *
      {
         if(param2 == "http-download" || param2 == "http-upload" || param2 == "rtmpdownload" || param2 == "socket-upload" || param2 == "socket-download")
         {
            this.handleSpeedUpdate(param1,param3);
         }
         else if(param1 == "latency")
         {
            this.handleLatencyUpdate(param1,param3);
         }
         else if(param1 == "throttling")
         {
            this.handleThrottingUpdate(param1,param3);
         }
         else
         {
            this.handleGenericProgress(param1,param2,param3);
         }
      }
      
      protected function handleLatencyUpdate(param1:String, param2:Object) : *
      {
      }
      
      protected function handleSpeedUpdate(param1:String, param2:Object) : *
      {
      }
      
      protected function handleThrottingUpdate(param1:String, param2:Object) : *
      {
      }
      
      protected function handleGenericProgress(param1:String, param2:String, param3:Object) : *
      {
      }
      
      public function handleFatalError(param1:String, param2:String, param3:Object) : *
      {
         Logger.warning("REPLACE ME: HandleFatal - " + param1);
      }
      
      public function handleSubTestStart(param1:String, param2:String) : *
      {
         Logger.warning("REPLACE ME: Handle SubTest Start - " + param1);
      }
      
      public function handleTestStart(param1:String) : *
      {
         Logger.warning("REPLACE ME: Handle Test Start - " + param1);
      }
      
      public function handleTestEnd(param1:String, param2:Object) : *
      {
         Logger.warning("REPLACE ME: Handle Test End - " + param1);
      }
      
      public function handleSubTestEnd(param1:String, param2:String, param3:Object) : *
      {
         Logger.warning("REPLACE ME: Handle SubTest End - " + param1);
      }
      
      public function startTest(param1:*) : *
      {
         this.controller.start(param1);
      }
      
      public function testUnlocked() : *
      {
         DocumentClass.document.play();
      }
   }
}
