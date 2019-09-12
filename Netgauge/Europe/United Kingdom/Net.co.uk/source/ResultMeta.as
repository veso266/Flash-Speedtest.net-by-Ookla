package
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ResultMeta extends MovieClip
   {
      
      public static var metaPositionX:Number = 10;
      
      public static var metaPositionY:Number = 365;
       
      
      public var top:MovieClip;
      
      public var bottom:MovieClip;
      
      public function ResultMeta(param1:Configuration, param2:SpeedTestController)
      {
         var _loc9_:Array = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:Array = null;
         super();
         addFrameScript(0,this.frame1);
         var _loc3_:* = param2.getResults();
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:* = "";
         var _loc7_:* = "";
         var _loc8_:* = TestConfigurator.getRangeInt(param1.getSetting("interface","displayserver"),0,2,2);
         if(_loc8_ == 1 || _loc8_ == 2 && param2.getButtonCount() > 1)
         {
            _loc4_ = true;
            _loc9_ = new Array();
            _loc10_ = param1.getServerName(_loc3_.serverindex);
            _loc11_ = param1.getServerLocation(_loc3_.serverindex);
            if(_loc10_ != undefined && _loc10_ != "")
            {
               _loc9_.push(_loc10_);
            }
            if(_loc11_ != undefined && _loc11_ != "")
            {
               _loc9_.push(_loc11_);
            }
            _loc7_ = _loc9_.join(" - ");
         }
         if(_loc3_.clientip != undefined)
         {
            _loc5_ = true;
            _loc12_ = new Array();
            if(_loc3_.clientip != undefined && _loc3_.clientip != "")
            {
               _loc12_.push(_loc3_.clientip);
            }
            if(_loc3_.clientisp != undefined && _loc3_.clientisp != "")
            {
               _loc12_.push(_loc3_.clientisp);
            }
            _loc6_ = _loc12_.join(" - ");
         }
         if(_loc5_ == true && _loc4_ == true)
         {
            this.setClient(this.top,_loc6_);
            this.setServer(this.bottom,_loc7_);
         }
         else if(_loc5_)
         {
            this.hide(this.top);
            this.setClient(this.bottom,_loc6_);
         }
         else if(_loc4_)
         {
            this.hide(this.top);
            this.setServer(this.bottom,_loc7_);
         }
         else
         {
            this.hide(this.top);
            this.hide(this.bottom);
         }
      }
      
      static function addResultMeta(param1:Configuration, param2:SpeedTestController) : *
      {
         var _loc3_:Point = DocumentClass.document.getSize();
         var _loc4_:* = new ResultMeta(param1,param2);
         _loc4_.x = metaPositionX;
         _loc4_.y = metaPositionY;
         _loc4_.name = "resultmeta";
         DocumentClass.document.addChild(_loc4_);
      }
      
      static function removeResultMeta() : *
      {
         if(NetGaugeUI.ng.getChild("resultmeta") != null)
         {
            Tools.fadeOutAndDelete(NetGaugeUI.ng.getChild("resultmeta"));
         }
      }
      
      protected function hide(param1:MovieClip) : *
      {
         param1.alpha = 0;
      }
      
      protected function setClient(param1:MovieClip, param2:String) : *
      {
         Translation.translate(param1.meta.label,"meta_client");
         param1.meta.metadata.text = param2;
         param1.icon.gotoAndStop(CustomUI.getIcon("client"));
      }
      
      protected function setServer(param1:MovieClip, param2:String) : *
      {
         Translation.translate(param1.meta.label,"meta_server");
         param1.meta.metadata.text = param2;
         param1.icon.gotoAndStop(CustomUI.getIcon("server"));
      }
      
      function frame1() : *
      {
         stop();
      }
   }
}
