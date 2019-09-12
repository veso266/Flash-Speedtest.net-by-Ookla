package org.as3commons.ui.layout.framework.core.row
{
   import org.as3commons.ui.layout.framework.core.sizeitem.ISizeItem;
   
   public interface IRowItem extends ISizeItem
   {
       
      
      function set isFirst(param1:Boolean) : void;
      
      function get isFirst() : Boolean;
      
      function set isLast(param1:Boolean) : void;
      
      function get isLast() : Boolean;
      
      function set nextRowItem(param1:IRowItem) : void;
      
      function get nextRowItem() : IRowItem;
   }
}
