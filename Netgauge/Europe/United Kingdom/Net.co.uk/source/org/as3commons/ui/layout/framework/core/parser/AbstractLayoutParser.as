package org.as3commons.ui.layout.framework.core.parser
{
   import org.as3commons.ui.layout.framework.core.AbstractLayout;
   import org.as3commons.ui.layout.framework.core.cell.ICell;
   import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
   import org.as3commons.ui.layout.framework.core.cell.LayoutCell;
   import org.as3commons.ui.layout.framework.core.row.IRow;
   
   public class AbstractLayoutParser implements ILayoutParser
   {
       
      
      protected var _layout:AbstractLayout;
      
      protected var _layoutCell:ILayoutCell;
      
      public function AbstractLayoutParser()
      {
         super();
      }
      
      public function set layout(param1:AbstractLayout) : void
      {
         this._layout = param1;
      }
      
      public function prepare() : void
      {
         this._layoutCell = new LayoutCell();
         this._layoutCell.layoutItem = this._layout;
         this._layoutCell.config.marginX = this._layout.marginX;
         this._layoutCell.config.marginY = this._layout.marginY;
         this._layoutCell.config.offsetX = this._layout.offsetX;
         this._layoutCell.config.offsetY = this._layout.offsetY;
         var _loc1_:IRow = this.createRow();
         _loc1_.isFirst = _loc1_.isLast = true;
         this._layoutCell.row = _loc1_;
      }
      
      public function parseCell(param1:ICell) : void
      {
      }
      
      public function finish() : ICell
      {
         this._layoutCell.row.measure();
         this._layoutCell.measure();
         return this._layoutCell;
      }
      
      protected function createRow() : IRow
      {
         return null;
      }
   }
}
