package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public dynamic class GenericStartButton extends GenericButton
   {
      
      protected static var buttonArray:Array = new Array();
      
      protected static var buttonsDisabled = false;
       
      
      protected var _serverId:Number;
      
      public function GenericStartButton()
      {
         super();
         disabled = buttonsDisabled;
         if(buttonsDisabled)
         {
            disabledFadeIn();
         }
         else
         {
            fadeIn();
         }
         buttonArray.push(this);
         addEventListener(MouseEvent.CLICK,this._onClick);
      }
      
      static function destroyButtons() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < buttonArray.length)
         {
            buttonArray[_loc1_].locked = true;
            buttonArray[_loc1_].parent.removeChild(buttonArray[_loc1_]);
            _loc1_++;
         }
         buttonArray = new Array();
      }
      
      static function fadeOutButtons(param1:* = 0.5) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < buttonArray.length)
         {
            buttonArray[_loc2_].locked = true;
            buttonArray[_loc2_].fadeOut(param1);
            _loc2_++;
         }
      }
      
      static function disableButtons() : *
      {
         buttonsDisabled = true;
         var _loc1_:* = 0;
         while(_loc1_ < buttonArray.length)
         {
            buttonArray[_loc1_].disabled = true;
            _loc1_++;
         }
      }
      
      static function enableButtons() : *
      {
         buttonsDisabled = false;
         var _loc1_:* = 0;
         while(_loc1_ < buttonArray.length)
         {
            buttonArray[_loc1_].disabled = false;
            _loc1_++;
         }
      }
      
      public function get serverId() : Number
      {
         return this._serverId;
      }
      
      public function set serverId(param1:Number) : *
      {
         this._serverId = param1;
      }
      
      override public function destroy() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ < buttonArray.length)
         {
            if(buttonArray[_loc1_] == this)
            {
               buttonArray.splice(_loc1_,1);
               break;
            }
            _loc1_++;
         }
         super.destroy();
      }
      
      override public function set display(param1:String) : *
      {
         super.display = param1;
         (this.getChildByName("labelText") as MovieClip).txt.text = param1;
      }
      
      protected function _onClick(param1:MouseEvent) : *
      {
         if(locked)
         {
            return;
         }
         locked = true;
         enabled = false;
         SpeedTestView.getView().startTest(this._serverId);
      }
   }
}
