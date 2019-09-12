package
{
   class TemplateConfiguration
   {
       
      
      function TemplateConfiguration()
      {
         super();
      }
      
      public static function getConfiguration(param1:String) : *
      {
         switch(param1)
         {
            case "lan":
            case "gigabit":
               return getConfigurationObject("lan");
            case "fiber":
               return getConfigurationObject("fiber");
            case "broadband":
               return getConfigurationObject("broadband");
            default:
               return null;
         }
      }
      
      private static function getValue(param1:Object, param2:String) : *
      {
         if(param1.hasOwnProperty(param2))
         {
            return param1[param2];
         }
         return param1._default;
      }
      
      private static function getConfigurationObject(param1:String) : *
      {
         var _loc2_:* = new Object();
         var _loc3_:* = new Object();
         _loc3_.testlength = 10;
         _loc3_.timeout = 30;
         var _loc4_:* = new Object();
         _loc4_.testlength = 15;
         _loc4_.minthreads = getValue({
            "lan":16,
            "fiber":8,
            "_default":4
         },param1);
         _loc4_.initialthreads = getValue({
            "lan":16,
            "fiber":8,
            "_default":4
         },param1);
         _loc4_.maxthreads = getValue({
            "lan":128,
            "fiber":64,
            "_default":32
         },param1);
         _loc4_.maxsamplesize = getValue({
            "lan":5000000,
            "fiber":2000000,
            "_default":1000000
         },param1);
         _loc4_.startsamplesize = getValue({
            "lan":1000000,
            "fiber":500000,
            "_default":200000
         },param1);
         _loc4_.timeout = 30;
         var _loc5_:* = new Object();
         _loc5_.testlength = 10;
         _loc5_.threads = getValue({
            "lan":8,
            "fiber":4,
            "_default":2
         },param1);
         _loc5_.initialtest = getValue({
            "lan":"16M",
            "fiber":"8M",
            "_default":"2M"
         },param1);
         _loc5_.initialtestlength = 2;
         _loc5_.timeout = 30;
         var _loc6_:* = new Object();
         _loc6_.testlength = 15;
         _loc6_.minthreads = getValue({
            "lan":16,
            "fiber":8,
            "_default":4
         },param1);
         _loc6_.initialthreads = getValue({
            "lan":16,
            "fiber":8,
            "_default":4
         },param1);
         _loc6_.maxthreads = getValue({
            "lan":128,
            "fiber":64,
            "_default":32
         },param1);
         _loc6_.maxsamplesize = getValue({
            "lan":3000000,
            "fiber":2000000,
            "_default":1000000
         },param1);
         _loc6_.startsamplesize = getValue({
            "lan":1000000,
            "fiber":200000,
            "_default":100000
         },param1);
         _loc6_.timeout = 30;
         var _loc7_:* = new Object();
         _loc7_.testlength = 10;
         _loc7_.ratio = getValue({
            "lan":1,
            "fiber":5,
            "_default":10
         },param1);
         _loc7_.threads = getValue({
            "lan":8,
            "fiber":4,
            "_default":2
         },param1);
         _loc7_.maxchunkcount = getValue({
            "lan":50,
            "fiber":25,
            "_default":10
         },param1);
         _loc7_.maxchunksize = getValue({
            "lan":"4M",
            "_default":"1M"
         },param1);
         _loc7_.timeout = 30;
         _loc2_.latency = _loc3_;
         _loc2_["socket-download"] = _loc4_;
         _loc2_["socket-upload"] = _loc6_;
         _loc2_["http-download"] = _loc5_;
         _loc2_["http-upload"] = _loc7_;
         _loc2_["configuration"] = {"testing":"template"};
         return _loc2_;
      }
   }
}
