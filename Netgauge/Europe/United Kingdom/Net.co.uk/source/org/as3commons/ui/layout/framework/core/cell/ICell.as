package org.as3commons.ui.layout.framework.core.cell
{
   import flash.geom.Rectangle;
   import org.as3commons.ui.layout.CellConfig;
   import org.as3commons.ui.layout.framework.core.AbstractLayoutItem;
   import org.as3commons.ui.layout.framework.core.config.RenderConfig;
   import org.as3commons.ui.layout.framework.core.row.IRowItem;
   import org.as3commons.ui.layout.framework.core.sizeitem.ISizeItem;
   
   public interface ICell extends ISizeItem, IRowItem
   {
       
      
      function set layoutItem(param1:AbstractLayoutItem) : void;
      
      function get config() : CellConfig;
      
      function set renderConfig(param1:RenderConfig) : void;
      
      function get renderConfig() : RenderConfig;
      
      function isEmpty() : Boolean;
      
      function get contentRect() : Rectangle;
   }
}
