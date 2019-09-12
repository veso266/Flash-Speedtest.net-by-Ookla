package
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   
   public class Tools
   {
      
      public static var UNIT_INPUT:Number = 0;
      
      public static var UNIT_SECONDS:Number = 1;
      
      public static var UNIT_MINUTES:Number = 2;
      
      public static var UNIT_HOURS:Number = 4;
      
      public static var UNIT_BYTES:Number = 8;
      
      public static var UNIT_BITS:Number = 16;
      
      public static var UNIT_KILO:Number = 32;
      
      public static var UNIT_MEGA:Number = 64;
      
      public static var UNIT_GIGA:Number = 128;
      
      public static var UNIT_HYBRID:Number = 1024;
      
      public static var UNIT_BINARY:Number = 256;
      
      public static var UNIT_DECIMAL:Number = 512;
      
      public static var JS_TEST_STARTED:Number = 1;
      
      public static var JS_TEST_ERROR:Number = 2;
      
      public static var JS_TEST_COMPONENT_COMPLETE:Number = 4;
      
      public static var JS_TEST_COMPONENT_STARTED:Number = 8;
       
      
      public function Tools()
      {
         super();
      }
      
      public static function valueToDegreesCustom(param1:*, param2:*, param3:*) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         _loc4_ = 1;
         while(_loc4_ < param3.length)
         {
            if(param1 < param2[_loc4_])
            {
               _loc5_ = param2[_loc4_ - 1];
               _loc6_ = param2[_loc4_];
               _loc7_ = param3[_loc4_ - 1];
               _loc8_ = param3[_loc4_];
               _loc9_ = (param1 - _loc5_) / (_loc6_ - _loc5_) * (_loc8_ - _loc7_) + _loc7_;
               return _loc9_;
            }
            _loc4_++;
         }
         return param3[param3.length - 1];
      }
      
      public static function convertSpeed(param1:Number, param2:Number, param3:Number) : Number
      {
         param1 = Number(param1);
         var _loc4_:* = calculateUnit(param2);
         var _loc5_:* = calculateUnit(param3);
         return param1 * (_loc4_ / _loc5_);
      }
      
      public static function calculateUnit(param1:Number) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = 1;
         if(param1 & UNIT_SECONDS)
         {
            _loc2_ = _loc2_ * 1;
         }
         else if(param1 & UNIT_MINUTES)
         {
            _loc2_ = _loc2_ / 60;
         }
         else if(param1 & UNIT_HOURS)
         {
            _loc2_ = _loc2_ / 3600;
         }
         if(param1 & UNIT_BYTES)
         {
            _loc2_ = _loc2_ * 1;
         }
         else if(param1 & UNIT_BITS)
         {
            _loc2_ = _loc2_ / 8;
         }
         _loc3_ = 1000;
         if(param1 & UNIT_BINARY)
         {
            _loc3_ = 1024;
         }
         else if(param1 & UNIT_DECIMAL)
         {
            _loc3_ = 1000;
         }
         if(param1 & UNIT_KILO)
         {
            _loc2_ = _loc2_ * _loc3_;
         }
         else if(param1 & UNIT_MEGA)
         {
            _loc2_ = _loc2_ * (_loc3_ * _loc3_);
         }
         else if(param1 & UNIT_GIGA)
         {
            _loc2_ = _loc2_ * (_loc3_ * _loc3_ * _loc3_);
         }
         return _loc2_;
      }
      
      public static function speedInKbps(param1:*) : *
      {
         return Math.round(Tools.convertSpeed(param1,Tools.UNIT_INPUT,Tools.UNIT_KILO + Tools.UNIT_BITS));
      }
      
      public static function speedInMbps(param1:*) : *
      {
         return Tools.convertSpeed(param1,Tools.UNIT_INPUT,Tools.UNIT_MEGA + Tools.UNIT_BITS);
      }
      
      public static function round(param1:Number, param2:Number) : String
      {
         var _loc3_:* = undefined;
         var _loc4_:Number = NaN;
         var _loc5_:* = null;
         var _loc6_:* = undefined;
         if(isNaN(param1) || param1 == 0)
         {
            param1 = 0;
         }
         _loc3_ = Math.pow(10,param2);
         _loc4_ = Math.round(_loc3_ * param1) / _loc3_;
         _loc5_ = String(_loc4_);
         if(_loc5_.lastIndexOf(".") == -1)
         {
            _loc5_ = _loc5_ + ".";
         }
         _loc6_ = _loc5_ + "00000000000";
         _loc6_ = _loc6_.substring(0,_loc6_.lastIndexOf(".") + param2 + 1);
         return _loc6_;
      }
      
      public static function getBasePath(param1:*) : *
      {
         param1 = param1.substr(0,param1.lastIndexOf("/") + 1);
         return param1;
      }
      
      public static function getDomainName(param1:*) : *
      {
         var _loc2_:* = getHostName(param1);
         var _loc3_:Array = _loc2_.split(".");
         _loc2_ = _loc3_[_loc3_.length - 2] + "." + _loc3_[_loc3_.length - 1];
         return _loc2_;
      }
      
      public static function getHostName(param1:*) : *
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         param1 = param1.toLowerCase();
         if(param1.indexOf("?") > -1)
         {
            param1 = param1.substr(0,param1.indexOf("?"));
         }
         param1 = param1.substr(0,param1.indexOf("/",8));
         _loc2_ = param1.substr(param1.indexOf(":") + 2 + 1);
         _loc3_ = _loc2_.indexOf(":");
         if(_loc3_ > -1)
         {
            _loc2_ = _loc2_.substr(0,_loc3_);
         }
         return _loc2_;
      }
      
      public static function getHostNameWithPort(param1:*) : *
      {
         var _loc2_:String = null;
         param1 = param1.toLowerCase();
         if(param1.indexOf("?") > -1)
         {
            param1 = param1.substr(0,param1.indexOf("?"));
         }
         param1 = param1.substr(0,param1.indexOf("/",8));
         _loc2_ = param1.substr(param1.indexOf(":") + 2 + 1);
         return _loc2_;
      }
      
      public static function getTime() : *
      {
         return new Date().getTime();
      }
      
      public static function fadeIn(param1:*, param2:* = 1) : *
      {
         TweenLite.to(param1,param2,{"alpha":1});
      }
      
      public static function convertIPtoNumber(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = param1.split(".");
         if(_loc2_.length != 4)
         {
            return 0;
         }
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc2_[_loc3_] = Number(_loc2_[_loc3_]);
            _loc4_ = _loc2_[_loc3_];
            if(isNaN(_loc4_) || _loc4_ < 0 || _loc4_ > 255)
            {
               return 0;
            }
            _loc3_++;
         }
         return _loc2_[3] + 256 * (_loc2_[2] + 256 * (_loc2_[1] + 256 * _loc2_[0]));
      }
      
      public static function fadeOut(param1:*, param2:* = 1) : *
      {
         TweenLite.to(param1,param2,{"alpha":0});
      }
      
      public static function fadeOutAndDelete(param1:*, param2:* = 1) : *
      {
         var clip:* = param1;
         var time:* = param2;
         TweenLite.to(clip,time,{
            "alpha":0,
            "onComplete":function(param1:DisplayObject):void
            {
               param1.parent.removeChild(param1);
            },
            "onCompleteParams":[clip]
         });
      }
      
      public static function getBitFlag(param1:*, param2:*) : *
      {
      }
      
      public static function stringReplace(param1:String, param2:String, param3:String) : *
      {
         var _loc4_:Array = param1.split(param2);
         var _loc5_:String = _loc4_.join(param3);
         return _loc5_;
      }
      
      public static function styleTextField(param1:TextField) : *
      {
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc3_:Array = arguments.slice(1);
         if(_loc3_.length == 0)
         {
            param1.text = "";
         }
         _loc4_ = "";
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_ = _loc4_ + String(_loc3_[_loc5_].text);
            _loc5_++;
         }
         param1.text = _loc4_;
         _loc6_ = 0;
         _loc7_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc7_ = _loc6_ + String(_loc3_[_loc5_].text).length;
            param1.setTextFormat(_loc3_[_loc5_].format,_loc6_,_loc7_);
            _loc6_ = _loc7_;
            _loc5_++;
         }
      }
      
      public static function ipRangeStart(param1:String) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = param1.split("/");
         if(_loc2_.length != 2)
         {
            return 0;
         }
         _loc3_ = ipToLong(_loc2_[0]);
         if(_loc3_ == 0)
         {
            return 0;
         }
         return _loc3_;
      }
      
      public static function ipRangeStop(param1:String) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:Array = param1.split("/");
         if(_loc2_.length != 2)
         {
            return 0;
         }
         _loc3_ = ipToLong(_loc2_[0]);
         if(_loc3_ == 0)
         {
            return 0;
         }
         _loc4_ = Number(_loc2_[1]);
         if(_loc4_ > 32 || _loc4_ < 0)
         {
            return 0;
         }
         _loc5_ = Math.pow(2,32 - _loc4_) - 1;
         return _loc3_ + _loc5_;
      }
      
      public static function ipToLong(param1:String) : Number
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc3_:Array = param1.split(".");
         if(_loc3_.length != 4)
         {
            return 0;
         }
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            if(_loc3_[_loc4_] > 255 || _loc3_[_loc4_] < 0)
            {
               return 0;
            }
            _loc2_ = _loc2_ * 256;
            _loc2_ = _loc2_ + Number(_loc3_[_loc4_]);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function longToIp(param1:Number) : String
      {
         var _loc5_:Number = NaN;
         var _loc2_:Array = new Array(0,0,0,0);
         var _loc3_:Number = 16777216;
         var _loc4_:Number = 0;
         while(_loc4_ < 4)
         {
            _loc5_ = Math.floor(param1 / _loc3_);
            param1 = param1 - _loc3_ * _loc5_;
            _loc2_[_loc4_] = _loc5_;
            _loc3_ = _loc3_ / 256;
            _loc4_++;
         }
         return _loc2_.join(".");
      }
      
      public static function deepTrace(param1:*, param2:int = 0) : void
      {
         var _loc5_:* = null;
         var _loc3_:* = "";
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc4_++;
            _loc3_ = _loc3_ + "\t";
         }
         for(_loc5_ in param1)
         {
            trace(_loc3_ + "[" + _loc5_ + "] -> " + param1[_loc5_]);
            deepTrace(param1[_loc5_],param2 + 1);
         }
      }
      
      public static function fullPath(param1:DisplayObject) : String
      {
         var _loc2_:Array = new Array(param1.name);
         var _loc3_:* = param1;
         while(_loc3_.parent != null)
         {
            if(_loc3_.parent == DocumentClass.document)
            {
               break;
            }
            _loc2_.push(_loc3_.parent.name);
            _loc3_ = _loc3_.parent;
         }
         _loc2_.reverse();
         return _loc2_.join(".");
      }
      
      public static function getMedian(param1:Array) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:* = param1.slice();
         _loc2_.sort(Array.NUMERIC);
         if(_loc2_.length % 2 == 0)
         {
            _loc3_ = _loc2_[int(_loc2_.length / 2) - 1];
            _loc4_ = _loc2_[int(_loc2_.length / 2)];
            return (_loc3_ + _loc4_) / 2;
         }
         return _loc2_[int(_loc2_.length / 2)];
      }
      
      public static function getAverage(param1:Array) : Number
      {
         var _loc2_:* = 0;
         var _loc3_:* = param1.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc2_ + param1[_loc4_];
            _loc4_++;
         }
         return _loc2_ / _loc3_;
      }
      
      public static function getMinimum(param1:Array) : Number
      {
         var _loc2_:* = Number.MAX_VALUE;
         var _loc3_:* = param1.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1[_loc4_] < _loc2_)
            {
               _loc2_ = param1[_loc4_];
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function getMaximum(param1:Array) : Number
      {
         var _loc2_:* = -Number.MAX_VALUE;
         var _loc3_:* = param1.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1[_loc4_] > _loc2_)
            {
               _loc2_ = param1[_loc4_];
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function traceDisplayList(param1:DisplayObjectContainer, param2:String = "") : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:uint = 0;
         while(_loc4_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc4_);
            trace(param2,_loc3_,_loc3_.name);
            if(param1.getChildAt(_loc4_) is DisplayObjectContainer)
            {
               traceDisplayList(DisplayObjectContainer(_loc3_),param2 + "    ");
            }
            _loc4_++;
         }
      }
      
      public static function openOoklaLanding() : *
      {
         navigateToURL(new URLRequest("http://www.ookla.com/from_test.php"),"_blank");
      }
      
      public static function openOoklaSupport() : *
      {
         navigateToURL(new URLRequest("http://support.ookla.com/"),"_blank");
      }
   }
}
