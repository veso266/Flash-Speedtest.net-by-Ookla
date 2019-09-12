package org.as3commons.ui.layout.framework.core.parser
{
   import org.as3commons.ui.layout.CellConfig;
   import org.as3commons.ui.layout.framework.core.cell.ICell;
   import org.as3commons.ui.layout.framework.core.config.CellConfigMerge;
   import org.as3commons.ui.layout.framework.core.row.IRow;
   
   public class AbstractMultilineLayoutParser extends AbstractLayoutParser
   {
       
      
      protected var _subRow:IRow;
      
      public function AbstractMultilineLayoutParser()
      {
         super();
      }
      
      override public function prepare() : void
      {
         super.prepare();
         this._subRow = this.createSubRow();
      }
      
      override public function parseCell(param1:ICell) : void
      {
         var _loc2_:CellConfig = null;
         param1.measure();
         if(param1.isEmpty())
         {
            return;
         }
         if(!this._subRow.accepts(param1,this.getCellConfig(this._subRow.numItems,_layoutCell.row.numItems)))
         {
            this.finishSubRow();
            this._subRow = this.createSubRow();
         }
         _loc2_ = this.getCellConfig(this._subRow.numItems,_layoutCell.row.numItems);
         if(_loc2_)
         {
            CellConfigMerge.merge(param1.config,_loc2_);
            param1.measure();
         }
         this._subRow.add(param1);
      }
      
      override public function finish() : ICell
      {
         this.finishSubRow();
         return super.finish();
      }
      
      protected function getCellConfig(param1:uint, param2:uint) : CellConfig
      {
         return _layout.getCellConfig(param1,param2);
      }
      
      protected function createSubRow() : IRow
      {
         return null;
      }
      
      private function finishSubRow() : void
      {
         this._subRow.measure();
         this._subRow.parentRow = _layoutCell.row;
         _layoutCell.row.add(this._subRow);
      }
   }
}
