package
{
   import flash.events.KeyboardEvent;
   
   class HotKey
   {
      
      private static var currentHotKey:HotKey;
       
      
      private var startKey:String = "s";
      
      private var activationState:Number = 0;
      
      private var activated:Number = 1;
      
      private var callback:Function;
      
      private var enabled:Boolean = true;
      
      function HotKey(param1:Function, param2:String)
      {
         super();
         this.callback = param1;
         this.startKey = param2;
         this.activated = param2.length;
         currentHotKey = this;
         this.enable();
      }
      
      public function enable() : *
      {
         this.enabled = true;
         DocumentClass.document.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      public function disable() : *
      {
         DocumentClass.document.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.enabled = false;
      }
      
      public function onKeyDown(param1:KeyboardEvent) : *
      {
         var _loc2_:uint = param1.charCode;
         if(this.activationState < this.activated && this.enabled)
         {
            if(_loc2_ == this.startKey.charCodeAt(this.activationState))
            {
               this.activationState++;
            }
            if(this.activationState == this.activated)
            {
               this.doIt();
            }
         }
      }
      
      public function doIt() : *
      {
         Logger.info("Showing debug window");
         this.disable();
         this.callback.call();
      }
   }
}
