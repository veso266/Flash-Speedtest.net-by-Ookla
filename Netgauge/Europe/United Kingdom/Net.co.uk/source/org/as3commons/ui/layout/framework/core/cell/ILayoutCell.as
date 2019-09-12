package org.as3commons.ui.layout.framework.core.cell
{
   import org.as3commons.ui.layout.framework.core.row.IRow;
   
   public interface ILayoutCell extends ICell
   {
       
      
      function set row(param1:IRow) : void;
      
      function get row() : IRow;
   }
}
