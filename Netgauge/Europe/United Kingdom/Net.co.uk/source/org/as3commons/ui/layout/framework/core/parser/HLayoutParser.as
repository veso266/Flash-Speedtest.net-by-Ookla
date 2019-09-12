package org.as3commons.ui.layout.framework.core.parser
{
   import org.as3commons.ui.layout.framework.IHLayout;
   import org.as3commons.ui.layout.framework.core.row.HRow;
   import org.as3commons.ui.layout.framework.core.row.IRow;
   import org.as3commons.ui.layout.framework.core.row.VRow;
   
   public class HLayoutParser extends AbstractMultilineLayoutParser
   {
       
      
      public function HLayoutParser()
      {
         super();
      }
      
      override protected function createRow() : IRow
      {
         var _loc1_:IRow = new VRow();
         _loc1_.config.minHeight = _layout.minHeight;
         _loc1_.config.gap = IHLayout(_layout).vGap;
         _loc1_.config.vAlign = _layout.vAlign;
         return _loc1_;
      }
      
      override protected function createSubRow() : IRow
      {
         var _loc1_:IRow = new HRow();
         _loc1_.config.minWidth = _layout.minWidth;
         _loc1_.config.maxContentSize = IHLayout(_layout).maxContentWidth;
         _loc1_.config.maxItems = IHLayout(_layout).maxItemsPerRow;
         _loc1_.config.gap = IHLayout(_layout).hGap;
         _loc1_.config.hAlign = _layout.hAlign;
         _loc1_.config.vAlign = _layout.vAlign;
         return _loc1_;
      }
   }
}
