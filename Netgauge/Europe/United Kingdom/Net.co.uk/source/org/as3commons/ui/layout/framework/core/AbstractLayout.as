package org.as3commons.ui.layout.framework.core
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.as3commons.collections.LinkedMap;
   import org.as3commons.collections.LinkedSet;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.StringMap;
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.IMap;
   import org.as3commons.collections.framework.IOrderedMap;
   import org.as3commons.collections.framework.IRecursiveIterator;
   import org.as3commons.collections.iterators.RecursiveIterator;
   import org.as3commons.ui.framework.core.as3commons_ui;
   import org.as3commons.ui.layout.CellConfig;
   import org.as3commons.ui.layout.Display;
   import org.as3commons.ui.layout.framework.ILayout;
   import org.as3commons.ui.layout.framework.ILayoutItem;
   import org.as3commons.ui.layout.framework.core.config.CellConfigCollection;
   import org.as3commons.ui.layout.framework.core.config.RenderConfig;
   import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;
   
   use namespace as3commons_ui;
   
   public class AbstractLayout extends AbstractLayoutItem implements ILayout
   {
       
      
      private var _cellConfigs:CellConfigCollection;
      
      private var _minWidth:uint;
      
      private var _minHeight:uint;
      
      private var _items:IOrderedMap;
      
      private var _itemIds:IMap;
      
      private var _subLayouts:LinkedSet;
      
      private var _lastRenderConfig:RenderConfig;
      
      public function AbstractLayout()
      {
         super();
         this._items = new LinkedMap();
      }
      
      public function setCellConfig(param1:CellConfig, param2:int = -1, param3:int = -1) : void
      {
         if(!this._cellConfigs)
         {
            this._cellConfigs = new CellConfigCollection();
         }
         this._cellConfigs.setConfig(param1,param2,param3);
      }
      
      public function getCellConfig(param1:int = -1, param2:int = -1) : CellConfig
      {
         if(!this._cellConfigs)
         {
            return null;
         }
         return this._cellConfigs.getConfig(param1,param2);
      }
      
      public function set minWidth(param1:uint) : void
      {
         this._minWidth = param1;
      }
      
      public function get minWidth() : uint
      {
         return this._minWidth;
      }
      
      public function set minHeight(param1:uint) : void
      {
         this._minHeight = param1;
      }
      
      public function get minHeight() : uint
      {
         return this._minHeight;
      }
      
      public function add(... rest) : void
      {
         var _loc2_:Array = this.getItemsToAdd(rest);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            this.addItem(_loc2_[_loc3_],_loc2_[_loc3_ + 1]);
            _loc3_ = _loc3_ + 2;
         }
      }
      
      public function addFirst(... rest) : void
      {
         var _loc2_:Array = this.getItemsToAdd(rest);
         var _loc3_:int = _loc2_.length - 2;
         while(_loc3_ >= 0)
         {
            this.addItemFirst(_loc2_[_loc3_],_loc2_[_loc3_ + 1]);
            _loc3_ = _loc3_ - 2;
         }
      }
      
      public function addAll(param1:Sprite) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.numChildren)
         {
            this.add(param1.getChildAt(_loc2_));
            _loc2_++;
         }
      }
      
      public function getLayoutItem(... rest) : ILayoutItem
      {
         var _loc2_:ILayoutItem = null;
         var _loc4_:uint = 0;
         var _loc3_:AbstractLayout = this;
         _loc4_ = 0;
         while(_loc4_ < rest.length)
         {
            _loc2_ = _loc3_.findLayoutItemByKey(rest[_loc4_]);
            if(_loc2_ && _loc2_ is AbstractLayout)
            {
               _loc3_ = _loc2_ as AbstractLayout;
               _loc4_++;
               continue;
            }
            _loc4_++;
            break;
         }
         return _loc4_ == rest.length?_loc2_:null;
      }
      
      public function getDisplayObject(... rest) : DisplayObject
      {
         var _loc2_:ILayoutItem = this.getLayoutItem.apply(this,rest);
         if(_loc2_ && _loc2_ is Display)
         {
            return Display(_loc2_).displayObject;
         }
         return null;
      }
      
      public function recursiveIterator() : IRecursiveIterator
      {
         return new RecursiveIterator(this);
      }
      
      public function remove(param1:*) : void
      {
         var _loc2_:ILayoutItem = this.getLayoutItemByKey(param1);
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_ is Display)
         {
            this._items.removeKey(Display(_loc2_).displayObject);
         }
         else if(_loc2_ is AbstractLayout)
         {
            this._items.removeKey(_loc2_);
            this._subLayouts.remove(_loc2_);
            if(!this._subLayouts.size)
            {
               this._subLayouts = null;
            }
         }
         if(_loc2_.id)
         {
            this._itemIds.removeKey(_loc2_.id);
            if(!this._itemIds.size)
            {
               this._itemIds = null;
            }
         }
      }
      
      public function get numItems() : uint
      {
         return this._items.size;
      }
      
      public function layout(param1:Sprite, param2:Boolean = false) : void
      {
         var _loc3_:RenderConfig = null;
         var _loc4_:Point = null;
         if(LayoutLock.locked)
         {
            return;
         }
         LayoutLock.locked = true;
         if(param2 && this._lastRenderConfig)
         {
            _loc3_ = this._lastRenderConfig;
            _loc4_ = _position;
         }
         else
         {
            _loc4_ = new Point();
         }
         if(!_loc3_)
         {
            _loc3_ = createRenderConfig();
         }
         _loc3_.container = param1;
         if(!_inLayout)
         {
            exclude(_loc3_);
         }
         else
         {
            parse(_loc3_);
            _cell.position.offset(_loc4_.x,_loc4_.y);
            _cell.render();
         }
         LayoutLock.locked = false;
      }
      
      public function iterator(param1:* = undefined) : IIterator
      {
         return this._items.iterator();
      }
      
      override as3commons_ui function notifyRenderFinished() : void
      {
         if(!_cell)
         {
            return;
         }
         this._lastRenderConfig = _cell.renderConfig;
         super.notifyRenderFinished();
      }
      
      override protected function parseLayoutItem(param1:RenderConfig) : void
      {
         var _loc4_:AbstractLayoutItem = null;
         var _loc5_:RenderConfig = null;
         var _loc6_:DisplayObject = null;
         var _loc2_:ILayoutParser = this.createParser();
         _loc2_.layout = this;
         _loc2_.prepare();
         var _loc3_:IIterator = this._items.iterator();
         while(_loc3_.hasNext())
         {
            _loc4_ = _loc3_.next();
            _loc5_ = _loc4_.createRenderConfig(param1);
            if(_loc4_ is Display)
            {
               _loc6_ = Display(_loc4_).displayObject;
               if(_loc6_.parent != param1.container)
               {
                  param1.container.addChild(_loc6_);
               }
            }
            if(_loc4_.inLayout)
            {
               _loc4_.parse(_loc5_);
               _loc2_.parseCell(_loc4_.cell);
            }
            else
            {
               _loc4_.exclude(_loc5_);
            }
         }
         _cell = _loc2_.finish();
         _cell.renderConfig = param1;
      }
      
      override protected function excludeLayoutItem(param1:RenderConfig) : void
      {
         var _loc3_:AbstractLayoutItem = null;
         var _loc4_:RenderConfig = null;
         var _loc2_:IIterator = this._items.iterator();
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next();
            _loc4_ = _loc3_.createRenderConfig(param1);
            _loc3_.exclude(_loc4_);
         }
      }
      
      protected function createParser() : ILayoutParser
      {
         return null;
      }
      
      private function getItemsToAdd(param1:Array) : Array
      {
         var _loc2_:* = undefined;
         var _loc5_:Display = null;
         var _loc3_:Array = new Array();
         var _loc4_:uint = 0;
         for(; _loc4_ < param1.length; _loc4_++)
         {
            _loc2_ = param1[_loc4_];
            if(_loc2_ is Array)
            {
               _loc3_ = _loc3_.concat(this.getItemsToAdd(_loc2_));
            }
            else if(_loc2_ is DisplayObject)
            {
               _loc5_ = new Display();
               _loc5_.displayObject = _loc2_;
               _loc3_.push(_loc2_,_loc5_);
            }
            else if(_loc2_ is AbstractLayoutItem)
            {
               if(_loc2_ is Display)
               {
                  if(!Display(_loc2_).displayObject)
                  {
                     continue;
                  }
                  _loc3_.push(Display(_loc2_).displayObject,_loc2_);
               }
               else if(_loc2_ is AbstractLayout)
               {
                  _loc3_.push(_loc2_,_loc2_);
               }
            }
         }
         return _loc3_;
      }
      
      private function addItem(param1:*, param2:ILayoutItem) : void
      {
         this._items.add(param1,param2);
         if(param2 is AbstractLayout)
         {
            if(!this._subLayouts)
            {
               this._subLayouts = new LinkedSet();
            }
            this._subLayouts.add(param2);
         }
         if(param2.id)
         {
            if(!this._itemIds)
            {
               this._itemIds = new StringMap();
            }
            this._itemIds.add(param2.id,param2);
         }
      }
      
      private function addItemFirst(param1:*, param2:ILayoutItem) : void
      {
         this._items.addFirst(param1,param2);
         if(param2 is AbstractLayout)
         {
            if(!this._subLayouts)
            {
               this._subLayouts = new LinkedSet();
            }
            this._subLayouts.addFirst(param2);
         }
         if(param2.id)
         {
            if(!this._itemIds)
            {
               this._itemIds = new Map();
            }
            this._itemIds.add(param2.id,param2);
         }
      }
      
      private function hasLayoutItem(param1:AbstractLayoutItem) : Boolean
      {
         return this._items.hasKey(param1);
      }
      
      private function getLayoutItemByDisplayObject(param1:DisplayObject) : AbstractLayoutItem
      {
         return this._items.itemFor(param1);
      }
      
      private function getLayoutItemById(param1:String) : AbstractLayoutItem
      {
         if(!this._itemIds)
         {
            return null;
         }
         return this._itemIds.itemFor(param1);
      }
      
      private function getLayoutItemByKey(param1:*) : ILayoutItem
      {
         if(param1 is Display)
         {
            param1 = Display(param1).displayObject;
         }
         if(param1 is String)
         {
            return this.getLayoutItemById(param1);
         }
         if(param1 is DisplayObject)
         {
            return this.getLayoutItemByDisplayObject(param1);
         }
         if(param1 is AbstractLayout && this.hasLayoutItem(param1))
         {
            return param1;
         }
         return null;
      }
      
      private function findLayoutItemByKey(param1:*) : ILayoutItem
      {
         var _loc3_:AbstractLayout = null;
         var _loc4_:IIterator = null;
         var _loc2_:ILayoutItem = this.getLayoutItemByKey(param1);
         if(_loc2_)
         {
            return _loc2_;
         }
         if(!this._subLayouts)
         {
            return null;
         }
         _loc4_ = this._subLayouts.iterator();
         while(_loc4_.hasNext())
         {
            _loc3_ = _loc4_.next();
            _loc2_ = _loc3_.findLayoutItemByKey(param1);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}
