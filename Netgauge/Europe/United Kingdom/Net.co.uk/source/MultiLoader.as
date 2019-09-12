package
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   
   class MultiLoader extends EventDispatcher
   {
       
      
      protected var _clips:Array = null;
      
      protected var clipsLoaded:Number = 0;
      
      protected var connectionsOpen:Number = 0;
      
      function MultiLoader()
      {
         super();
         this._clips = new Array();
      }
      
      public function addClip(param1:String, param2:Number) : void
      {
         var _loc3_:Object = new Object();
         _loc3_.url = param1;
         _loc3_.id = param2;
         _loc3_.loadstart = false;
         this._clips.push(_loc3_);
      }
      
      public function clearClips() : void
      {
         var _loc2_:Loader = null;
         if(this._clips == null)
         {
            return;
         }
         var _loc1_:* = 0;
         while(_loc1_ < this._clips.length)
         {
            _loc2_ = this._clips[_loc1_].loader as Loader;
            _loc2_.close();
            _loc2_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            _loc2_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            _loc2_.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadSecurityError);
            _loc2_.contentLoaderInfo.removeEventListener(Event.OPEN,this.onLoadStart);
            _loc1_++;
         }
      }
      
      public function loadClips() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Loader = null;
         var _loc6_:URLRequest = null;
         this.clipsLoaded = 0;
         this.connectionsOpen = 0;
         var _loc1_:Number = 0;
         var _loc2_:Number = this._clips.length;
         var _loc3_:String = "";
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this._clips[_loc1_];
            _loc5_ = new Loader();
            _loc6_ = new URLRequest(_loc4_.url);
            _loc5_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
            _loc5_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            _loc5_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadSecurityError);
            _loc5_.contentLoaderInfo.addEventListener(Event.OPEN,this.onLoadStart);
            _loc4_.loader = _loc5_;
            _loc5_.load(_loc6_);
            _loc1_++;
         }
         DocumentClass.document.addEventListener(Event.ENTER_FRAME,this.getGroupProgress);
      }
      
      protected function onLoadComplete(param1:Event) : void
      {
         this.clipsLoaded++;
         this.connectionsOpen--;
         param1.target.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         param1.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadSecurityError);
         param1.target.removeEventListener(Event.OPEN,this.onLoadStart);
         if(this.clipsLoaded == this._clips.length && this.connectionsOpen == 0)
         {
            this.clearEnterFrame();
            this.getGroupProgress(null);
         }
      }
      
      public function clearEnterFrame() : *
      {
         DocumentClass.document.removeEventListener(Event.ENTER_FRAME,this.getGroupProgress);
      }
      
      protected function onLoadStart(param1:Event) : *
      {
         this.connectionsOpen++;
         var _loc2_:* = 0;
         while(_loc2_ < this._clips.length)
         {
            if(this._clips[_loc2_].loader.contentLoaderInfo == param1.target)
            {
               this._clips[_loc2_].loadstart = true;
               Logger.info(_loc2_ + " " + this.connectionsOpen);
               break;
            }
            _loc2_++;
         }
      }
      
      protected function onLoadError(param1:IOErrorEvent) : *
      {
         var _loc2_:* = {
            "type":"loadError",
            "target":this,
            "event":param1
         };
         var _loc3_:MultiLoaderEvent = new MultiLoaderEvent(MultiLoaderEvent.LOAD_ERROR,_loc2_);
         dispatchEvent(_loc3_);
      }
      
      protected function onLoadSecurityError(param1:SecurityErrorEvent) : *
      {
         var _loc2_:* = {
            "type":"loadError",
            "target":this,
            "event":param1
         };
         var _loc3_:MultiLoaderEvent = new MultiLoaderEvent(MultiLoaderEvent.LOAD_ERROR,_loc2_);
         dispatchEvent(_loc3_);
      }
      
      protected function getGroupProgress(param1:Event) : void
      {
         var _loc6_:Boolean = false;
         var _loc7_:* = undefined;
         var _loc8_:MultiLoaderEvent = null;
         var _loc9_:* = undefined;
         var _loc10_:Loader = null;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = this._clips.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = this._clips[_loc4_];
            _loc10_ = _loc9_.loader;
            if(this._clips[_loc4_].loadstart)
            {
               _loc2_ = _loc2_ + _loc10_.contentLoaderInfo.bytesLoaded;
            }
            _loc3_ = _loc3_ + _loc10_.contentLoaderInfo.bytesTotal;
            _loc4_++;
         }
         _loc6_ = false;
         if(this.clipsLoaded == this._clips.length && this.connectionsOpen == 0)
         {
            _loc6_ = true;
         }
         _loc7_ = {
            "type":"onGroupProgress",
            "target":this,
            "groupBytesLoaded":_loc2_,
            "groupBytesTotal":_loc3_,
            "done":_loc6_
         };
         _loc8_ = new MultiLoaderEvent(MultiLoaderEvent.GROUP_PROGRESS,_loc7_);
         dispatchEvent(_loc8_);
      }
   }
}
