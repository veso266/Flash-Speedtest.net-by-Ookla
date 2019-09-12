package
{
   import com.adobe.crypto.MD5;
   
   class License
   {
       
      
      protected var global_secret = "fours4me";
      
      protected var url_secret = "bling^bling";
      
      protected var date_secret = "n0v4super";
      
      protected var global_hash:String;
      
      protected var date_hash:String;
      
      protected var host_hash:Array;
      
      protected var full_license:String;
      
      protected var serverCount:Number = 0;
      
      protected var trialTest:Boolean = false;
      
      protected var _trialActive:Boolean = false;
      
      protected var validTags:Array;
      
      protected var activeTags:Array;
      
      protected var whiteDomains:Array;
      
      protected var blackDomains:Array;
      
      protected var whiteHosts:Array;
      
      protected var verifyLoader:Boolean = true;
      
      function License()
      {
         this.validTags = new Array("speedtest-only");
         this.activeTags = new Array();
         this.whiteDomains = new Array("ookla.com","speedtest.net");
         this.blackDomains = new Array();
         this.whiteHosts = new Array();
         super();
      }
      
      public function get isTrial() : Boolean
      {
         return this.trialTest && this._trialActive;
      }
      
      public function verifyKey(param1:*) : *
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(param1 == "configurationloadfailed")
         {
            Logger.error("License - Load Failed");
            return 4;
         }
         if(param1 == "" || param1 == undefined)
         {
            Logger.error("License - License Key is missing");
            return 5;
         }
         if(param1 == "gallery")
         {
            Logger.info("License - Gallery Mode");
            _loc4_ = Configuration.removeDynamic(DocumentClass.document.loaderInfo.loaderURL.toLowerCase());
            _loc5_ = Tools.getHostName(_loc4_);
            if(_loc4_.substr(0,_loc4_.indexOf(":")) == "http")
            {
               _loc6_ = _loc4_.substr(0,_loc4_.indexOf("/",_loc5_.length + 8) + 1);
               Logger.info("URL: " + _loc6_);
               _loc7_ = MD5.hash("G$LL/RY" + _loc6_);
               if(_loc7_ == "03855aacab57ed1311cca775f3caa3d5" || _loc7_ == "c3b855db38606921e3e82ee65e237ae5")
               {
                  Logger.info("License - Gallery URL Valid");
                  return 0;
               }
            }
         }
         _loc2_ = param1.split("-");
         this.full_license = param1;
         this.global_hash = String(_loc2_.pop());
         this.date_hash = String(_loc2_.shift());
         this.host_hash = _loc2_;
         _loc3_ = 0;
         if(!this.checkHost())
         {
            _loc3_ = 3;
            Logger.error("License - Invalid Host");
         }
         if(!this.checkDate())
         {
            _loc3_ = 2;
            Logger.error("License - License Expired");
         }
         if(!this.checkLicense())
         {
            _loc3_ = 1;
            Logger.error("License - Invalid License");
         }
         return _loc3_;
      }
      
      public function checkLicense() : Boolean
      {
         if(this.date_hash.length != 16)
         {
            Logger.error("License - Bad Date Hash Length");
            return false;
         }
         if(this.global_hash.length != 16)
         {
            Logger.error("License - Bad Global Hash Length");
            return false;
         }
         var _loc1_:* = MD5.hash(this.full_license.slice(0,-16 - 1) + this.global_secret).substr(0,16);
         if(_loc1_ != this.global_hash)
         {
            Logger.error("License - Corrupted License (Global)");
            return false;
         }
         return true;
      }
      
      public function checkHost() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:String = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:String = null;
         var _loc15_:* = undefined;
         if(this.verifyLoader)
         {
            _loc2_ = Configuration.removeDynamic(DocumentClass.document.loaderInfo.loaderURL);
            Logger.info("License - Current URL: " + _loc2_);
            _loc1_ = _loc2_.toLowerCase();
         }
         else
         {
            _loc2_ = Configuration.removeDynamic(DocumentClass.document.loaderInfo.url);
            Logger.info("License - Current URL: " + _loc2_);
            _loc1_ = _loc2_.toLowerCase();
         }
         if(_loc1_.indexOf("?") > -1)
         {
            _loc1_ = _loc1_.substr(0,_loc1_.indexOf("?"));
         }
         _loc3_ = Tools.getDomainName(_loc1_);
         Logger.info("License - Domain: " + _loc3_);
         _loc4_ = Tools.getHostName(_loc1_);
         Logger.info("License - Host: " + _loc4_);
         _loc5_ = 0;
         while(_loc5_ < this.host_hash.length)
         {
            _loc7_ = this.host_hash[_loc5_];
            switch(_loc7_.charAt(0))
            {
               case "T":
                  for each(_loc14_ in this.validTags)
                  {
                     _loc15_ = MD5.hash("%t4gs$" + _loc14_ + this.url_secret).substr(0,16);
                     if(_loc7_ == "T" + _loc15_)
                     {
                        this.activeTags.push(_loc14_);
                        Logger.info("Active: " + _loc14_);
                     }
                  }
                  break;
               case "S":
                  _loc8_ = _loc7_.substr(15,2);
                  _loc9_ = parseInt(_loc8_,16);
                  _loc10_ = MD5.hash("%s3rv3r$" + _loc9_ + this.url_secret).substr(0,14);
                  if(_loc7_.substr(0,15) == "S" + _loc10_)
                  {
                     this.serverCount = _loc9_;
                     Logger.info("Server Count: " + this.serverCount);
                  }
                  break;
               case "H":
                  _loc11_ = MD5.hash("%wildh0st$" + _loc4_ + this.url_secret).substr(0,16);
                  if(_loc7_ == "H" + _loc11_)
                  {
                     Logger.info("License - Adding host: " + _loc4_ + " to wildcard list");
                     this.whiteHosts.push(_loc4_);
                  }
                  break;
               case "W":
                  _loc12_ = MD5.hash("%wildc4rd$" + _loc3_ + this.url_secret).substr(0,16);
                  if(_loc7_ == "W" + _loc12_)
                  {
                     Logger.info("License - Adding domain: " + _loc3_ + " to wildcard list");
                     this.whiteDomains.push(_loc3_);
                  }
                  break;
               case "B":
                  _loc13_ = MD5.hash("%blackc4rd$" + _loc3_ + this.url_secret).substr(0,16);
                  if(_loc7_ == "B" + _loc13_)
                  {
                     Logger.info("License - Adding domain: " + _loc3_ + " to b wildcard list");
                     this.blackDomains.push(_loc3_);
                  }
            }
            _loc5_++;
         }
         if(_loc1_.substr(0,_loc1_.indexOf(":")) == "file")
         {
            return true;
         }
         _loc5_ = 0;
         while(_loc5_ < this.host_hash.length)
         {
            _loc6_ = this.host_hash[_loc5_];
            if(_loc6_ == MD5.hash(_loc1_ + this.url_secret).substr(0,16))
            {
               return true;
            }
            _loc5_++;
         }
         if(this.trialTest)
         {
            _loc5_ = 0;
            while(_loc5_ < this.host_hash.length)
            {
               _loc6_ = this.host_hash[_loc5_];
               if(_loc6_ == MD5.hash("***trial***" + this.url_secret).substr(0,16))
               {
                  Logger.info("License - !!!!!trialtest!!!!!!!!!");
                  this.trialActive();
                  return true;
               }
               _loc5_++;
            }
         }
         _loc5_ = 0;
         while(_loc5_ < this.blackDomains.length)
         {
            if(_loc3_ == this.blackDomains[_loc5_])
            {
               Logger.info("License - B Wildcard: " + _loc3_);
               return false;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.whiteDomains.length)
         {
            if(_loc3_ == this.whiteDomains[_loc5_])
            {
               Logger.info("License - Wildcard: " + _loc3_);
               return true;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.whiteHosts.length)
         {
            if(_loc4_ == this.whiteHosts[_loc5_])
            {
               Logger.info("License - Host: " + _loc4_);
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      protected function trialActive() : *
      {
         this._trialActive = true;
      }
      
      public function checkDate() : Boolean
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc1_:* = this.date_hash.substr(8,8);
         var _loc2_:* = this.date_hash.substr(0,8);
         var _loc3_:* = MD5.hash(_loc1_ + this.date_secret).substr(0,8);
         if(_loc2_ != _loc3_)
         {
            Logger.error("License - Corrupted License (Date)");
            return false;
         }
         _loc4_ = new Date(parseInt(_loc1_,16) * 1000);
         Logger.info("Expiration Date: " + (_loc4_.getMonth() + 1) + "/" + _loc4_.getDate() + "/" + _loc4_.getFullYear());
         _loc5_ = new Date();
         if(_loc4_.valueOf() < _loc5_.valueOf())
         {
            Logger.error("License - License Expired");
            return false;
         }
         if(_loc4_.valueOf() < _loc5_.valueOf() + 86400 * 1000 * 15)
         {
            _loc6_ = Math.ceil((_loc4_.valueOf() - _loc5_.valueOf()) / (86400 * 1000));
            Logger.warning("License - License Expiring soon: " + _loc6_);
            SpeedTestController.getController().licenseExpiringSoon(_loc6_);
         }
         return true;
      }
      
      public function getServerCount() : Number
      {
         return this.serverCount;
      }
      
      public function isActiveTag(param1:String) : Boolean
      {
         return this.activeTags.indexOf(param1) >= 0;
      }
   }
}
