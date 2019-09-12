package org.as3commons.ui.layout.framework.core.row
{
   import flash.geom.Rectangle;
   import org.as3commons.ui.layout.CellConfig;
   
   public interface IRow extends IRowItem
   {
       
      
      function get config() : RowConfig;
      
      function accepts(param1:IRowItem, param2:CellConfig = null) : Boolean;
      
      function add(param1:IRowItem) : void;
      
      function fillWithEmptyCell(param1:Rectangle) : void;
      
      function set parentRow(param1:IRow) : void;
      
      function get numItems() : uint;
      
      function get firstRowItem() : IRowItem;
   }
}
