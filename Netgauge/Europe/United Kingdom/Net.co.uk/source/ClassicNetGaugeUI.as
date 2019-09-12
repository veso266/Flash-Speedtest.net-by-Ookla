package
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   class ClassicNetGaugeUI extends NetGaugeUI
   {
       
      
      protected var dashPath:Path;
      
      protected var needleSpeed = 0;
      
      function ClassicNetGaugeUI()
      {
         super();
         _template = "classic";
         this.dashPath = new Path();
         this.dashPath.moveTo(-229,44.5);
         this.dashPath.curveTo(-137,3,0.2,0.7);
         this.dashPath.curveTo(163,-3,270.6,45.7);
      }
      
      override public function set speedSpeed(param1:Number) : *
      {
         super.speedSpeed = param1;
         (getChild("dash") as MovieClip).speed.gauge.speed.text = CustomUI.displaySpeed(param1,"gauge");
         var _loc2_:* = Math.abs(this.needleSpeed - param1) / Math.max(1,param1);
         if(_loc2_ > 0.01 || param1 < 4000000)
         {
            (getChild("dash") as MovieClip).speed.gauge.needle.rotation = speedToDegrees(param1);
            this.needleSpeed = param1;
         }
      }
      
      override public function latencyProgress(param1:Number) : *
      {
         var _loc5_:* = undefined;
         var _loc2_:* = new LatencyRingAnimation();
         var _loc3_:* = this.dashPath.pointAt(param1);
         var _loc4_:* = this.dashPath.angleAt(param1);
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         _loc2_.rotation = 180 + _loc4_ * (180 / Math.PI);
         (getChild("dash") as MovieClip).latencyani.addChild(_loc2_);
         if(param1 > 0.8)
         {
            _loc5_ = new LatencyRing();
            _loc5_.x = 264.95;
            _loc5_.y = 196.6;
            (getChild("dash") as MovieClip).addChildAt(_loc5_,0);
         }
      }
      
      override public function setDashTest(param1:String) : *
      {
         var _loc2_:int = 1;
         var _loc3_:* = param1;
         switch(param1)
         {
            case "download":
            case "upload":
               _loc3_ = "speed";
               break;
            case "hide":
               _loc3_ = "";
         }
         if(_loc3_ != "")
         {
            (getChild("dash") as MovieClip).gotoAndStop(_loc3_);
         }
         else
         {
            (getChild("dash") as MovieClip).gotoAndStop(0);
         }
         switch(param1)
         {
            case "download":
               (getChild("dash") as MovieClip).speed.liveresult.downloadicon.state = ProgressBar.STATE_REALPROGRESS;
               break;
            case "upload":
               (getChild("dash") as MovieClip).speed.liveresult.uploadicon.state = ProgressBar.STATE_REALPROGRESS;
               break;
            case "hide":
               _loc2_ = 0;
         }
         TweenLite.to(getChild("dash") as MovieClip,0.5,{"alpha":_loc2_});
      }
      
      override public function setSpeedProgress(param1:Number, param2:String) : *
      {
         var _loc3_:Point = null;
         if(param2 == "download")
         {
            DocumentClass.document.dash.speed.liveresult.downloadicon.progress = param1;
            param1 = 1 - param1;
         }
         else
         {
            DocumentClass.document.dash.speed.liveresult.uploadicon.progress = param1;
         }
         _loc3_ = this.dashPath.pointAt(param1);
         (getChild("dash") as MovieClip).speed.packets.packet.x = _loc3_.x;
         (getChild("dash") as MovieClip).speed.packets.packet.y = _loc3_.y;
      }
   }
}
