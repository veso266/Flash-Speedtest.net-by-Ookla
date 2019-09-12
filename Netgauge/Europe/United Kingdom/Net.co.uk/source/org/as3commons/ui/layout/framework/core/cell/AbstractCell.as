package org.as3commons.ui.layout.framework.core.cell
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.as3commons.ui.framework.core.as3commons_ui;
   import org.as3commons.ui.layout.CellConfig;
   import org.as3commons.ui.layout.constants.Align;
   import org.as3commons.ui.layout.framework.core.AbstractLayoutItem;
   import org.as3commons.ui.layout.framework.core.config.RenderConfig;
   import org.as3commons.ui.layout.framework.core.row.AbstractRowItem;
   
   public class AbstractCell extends AbstractRowItem implements ICell
   {
       
      
      protected var _layoutItem:AbstractLayoutItem;
      
      protected var _config:CellConfig;
      
      protected var _renderConfig:RenderConfig;
      
      protected var _measured:Rectangle;
      
      protected var _contentRect:Rectangle;
      
      public function AbstractCell()
      {
         super();
         this._config = new CellConfig();
      }
      
      public function set layoutItem(param1:AbstractLayoutItem) : void
      {
         this._layoutItem = param1;
      }
      
      public function get config() : CellConfig
      {
         return this._config;
      }
      
      public function set renderConfig(param1:RenderConfig) : void
      {
         this._renderConfig = param1;
      }
      
      public function get renderConfig() : RenderConfig
      {
         return this._renderConfig;
      }
      
      public function isEmpty() : Boolean
      {
         return !_space || !_space.width || !_space.height;
      }
      
      public function get contentRect() : Rectangle
      {
         return this._contentRect;
      }
      
      override public function measure() : void
      {
         _space = new Rectangle();
         this.measureCellContent();
         this._measured = _space.clone();
         if(this._config.width)
         {
            _space.width = this._config.width;
         }
         if(this._config.height)
         {
            _space.height = this._config.height;
         }
         _space.offset(this._config.marginX,this._config.marginY);
      }
      
      override public function render() : void
      {
         var _loc1_:int = this._config.marginX + this._config.offsetX;
         var _loc2_:int = this._config.marginY + this._config.offsetY;
         this._contentRect = new Rectangle();
         this._contentRect.offsetPoint(_position);
         this._contentRect.offsetPoint(this._measured.topLeft);
         this._contentRect.offset(_loc1_,_loc2_);
         this._contentRect.size = _space.size;
         var _loc3_:Point = _position.clone();
         _loc3_.offset(_loc1_,_loc2_);
         this.alignCellContent(_loc3_);
         this.renderCellContent(_loc3_);
         AbstractLayoutItem(this._layoutItem).as3commons_ui::notifyRenderFinished();
      }
      
      protected function measureCellContent() : void
      {
      }
      
      protected function renderCellContent(param1:Point) : void
      {
      }
      
      private function alignCellContent(param1:Point) : void
      {
         var _loc2_:uint = 0;
         if(this._config.hAlign != Align.LEFT)
         {
            if(this._contentRect.width > this._measured.width)
            {
               _loc2_ = this._contentRect.width - this._measured.width;
               switch(this._config.hAlign)
               {
                  case Align.CENTER:
                     param1.x = param1.x + Math.round(_loc2_ / 2);
                     break;
                  case Align.RIGHT:
                     param1.x = param1.x + _loc2_;
               }
            }
         }
         if(this._config.vAlign != Align.TOP)
         {
            if(this._contentRect.height > this._measured.height)
            {
               _loc2_ = this._contentRect.height - this._measured.height;
               switch(this._config.vAlign)
               {
                  case Align.MIDDLE:
                     param1.y = param1.y + Math.round(_loc2_ / 2);
                     break;
                  case Align.BOTTOM:
                     param1.y = param1.y + _loc2_;
               }
            }
         }
      }
   }
}
