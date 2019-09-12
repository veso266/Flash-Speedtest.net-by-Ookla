package
{
   public class JSONEngineConfigurationReader implements EngineConfigurationReader
   {
       
      
      protected var data:Object = null;
      
      protected var controller:SpeedTestController;
      
      public function JSONEngineConfigurationReader(param1:CustomSpeedTestController)
      {
         super();
         this.controller = param1;
      }
      
      public static function getArray(param1:Object) : *
      {
         var _loc3_:* = null;
         var _loc2_:* = {};
         for(_loc3_ in param1)
         {
            if(_loc3_.charAt(0) == "@")
            {
               _loc2_[_loc3_.substr(1)] = param1[_loc3_];
            }
         }
         return _loc2_;
      }
      
      public function parse(param1:String) : *
      {
         var file:String = param1;
         try
         {
            this.data = com.adobe.serialization.json.JSON.decode(file);
            return;
         }
         catch(error:Error)
         {
            data = new Object();
            Logger.error("Configuration - JSON Parse Error");
            throw error;
         }
      }
      
      public function getRaw() : *
      {
         return this.data;
      }
      
      public function getSetting(param1:String, param2:String) : String
      {
         if(this.data.hasOwnProperty(param1))
         {
            return this.data[param1]["@" + param2];
         }
         return null;
      }
      
      public function getSettingValue(param1:String) : String
      {
         if(this.data.hasOwnProperty(param1))
         {
            return this.data[param1].toString();
         }
         return null;
      }
      
      public function getSettingArray(param1:String) : Object
      {
         var _loc2_:* = undefined;
         if(param1.indexOf(".") >= 0)
         {
            _loc2_ = this.getSettingObjectAtPath(param1);
         }
         else
         {
            _loc2_ = this.data[param1];
         }
         if(_loc2_ == null)
         {
            return new Object();
         }
         return getArray(_loc2_);
      }
      
      protected function getSettingObjectAtPath(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1 == "recolor.color")
         {
            param1 = "recolor";
         }
         if(param1 == "conditions.cond")
         {
            param1 = "conditions";
         }
         _loc2_ = this.data;
         _loc3_ = param1.split(".");
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc2_.hasOwnProperty(_loc3_[_loc4_]))
            {
               _loc2_ = _loc2_[_loc3_[_loc4_]];
               _loc4_++;
               continue;
            }
            return null;
         }
         return _loc2_;
      }
      
      public function getSettingArrays(param1:String) : *
      {
         var _loc4_:int = 0;
         var _loc2_:* = this.getSettingObjectAtPath(param1);
         var _loc3_:* = new Array();
         if(_loc2_ != null)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_.push(getArray(_loc2_[_loc4_]));
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      public function getServers() : *
      {
         return this.data.servers;
      }
      
      public function getTranslation() : *
      {
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc1_:* = this.data.translation;
         var _loc2_:* = [];
         if(_loc1_ == null)
         {
            return _loc2_;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = this.getSingleTranslation(_loc1_[_loc3_]);
            if(_loc4_ != null)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function getSingleTranslation(param1:Object) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc2_:* = {"data":[]};
         if(param1["@lang"])
         {
            _loc2_.lang = param1["@lang"];
            _loc3_ = param1.text;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               if(_loc5_["@id"])
               {
                  _loc2_.data.push({
                     "id":_loc5_["@id"],
                     "value":_loc5_["@value"]
                  });
               }
               _loc4_++;
            }
            return _loc2_;
         }
         return null;
      }
   }
}
