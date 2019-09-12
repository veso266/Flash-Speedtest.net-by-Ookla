package org.as3commons.ui.layout.framework.core.config
{
   import flash.display.Sprite;
   
   public class RenderConfig
   {
       
      
      public var container:Sprite;
      
      public var show:Boolean = false;
      
      public var hide:Boolean = false;
      
      public var renderCallback:Function;
      
      public var hideCallback:Function;
      
      public var showCallback:Function;
      
      public function RenderConfig()
      {
         super();
      }
      
      public function clone() : RenderConfig
      {
         var _loc1_:RenderConfig = new RenderConfig();
         _loc1_.container = this.container;
         _loc1_.show = this.show;
         _loc1_.hide = this.hide;
         _loc1_.renderCallback = this.renderCallback;
         _loc1_.hideCallback = this.hideCallback;
         _loc1_.showCallback = this.showCallback;
         return _loc1_;
      }
   }
}
