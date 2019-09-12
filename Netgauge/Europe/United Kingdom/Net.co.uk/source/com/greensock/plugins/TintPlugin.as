package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import com.greensock.core.PropTween;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.geom.Transform;
   
   public class TintPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
       
      
      protected var _transform:Transform;
      
      public function TintPlugin()
      {
         super();
         this.propName = "tint";
         this.overwriteProps = ["tint"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         var _loc5_:ColorTransform = null;
         if(!(param1 is DisplayObject))
         {
            return false;
         }
         var _loc4_:ColorTransform = new ColorTransform();
         if(param2 != null && param3.vars.removeTint != true)
         {
            _loc4_.color = uint(param2);
         }
         this._transform = DisplayObject(param1).transform;
         _loc5_ = this._transform.colorTransform;
         _loc4_.alphaMultiplier = _loc5_.alphaMultiplier;
         _loc4_.alphaOffset = _loc5_.alphaOffset;
         this.init(_loc5_,_loc4_);
         return true;
      }
      
      public function init(param1:ColorTransform, param2:ColorTransform) : void
      {
         var _loc4_:String = null;
         var _loc3_:int = _props.length;
         var _loc5_:int = _tweens.length;
         while(_loc3_--)
         {
            _loc4_ = _props[_loc3_];
            if(param1[_loc4_] != param2[_loc4_])
            {
               _tweens[_loc5_++] = new PropTween(param1,_loc4_,param1[_loc4_],param2[_loc4_] - param1[_loc4_],"tint",false);
            }
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc2_:ColorTransform = null;
         var _loc3_:PropTween = null;
         var _loc4_:int = 0;
         if(this._transform)
         {
            _loc2_ = this._transform.colorTransform;
            _loc4_ = _tweens.length;
            while(--_loc4_ > -1)
            {
               _loc3_ = _tweens[_loc4_];
               _loc2_[_loc3_.property] = _loc3_.start + _loc3_.change * param1;
            }
            this._transform.colorTransform = _loc2_;
         }
      }
   }
}
