package org.as3commons.ui.layout
{
   import flash.display.DisplayObject;
   import org.as3commons.ui.layout.framework.IDisplay;
   import org.as3commons.ui.layout.framework.core.AbstractLayoutItem;
   import org.as3commons.ui.layout.framework.core.cell.DisplayCell;
   import org.as3commons.ui.layout.framework.core.config.RenderConfig;
   
   public class Display extends AbstractLayoutItem implements IDisplay
   {
       
      
      private var _displayObject:DisplayObject;
      
      public function Display()
      {
         super();
      }
      
      public function set displayObject(param1:DisplayObject) : void
      {
         this._displayObject = param1;
      }
      
      public function get displayObject() : DisplayObject
      {
         return this._displayObject;
      }
      
      override public function toString() : String
      {
         return "[Display]" + super.toString() + ", object:" + this._displayObject;
      }
      
      override protected function excludeLayoutItem(param1:RenderConfig) : void
      {
         if(param1.hide)
         {
            if(param1.hideCallback != null)
            {
               param1.hideCallback(this._displayObject);
            }
            else
            {
               this._displayObject.visible = false;
            }
         }
      }
      
      override protected function parseLayoutItem(param1:RenderConfig) : void
      {
         _cell = new DisplayCell();
         DisplayCell(_cell).layoutItem = this;
         _cell.renderConfig = param1;
         _cell.config.marginX = _marginX;
         _cell.config.marginY = _marginY;
         _cell.config.offsetX = _offsetX;
         _cell.config.offsetY = _offsetY;
         _cell.config.hAlign = _hAlign;
         _cell.config.vAlign = _vAlign;
      }
   }
}
