package
{
   class TestConfigurator
   {
       
      
      function TestConfigurator()
      {
         super();
      }
      
      public static function getSocketHost(param1:String) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Array = param1.split(":");
         return _loc2_[0];
      }
      
      public static function getSocketPort(param1:String) : int
      {
         if(param1 == null)
         {
            return 0;
         }
         var _loc2_:Array = param1.split(":");
         if(_loc2_.length > 1)
         {
            return getRangeInt(_loc2_[1],1,65536,8080);
         }
         return 8080;
      }
      
      public static function parseXML(param1:*) : String
      {
         if(param1.length())
         {
            return param1.toString();
         }
         return null;
      }
      
      public static function getNumber(param1:*) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(typeof param1 == "xml")
         {
            param1 = parseXML(param1);
         }
         if(param1 == null)
         {
            return Number.NaN;
         }
         if(isNaN(param1))
         {
            if(param1.length == 0)
            {
               return Number.NaN;
            }
            _loc3_ = String(param1);
            _loc4_ = _loc3_.substr(0,_loc3_.length - 1).toUpperCase();
            _loc5_ = _loc3_.substr(-1,1);
            if(isNaN(_loc4_))
            {
               return Number.NaN;
            }
            switch(_loc5_)
            {
               case "K":
                  _loc2_ = Number(_loc4_) * 1000;
                  break;
               case "M":
                  _loc2_ = Number(_loc4_) * 1000000;
                  break;
               case "G":
                  _loc2_ = Number(_loc4_) * 1000000000;
                  break;
               default:
                  _loc2_ = Number(_loc4_);
            }
         }
         else
         {
            _loc2_ = Number(param1);
         }
         return _loc2_;
      }
      
      public static function isDynamic(param1:String) : *
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1.indexOf("dyn:") == 0)
         {
            return true;
         }
         return false;
      }
      
      public static function getResult(param1:*, param2:*) : *
      {
         switch(param2)
         {
            case "download":
            case "initialdownload":
            case "rtmpdownload":
            case "upload":
            case "initialupload":
               return Tools.speedInKbps(param1[param2]);
            case "clientip":
               return Tools.ipToLong(param1[param2]);
            default:
               return param1[param2];
         }
      }
      
      public static function convertInput(param1:*, param2:*) : *
      {
         switch(param1)
         {
            case "clientip":
               return Tools.ipToLong(param2);
            default:
               return param2;
         }
      }
      
      public static function evaluateCondition(param1:*) : Boolean
      {
         var _loc4_:* = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:SpeedTestController = SpeedTestController.getController();
         var _loc3_:* = _loc2_.getResults();
         while(true)
         {
            loop0:
            for(_loc4_ in param1)
            {
               if(_loc4_ == "value" || _loc4_ == "name")
               {
                  continue;
               }
               if(_loc3_[_loc4_] == null)
               {
                  Logger.debug("result " + _loc4_ + " missing");
                  return false;
               }
               _loc5_ = getResult(_loc3_,_loc4_);
               _loc6_ = param1[_loc4_];
               _loc7_ = _loc6_.substring(0,1);
               _loc8_ = _loc6_.substring(1);
               switch(_loc7_)
               {
                  case "<":
                  case "-":
                     _loc8_ = convertInput(_loc4_,_loc8_);
                     if(isNaN(_loc8_))
                     {
                        return false;
                     }
                     if(Number(_loc8_) <= _loc5_)
                     {
                        return false;
                     }
                     continue;
                  case ">":
                  case "+":
                     _loc8_ = convertInput(_loc4_,_loc8_);
                     if(isNaN(_loc8_))
                     {
                        return false;
                     }
                     if(Number(_loc8_) >= _loc5_)
                     {
                        return false;
                     }
                     continue;
                  case "=":
                     _loc8_ = convertInput(_loc4_,_loc8_);
                     if(isNaN(_loc8_))
                     {
                        return false;
                     }
                     if(Number(_loc8_) != _loc5_)
                     {
                        return false;
                     }
                     continue;
                  case "/":
                     _loc9_ = _loc8_.split("-");
                     if(_loc9_.length != 2)
                     {
                        return false;
                     }
                     _loc9_[0] = convertInput(_loc4_,_loc9_[0]);
                     _loc9_[1] = convertInput(_loc4_,_loc9_[1]);
                     if(isNaN(_loc9_[0]) || isNaN(_loc9_[1]))
                     {
                        return false;
                     }
                     if(Number(_loc9_[0]) > _loc5_)
                     {
                        return false;
                     }
                     if(Number(_loc9_[1]) <= _loc5_)
                     {
                        return false;
                     }
                     continue;
                  default:
                     break loop0;
               }
            }
            return true;
         }
         return false;
      }
      
      public static function getDynamic(param1:String) : String
      {
         var _loc3_:* = undefined;
         var _loc4_:SpeedTestController = null;
         var _loc5_:CustomConfiguration = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc2_:Array = param1.split(":");
         if(_loc2_.length != 2)
         {
            return null;
         }
         _loc3_ = _loc2_[1];
         _loc4_ = SpeedTestController.getController();
         _loc5_ = _loc4_.getConfiguration();
         _loc6_ = _loc5_.getSettingArrays("conditions.cond");
         if(_loc6_.length == 0 || _loc6_ == null)
         {
            return null;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc8_ = _loc6_[_loc7_];
            if(_loc8_.name == _loc3_ && _loc8_.value != undefined)
            {
               if(evaluateCondition(_loc8_))
               {
                  Logger.debug(_loc8_.name + ": " + _loc8_.value);
                  Logger.debug("Condition matched: " + param1 + " -> " + _loc8_.value);
                  return _loc8_.value;
               }
            }
            _loc7_++;
         }
         return null;
      }
      
      public static function getRangeInt(param1:*, param2:*, param3:*, param4:*) : *
      {
         var _loc5_:* = undefined;
         if(isDynamic(param1))
         {
            param1 = getDynamic(param1);
         }
         _loc5_ = getNumber(param1);
         if(isNaN(_loc5_))
         {
            return param4;
         }
         _loc5_ = Math.round(_loc5_);
         if(_loc5_ < param2)
         {
            Logger.warning("Setting value: " + _loc5_ + " lower than minimum value " + param2);
            _loc5_ = param2;
         }
         if(_loc5_ > param3)
         {
            Logger.warning("Setting value: " + _loc5_ + " higher than maximum value " + param3);
            _loc5_ = param3;
         }
         return _loc5_;
      }
      
      public static function getRangeFloat(param1:*, param2:*, param3:*, param4:*) : *
      {
         var _loc5_:* = getNumber(param1);
         if(isNaN(_loc5_))
         {
            return param4;
         }
         if(_loc5_ < param2)
         {
            Logger.warning("Setting value: " + _loc5_ + " lower than minimum value " + param2);
            _loc5_ = param2;
         }
         if(_loc5_ > param3)
         {
            Logger.warning("Setting value: " + _loc5_ + " higher than maximum value " + param3);
            _loc5_ = param3;
         }
         return _loc5_;
      }
      
      public static function getString(param1:*, param2:*) : *
      {
         if(typeof param1 == "xml")
         {
            param1 = parseXML(param1);
         }
         if(param1 == null || param1 == undefined)
         {
            return param2;
         }
         return param1;
      }
      
      public static function getBoolean(param1:*, param2:*) : *
      {
         if(isDynamic(param1))
         {
            param1 = getDynamic(param1);
         }
         if(param1 == "true" || param1 == "1")
         {
            return true;
         }
         if(param1 == "false" || param1 == "0")
         {
            return false;
         }
         return param2;
      }
      
      public static function getIntArray(param1:*, param2:*, param3:*) : *
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         if(typeof param1 == "xml")
         {
            param1 = parseXML(param1);
         }
         _loc4_ = new Array();
         if(param1 == null || param1 == "")
         {
            return param3;
         }
         _loc5_ = param1.split(" ").join("").split(",");
         if(param2 != -1 && param2 != _loc5_.length)
         {
            return param3;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc4_.push(Math.round(Number(_loc5_[_loc6_])));
            _loc6_++;
         }
         return _loc4_;
      }
      
      public static function getNumberArray(param1:*, param2:*, param3:*) : *
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         if(typeof param1 == "xml")
         {
            param1 = parseXML(param1);
         }
         _loc4_ = new Array();
         if(param1 == null || param1 == "")
         {
            return param3;
         }
         _loc5_ = param1.split(" ").join("").split(",");
         if(param2 != -1 && param2 != _loc5_.length)
         {
            return param3;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc4_.push(Number(_loc5_[_loc6_]));
            _loc6_++;
         }
         return _loc4_;
      }
      
      public static function getStringArray(param1:*, param2:*, param3:*) : *
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         if(typeof param1 == "xml")
         {
            param1 = parseXML(param1);
         }
         _loc4_ = new Array();
         if(param1 == null || param1 == "")
         {
            return param3;
         }
         _loc5_ = param1.split("|");
         if(param2 != -1 && param2 != _loc5_.length)
         {
            return param3;
         }
         return _loc5_;
      }
      
      public function configureSocketLatencyTest(param1:*, param2:*) : *
      {
         var _loc3_:* = new Object();
         var _loc4_:* = param1.getMergedSettingArrays("latency","socket-latency");
         _loc3_.timeOut = getRangeInt(_loc4_.timeout,0,1000,0);
         _loc3_.sampleSize = getRangeInt(_loc4_.testlength,0,500,10);
         _loc3_.enabled = _loc3_.sampleSize > 0;
         _loc3_.waitTime = getRangeInt(_loc4_.waittime,0,1000,50);
         var _loc5_:String = param1.getServerUrl(undefined,undefined,"socket-latency");
         _loc3_.host = getSocketHost(_loc5_);
         _loc3_.port = getSocketPort(_loc5_);
         return _loc3_;
      }
      
      public function configureSocketUploadTest(param1:*, param2:*) : *
      {
         var _loc3_:* = new Object();
         var _loc4_:* = param1.getMergedSettingArrays("upload","socket-upload");
         _loc3_.timeOut = getRangeInt(_loc4_.timeout,0,1000,0);
         _loc3_.sampleSize = getRangeInt(_loc4_.testlength,0,500,15);
         _loc3_.initialThreadCount = getRangeInt(_loc4_.initialthreads,1,16,2);
         _loc3_.minimumThreadCount = getRangeInt(_loc4_.minthreads,1,16,2);
         _loc3_.maximumThreadCount = getRangeInt(_loc4_.maxthreads,1,128,4);
         _loc3_.threadRatio = getRangeInt(_loc4_.threadratio,100000,16000000,1000000);
         _loc3_.threadAddRate = getRangeInt(_loc4_.threadaddrate,0,25,10);
         _loc3_.maxSampleSize = getRangeInt(_loc4_.maxsamplesize,64000,10000000,1000000);
         _loc3_.minSampleSize = getRangeInt(_loc4_.minsamplesize,5000,1000000,32000);
         _loc3_.startSampleSize = getRangeInt(_loc4_.startsamplesize,5000,1000000,100000);
         _loc3_.startBufferSize = getRangeInt(_loc4_.startbuffersize,1,10,1);
         _loc3_.bufferLength = getRangeInt(_loc4_.bufferlength,100,100000,3000);
         _loc3_.packetLength = getRangeInt(_loc4_.packetlength,100,100000,1000);
         _loc3_.randomDataMethod = getRangeInt(_loc4_.randomdatamethod,1,2,1);
         _loc3_.progressMethod = getRangeInt(_loc4_.progressmethod,1,2,1);
         _loc3_.progressTimerLength = getRangeInt(_loc4_.progresstimerlength,10,1000,20);
         _loc3_.maintenanceTimerLength = getRangeInt(_loc4_.maintenancetimerlength,50,10000,500);
         _loc3_.enabled = _loc3_.sampleSize > 0;
         var _loc5_:String = param1.getServerUrl(undefined,undefined,"socket-upload");
         _loc3_.host = getSocketHost(_loc5_);
         _loc3_.port = getSocketPort(_loc5_);
         var _loc6_:* = param1.getMergedMethod();
         if(_loc6_.host2 != undefined)
         {
            _loc3_.host2 = getSocketHost(_loc6_.host2);
            _loc3_.port2 = getSocketPort(_loc6_.host2);
         }
         return _loc3_;
      }
      
      public function configureSocketDownloadTest(param1:*, param2:*) : *
      {
         var _loc3_:* = new Object();
         var _loc4_:* = param1.getMergedSettingArrays("download","socket-download");
         _loc3_.timeOut = getRangeInt(_loc4_.timeout,0,1000,0);
         _loc3_.sampleSize = getRangeInt(_loc4_.testlength,0,500,15);
         _loc3_.initialThreadCount = getRangeInt(_loc4_.initialthreads,1,16,2);
         _loc3_.minimumThreadCount = getRangeInt(_loc4_.minthreads,1,16,2);
         _loc3_.maximumThreadCount = getRangeInt(_loc4_.maxthreads,1,128,4);
         _loc3_.threadRatio = getRangeInt(_loc4_.threadratio,100000,16000000,1000000);
         _loc3_.threadAddRate = getRangeInt(_loc4_.threadaddrate,0,25,10);
         _loc3_.maxSampleSize = getRangeInt(_loc4_.maxsamplesize,64000,10000000,1000000);
         _loc3_.minSampleSize = getRangeInt(_loc4_.minsamplesize,5000,1000000,32000);
         _loc3_.startSampleSize = getRangeInt(_loc4_.startsamplesize,5000,1000000,200000);
         _loc3_.startBufferSize = getRangeInt(_loc4_.startbuffersize,1,10,1);
         _loc3_.bufferLength = getRangeInt(_loc4_.bufferlength,100,100000,3000);
         _loc3_.packetLength = getRangeInt(_loc4_.packetlength,100,100000,1000);
         _loc3_.readBuffer = getRangeInt(_loc4_.readbuffer,4096,1024 * 1024,65536);
         _loc3_.progressMethod = getRangeInt(_loc4_.progressmethod,1,2,1);
         _loc3_.progressTimerLength = getRangeInt(_loc4_.progresstimerlength,10,1000,20);
         _loc3_.maintenanceTimerLength = getRangeInt(_loc4_.maintenancetimerlength,50,10000,500);
         _loc3_.enabled = _loc3_.sampleSize > 0;
         var _loc5_:String = param1.getServerUrl(undefined,undefined,"socket-download");
         _loc3_.host = getSocketHost(_loc5_);
         _loc3_.port = getSocketPort(_loc5_);
         var _loc6_:* = param1.getMergedMethod();
         if(_loc6_.host2 != undefined)
         {
            _loc3_.host2 = getSocketHost(_loc6_.host2);
            _loc3_.port2 = getSocketPort(_loc6_.host2);
         }
         return _loc3_;
      }
      
      public function configureSocketPacketLossTest(param1:*, param2:*) : *
      {
         var _loc3_:* = new Object();
         var _loc4_:String = param1.getServerUrl(undefined,undefined,"socket-packetloss");
         _loc3_.host = getSocketHost(_loc4_);
         _loc3_.port = getSocketPort(_loc4_);
         var _loc5_:* = param1.getMergedMethod();
         _loc3_.applet = getString(_loc5_.applet,"VoipApplet.jar");
         var _loc6_:* = param1.getSettingArray("linequality");
         _loc3_.sampleSize = getRangeInt(_loc6_.packetlosslength,10,500,100);
         _loc3_.waitTime = getRangeInt(_loc6_.packetlosspause,0,500,20);
         _loc3_.customer = param1.getCustomer();
         return _loc3_;
      }
      
      public function configureSocketFirewallTest(param1:*, param2:*) : *
      {
         var _loc3_:* = new Object();
         var _loc4_:String = param1.getServerUrl(undefined,undefined,"socket-firewall");
         _loc3_.host = getSocketHost(_loc4_);
         _loc3_.port = getSocketPort(_loc4_);
         var _loc5_:* = param1.getMergedMethod();
         _loc3_.applet = getString(_loc5_.applet,"VoipApplet.jar");
         _loc3_.customer = param1.getCustomer();
         return _loc3_;
      }
      
      public function configureHTTPLatencyTest(param1:*, param2:*) : *
      {
         var _loc3_:* = new Object();
         var _loc4_:* = param1.getMergedSettingArrays("latency","http-latency");
         _loc3_.timeOut = getRangeInt(_loc4_.timeout,0,1000,0);
         _loc3_.sampleSize = getRangeInt(_loc4_.testlength,0,50,10);
         _loc3_.enabled = _loc3_.sampleSize > 0;
         _loc3_.fullUrl = param1.getServerUrl(undefined,undefined,"http-latency");
         _loc3_.waitTime = getRangeInt(_loc4_.waittime,0,1000,50);
         return _loc3_;
      }
      
      public function configureHTTPInitialDownloadTest(param1:*, param2:*) : *
      {
         var _loc3_:* = new Object();
         var _loc4_:* = param1.getMergedSettingArrays("download","http-download");
         _loc3_.timeOut = getRangeInt(_loc4_.timeout,0,1000,0);
         _loc3_.sampleSize = getRangeInt(_loc4_.initialtest,0,100000000,250000);
         _loc3_.initialtestlength = getRangeInt(_loc4_.initialtestlength,0,20,0);
         _loc3_.fullUrl = param1.getServerUrl(undefined,undefined,"http-download");
         var _loc5_:* = param1.getMergedMethod();
         _loc3_.fullUrl2 = _loc5_[this.getHTTPURLPrefix() + "2"];
         _loc3_.fullUrl3 = _loc5_[this.getHTTPURLPrefix() + "3"];
         _loc3_.fullUrl4 = _loc5_[this.getHTTPURLPrefix() + "4"];
         var _loc6_:Number = this.getMaxThreadCount(_loc5_,_loc4_);
         _loc3_.enabled = _loc3_.sampleSize > 0;
         var _loc7_:* = getRangeInt(_loc4_.initialthreads,1,_loc6_,0);
         if(_loc7_ == 0)
         {
            _loc3_.threadCount = getRangeInt(_loc4_.threads,1,_loc6_,1);
         }
         else
         {
            _loc3_.threadCount = _loc7_;
         }
         _loc3_.testLength = 2;
         _loc3_.maxImageSize = getRangeInt(_loc4_.maximagesize,10000000,500000000,40000000);
         _loc3_.minImageSize = getRangeInt(_loc4_.minimagesize,10000,500000000,240000);
         _loc3_.threadPerURL = getRangeInt(_loc4_.threadsperurl,2,8,4);
         return _loc3_;
      }
      
      public function configureHTTPDownloadTest(param1:*, param2:*) : *
      {
         var _loc8_:* = undefined;
         var _loc9_:Number = NaN;
         var _loc10_:* = undefined;
         var _loc3_:* = new Object();
         var _loc4_:* = param1.getMergedSettingArrays("download","http-download");
         _loc3_.timeOut = getRangeInt(_loc4_.timeout,0,1000,0);
         var _loc5_:* = getRangeInt(_loc4_.mintestsize,1,500000000,250000);
         var _loc6_:* = getRangeInt(_loc4_.maxtestsize,_loc5_,500000000,500000000);
         var _loc7_:* = getRangeInt(_loc4_.testlength,1,500000000,10);
         if(_loc7_ < 1000)
         {
            _loc10_ = _loc7_ * (!!isNaN(param2["http-initialdownload"])?10000:param2["http-initialdownload"]);
            _loc3_.sampleSize = Math.max(Math.min(_loc10_,_loc6_),_loc5_);
            _loc3_.testLength = _loc7_;
         }
         else
         {
            _loc3_.sampleSize = _loc7_;
            _loc3_.testLength = 10;
         }
         _loc3_.fullUrl = param1.getServerUrl(undefined,undefined,"http-download");
         _loc8_ = param1.getMergedMethod();
         _loc3_.fullUrl2 = _loc8_[this.getHTTPURLPrefix() + "2"];
         _loc3_.fullUrl3 = _loc8_[this.getHTTPURLPrefix() + "3"];
         _loc3_.fullUrl4 = _loc8_[this.getHTTPURLPrefix() + "4"];
         _loc9_ = this.getMaxThreadCount(_loc8_,_loc4_);
         _loc3_.threadCount = getRangeInt(_loc4_.threads,1,_loc9_,2);
         _loc3_.maxImageSize = getRangeInt(_loc4_.maximagesize,10000000,500000000,40000000);
         _loc3_.minImageSize = getRangeInt(_loc4_.minimagesize,10000,500000000,240000);
         _loc3_.threadPerURL = getRangeInt(_loc4_.threadsperurl,2,8,4);
         return _loc3_;
      }
      
      protected function getHTTPURLPrefix() : *
      {
         return "url";
      }
      
      public function configureHTTPInitialUploadTest(param1:*, param2:*) : *
      {
         var _loc9_:* = undefined;
         var _loc10_:Number = NaN;
         var _loc11_:* = undefined;
         var _loc3_:* = new Object();
         var _loc4_:* = param1.getMergedSettingArrays("upload","http-upload");
         _loc3_.timeOut = getRangeInt(_loc4_.timeout,0,1000,0);
         var _loc5_:* = getRangeInt(_loc4_.mintestsize,0,500000000,32000);
         var _loc6_:* = getRangeInt(_loc4_.maxtestsize,_loc5_,500000000,500000000);
         var _loc7_:* = getRangeInt(_loc4_.initialtest,0,100000000,0);
         var _loc8_:* = getRangeInt(_loc4_.ratio,1,100,10);
         if(_loc7_ == 0)
         {
            _loc11_ = Math.round(2 * (!!isNaN(param2.download)?10000:param2.download) / _loc8_);
            _loc3_.sampleSize = Math.max(Math.min(_loc11_,_loc6_),_loc5_);
            _loc3_.testLength = 2;
         }
         else
         {
            _loc3_.sampleSize = _loc7_;
         }
         _loc3_.fullUrl = param1.getServerUrl(undefined,undefined,"http-upload");
         _loc9_ = param1.getMergedMethod();
         _loc3_.fullUrl2 = _loc9_[this.getHTTPURLPrefix() + "2"];
         _loc3_.fullUrl3 = _loc9_[this.getHTTPURLPrefix() + "3"];
         _loc3_.fullUrl4 = _loc9_[this.getHTTPURLPrefix() + "4"];
         _loc10_ = this.getMaxThreadCount(_loc9_,_loc4_);
         _loc3_.estimatedUploadSpeed = param2.download / _loc8_;
         _loc3_.threadCount = getRangeInt(_loc4_.threads,1,_loc10_,2);
         _loc3_.maximumChunkCount = getRangeInt(_loc4_.maxchunkcount,1,100,10);
         _loc3_.maximumSampleSize = getRangeInt(_loc4_.maxchunksize,16000,10000000,1000000);
         _loc3_.threadPerURL = getRangeInt(_loc4_.threadsperurl,2,8,4);
         return _loc3_;
      }
      
      public function configureHTTPUploadTest(param1:*, param2:*) : *
      {
         var _loc8_:* = undefined;
         var _loc9_:Number = NaN;
         var _loc10_:* = undefined;
         var _loc3_:* = new Object();
         var _loc4_:* = param1.getMergedSettingArrays("upload","http-upload");
         _loc3_.timeOut = getRangeInt(_loc4_.timeout,0,1000,0);
         var _loc5_:* = getRangeInt(_loc4_.mintestsize,1,500000000,64000);
         var _loc6_:* = getRangeInt(_loc4_.maxtestsize,_loc5_,500000000,500000000);
         var _loc7_:* = getRangeInt(_loc4_.testlength,1,500000000,10);
         if(_loc7_ < 1000)
         {
            _loc10_ = _loc7_ * (!!isNaN(param2["http-initialupload"])?10000:param2["http-initialupload"]);
            _loc3_.sampleSize = Math.max(Math.min(_loc10_,_loc6_),_loc5_);
            if(_loc3_.sampleSize == _loc10_)
            {
               _loc3_.testLength = _loc7_;
            }
         }
         else
         {
            _loc3_.sampleSize = _loc7_;
         }
         _loc3_.fullUrl = param1.getServerUrl(undefined,undefined,"http-upload");
         _loc8_ = param1.getMergedMethod();
         _loc3_.fullUrl2 = _loc8_[this.getHTTPURLPrefix() + "2"];
         _loc3_.fullUrl3 = _loc8_[this.getHTTPURLPrefix() + "3"];
         _loc3_.fullUrl4 = _loc8_[this.getHTTPURLPrefix() + "4"];
         _loc9_ = this.getMaxThreadCount(_loc8_,_loc4_);
         _loc3_.estimatedUploadSpeed = param2["http-initialupload"];
         _loc3_.threadCount = getRangeInt(_loc4_.threads,1,_loc9_,2);
         _loc3_.maximumChunkCount = getRangeInt(_loc4_.maxchunkcount,1,100,10);
         _loc3_.maximumSampleSize = getRangeInt(_loc4_.maxchunksize,16000,10000000,1000000);
         _loc3_.threadPerURL = getRangeInt(_loc4_.threadsperurl,2,8,4);
         return _loc3_;
      }
      
      public function configureHTTPHealthCheck(param1:*, param2:*) : *
      {
         var _loc3_:* = new Object();
         var _loc4_:* = param1.getMergedSettingArrays("upload","http-upload");
         _loc3_.timeOut = getRangeInt(_loc4_.timeout,0,1000,0);
         _loc3_.sampleSize = 10;
         _loc3_.fullUrl = param1.getServerUrl(undefined,undefined,"http-upload");
         _loc3_.estimatedUploadSpeed = 0;
         _loc3_.threadCount = 1;
         _loc3_.maximumChunkCount = 1;
         _loc3_.maximumSampleSize = 10;
         return _loc3_;
      }
      
      public function configureThrottlingTest(param1:*, param2:*) : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc3_:* = new Object();
         var _loc4_:* = param1.getSettingArray("throttling");
         var _loc5_:SpeedTestController = SpeedTestController.getController();
         _loc3_.sampleSize = 0;
         if(_loc5_.getCurrentMethod().toString() == "tcp")
         {
            _loc6_ = param1.getMergedSettingArrays("upload","socket-upload");
            _loc7_ = param1.getMergedSettingArrays("download","socket-download");
         }
         else
         {
            _loc6_ = param1.getMergedSettingArrays("upload","http-upload");
            _loc7_ = param1.getMergedSettingArrays("download","http-download");
         }
         _loc8_ = getRangeInt(_loc6_.testlength,1,100,10);
         _loc9_ = getRangeInt(_loc7_.testlength,1,100,10);
         _loc3_.testlength = _loc8_ + _loc9_;
         _loc3_.testlimit = getRangeInt(_loc4_.testlimit,0,1000,0);
         _loc3_.dailylimit = getRangeInt(_loc4_.dailylimit,0,1000,0);
         _loc3_.uselocalip = getBoolean(_loc4_.uselocalip,false);
         _loc3_.apiurl = getString(_loc4_.apiurl,"http://speedtest.ookla.com/api/throttle.php");
         _loc3_.clientip = param2.clientip;
         if(_loc3_.testlimit > 0 || _loc3_.dailylimit > 0)
         {
            _loc3_.enabled = true;
         }
         else
         {
            _loc3_.enabled = false;
         }
         _loc3_.customer = param1.getCustomer();
         _loc3_.serverid = param1.getServerId();
         return _loc3_;
      }
      
      protected function getMaxThreadCount(param1:*, param2:*) : *
      {
         var _loc3_:* = getRangeInt(param2.threadsperurl,2,8,4);
         var _loc4_:Number = _loc3_;
         if(param1[this.getHTTPURLPrefix() + "2"] != undefined)
         {
            _loc4_ = _loc3_ * 2;
            if(param1[this.getHTTPURLPrefix() + "3"] != undefined)
            {
               _loc4_ = _loc3_ * 3;
               if(param1[this.getHTTPURLPrefix() + "4"] != undefined)
               {
                  _loc4_ = _loc3_ * 4;
               }
            }
         }
         return _loc4_;
      }
   }
}
