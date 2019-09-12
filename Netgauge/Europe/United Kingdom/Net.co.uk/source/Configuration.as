package
{
   import com.adobe.utils.StringUtil;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   
   class Configuration
   {
      
      public static const IP_RETRIEVED:String = "ipRetrieved";
      
      public static const CONFIG_LOADED:String = "configLoaded";
      
      protected static var cachedPageURL = null;
       
      
      protected var dynamicSettings:Object;
      
      protected var templateSettings:Object;
      
      protected var url:String;
      
      protected var controller:CustomSpeedTestController;
      
      protected var onlineConfigName:String = "settings.xml";
      
      protected var configMode:String = "xml";
      
      protected var engineConfiguration:EngineConfigurationReader;
      
      protected var serverConfiguration:ServerConfigurationReader;
      
      protected var defaultAPIURL = "http://speedtest.ookla.com/api/api.php";
      
      protected var serverId = 1;
      
      protected var methodId = 0;
      
      function Configuration(param1:CustomSpeedTestController)
      {
         super();
         this.controller = param1;
         this.dynamicSettings = new Object();
         this.templateSettings = new Object();
         this.updateConfigSettings();
         this.setConfigurationLocation(1);
      }
      
      public static function getParameter(param1:String) : String
      {
         var _loc2_:String = null;
         if(_loc2_ == null && DocumentClass.document.parent.parent != null)
         {
            _loc2_ = LoaderInfo(DocumentClass.document.parent.parent.loaderInfo).parameters[param1];
         }
         if(_loc2_ == null && DocumentClass.document.parent != null)
         {
            _loc2_ = LoaderInfo(DocumentClass.document.parent.loaderInfo).parameters[param1];
         }
         if(_loc2_ == null && DocumentClass.document != null)
         {
            _loc2_ = LoaderInfo(DocumentClass.document.loaderInfo).parameters[param1];
         }
         return _loc2_;
      }
      
      public static function getParameters() : Object
      {
         var _loc1_:Object = LoaderInfo(DocumentClass.document.loaderInfo).parameters;
         if(DocumentClass.document.parent != null)
         {
            _loc1_ = LoaderInfo(DocumentClass.document.parent.loaderInfo).parameters;
         }
         if(DocumentClass.document.parent.parent != null)
         {
            _loc1_ = LoaderInfo(DocumentClass.document.parent.parent.loaderInfo).parameters;
         }
         return _loc1_;
      }
      
      public static function removeDynamic(param1:String) : String
      {
         var _loc2_:String = param1;
         var _loc3_:int = _loc2_.indexOf("/[[DYNAMIC]]/");
         var _loc4_:String = _loc3_ > 0?_loc2_.substr(0,_loc3_):_loc2_;
         return _loc4_;
      }
      
      public static function getPageURL() : String
      {
         if(cachedPageURL != null)
         {
            return cachedPageURL;
         }
         var _loc1_:String = "";
         if(ExternalInterface.available)
         {
            try
            {
               _loc1_ = cachedPageURL = ExternalInterface.call("window.location.href.toString");
            }
            catch(e:Error)
            {
            }
         }
         return _loc1_;
      }
      
      public static function mergeObjects(param1:Object, param2:Object) : Object
      {
         var _loc4_:* = undefined;
         var _loc3_:* = new Object();
         for(_loc4_ in param1)
         {
            _loc3_[_loc4_] = param1[_loc4_];
         }
         for(_loc4_ in param2)
         {
            _loc3_[_loc4_] = param2[_loc4_];
         }
         return _loc3_;
      }
      
      protected function setConfigurationLocation(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = removeDynamic(DocumentClass.document.loaderInfo.url);
         if(_loc2_.substr(0,_loc2_.indexOf(":")) == "file")
         {
            if(this.configMode == "xml")
            {
               this.url = "settings.xml";
            }
            else
            {
               this.url = "settings.json";
            }
         }
         else
         {
            switch(param1)
            {
               case 4:
                  this.url = DocumentClass.document.loaderInfo.parameters.configURL + "?x=" + Tools.getTime();
                  break;
               case 2:
                  _loc3_ = this.getBasePath();
                  this.url = _loc3_ + this.onlineConfigName + "?x=" + Tools.getTime();
                  break;
               case 1:
               default:
                  this.url = this.onlineConfigName + "?x=" + Tools.getTime();
            }
         }
      }
      
      protected function updateConfigSettings() : *
      {
         var _loc1_:* = getParameter("configMode");
         if(_loc1_ == "json")
         {
            this.configMode = "json";
            this.onlineConfigName = "settings.json";
         }
         _loc1_ = getParameter("configExtension");
         if(_loc1_ != undefined)
         {
            this.onlineConfigName = "settings." + this.stripChars(_loc1_);
         }
      }
      
      protected function onSettingsLoadComplete(param1:Event) : *
      {
         var event:Event = param1;
         Logger.info("Configuration - File Loaded");
         try
         {
            if(this.configMode == "xml")
            {
               this.engineConfiguration = new XMLEngineConfigurationReader(this.controller);
               this.engineConfiguration.parse(event.target.data);
            }
            else
            {
               this.engineConfiguration = new JSONEngineConfigurationReader(this.controller);
               this.engineConfiguration.parse(event.target.data);
            }
         }
         catch(E:Error)
         {
            Logger.error("Configuration - Parse Error");
            controller.settingsLoaded("configurationloadfailed");
            return;
         }
         try
         {
            if(this.configMode == "xml")
            {
               this.serverConfiguration = new XMLServerConfigurationReader(this.controller);
               this.serverConfiguration.parse(this.engineConfiguration.getServers());
            }
            else
            {
               this.serverConfiguration = new JSONServerConfigurationReader(this.controller);
               this.serverConfiguration.parse(this.engineConfiguration.getServers());
            }
         }
         catch(E:Error)
         {
            Logger.error("Configuration - Parse Error");
            controller.settingsLoaded("configurationloadfailed");
            return;
         }
         this.controller.settingsLoaded(this.getLicense());
      }
      
      protected function onSettingsLoadError(param1:IOErrorEvent) : *
      {
         Logger.error("Configuration - Load Failed");
         this.controller.settingsLoaded("configurationloadfailed");
      }
      
      protected function onSettingsSecurityError(param1:SecurityErrorEvent) : *
      {
         Logger.error("Configuration - Security Error");
      }
      
      public function autostart() : *
      {
         DocumentClass.document.addEventListener(Event.ENTER_FRAME,this.checkLoad);
      }
      
      public function checkLoad(param1:Event) : *
      {
         var _loc2_:* = DocumentClass.document.loaderInfo.bytesLoaded / DocumentClass.document.loaderInfo.bytesTotal;
         if(_loc2_ >= 1)
         {
            DocumentClass.document.removeEventListener(Event.ENTER_FRAME,this.checkLoad);
            Logger.info("SWF Loaded: " + DocumentClass.document.loaderInfo.bytesLoaded);
            this.start();
         }
         else
         {
            Logger.info("Loading SWF: " + _loc2_);
         }
      }
      
      public function start() : *
      {
         Logger.debug("Configuration - Loading from URL: " + this.url);
         var _loc1_:String = Configuration.getPageURL();
         Logger.debug("Current Page: " + _loc1_);
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.onSettingsLoadComplete);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onSettingsLoadError);
         _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSettingsSecurityError);
         _loc2_.load(new URLRequest(this.url));
      }
      
      public function getCustomer() : *
      {
         try
         {
            return this.getSettingValue("customer");
         }
         catch(error:Error)
         {
            return null;
         }
      }
      
      public function getLicense() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         try
         {
            _loc1_ = this.getSettingValue("licensekey");
         }
         catch(error:Error)
         {
         }
         _loc1_ = StringUtil.trim(_loc1_);
         _loc2_ = _loc1_.lastIndexOf("#");
         if(_loc2_ >= 0)
         {
            _loc1_ = _loc1_.substr(_loc2_ + 1);
         }
         return _loc1_;
      }
      
      public function testUnlocked() : *
      {
         this.parseTemplateSettings();
         this.parseDynamicSettings();
         this.getClientIp();
      }
      
      protected function parseDynamicSettings() : *
      {
         var _loc2_:* = null;
         var _loc1_:* = getParameters();
         for(_loc2_ in _loc1_)
         {
            if(StringUtil.beginsWith(_loc2_,"settings.") && _loc2_.split(".").length - 1 == 2)
            {
               this.addSetting(_loc2_.substr(9),_loc1_[_loc2_]);
            }
         }
      }
      
      protected function parseTemplateSettings() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = TestConfigurator.getString(this.getSetting("configuration","connection"),"");
         _loc1_ = TestConfigurator.getString(getParameter("connection"),_loc1_);
         if(_loc1_ != "")
         {
            _loc2_ = TemplateConfiguration.getConfiguration(_loc1_);
            if(_loc2_ != null)
            {
               this.templateSettings = _loc2_;
            }
            else
            {
               this.templateSettings = new Object();
            }
         }
      }
      
      protected function stripChars(param1:*) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:* = "";
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.charAt(_loc3_).toLowerCase();
            if(_loc4_ >= "0" && _loc4_ <= "9" || _loc4_ >= "a" && _loc4_ <= "z")
            {
               _loc2_ = _loc2_ + param1.charAt(_loc3_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getBasePath() : String
      {
         var _loc2_:* = undefined;
         var _loc1_:* = removeDynamic(DocumentClass.document.loaderInfo.url);
         if(_loc1_.lastIndexOf("/",9) > -1)
         {
            _loc2_ = _loc1_.substr(0,_loc1_.lastIndexOf("/") + 1);
         }
         else
         {
            _loc2_ = _loc1_ + "/";
         }
         return _loc2_;
      }
      
      protected function maintainProtocol(param1:String) : String
      {
         var _loc2_:* = this.getBasePath();
         var _loc3_:* = _loc2_.substring(0,_loc2_.indexOf(":"));
         if(_loc3_ == "https")
         {
            param1 = Tools.stringReplace(param1,"http://","https://");
         }
         return param1;
      }
      
      public function getAPIURL() : *
      {
         var _loc1_:* = this.getSetting("extras","apiurl");
         if(_loc1_ == undefined || _loc1_.length < 5)
         {
            _loc1_ = this.getSetting("reporting","apiurl");
         }
         if(_loc1_ != undefined && _loc1_.length > 5)
         {
            return _loc1_;
         }
         return this.maintainProtocol(this.defaultAPIURL);
      }
      
      public function isAPIURLDefault() : *
      {
         var _loc1_:* = this.getSetting("extras","apiurl");
         if(_loc1_ == undefined || _loc1_.length < 5)
         {
            _loc1_ = this.getSetting("reporting","apiurl");
         }
         if(_loc1_ != undefined && _loc1_.length > 5)
         {
            return false;
         }
         return true;
      }
      
      public function getDefaultAPIURL() : *
      {
         return this.maintainProtocol(this.defaultAPIURL);
      }
      
      public function hitDefaultAPI() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = this.getSetting("extras","apiurl");
         if(_loc1_ == undefined || _loc1_.length < 5)
         {
            _loc1_ = this.getSetting("reporting","apiurl");
         }
         _loc2_ = TestConfigurator.getBoolean(this.getSetting("extras","hitdefaultapi"),false);
         _loc2_ = TestConfigurator.getBoolean(this.getSetting("reporting","hitdefaultapi"),_loc2_);
         if(_loc1_ != undefined && _loc1_.length > 5 && _loc2_)
         {
            return true;
         }
         return false;
      }
      
      public function addSetting(param1:String, param2:*) : *
      {
         var _loc3_:Array = param1.split(".",2);
         if(!this.dynamicSettings.hasOwnProperty(_loc3_[0]))
         {
            this.dynamicSettings[_loc3_[0]] = new Object();
         }
         this.dynamicSettings[_loc3_[0]][_loc3_[1]] = String(param2);
         Logger.debug("DYNSET: " + _loc3_[0] + "." + _loc3_[1] + " = " + this.dynamicSettings[_loc3_[0]][_loc3_[1]]);
      }
      
      protected function getTemplateSetting(param1:String) : *
      {
         var _loc2_:Array = param1.split(".",2);
         if(!this.templateSettings.hasOwnProperty(_loc2_[0]))
         {
            return null;
         }
         if(!this.templateSettings[_loc2_[0]].hasOwnProperty(_loc2_[1]))
         {
            return null;
         }
         return this.templateSettings[_loc2_[0]][_loc2_[1]];
      }
      
      protected function getDynamicSetting(param1:String) : *
      {
         var _loc2_:Array = param1.split(".",2);
         if(!this.dynamicSettings.hasOwnProperty(_loc2_[0]))
         {
            return null;
         }
         if(!this.dynamicSettings[_loc2_[0]].hasOwnProperty(_loc2_[1]))
         {
            return null;
         }
         return this.dynamicSettings[_loc2_[0]][_loc2_[1]];
      }
      
      public function getMergedSettingArrays(param1:String, param2:String) : Object
      {
         var _loc3_:* = this.getSettingArray(param1);
         var _loc4_:* = this.getSettingArray(param2);
         return Configuration.mergeObjects(_loc3_,_loc4_);
      }
      
      protected function getTemplateArray(param1:String) : Object
      {
         var _loc3_:* = undefined;
         var _loc2_:* = new Object();
         if(this.templateSettings.hasOwnProperty(param1))
         {
            for(_loc3_ in this.templateSettings[param1])
            {
               _loc2_[_loc3_] = this.templateSettings[param1][_loc3_];
            }
         }
         return _loc2_;
      }
      
      protected function getDynamicArray(param1:String) : Object
      {
         var _loc3_:* = undefined;
         var _loc2_:* = new Object();
         if(this.dynamicSettings.hasOwnProperty(param1))
         {
            for(_loc3_ in this.dynamicSettings[param1])
            {
               Logger.debug("DYNGET: " + param1 + "." + _loc3_ + " = " + this.dynamicSettings[param1][_loc3_]);
               _loc2_[_loc3_] = this.dynamicSettings[param1][_loc3_];
            }
         }
         return _loc2_;
      }
      
      public function getSettingArray(param1:String) : Object
      {
         var name:String = param1;
         var t:* = this.getTemplateArray(name);
         var r:* = null;
         try
         {
            r = this.engineConfiguration.getSettingArray(name);
         }
         catch(error:Error)
         {
            r = new Object();
         }
         r = Configuration.mergeObjects(t,r);
         r = Configuration.mergeObjects(r,this.getDynamicArray(name));
         return r;
      }
      
      public function getSettingArrays(param1:String) : *
      {
         return this.engineConfiguration.getSettingArrays(param1);
      }
      
      public function getSettingValue(param1:String) : String
      {
         return this.engineConfiguration.getSettingValue(param1);
      }
      
      public function getSetting(param1:String, param2:String) : *
      {
         var _loc4_:* = undefined;
         if(this.engineConfiguration == null)
         {
            return null;
         }
         var _loc3_:* = this.getDynamicSetting(param1 + "." + param2);
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         _loc4_ = this.engineConfiguration.getSetting(param1,param2);
         if(_loc4_ != null)
         {
            return _loc4_;
         }
         return this.getTemplateSetting(param1 + "." + param2);
      }
      
      public function getXMLSA() : XML
      {
         if(this.configMode == "xml")
         {
            return this.engineConfiguration.getRaw();
         }
         return new XML();
      }
      
      function getTranslation() : *
      {
         return this.engineConfiguration.getTranslation();
      }
      
      public function getClientIp() : *
      {
         if(this.getSetting("ip","enabled") == undefined)
         {
            this.controller.clientIp = this.getSetting("client","ip");
            return;
         }
         var _loc1_:* = TestConfigurator.getRangeInt(this.getSetting("ip","enabled"),0,3,0);
         trace("IP: " + _loc1_);
         switch(_loc1_)
         {
            case 0:
               this.controller.clientIp = null;
               break;
            case 1:
               this.controller.clientIp = this.getSetting("ip","ip");
               break;
            case 2:
            case 3:
               this.retrieveIp();
         }
      }
      
      protected function retrieveIp() : *
      {
         var _loc1_:URLRequest = new URLRequest(this.maintainProtocol("http://api.ookla.com/ipaddress.php"));
         _loc1_.method = URLRequestMethod.GET;
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.IPRetrievedComplete);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.IPRetrievedError);
         _loc2_.load(_loc1_);
      }
      
      function IPRetrievedComplete(param1:Event) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         Logger.debug("IP Retrieved: true " + param1);
         var _loc2_:URLLoader = URLLoader(param1.target);
         var _loc3_:URLVariables = new URLVariables(_loc2_.data);
         var _loc4_:* = TestConfigurator.getRangeInt(this.getSetting("ip","enabled"),0,3,0);
         if(_loc4_ == 3)
         {
            this.controller.clientIsp = _loc3_.isp;
         }
         _loc5_ = Number(_loc3_.lat);
         _loc6_ = Number(_loc3_.lon);
         this.controller.clientLocation = new Point(_loc6_,_loc5_);
         this.controller.clientIp = _loc3_.ip_address;
      }
      
      function IPRetrievedError(param1:IOErrorEvent) : *
      {
         Logger.debug("IP Retrieved: false " + param1);
         this.controller.clientIp = null;
      }
      
      public function getServer(param1:* = undefined) : Object
      {
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         return this.serverConfiguration.getServer(param1);
      }
      
      public function getMergedMethod(param1:* = undefined, param2:* = undefined) : Object
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         if(param2 == undefined)
         {
            param2 = this.methodId;
         }
         _loc3_ = this.getServer(param1);
         _loc4_ = this.getServerMethod(param1,param2);
         return Configuration.mergeObjects(_loc3_,_loc4_);
      }
      
      public function getServerMethodCount(param1:* = undefined, param2:* = false) : *
      {
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         return this.serverConfiguration.getServerMethodCount(param1,param2);
      }
      
      public function getServerMethod(param1:* = undefined, param2:* = undefined) : Object
      {
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         if(param2 == undefined)
         {
            param2 = this.methodId;
         }
         return this.serverConfiguration.getServerMethod(param1,param2);
      }
      
      public function getServerPosition(param1:* = undefined) : *
      {
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         return this.serverConfiguration.getServerPosition(param1);
      }
      
      public function getServerCount() : *
      {
         return this.serverConfiguration.getServerCount();
      }
      
      public function getServerId(param1:* = undefined) : *
      {
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         return this.serverConfiguration.getServerId(param1);
      }
      
      public function getServerName(param1:* = undefined) : *
      {
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         return this.serverConfiguration.getServerName(param1);
      }
      
      public function setServerId(param1:* = undefined) : *
      {
         Logger.info("ServerId set to: " + param1);
         if(param1 > 0)
         {
            if(this.serverId != param1)
            {
               this.methodId = 0;
            }
            this.serverId = param1;
         }
      }
      
      public function setMethodId(param1:* = undefined) : *
      {
         Logger.info("MethodId set to: " + param1);
         if(param1 >= 0)
         {
            this.methodId = param1;
         }
      }
      
      public function getMethodId() : *
      {
         return this.methodId;
      }
      
      public function getId() : *
      {
         return this.serverId;
      }
      
      public function getMethodType(param1:* = undefined, param2:* = undefined) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         if(param2 == undefined)
         {
            param2 = this.methodId;
         }
         _loc3_ = this.getMergedMethod(param1,param2);
         _loc4_ = _loc3_.type;
         if(_loc4_ == undefined)
         {
            if(this.isMethodAvailable("http",param1,param2))
            {
               _loc4_ = "http";
            }
            else if(this.isMethodAvailable("tcp",param1,param2))
            {
               _loc4_ = "tcp";
            }
            Logger.info("AutoMethod Used: " + _loc4_);
         }
         else
         {
            Logger.info("Method Used: " + _loc4_);
         }
         return _loc4_;
      }
      
      public function getServerPort(param1:* = undefined, param2:* = undefined, param3:* = undefined) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:Array = null;
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         if(param2 == undefined)
         {
            param2 = this.methodId;
         }
         if(param3 == undefined)
         {
            _loc5_ = this.getMethodType(param1,param2);
            if(_loc5_ == "tcp")
            {
               param3 = "socket-download";
            }
            if(_loc5_ == "http")
            {
               param3 = "http-download";
            }
         }
         _loc4_ = this.getMergedMethod(param1,param2);
         switch(param3)
         {
            case "socket-upload":
            case "socket-download":
            case "socket-latency":
            case "socket-packetloss":
            case "socket-firewall":
               return TestConfigurator.getSocketPort(_loc4_.host);
            case "http-upload":
            case "http-latency":
            case "http-download":
            default:
               _loc6_ = 80;
               _loc7_ = _loc4_.url;
               _loc8_ = _loc7_.split("://");
               if(_loc8_.length != 2)
               {
                  return _loc6_;
               }
               if(_loc8_[0] == "https")
               {
                  _loc6_ = 443;
               }
               _loc9_ = _loc8_[1].split("/")[0];
               _loc10_ = _loc9_.split(":");
               if(_loc10_.length > 1)
               {
                  return TestConfigurator.getRangeInt(_loc10_[1],1,65536,_loc6_);
               }
               return _loc6_;
         }
      }
      
      public function getServerUrl(param1:* = undefined, param2:* = undefined, param3:* = undefined) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         if(param2 == undefined)
         {
            param2 = this.methodId;
         }
         if(param3 == undefined)
         {
            _loc5_ = this.getMethodType(param1,param2);
            if(_loc5_ == "tcp")
            {
               param3 = "socket-download";
            }
            if(_loc5_ == "http")
            {
               param3 = "http-download";
            }
         }
         _loc4_ = this.getMergedMethod(param1,param2);
         switch(param3)
         {
            case "linequality":
               return _loc4_.linequality;
            case "socket-upload":
            case "socket-download":
            case "socket-latency":
            case "socket-packetloss":
            case "socket-firewall":
               return _loc4_.host;
            case "http-upload":
            case "http-latency":
            case "http-download":
            default:
               return _loc4_.url;
         }
      }
      
      public function getServerLocation(param1:* = undefined, param2:* = undefined) : *
      {
         var _loc3_:* = undefined;
         if(param1 == undefined)
         {
            param1 = this.serverId;
         }
         if(param2 == undefined)
         {
            param2 = this.methodId;
         }
         _loc3_ = this.getMergedMethod(param1,param2);
         if(_loc3_.location != undefined)
         {
            return _loc3_.location;
         }
         return "";
      }
      
      public function isMethodAvailable(param1:String, param2:* = undefined, param3:* = undefined) : Boolean
      {
         var _loc4_:* = undefined;
         if(param2 == undefined)
         {
            param2 = this.serverId;
         }
         if(param3 == undefined)
         {
            param3 = this.methodId;
         }
         _loc4_ = this.getMergedMethod(param2,param3);
         switch(param1)
         {
            case "tcp":
            case "socket":
               return _loc4_.host != undefined;
            case "http":
               return _loc4_.url != undefined;
            default:
               return false;
         }
      }
   }
}
