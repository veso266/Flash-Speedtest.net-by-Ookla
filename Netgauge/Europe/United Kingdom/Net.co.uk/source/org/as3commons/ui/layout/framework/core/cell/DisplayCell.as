package org.as3commons.ui.layout.framework.core.cell
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.as3commons.ui.layout.Display;
   
   public class DisplayCell extends AbstractCell
   {
       
      
      private var _visibleRect:Rectangle;
      
      public function DisplayCell()
      {
         super();
      }
      
      override protected function measureCellContent() : void
      {
         _space.width = this._displayObject.width;
         _space.height = this._displayObject.height;
      }
      
      override protected function renderCellContent(param1:Point) : void
      {
         if(_renderConfig.show)
         {
            if(_renderConfig.showCallback != null)
            {
               _renderConfig.showCallback(this._displayObject);
            }
            else
            {
               this._displayObject.visible = true;
            }
         }
         if(_renderConfig.renderCallback != null)
         {
            _renderConfig.renderCallback(this._displayObject,param1.x,param1.y);
         }
         else
         {
            this._displayObject.x = param1.x;
            this._displayObject.y = param1.y;
         }
         this._visibleRect = new Rectangle(param1.x,param1.y,this._displayObject.width,this._displayObject.height);
      }
      
      override public function get visibleRect() : Rectangle
      {
         return this._visibleRect;
      }
      
      private function get _displayObject() : DisplayObject
      {
         return Display(_layoutItem).displayObject;
      }
   }
}
