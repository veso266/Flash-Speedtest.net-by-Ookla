package org.as3commons.ui.layout.framework.core.cell
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.as3commons.ui.layout.framework.core.row.IRow;
   
   public class LayoutCell extends AbstractCell implements ILayoutCell
   {
       
      
      private var _row:IRow;
      
      public function LayoutCell()
      {
         super();
      }
      
      public function set row(param1:IRow) : void
      {
         this._row = param1;
      }
      
      public function get row() : IRow
      {
         return this._row;
      }
      
      override public function get visibleRect() : Rectangle
      {
         return this._row.visibleRect;
      }
      
      override protected function measureCellContent() : void
      {
         _space = this.row.space.clone();
      }
      
      override protected function renderCellContent(param1:Point) : void
      {
         this._row.position.x = param1.x;
         this._row.position.y = param1.y;
         this._row.render();
      }
   }
}
