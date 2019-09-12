package org.as3commons.ui.layout.framework.core.row
{
   import org.as3commons.ui.layout.constants.Align;
   
   public class HRow extends AbstractRow
   {
       
      
      public function HRow()
      {
         super();
         _x = "x";
         _y = "y";
         _width = "width";
         _height = "height";
         _align = "hAlign";
         _alignLeft = Align.LEFT;
         _alignCenter = Align.CENTER;
         _alignRight = Align.RIGHT;
         _oppositeAlign = "vAlign";
         _oppositeAlignTop = Align.TOP;
         _oppositeAlignMiddle = Align.MIDDLE;
         _oppositeAlignBottom = Align.BOTTOM;
      }
   }
}
