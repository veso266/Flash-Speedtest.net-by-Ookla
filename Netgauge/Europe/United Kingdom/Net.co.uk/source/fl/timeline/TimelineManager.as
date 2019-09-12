package fl.timeline
{
   import fl.timeline.timelineManager.InstanceInfo;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class TimelineManager
   {
      
      public static const PARENT:int = 3;
      
      public static const PREV:int = 0;
      
      public static const NEXT:int = 1;
      
      private static var _patentIDB1104:String = "AdobePatentID=\"B1104\"";
      
      public static const CHILD:int = 2;
       
      
      protected var initTargetDict:Dictionary;
      
      protected var _supportNextPrevAcrossFrames:Boolean;
      
      protected var containerDict:Dictionary;
      
      protected var targetDict:Dictionary;
      
      protected var _supportParentChildAcrossFrames:Boolean;
      
      public function TimelineManager()
      {
         super();
         this.containerDict = new Dictionary(true);
         this.targetDict = new Dictionary(true);
         this.initTargetDict = new Dictionary(true);
      }
      
      private static function findTarget(param1:InstanceInfo, param2:DisplayObject) : DisplayObject
      {
         var target:DisplayObject = null;
         var btn:SimpleButton = null;
         var ii:InstanceInfo = param1;
         var parent:DisplayObject = param2;
         var container:DisplayObjectContainer = parent as DisplayObjectContainer;
         if(container != null)
         {
            try
            {
               target = container[ii.instanceName];
            }
            catch(e:Error)
            {
               target = null;
            }
            if(target == null)
            {
               target = container.getChildByName(ii.instanceName);
            }
         }
         else
         {
            btn = parent as SimpleButton;
            if(btn != null)
            {
               switch(ii.startFrame)
               {
                  case 0:
                     target = btn.upState;
                     break;
                  case 1:
                     target = btn.overState;
                     break;
                  case 2:
                     target = btn.downState;
               }
               if(ii.endFrame >= 0)
               {
                  try
                  {
                     target = DisplayObjectContainer(target).getChildAt(ii.endFrame);
                  }
                  catch(err:Error)
                  {
                     target = null;
                  }
               }
            }
         }
         return target;
      }
      
      public function initInstance(param1:DisplayObject, param2:DisplayObjectContainer) : void
      {
         var _loc3_:InstanceInfo = null;
         var _loc5_:Vector.<InstanceInfo> = null;
         var _loc6_:MovieClip = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:Dictionary = this.containerDict[param2];
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_[param1.name];
            if(_loc5_ != null)
            {
               _loc6_ = param2 as MovieClip;
               if(_loc6_ == null)
               {
                  _loc3_ = _loc5_[0];
               }
               else
               {
                  _loc7_ = _loc6_.currentFrame - 1;
                  _loc8_ = 0;
                  while(_loc8_ < _loc5_.length)
                  {
                     _loc3_ = _loc5_[_loc8_];
                     if(_loc6_.currentScene.name == _loc3_.sceneName && _loc3_.startFrame <= _loc7_ && _loc7_ <= _loc3_.endFrame)
                     {
                        break;
                     }
                     _loc3_ = null;
                     _loc8_++;
                  }
               }
            }
         }
         if(_loc3_ != null)
         {
            if(this.getInstanceForInfo(_loc3_,param1) == null)
            {
               this.initTargetDict[param1] = _loc3_;
               param1.addEventListener(Event.FRAME_CONSTRUCTED,this.handleInit);
               param1.addEventListener(Event.REMOVED,this.handleInitRemoved);
            }
         }
      }
      
      private function fixXnEntry(param1:InstanceInfo, param2:InstanceInfo, param3:InstanceInfo) : void
      {
         switch(param2.type)
         {
            case PREV:
               param1.prev = param3;
               param3.realIIForXn = param3;
               break;
            case NEXT:
               param1.next = param3;
               param3.realIIForXn = param3;
               break;
            case CHILD:
               if(param1.children == null)
               {
                  param1.children = new Vector.<InstanceInfo>(1);
                  param1.children[0] = param3;
               }
               else
               {
                  param1.children.push(param3);
               }
               param3.realIIForXn = param3;
               break;
            case PARENT:
               param1.parent = param3;
               param3.realIIForXn = param3;
               break;
            default:
               param2.realIIForXn = param3;
         }
      }
      
      public function getInstance(param1:DisplayObject, param2:String, param3:int, param4:String = null) : DisplayObject
      {
         var _loc8_:InstanceInfo = null;
         var _loc10_:DisplayObject = null;
         var _loc5_:Dictionary = Dictionary(this.containerDict[param1]);
         if(_loc5_ == null)
         {
            return null;
         }
         var _loc6_:Vector.<InstanceInfo> = _loc5_[param2];
         if(_loc6_ == null)
         {
            return null;
         }
         var _loc7_:* = param1 is SimpleButton;
         var _loc9_:int = 0;
         while(_loc9_ < _loc6_.length)
         {
            _loc8_ = _loc6_[_loc9_];
            if(_loc7_ && _loc8_.startFrame == param3 || !_loc7_ && _loc8_.startFrame <= param3 && param3 <= _loc8_.endFrame && (param4 == null || param4.length < 1 || param4 == _loc8_.sceneName))
            {
               _loc10_ = this.getInstanceForInfoWithXns(_loc8_);
               if(_loc10_ != null)
               {
                  this.targetDict[_loc10_] = _loc8_;
               }
               return _loc10_;
            }
            _loc9_++;
         }
         return null;
      }
      
      protected function getInstanceForInfo(param1:InstanceInfo, param2:DisplayObject = null) : DisplayObject
      {
         return null;
      }
      
      public function addInstance(param1:DisplayObject, param2:String, param3:Rectangle, param4:XML, param5:Array, param6:* = undefined, param7:int = 0, param8:int = 0, param9:String = null, param10:Boolean = true, param11:Boolean = false) : void
      {
         var _loc15_:DisplayObject = null;
         var _loc16_:Boolean = false;
         var _loc17_:int = 0;
         var _loc18_:InstanceInfo = null;
         var _loc12_:InstanceInfo = new InstanceInfo(param1,param2,param7,param8,-1,param3,param4,param5 == null?null:Vector.<InstanceInfo>(param5),param6,param9);
         if(param11)
         {
            _loc15_ = findTarget(_loc12_,_loc12_.container);
            if(this.getInstanceForInfo(_loc12_,_loc15_) == null)
            {
               this.initTargetDict[_loc15_] = _loc12_;
               _loc15_.addEventListener(Event.FRAME_CONSTRUCTED,this.handleInit);
               _loc15_.addEventListener(Event.REMOVED,this.handleInitRemoved);
            }
         }
         if(!param10)
         {
            return;
         }
         var _loc13_:Dictionary = this.containerDict[param1];
         if(!_loc13_)
         {
            _loc13_ = new Dictionary();
            this.containerDict[param1] = _loc13_;
         }
         var _loc14_:Vector.<InstanceInfo> = _loc13_[param2];
         if(_loc14_ == null)
         {
            _loc14_ = new Vector.<InstanceInfo>(1);
            _loc14_[0] = _loc12_;
            _loc13_[param2] = _loc14_;
         }
         else if(param1 is SimpleButton)
         {
            _loc14_.push(_loc12_);
         }
         else
         {
            _loc16_ = false;
            _loc17_ = 0;
            while(_loc17_ < _loc14_.length)
            {
               _loc18_ = _loc14_[_loc17_];
               if(param9 != null && param9.length > 0 && _loc18_.sceneName != param9)
               {
                  _loc17_++;
                  continue;
               }
               if(_loc18_.startFrame <= param7)
               {
                  if(_loc18_.endFrame >= param7)
                  {
                     _loc14_.splice(_loc17_,1);
                  }
                  else
                  {
                     _loc17_++;
                  }
                  continue;
               }
               _loc14_.splice(_loc17_,0,_loc12_);
               _loc16_ = true;
               _loc17_++;
               while(_loc17_ < _loc14_.length)
               {
                  _loc18_ = _loc14_[_loc17_];
                  if(param8 >= _loc18_.startFrame)
                  {
                     _loc14_.splice(_loc17_,1);
                     continue;
                  }
                  break;
               }
               break;
            }
            if(!_loc16_)
            {
               _loc14_.push(_loc12_);
            }
         }
      }
      
      protected function handleInit(param1:Event) : void
      {
         var _loc2_:InstanceInfo = this.initTargetDict[param1.target];
         if(_loc2_ == null || this.getInstanceForInfo(_loc2_,DisplayObject(param1.target)) != null)
         {
            delete this.initTargetDict[param1.target];
            this.handleInitRemoved(param1);
         }
      }
      
      protected function removeXn(param1:DisplayObject, param2:InstanceInfo, param3:int) : void
      {
      }
      
      public function isTargetForFrame(param1:DisplayObject, param2:int, param3:String = null) : Boolean
      {
         var _loc4_:InstanceInfo = this.targetDict[param1];
         if(_loc4_ == null)
         {
            return false;
         }
         return _loc4_.startFrame <= param2 && param2 <= _loc4_.endFrame && (param3 == null || param3.length < 1 || param3 == _loc4_.sceneName) && (param1.parent == null || param1.parent == _loc4_.container);
      }
      
      protected function handleInitRemoved(param1:Event) : void
      {
         param1.target.removeEventListener(Event.REMOVED,this.handleInitRemoved);
         param1.target.removeEventListener(Event.FRAME_CONSTRUCTED,this.handleInit);
      }
      
      protected function getInstanceForInfoWithXns(param1:InstanceInfo) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:InstanceInfo = null;
         var _loc4_:InstanceInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:InstanceInfo = null;
         if(param1.content != null)
         {
            _loc2_ = param1.content;
            if(this._supportNextPrevAcrossFrames && param1.next != null && param1.next.content == null)
            {
               param1.next.content = this.getInstanceForInfo(param1.next);
            }
         }
         else if(!this._supportNextPrevAcrossFrames || param1.prev == null && param1.next == null)
         {
            param1.content = this.getInstanceForInfo(param1);
         }
         else
         {
            _loc3_ = param1;
            while(_loc3_.prev != null)
            {
               _loc3_ = _loc3_.prev;
            }
            while(_loc3_ != null && _loc3_ != param1)
            {
               if(_loc3_.content == null)
               {
                  _loc3_.content = this.getInstanceForInfo(_loc3_);
               }
               if(_loc4_ != null && _loc4_.content != null && _loc3_.content != null)
               {
                  this.addXn(_loc4_.content,_loc3_.content,_loc3_,TimelineManager.NEXT);
                  this.addXn(_loc3_.content,_loc4_.content,_loc4_,TimelineManager.PREV);
               }
               _loc4_ = _loc3_;
               _loc3_ = _loc3_.next;
            }
            if(_loc3_ != param1)
            {
               _loc4_ = null;
            }
            param1.content = this.getInstanceForInfo(param1);
            if(param1.content != null)
            {
               if(_loc4_ != null && _loc4_.content != null)
               {
                  this.addXn(_loc4_.content,param1.content,param1,TimelineManager.NEXT);
                  this.addXn(param1.content,_loc4_.content,_loc4_,TimelineManager.PREV);
               }
               if(param1.next != null)
               {
                  if(param1.next.content == null)
                  {
                     param1.next.content = this.getInstanceForInfo(param1.next);
                  }
                  if(param1.next.content != null)
                  {
                     this.addXn(param1.content,param1.next.content,param1.next,TimelineManager.NEXT);
                     this.addXn(param1.next.content,param1.content,param1,TimelineManager.PREV);
                  }
               }
            }
         }
         if(this._supportParentChildAcrossFrames && param1.children != null)
         {
            _loc5_ = param1.children.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = param1.children[_loc6_];
               if(_loc7_.content == null)
               {
                  _loc7_.content = this.getInstanceForInfo(_loc7_);
               }
               if(_loc7_.content != null)
               {
                  this.addXn(param1.content,_loc7_.content,_loc7_,TimelineManager.CHILD);
                  this.addXn(_loc7_.content,param1.content,param1,TimelineManager.PARENT);
               }
               _loc6_++;
            }
         }
         if(this._supportParentChildAcrossFrames && param1.parent != null)
         {
            if(param1.parent.content == null)
            {
               param1.parent.content = this.getInstanceForInfo(param1.parent);
            }
            if(param1.parent.content)
            {
               this.addXn(param1.content,param1.parent.content,param1.parent,TimelineManager.PARENT);
               this.addXn(param1.parent.content,param1.content,param1,TimelineManager.CHILD);
            }
         }
         if(!this._supportNextPrevAcrossFrames && (param1.next != null || param1.prev != null) || !this._supportParentChildAcrossFrames && (param1.children != null || param1.parent != null) || param1.xns != null && param1.xns.length > 0)
         {
            if(_loc2_ != null)
            {
               this.handleXns(_loc2_,param1);
            }
            param1.content.addEventListener(Event.FRAME_CONSTRUCTED,this.handleXns);
            if(param1.container is MovieClip)
            {
               param1.content.addEventListener(Event.REMOVED,this.handleRemoved,false,1);
            }
         }
         if(_loc2_ == null)
         {
            _loc2_ = param1.content;
         }
         if((!this._supportNextPrevAcrossFrames || param1.next == null && param1.prev == null) && (!this._supportParentChildAcrossFrames || param1.parent == null && param1.children == null))
         {
            param1.content = null;
         }
         return _loc2_;
      }
      
      public function addInstanceComplete(param1:DisplayObject) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc2_:Dictionary = this.containerDict[param1];
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:* = param1 is SimpleButton;
         var _loc4_:Dictionary = new Dictionary();
         do
         {
            _loc5_ = false;
            for each(_loc6_ in _loc2_)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  _loc8_ = _loc6_[_loc7_];
                  if(_loc4_[_loc8_] == undefined)
                  {
                     _loc4_[_loc8_] = true;
                     if(_loc8_.xns != null)
                     {
                        _loc9_ = _loc8_.xns;
                        _loc10_ = 0;
                        while(_loc10_ < _loc9_.length)
                        {
                           _loc11_ = _loc9_[_loc10_];
                           if(_loc11_.type >= PREV && _loc11_.type <= PARENT)
                           {
                              _loc9_.splice(_loc10_,1);
                              _loc10_--;
                           }
                           _loc12_ = _loc2_[_loc11_.instanceName];
                           if(_loc12_ != null)
                           {
                              _loc13_ = 0;
                              while(_loc13_ < _loc12_.length)
                              {
                                 _loc14_ = _loc12_[_loc13_];
                                 if(_loc3_)
                                 {
                                    if(_loc8_.startFrame == _loc14_.startFrame)
                                    {
                                       this.fixXnEntry(_loc8_,_loc11_,_loc14_);
                                       break;
                                    }
                                 }
                                 else if(_loc14_.startFrame == _loc11_.startFrame && _loc14_.endFrame == _loc11_.endFrame && (_loc8_.sceneName == null || _loc8_.sceneName.length < 1 || _loc14_.sceneName == _loc8_.sceneName))
                                 {
                                    this.fixXnEntry(_loc8_,_loc11_,_loc14_);
                                    break;
                                 }
                                 _loc13_++;
                              }
                              if(_loc3_ && _loc13_ >= _loc12_.length)
                              {
                                 _loc14_ = _loc12_[0].clone();
                                 _loc14_.startFrame = _loc8_.startFrame;
                                 _loc12_.push(_loc14_);
                                 _loc5_ = true;
                                 this.fixXnEntry(_loc8_,_loc11_,_loc14_);
                              }
                           }
                           _loc10_++;
                        }
                     }
                  }
                  _loc7_++;
               }
            }
         }
         while(_loc5_);
         
      }
      
      protected function handleRemoved(param1:Event) : void
      {
         param1.target.removeEventListener(Event.REMOVED,this.handleRemoved);
         param1.target.removeEventListener(Event.FRAME_CONSTRUCTED,this.handleXns);
      }
      
      protected function handleXns(param1:Object, param2:InstanceInfo = null) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc9_:InstanceInfo = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:InstanceInfo = null;
         var _loc4_:* = param2 == null;
         if(_loc4_)
         {
            _loc3_ = param1.target as DisplayObject;
            param2 = this.targetDict[_loc3_];
            if(param2 == null)
            {
               return;
            }
         }
         else
         {
            _loc3_ = param1 as DisplayObject;
         }
         if(_loc3_ == null)
         {
            return;
         }
         var _loc5_:MovieClip = param2.container as MovieClip;
         var _loc6_:* = _loc5_ == null;
         var _loc7_:int = !!_loc6_?0:int(_loc5_.currentFrame - 1);
         if(!_loc6_ && _loc5_.scenes.length > 1 && param2.sceneName != null && param2.sceneName.length > 0 && _loc5_.currentScene.name != param2.sceneName)
         {
            return;
         }
         if(_loc6_ && _loc4_)
         {
            _loc3_.removeEventListener(Event.FRAME_CONSTRUCTED,this.handleXns);
         }
         var _loc8_:int = 0;
         while(_loc8_ < param2.xns.length)
         {
            _loc9_ = param2.xns[_loc8_];
            this.handleXn(_loc3_,param2,_loc9_,_loc9_.type,_loc7_,_loc6_);
            _loc8_++;
         }
         if(!this._supportNextPrevAcrossFrames)
         {
            if(param2.prev != null)
            {
               this.handleXn(_loc3_,param2,param2.prev,TimelineManager.PREV,_loc7_,_loc6_);
            }
            if(param2.next != null)
            {
               this.handleXn(_loc3_,param2,param2.next,TimelineManager.NEXT,_loc7_,_loc6_);
            }
         }
         if(!this._supportParentChildAcrossFrames)
         {
            if(param2.parent != null)
            {
               this.handleXn(_loc3_,param2,param2.parent,TimelineManager.PARENT,_loc7_,_loc6_);
            }
            if(param2.children != null)
            {
               _loc10_ = param2.children.length;
               _loc11_ = 0;
               while(_loc11_ < _loc10_)
               {
                  _loc12_ = param2.children[_loc11_];
                  this.handleXn(_loc3_,param2,_loc12_,TimelineManager.CHILD,_loc7_,_loc6_);
                  _loc11_++;
               }
            }
         }
      }
      
      protected function addXn(param1:DisplayObject, param2:DisplayObject, param3:InstanceInfo, param4:int) : void
      {
      }
      
      protected function handleXn(param1:DisplayObject, param2:InstanceInfo, param3:InstanceInfo, param4:int, param5:int, param6:Boolean) : void
      {
         var _loc7_:DisplayObject = null;
         if(param6 || param3.startFrame <= param5 && param5 <= param3.endFrame)
         {
            _loc7_ = findTarget(param3,param2.container);
            if(_loc7_ == null && param3.realIIForXn != null)
            {
               _loc7_ = param3.content = this.getInstanceForInfoWithXns(param3.realIIForXn);
            }
            if(_loc7_ != null)
            {
               this.addXn(param1,_loc7_,param3,param4);
            }
         }
         else
         {
            this.removeXn(param1,param3,param4);
         }
      }
   }
}
