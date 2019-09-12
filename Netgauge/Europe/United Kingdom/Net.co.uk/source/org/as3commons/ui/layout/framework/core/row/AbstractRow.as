package org.as3commons.ui.layout.framework.core.row
{
   import flash.geom.Rectangle;
   import org.as3commons.ui.layout.CellConfig;
   import org.as3commons.ui.layout.constants.Align;
   
   public class AbstractRow extends AbstractRowDirection implements IRow
   {
       
      
      private var _config:RowConfig;
      
      private var _parentRow:IRow;
      
      private var _firstRowItem:IRowItem;
      
      private var _lastRowItem:IRowItem;
      
      private var _currentPosition:int;
      
      private var _measuredSize:uint;
      
      private var _numItems:uint;
      
      private var _visibleRect:Rectangle;
      
      public function AbstractRow()
      {
         super();
         this._config = new RowConfig();
         _space = new Rectangle();
         this._visibleRect = new Rectangle();
      }
      
      public function get config() : RowConfig
      {
         return this._config;
      }
      
      public function accepts(param1:IRowItem, param2:CellConfig = null) : Boolean
      {
         var _loc3_:uint = 0;
         if(this._numItems)
         {
            if(this._config.maxItems && this._numItems == this._config.maxItems)
            {
               return false;
            }
            if(this._config.maxContentSize)
            {
               if(param2 && param2[_width])
               {
                  _loc3_ = param2[_width];
               }
               else
               {
                  _loc3_ = param1.space[_width];
               }
               if(this._currentPosition + this._config.gap + param1.space[_x] + _loc3_ > this._config.maxContentSize)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      public function add(param1:IRowItem) : void
      {
         if(!this._firstRowItem)
         {
            this._firstRowItem = this._lastRowItem = param1;
            this._firstRowItem.isFirst = this._firstRowItem.isLast = true;
         }
         else
         {
            this._lastRowItem.isLast = false;
            this._lastRowItem.nextRowItem = param1;
            this._lastRowItem = param1;
            this._lastRowItem.isLast = true;
         }
         this._numItems++;
         if(!param1.isFirst)
         {
            this._currentPosition = this._currentPosition + this._config.gap;
         }
         param1.position[_x] = this._currentPosition;
         param1.space[_x] = param1.space[_x] + this._currentPosition;
         this._currentPosition = param1.space[_x] + param1.space[_width];
         _space = _space.union(param1.space);
      }
      
      public function fillWithEmptyCell(param1:Rectangle) : void
      {
         this._numItems++;
         this._currentPosition = this._currentPosition + this._config.gap;
         param1[_x] = this._currentPosition;
         this._currentPosition = this._currentPosition + param1[_width];
         _space = _space.union(param1);
      }
      
      public function set parentRow(param1:IRow) : void
      {
         this._parentRow = param1;
      }
      
      public function get numItems() : uint
      {
         return this._numItems;
      }
      
      public function get firstRowItem() : IRowItem
      {
         return this._firstRowItem;
      }
      
      override public function measure() : void
      {
         this._measuredSize = _space[_width];
         if(this._config.minWidth)
         {
            _space.width = Math.max(_space.width,this._config.minWidth);
         }
         if(this._config.minHeight)
         {
            _space.height = Math.max(_space.height,this._config.minHeight);
         }
      }
      
      override public function render() : void
      {
         var _loc2_:uint = 0;
         var _loc1_:IRowItem = this._firstRowItem;
         while(_loc1_)
         {
            _loc1_.position.offset(_position.x,_position.y);
            this.alignRowItem(_loc1_,_loc2_);
            _loc1_.render();
            this._visibleRect = _loc1_.visibleRect.union(this._visibleRect);
            _loc1_ = _loc1_.nextRowItem;
            _loc2_++;
         }
      }
      
      override public function get visibleRect() : Rectangle
      {
         return this._visibleRect;
      }
      
      private function alignRowItem(param1:IRowItem, param2:uint) : void
      {
         var width:uint = 0;
         var diff:uint = 0;
         var gap:uint = 0;
         var align:String = null;
         var oppositeDiff:uint = 0;
         var rowItem:IRowItem = param1;
         var index:uint = param2;
         var getAdditionalGap:Function = function():int
         {
            var _loc1_:int = diff - (_numItems - 1) * gap;
            var _loc2_:uint = Math.abs(_loc1_);
            var _loc3_:uint = _numItems - _loc2_;
            if(index >= _loc3_)
            {
               return (index - _loc3_ + 1) * _loc1_ / _loc2_;
            }
            return 0;
         };
         if(this._config[_align] != _alignLeft)
         {
            width = !!this._parentRow?uint(this._parentRow.space[_width]):uint(_space[_width]);
            diff = width - this._measuredSize;
            if(diff)
            {
               if(this._config[_align] == Align.JUSTIFY)
               {
                  if(this._numItems > 1)
                  {
                     gap = Math.round(diff / (this._numItems - 1));
                     rowItem.position[_x] = rowItem.position[_x] + gap * index;
                     if(this._numItems > 2)
                     {
                        rowItem.position[_x] = rowItem.position[_x] + getAdditionalGap();
                     }
                  }
               }
               else
               {
                  switch(this._config[_align])
                  {
                     case _alignCenter:
                        rowItem.position[_x] = rowItem.position[_x] + Math.round(diff / 2);
                        break;
                     case _alignRight:
                        rowItem.position[_x] = rowItem.position[_x] + diff;
                  }
               }
            }
         }
         if(this._config[_oppositeAlign] != _oppositeAlignTop)
         {
            if(this._parentRow && this._config[_oppositeAlign] == Align.JUSTIFY && !_isFirst)
            {
               align = !!_isLast?_oppositeAlignBottom:_oppositeAlignMiddle;
            }
            else
            {
               align = this._config[_oppositeAlign];
            }
            oppositeDiff = _space[_height] - rowItem.space[_height];
            if(oppositeDiff)
            {
               switch(align)
               {
                  case _oppositeAlignMiddle:
                     rowItem.position[_y] = rowItem.position[_y] + Math.round(oppositeDiff / 2);
                     break;
                  case _oppositeAlignBottom:
                     rowItem.position[_y] = rowItem.position[_y] + oppositeDiff;
               }
            }
         }
      }
   }
}
