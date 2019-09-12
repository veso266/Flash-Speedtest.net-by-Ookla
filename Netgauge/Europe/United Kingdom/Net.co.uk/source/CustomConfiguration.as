package
{
   class CustomConfiguration extends Configuration
   {
       
      
      function CustomConfiguration(param1:*)
      {
         super(param1);
         defaultAPIURL = "http://api.ookla.com/netgauge/api.php";
      }
   }
}
