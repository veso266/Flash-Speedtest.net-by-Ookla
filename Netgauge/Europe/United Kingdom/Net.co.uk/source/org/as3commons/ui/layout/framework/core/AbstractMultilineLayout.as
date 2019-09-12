package org.as3commons.ui.layout.framework.core
{
   import org.as3commons.ui.layout.framework.IMultilineLayout;
   
   public class AbstractMultilineLayout extends AbstractLayout implements IMultilineLayout
   {
       
      
      private var _hGap:uint;
      
      private var _vGap:uint;
      
      public function AbstractMultilineLayout()
      {
         super();
      }
      
      public function set hGap(param1:uint) : void
      {
         this._hGap = param1;
      }
      
      public function get hGap() : uint
      {
         return this._hGap;
      }
      
      public function set vGap(param1:uint) : void
      {
         this._vGap = param1;
      }
      
      public function get vGap() : uint
      {
         return this._vGap;
      }
   }
}
