package
{
   public interface EngineConfigurationReader
   {
       
      
      function parse(param1:String) : *;
      
      function getSetting(param1:String, param2:String) : String;
      
      function getSettingValue(param1:String) : String;
      
      function getSettingArray(param1:String) : Object;
      
      function getSettingArrays(param1:String) : *;
      
      function getServers() : *;
      
      function getRaw() : *;
      
      function getTranslation() : *;
   }
}
