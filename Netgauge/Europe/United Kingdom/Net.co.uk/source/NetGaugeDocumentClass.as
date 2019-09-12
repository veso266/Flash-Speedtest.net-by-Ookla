package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class NetGaugeDocumentClass extends DocumentClass
   {
       
      
      public var progress:MovieClip;
      
      public var masthead:MovieClip;
      
      public var dash:MovieClip;
      
      public var fade:MovieClip;
      
      public var __rslLoaders:Object;
      
      public function NetGaugeDocumentClass()
      {
         addFrameScript(0,this.frame1,4,this.frame5);
         super();
      }
      
      override protected function _onComplete(param1:Event) : void
      {
         super._onComplete(param1);
         trace("test loaded");
         _netgauge = new ClassicNetGaugeUI();
         _controller = new CustomSpeedTestController();
         _config = new CustomConfiguration(controller);
         _view = controller.getView();
         controller.setConfiguration(config);
         config.autostart();
         LanguageEnglish.regularFont = "Helvetica Neue LT Std 55 Roman";
         LanguageEnglish.boldFont = "HelveticaNeueLT Std";
         LanguageEnglish.addBoldTag = true;
         var _loc2_:* = new LanguageEnglish();
         Translation.load(_loc2_);
         Translation.autoSelect();
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame5() : *
      {
         stop();
      }
   }
}
