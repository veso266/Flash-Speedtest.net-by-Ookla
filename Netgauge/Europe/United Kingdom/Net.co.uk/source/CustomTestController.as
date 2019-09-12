package
{
   import com.adobe.utils.ArrayUtil;
   import flash.events.Event;
   
   class CustomTestController extends SpeedTestController
   {
       
      
      protected var progressBarTests:Array;
      
      function CustomTestController()
      {
         super();
         trace("CustomTestController");
      }
      
      protected function getTestList() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:* = new Array("throttling");
         this.progressBarTests = new Array();
         if(license.isActiveTag("speedtest-only"))
         {
            _loc2_ = new Array("latency","speed","download","upload");
         }
         else
         {
            _loc2_ = new Array("latency","speed","download","upload","firewall","packetloss");
         }
         _loc3_ = configuration.getSetting("netgauge","activetests");
         for each(_loc4_ in _loc2_)
         {
            if(_loc3_.indexOf(_loc4_) != -1)
            {
               switch(_loc4_)
               {
                  case "speed":
                     _loc1_.push("download");
                     this.progressBarTests.push("download");
                     _loc1_.push("upload");
                     this.progressBarTests.push("upload");
                     continue;
                  default:
                     _loc1_.push(_loc4_);
                     this.progressBarTests.push(_loc4_);
                     continue;
               }
            }
            else
            {
               continue;
            }
         }
         return ArrayUtil.createUniqueCopy(_loc1_);
      }
      
      override protected function testUnlocked() : *
      {
         super.testUnlocked();
         NetGaugeUI.ng.testUnlocked(configuration);
         testList = this.getTestList();
         Logger.info("Active Test: " + testList.join(", "));
         ProgressBar.createProgress(this.progressBarTests);
         if(TestConfigurator.getBoolean(configuration.getSetting("java","skiponfailure"),true))
         {
            dontDieOnErrorTestList.push("firewall");
            dontDieOnErrorTestList.push("packetloss");
         }
      }
      
      override public function licenseExpiringSoon(param1:*) : *
      {
         super.licenseExpiringSoon(param1);
         if(TestConfigurator.getBoolean(configuration.getSetting("errors","showexpirewarning"),true))
         {
            NetGaugeUI.ng.licenseExpiringSoon(param1,license.isTrial);
         }
      }
      
      override protected function trialActive() : *
      {
         super.trialActive();
         if(expiringSoonDays >= 0 && TestConfigurator.getBoolean(configuration.getSetting("errors","showexpirewarning"),true))
         {
            return;
         }
         NetGaugeUI.ng.trialMode();
      }
      
      override public function handleTestEnd(param1:*) : *
      {
         super.handleTestEnd(param1);
         var _loc2_:* = TestConfigurator.getBoolean(configuration.getSetting("extras","apireporting"),true);
         _loc2_ = TestConfigurator.getBoolean(configuration.getSetting("reporting","apireporting"),_loc2_);
         if(!_loc2_)
         {
            BarrierManager.barrierTouch("postAPIHit",2);
         }
      }
      
      override public function resultsSaved(param1:Event, param2:Object) : *
      {
         super.resultsSaved(param1,param2);
         if(!configuration.hitDefaultAPI() || param2._default == true)
         {
            BarrierManager.barrierTouch("postAPIHit",2);
         }
      }
   }
}
