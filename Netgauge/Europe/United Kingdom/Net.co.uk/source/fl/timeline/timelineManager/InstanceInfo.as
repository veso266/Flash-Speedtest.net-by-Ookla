package fl.timeline.timelineManager
{
   import fl.timeline.TimelineManager;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class InstanceInfo
   {
       
      
      public var container:DisplayObject;
      
      public var instanceName:String;
      
      public var content:DisplayObject;
      
      public var type:int;
      
      public var prev:InstanceInfo;
      
      public var realIIForXn:InstanceInfo;
      
      public var endFrame:int;
      
      public var extraInfo;
      
      public var data:XML;
      
      public var startFrame:int;
      
      public var next:InstanceInfo;
      
      public var bounds:Rectangle;
      
      public var sceneName:String;
      
      public var parent:InstanceInfo;
      
      public var xns:Vector.<InstanceInfo>;
      
      public var children:Vector.<InstanceInfo>;
      
      public function InstanceInfo(param1:DisplayObject, param2:String, param3:int, param4:int, param5:int, param6:Rectangle = null, param7:XML = null, param8:Vector.<InstanceInfo> = null, param9:* = undefined, param10:String = null)
      {
         super();
         this.container = param1;
         this.instanceName = param2;
         this.bounds = param6;
         this.data = param7;
         this.startFrame = param3;
         this.endFrame = param4;
         this.type = param5;
         this.xns = param8;
         this.extraInfo = param9;
         this.sceneName = param10;
      }
      
      public function clone() : InstanceInfo
      {
         var _loc1_:InstanceInfo = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<InstanceInfo> = new Vector.<InstanceInfo>();
         _loc2_ = 0;
         while(_loc2_ < this.xns.length)
         {
            _loc1_ = this.xns[_loc2_];
            _loc3_.push(new InstanceInfo(_loc1_.container,_loc1_.instanceName,_loc1_.startFrame,_loc1_.endFrame,_loc1_.type));
            _loc2_++;
         }
         if(this.prev != null)
         {
            _loc3_.push(new InstanceInfo(this.prev.container,this.prev.instanceName,this.prev.startFrame,this.prev.endFrame,TimelineManager.PREV));
         }
         if(this.next != null)
         {
            _loc3_.push(new InstanceInfo(this.next.container,this.next.instanceName,this.next.startFrame,this.next.endFrame,TimelineManager.NEXT));
         }
         if(this.parent != null)
         {
            _loc3_.push(new InstanceInfo(this.parent.container,this.parent.instanceName,this.parent.startFrame,this.parent.endFrame,TimelineManager.PARENT));
         }
         if(this.children != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.children.length)
            {
               _loc1_ = this.children[_loc2_];
               _loc3_.push(new InstanceInfo(_loc1_.container,_loc1_.instanceName,_loc1_.startFrame,_loc1_.endFrame,TimelineManager.CHILD));
               _loc2_++;
            }
         }
         return new InstanceInfo(this.container,this.instanceName,this.startFrame,this.endFrame,this.type,new Rectangle(this.bounds.x,this.bounds.y,this.bounds.width,this.bounds.height),this.data.copy(),_loc3_,this.extraInfo,this.sceneName);
      }
   }
}
