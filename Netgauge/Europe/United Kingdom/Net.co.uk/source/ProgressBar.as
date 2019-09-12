package
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ProgressBar extends MovieClip
   {
      
      public static const STATE_INIT:Number = 0;
      
      public static const STATE_PROGRESS:Number = 1;
      
      public static const STATE_REALPROGRESS:Number = 3;
      
      public static const STATE_COMPLETE:Number = 2;
      
      public static const STATE_SKIPPED:Number = 4;
      
      protected static var progressBars:Object = new Object();
       
      
      public var skip:MovieClip;
      
      public var icon:MovieClip;
      
      public var fill:Color01;
      
      private var _state:Number = 0;
      
      private var _progress:Number = 0;
      
      private var _label:String = "";
      
      private var _skipMessage:String = "";
      
      public function ProgressBar()
      {
         addFrameScript(0,this.frame1,120,this.frame121,125,this.frame126,145,this.frame146,179,this.frame180,199,this.frame200);
         super();
         trace("ProgressBar: " + this);
      }
      
      public static function createProgress(param1:Array) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = new ProgressBar();
            _loc5_.name = _loc4_;
            _loc5_.icon.gotoAndPlay(_loc4_);
            _loc2_.push(_loc5_);
            progressBars[_loc4_] = _loc5_;
            _loc3_++;
         }
         ButtonPlacement.placeItems(_loc2_,"progress");
      }
      
      public static function getProgressBar(param1:String) : ProgressBar
      {
         return progressBars[param1] as ProgressBar;
      }
      
      public static function fadeIn() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in progressBars)
         {
            TweenLite.to(progressBars[_loc1_],0.5,{"autoAlpha":1});
         }
      }
      
      public static function reset() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in progressBars)
         {
            progressBars[_loc1_].state = STATE_INIT;
            progressBars[_loc1_].progress = 0;
         }
      }
      
      public static function fadeOut() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in progressBars)
         {
            TweenLite.to(progressBars[_loc1_],0.5,{"autoAlpha":0});
         }
      }
      
      public static function hide() : *
      {
         var _loc1_:* = undefined;
         for(_loc1_ in progressBars)
         {
            progressBars[_loc1_].alpha = 0;
         }
      }
      
      public function set state(param1:Number) : *
      {
         trace("new state: " + param1);
         this._state = param1;
         switch(this._state)
         {
            case STATE_INIT:
               this.gotoAndStop("base");
               break;
            case STATE_PROGRESS:
               this.gotoAndPlay("activeloop");
               break;
            case STATE_REALPROGRESS:
               if(NetGaugeUI.ng.template == "classic")
               {
                  this.gotoAndStop("activefill");
               }
               else
               {
                  this._state = STATE_PROGRESS;
                  this.gotoAndPlay("activeloop");
               }
               break;
            case STATE_COMPLETE:
               if(NetGaugeUI.ng.template == "classic")
               {
                  this.gotoAndStop("complete");
               }
               else
               {
                  this.gotoAndPlay("complete");
               }
               break;
            case STATE_SKIPPED:
               this.gotoAndStop("skip");
         }
      }
      
      protected function skipMouseOver(param1:MouseEvent) : void
      {
         (this.getChildByName("skip") as MovieClip).gotoAndPlay("over");
      }
      
      protected function skipMouseOut(param1:MouseEvent) : void
      {
         (this.getChildByName("skip") as MovieClip).gotoAndPlay("out");
      }
      
      public function get state() : Number
      {
         return this._state;
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function set progress(param1:Number) : *
      {
         if(this._state != STATE_REALPROGRESS)
         {
            return;
         }
         this._progress = param1;
         this.getChildByName("fill").y = 58.75 + param1 * (31.75 - 58.75);
      }
      
      public function get display() : String
      {
         return this._label;
      }
      
      public function set display(param1:String) : *
      {
         this._label = param1;
         (this.getChildByName("label") as MovieClip).txt.text = this._label;
      }
      
      public function set skipMessage(param1:String) : *
      {
         this._skipMessage = param1;
      }
      
      override public function get width() : Number
      {
         return 25.9 * scaleX;
      }
      
      override public function get height() : Number
      {
         return 25.9 * scaleY;
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame121() : *
      {
         gotoAndPlay("activeloop");
      }
      
      function frame126() : *
      {
         stop();
      }
      
      function frame146() : *
      {
         stop();
      }
      
      function frame180() : *
      {
         gotoAndStop("complete");
      }
      
      function frame200() : *
      {
         stop();
      }
   }
}
