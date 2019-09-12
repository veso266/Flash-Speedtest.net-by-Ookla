package org.as3commons.ui.layout.framework.core.row
{
   import org.as3commons.ui.layout.framework.core.sizeitem.SizeItem;
   
   public class AbstractRowItem extends SizeItem implements IRowItem
   {
       
      
      private var _nextRowItem:IRowItem;
      
      protected var _isFirst:Boolean;
      
      protected var _isLast:Boolean;
      
      public function AbstractRowItem()
      {
         super();
      }
      
      public function set isFirst(param1:Boolean) : void
      {
         this._isFirst = param1;
      }
      
      public function get isFirst() : Boolean
      {
         return this._isFirst;
      }
      
      public function set isLast(param1:Boolean) : void
      {
         this._isLast = param1;
      }
      
      public function get isLast() : Boolean
      {
         return this._isLast;
      }
      
      public function set nextRowItem(param1:IRowItem) : void
      {
         this._nextRowItem = param1;
      }
      
      public function get nextRowItem() : IRowItem
      {
         return this._nextRowItem;
      }
   }
}
