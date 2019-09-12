package org.as3commons.ui.layout.framework.core.parser
{
   import org.as3commons.ui.layout.framework.core.AbstractLayout;
   import org.as3commons.ui.layout.framework.core.cell.ICell;
   
   public interface ILayoutParser
   {
       
      
      function set layout(param1:AbstractLayout) : void;
      
      function prepare() : void;
      
      function parseCell(param1:ICell) : void;
      
      function finish() : ICell;
   }
}
