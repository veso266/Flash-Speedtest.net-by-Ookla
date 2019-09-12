package
{
   class ErrorMessages
   {
      
      private static var strings:Object = new Object();
       
      
      function ErrorMessages()
      {
         super();
      }
      
      static function getErrorTitle(param1:String) : *
      {
         if(strings.loaded == undefined)
         {
            loadStrings();
         }
         var _loc2_:* = Translation.getExactText(param1 + "title");
         if(_loc2_ == null || _loc2_ == undefined)
         {
            _loc2_ = strings[param1 + "title"];
            if(_loc2_ == null || _loc2_ == undefined)
            {
               _loc2_ = param1 + " - title";
            }
         }
         return _loc2_;
      }
      
      static function loadStrings() : *
      {
         Logger.info("Loading Error Strings");
         strings.loaded = true;
         strings.license06message = "The license for this Speed Test is missing.\nPlease contact the webmaster of this site to let them know.";
         strings.license06title = "Missing License Key";
         strings.license05message = "The configuration for the Speed Test could not be loaded.\nPlease contact the webmaster of this site to let them know.";
         strings.license05title = "Configuration Load Failed";
         strings.license02message = "The license for this Speed Test has expired.\nPlease contact the webmaster of this site to let them know.";
         strings.license02title = "Expired License";
         strings.license03message = "This Speed Test is not setup to work at this URL.\nPlease contact the webmaster of this site to let them know.";
         strings.license03title = "Wrong License";
         strings.license04message = "The license for this Speed Test is invalid.\nPlease contact the webmaster of this site to let them know.";
         strings.license04title = "Invalid License";
         strings.settings01message = "The test returned an error because it is configured improperly";
         strings.settings01title = "Test Error";
         strings.timeout01title = "Test Timed Out";
         strings.timeout01message = "The test timed out. Please try again later.";
         strings.download01title = "Download Test Error";
         strings.download01message = "Download test returned an error while trying to read the download file.";
         strings.latency01message = "Latency test returned an error while trying to read the latency file.";
         strings.latency01title = "Latency Test Error";
         strings.upload01title = "Upload Test Error";
         strings.upload01message = "Download test returned an error while trying to read the upload file.";
         strings.linequality02title = "Test cannot be completed";
         strings.linequality02message = "The test server is inaccessible. It is possible that a firewall is blocking the test from happening. Please verify your configuration and try again.";
         strings.throttle01title = "Daily Test Limit Exceeded";
         strings.throttle01message = "You have exceeded the limit of {DAILYLIMIT} tests per day.";
         strings["socket-latency01title"] = "Latency Test Error";
         strings["socket-latency01message"] = "A socket error occurred during the Latency test. Please try again later.";
         strings["socket-upload01title"] = "Upload Test Error";
         strings["socket-upload01message"] = "A socket error occurred during the Upload test. Please try again later.";
         strings["socket-download01title"] = "Download Test Error";
         strings["socket-download01message"] = "A socket error occurred during the Download test. Please try again later.";
         strings["socket-packetloss01title"] = "Packet Loss Test Error";
         strings["socket-packetloss01message"] = "Java was not detected.";
         strings["socket-packetloss03title"] = "Packet Loss Test Error";
         strings["socket-packetloss03message"] = "Could not connect to the test server. A firewall could be blocking the connection or the server might be having some issues. Please try again later.";
         strings["socket-firewall01title"] = "Firewall Test Error";
         strings["socket-firewall01message"] = "Java was not detected.";
         strings["socket-firewall03title"] = "Firewall Test Error";
         strings["socket-firewall03message"] = "Could not connect to the test server. A firewall could be blocking the connection or the server might be having some issues. Please try again later.";
         strings["socket-latency01title"] = "Latency Test Error";
         strings["socket-latency01message"] = "Could not connect to the test server. A firewall could be blocking the connection or the server might be having some issues. Please try again later.";
      }
      
      static function getErrorMessage(param1:String) : *
      {
         if(strings.loaded == undefined)
         {
            loadStrings();
         }
         var _loc2_:* = Translation.getExactText(param1 + "message");
         if(_loc2_ == null || _loc2_ == undefined)
         {
            _loc2_ = strings[param1 + "message"];
            if(_loc2_ == null || _loc2_ == undefined)
            {
               _loc2_ = param1 + " - message";
            }
         }
         return _loc2_;
      }
   }
}
