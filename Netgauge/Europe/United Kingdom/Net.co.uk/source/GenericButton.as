package
{
   import com.greensock.TweenLite;
   import fl.transitions.easing.None;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class GenericButton extends MovieClip
   {
      
      public static var disabledAlpha = 0.3;
       
      
      protected var _display:String = "";
      
      protected var _locked:Boolean = false;
      
      protected var _disabled:Boolean = false;
      
      protected var currentTween:TweenLite = null;
      
      public function GenericButton()
      {
         super();
         useHandCursor = true;
         buttonMode = true;
         this.locked = false;
         blendMode = "layer";
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,this._onRollOver);
         addEventListener(MouseEvent.MOUSE_OUT,this._onRollOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this._onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this._onMouseUp);
      }
      
      public function get disabled() : Boolean
      {
         return this._disabled;
      }
      
      public function set disabled(param1:Boolean) : *
      {
         this._disabled = param1;
         this.locked = param1;
         if(this._disabled)
         {
            alpha = disabledAlpha;
         }
         else
         {
            alpha = 1;
         }
      }
      
      public function disabledFadeIn(param1:* = 0.5) : *
      {
         this.currentTween = TweenLite.to(this,param1,{
            "alpha":disabledAlpha,
            "ease":None.easeNone
         });
      }
      
      public function fadeIn(param1:* = 0.5) : *
      {
         this.currentTween = TweenLite.to(this,param1,{
            "alpha":1,
            "ease":None.easeNone
         });
      }
      
      public function fadeOut(param1:* = 0.5) : *
      {
         var _loc2_:TweenLite = TweenLite.to(this,param1,{
            "alpha":0,
            "ease":None.easeNone,
            "onComplete":this.destroy
         });
      }
      
      public function get display() : String
      {
         return this._display;
      }
      
      public function set display(param1:String) : *
      {
         this._display = param1;
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(param1:Boolean) : *
      {
         this._locked = param1;
         this.enabled = !param1;
      }
      
      protected function _onRollOver(param1:MouseEvent) : *
      {
         if(this.locked)
         {
            return;
         }
         this.gotoAndPlay("over");
      }
      
      protected function _onRollOut(param1:MouseEvent) : *
      {
         if(this.locked)
         {
            return;
         }
         this.gotoAndPlay("out");
      }
      
      protected function _onMouseDown(param1:MouseEvent) : *
      {
         if(this.locked)
         {
            return;
         }
         this.gotoAndStop("click");
      }
      
      protected function _onMouseUp(param1:MouseEvent) : *
      {
         if(this.locked)
         {
            return;
         }
         this.gotoAndStop("hover");
      }
      
      public function destroy() : *
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this._onRollOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this._onRollOut);
         removeEventListener(MouseEvent.MOUSE_DOWN,this._onMouseDown);
         removeEventListener(MouseEvent.MOUSE_UP,this._onMouseUp);
         parent.removeChild(this);
      }
   }
}
