package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class CustomUI
   {
      
      private static var _configuration:Configuration = null;
      
      private static var _increments:MovieClip = null;
      
      public static var clientIcon:MovieClip = null;
      
      public static var serverIcon:MovieClip = null;
      
      public static var incrementCount:Number = 9;
      
      public static var incrementSpeeds:Array = null;
      
      public static var defaultIncrements:Array = null;
      
      public static var customDecimalSeparator:String = null;
      
      private static var speedUnit:Number = 16 + 32;
      
      private static var speedPrecision:Number = 0;
      
      private static var displayUnit = "";
       
      
      public function CustomUI()
      {
         super();
      }
      
      public static function setIncrements(param1:*, param2:String = "") : *
      {
         _increments = param1;
         if(_configuration != null)
         {
            return doIncrements(param2);
         }
      }
      
      public static function configureIcons(param1:MovieClip, param2:MovieClip) : *
      {
         clientIcon = param1;
         serverIcon = param2;
      }
      
      public static function doIncrements(param1:String = "") : *
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         Logger.info("setting up increments");
         var _loc2_:* = _configuration.getSettingArray("interface");
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.size = TestConfigurator.getRangeInt(_loc2_.incrementunitsize,0,15,9);
         var _loc4_:* = TestConfigurator.getIntArray(_loc2_[param1 + "increments"],incrementCount,null);
         var _loc5_:* = TestConfigurator.getStringArray(_loc2_[param1 + "incrementdisplay"],incrementCount,null);
         if(_loc4_ != null)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_.length)
            {
               _loc8_ = _loc4_[_loc7_];
               if(_loc7_ == 0)
               {
                  if(_loc8_ != 0)
                  {
                     _loc4_ = null;
                     break;
                  }
               }
               else if(_loc8_ <= _loc4_[_loc7_ - 1])
               {
                  _loc4_ = null;
                  break;
               }
               _loc7_++;
            }
         }
         if(_loc4_ == null)
         {
            _loc9_ = Math.round(TestConfigurator.getNumber(_loc2_[param1 + "incrementtemplate"]));
            _loc5_ = null;
            _loc10_ = getKiloFactor();
            switch(incrementCount)
            {
               case 9:
                  switch(_loc9_)
                  {
                     case 10000000:
                        _loc4_ = new Array(0,256,512,1 * _loc10_,2 * _loc10_,3 * _loc10_,5 * _loc10_,8 * _loc10_,10 * _loc10_);
                        break;
                     case 50000000:
                        _loc4_ = new Array(0,512,1 * _loc10_,3 * _loc10_,5 * _loc10_,10 * _loc10_,20 * _loc10_,30 * _loc10_,50 * _loc10_);
                        break;
                     case 100000000:
                        _loc4_ = new Array(0,1 * _loc10_,3 * _loc10_,5 * _loc10_,10 * _loc10_,20 * _loc10_,30 * _loc10_,50 * _loc10_,100 * _loc10_);
                        break;
                     case 500000000:
                        _loc4_ = new Array(0,5 * _loc10_,10 * _loc10_,30 * _loc10_,50 * _loc10_,100 * _loc10_,200 * _loc10_,300 * _loc10_,500 * _loc10_);
                        break;
                     case 1000000000:
                        _loc4_ = new Array(0,10 * _loc10_,30 * _loc10_,50 * _loc10_,100 * _loc10_,200 * _loc10_,300 * _loc10_,500 * _loc10_,_loc10_ * _loc10_);
                        break;
                     case 20000000:
                        _loc4_ = new Array(0,256,512,1 * _loc10_,1.5 * _loc10_,3 * _loc10_,5 * _loc10_,10 * _loc10_,20 * _loc10_);
                        break;
                     default:
                        if(defaultIncrements != null)
                        {
                           _loc4_ = defaultIncrements;
                        }
                        else
                        {
                           _loc4_ = new Array(0,256,512,1 * _loc10_,1.5 * _loc10_,3 * _loc10_,5 * _loc10_,10 * _loc10_,20 * _loc10_);
                        }
                  }
                  break;
               default:
                  _loc4_ = defaultIncrements;
            }
         }
         if(param1 == "")
         {
            incrementSpeeds = _loc4_;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc11_ = _loc4_[_loc6_];
            if(_loc5_ != null)
            {
               formatSpeed(_increments["inc" + _loc6_],_loc3_,_loc11_,_loc6_,_loc4_.length,_loc5_[_loc6_]);
            }
            else
            {
               formatSpeed(_increments["inc" + _loc6_],_loc3_,_loc11_,_loc6_,_loc4_.length);
            }
            _loc6_++;
         }
         return _loc4_;
      }
      
      public static function formatSpeed(param1:TextField, param2:TextFormat, param3:Number, param4:Number, param5:Number, param6:String = null) : *
      {
         var _loc8_:* = null;
         var _loc9_:String = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:String = null;
         var _loc7_:* = _configuration.getSettingArray("interface");
         if(param6 != null)
         {
            _loc9_ = param6;
            _loc11_ = 0;
            _loc12_ = 0;
            while(_loc12_ < _loc9_.length)
            {
               _loc13_ = _loc9_.charCodeAt(_loc12_);
               if(_loc13_ >= 48 && _loc13_ <= 57 || _loc13_ == 46)
               {
                  _loc11_++;
                  _loc12_++;
                  continue;
               }
               break;
            }
            _loc8_ = _loc9_.substring(_loc11_);
         }
         else
         {
            if(param3 == 0)
            {
               _loc8_ = TestConfigurator.getString(_loc7_.incrementzero,"");
            }
            else if(param3 < getKiloFactor())
            {
               _loc8_ = TestConfigurator.getString(_loc7_.incrementkilo,"k");
            }
            else if(param3 < getKiloFactor() * getKiloFactor())
            {
               param3 = param3 / getKiloFactor();
               _loc8_ = TestConfigurator.getString(_loc7_.incrementmega,"M");
            }
            else
            {
               param3 = param3 / (getKiloFactor() * getKiloFactor());
               _loc8_ = TestConfigurator.getString(_loc7_.incrementgiga,"G");
            }
            if(param4 == param5 - 1 && !TestConfigurator.getBoolean(_loc7_.incrementnoplus,false))
            {
               _loc8_ = _loc8_ + "+";
            }
            _loc14_ = param3.toString();
            if(customDecimalSeparator != null)
            {
               _loc14_ = _loc14_.split(".").join(customDecimalSeparator);
            }
            if(param2.size == 0)
            {
               _loc8_ = "";
            }
            if(param4 == 0 && TestConfigurator.getBoolean(_loc7_.incrementnozero,false))
            {
               _loc9_ = "";
            }
            else
            {
               _loc9_ = _loc14_ + _loc8_;
            }
         }
         _loc10_ = _loc9_.length;
         param1.text = _loc9_;
         if(_loc8_.length != 0)
         {
            param1.setTextFormat(param2,_loc10_ - _loc8_.length,_loc10_);
         }
      }
      
      public static function displayFinalSpeed(param1:*, param2:*, param3:*, param4:*, param5:*, param6:*) : *
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         param1.text = param2;
         var _loc7_:* = param1.textWidth;
         if(param6 == undefined)
         {
            param6 = "  ";
         }
         _loc8_ = param6 + param3;
         param1.text = param2 + _loc8_;
         _loc9_ = param1.length;
         param1.setTextFormat(param4,_loc9_ - _loc8_.length,_loc9_);
         _loc10_ = param1.textWidth;
         if(param5)
         {
            param1._x = (_loc10_ - _loc7_) / 2;
         }
      }
      
      public static function displayFinalSpeed2(param1:*, param2:*, param3:*, param4:TextFormat, param5:Boolean) : *
      {
         param1.text = param2;
         var _loc6_:* = param1.textWidth;
         param1.text = param2 + param3;
         var _loc7_:* = param1.length;
         param1.setTextFormat(param4,_loc7_ - param3.length,_loc7_);
         var _loc8_:* = param1.textWidth;
         if(param5)
         {
            param1.x = (_loc8_ - _loc6_) / 2;
         }
      }
      
      public static function setInterfaceSettings(param1:Configuration) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _configuration = param1;
         doSpeedConfiguration(param1);
         if(clientIcon != null)
         {
            doIconConfiguration("client","person");
         }
         if(serverIcon != null)
         {
            doIconConfiguration("server","pyramid");
         }
         if(_increments != null)
         {
            doIncrements();
         }
         _loc2_ = _configuration.getSettingArray("interface");
         _loc3_ = TestConfigurator.getBoolean(_loc2_.showborder,true);
      }
      
      private static function doIconConfiguration(param1:*, param2:*) : *
      {
         var _loc3_:* = _configuration.getSettingArray("interface");
         var _loc4_:* = TestConfigurator.getString(_loc3_[param1 + "icon"],param2);
         setIcon(param1,_loc4_);
      }
      
      public static function getIcon(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         switch(param1)
         {
            case "server":
               _loc2_ = "person";
               break;
            case "client":
               _loc2_ = "pyramid";
         }
         _loc3_ = _configuration.getSettingArray("interface");
         _loc4_ = TestConfigurator.getString(_loc3_[param1 + "icon"],_loc2_);
         return _loc4_;
      }
      
      public static function setIcon(param1:*, param2:*) : *
      {
         switch(param1)
         {
            case "server":
               try
               {
                  serverIcon.gotoAndStop(param2);
                  serverIcon.glow.glow.gotoAndStop(param2);
               }
               catch(e:Error)
               {
               }
               break;
            case "client":
               try
               {
                  clientIcon.gotoAndStop(param2);
                  clientIcon.glow.glow.gotoAndStop(param2);
               }
               catch(e:Error)
               {
               }
         }
      }
      
      public static function iconAction(param1:String, param2:String) : *
      {
         switch(param1)
         {
            case "server":
               serverIcon.glow.glow.glow.gotoAndPlay(param2);
               break;
            case "client":
               clientIcon.glow.glow.glow.gotoAndPlay(param2);
         }
      }
      
      private static function doSpeedConfiguration(param1:Configuration) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = param1.getSettingArray("interface");
         var _loc3_:String = TestConfigurator.getString(_loc2_.template,"kbps");
         switch(_loc3_.toLowerCase())
         {
            case "mbps":
               speedUnit = 80;
               speedPrecision = 2;
               break;
            case "hybridkbps":
            case "hybrid":
               speedUnit = 1024 + 48;
               speedPrecision = 2;
               break;
            case "hybridmbps":
               speedUnit = 1024 + 80;
               speedPrecision = 2;
               break;
            case "kbs":
               speedUnit = 40;
               speedPrecision = 1;
               break;
            case "mbs":
               speedUnit = 72;
               speedPrecision = 3;
               break;
            default:
            case "kbps":
               speedUnit = 48;
               speedPrecision = 0;
         }
         _loc4_ = TestConfigurator.getBoolean(_loc2_.binaryprefix,false);
         if(_loc4_)
         {
            speedUnit = speedUnit + 256;
         }
         speedUnit = TestConfigurator.getRangeInt(_loc2_.speedunit,1,1023,speedUnit);
         speedPrecision = TestConfigurator.getRangeInt(_loc2_.speedprecision,0,5,speedPrecision);
         displayUnit = TestConfigurator.getString(_loc2_.displayspeedunit,displayUnit);
         _loc5_ = TestConfigurator.getString(_loc2_.decimalseparator,null);
         if(_loc5_ != null)
         {
            customDecimalSeparator = _loc5_;
         }
      }
      
      public static function getKiloFactor() : Number
      {
         if(speedUnit & Tools.UNIT_BINARY)
         {
            return 1024;
         }
         return 1000;
      }
      
      public static function formatDecimal(param1:*) : *
      {
         if(customDecimalSeparator != null)
         {
            return String(param1).split(".").join(customDecimalSeparator);
         }
         return param1;
      }
      
      public static function displaySpeed(param1:*, param2:*) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(isHybrid())
         {
            if(param2 == "gauge")
            {
               if((speedUnit & (Tools.UNIT_BITS | Tools.UNIT_MEGA)) == (Tools.UNIT_BITS | Tools.UNIT_MEGA))
               {
                  _loc3_ = Tools.round(Tools.convertSpeed(param1,Tools.UNIT_INPUT,speedUnit & ~1024),speedPrecision);
                  return formatDecimal(_loc3_);
               }
               return Math.round(Tools.convertSpeed(param1,Tools.UNIT_INPUT,speedUnit & ~1024));
            }
            if(Tools.speedInKbps(param1) > getKiloFactor())
            {
               _loc4_ = Tools.round(Tools.convertSpeed(param1,Tools.UNIT_INPUT,speedUnit & ~(1024 | 32) | (Tools.UNIT_BITS | Tools.UNIT_MEGA)),speedPrecision);
               return formatDecimal(_loc4_);
            }
            return Math.round(Tools.convertSpeed(param1,Tools.UNIT_INPUT,speedUnit & ~(1024 | 64) | (Tools.UNIT_BITS | Tools.UNIT_KILO)));
         }
         if(speedPrecision)
         {
            _loc5_ = Tools.round(Tools.convertSpeed(param1,Tools.UNIT_INPUT,speedUnit),speedPrecision);
            return formatDecimal(_loc5_);
         }
         return Math.round(Tools.convertSpeed(param1,Tools.UNIT_INPUT,speedUnit));
      }
      
      public static function isHybrid() : *
      {
         return (speedUnit & Tools.UNIT_HYBRID) > 0;
      }
      
      public static function displaySpeedUnit(param1:*, param2:*) : *
      {
         if(displayUnit.length)
         {
            return displayUnit;
         }
         switch(true)
         {
            case (speedUnit & Tools.UNIT_HYBRID) > 0:
               if(param2 == "gauge")
               {
                  if((speedUnit & (Tools.UNIT_BITS | Tools.UNIT_MEGA)) == (Tools.UNIT_BITS | Tools.UNIT_MEGA))
                  {
                     return Translation.getText("mbps");
                  }
                  return Translation.getText("kbps");
               }
               if(Tools.speedInKbps(param1) > getKiloFactor())
               {
                  return Translation.getText("mbps");
               }
               return Translation.getText("kbps");
            default:
               switch(speedUnit)
               {
                  case 560:
                  case 304:
                  case 48:
                     return Translation.getText("kbps");
                  case 592:
                  case 336:
                  case 80:
                     return Translation.getText("mbps");
                  case 552:
                  case 296:
                  case 40:
                     return "kB/s";
                  case 584:
                  case 328:
                  case 72:
                     return "MB/s";
                  default:
                     return "";
               }
         }
      }
   }
}
