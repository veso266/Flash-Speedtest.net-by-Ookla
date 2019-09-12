package org.as3commons.ui.layout
{
   import org.as3commons.ui.layout.framework.IHLayout;
   import org.as3commons.ui.layout.framework.core.AbstractMultilineLayout;
   import org.as3commons.ui.layout.framework.core.cell.ILayoutCell;
   import org.as3commons.ui.layout.framework.core.parser.HLayoutParser;
   import org.as3commons.ui.layout.framework.core.parser.ILayoutParser;
   
   public class HLayout extends AbstractMultilineLayout implements IHLayout
   {
       
      
      private var _maxItemsPerRow:uint;
      
      private var _maxContentWidth:uint;
      
      public function HLayout()
      {
         super();
      }
      
      public function set maxItemsPerRow(param1:uint) : void
      {
         this._maxItemsPerRow = param1;
      }
      
      public function get maxItemsPerRow() : uint
      {
         return this._maxItemsPerRow;
      }
      
      public function set maxContentWidth(param1:uint) : void
      {
         this._maxContentWidth = param1;
      }
      
      public function get maxContentWidth() : uint
      {
         return this._maxContentWidth;
      }
      
      public function get numLayoutRows() : uint
      {
         return !!_cell?uint(ILayoutCell(_cell).row.numItems):uint(0);
      }
      
      override public function toString() : String
      {
         return "[HLayout]" + super.toString();
      }
      
      override protected function createParser() : ILayoutParser
      {
         var _loc1_:ILayoutParser = new HLayoutParser();
         return _loc1_;
      }
   }
}
