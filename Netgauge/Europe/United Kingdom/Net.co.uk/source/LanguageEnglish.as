package
{
   class LanguageEnglish extends Language
   {
      
      public static var boldFont:String = "Arial Bold";
      
      public static var regularFont:String = "Arial Regular";
      
      public static var addBoldTag:Boolean = false;
       
      
      function LanguageEnglish()
      {
         super();
         languageString = "en";
      }
      
      override protected function loadTranslation() : *
      {
         var _loc1_:* = "<font face=\'" + boldFont + "\'>";
         var _loc2_:* = "</font>";
         if(addBoldTag)
         {
            _loc1_ = _loc1_ + "<b>";
            _loc2_ = "</b>" + _loc2_;
         }
         translations.starttest = "Begin Test";
         translations.restarttest = "Restart Test";
         translations.newserver = "New Server";
         translations.testagain = "Test Again";
         translations.testinglatency = "Testing Latency";
         translations.testingdownload = "Testing Download Speed";
         translations.preparingdownload = "Preparing Download Test";
         translations.testingupload = "Testing Upload Speed";
         translations.preparingupload = "Preparing Upload Test";
         translations.testingfirewall = "Testing Firewall";
         translations.testingpacketloss = "Measuring Packet Loss";
         translations.yourip = "Your IP:";
         translations.ping = "PING:";
         translations.mbps = "Mbps";
         translations.kbps = "kbps";
         translations.firewallfound = "Firewall Found";
         translations.firewallnotfound = "Firewall Not Found";
         translations.downloadspeed = "[html]" + _loc1_ + "DOWNLOAD" + _loc2_ + " SPEED";
         translations.uploadspeed = "[html]" + _loc1_ + "UPLOAD" + _loc2_ + " SPEED";
         translations.connectiongraph = "[html]" + _loc1_ + "CONNECTION" + _loc2_ + " GRAPH";
         translations.packetssent = "[html]PACKETS " + _loc1_ + "SENT" + _loc2_;
         translations.packetsreceived = "[html]PACKETS " + _loc1_ + "RECEIVED" + _loc2_;
         translations.label_latency = "Latency";
         translations.label_jitter = "Jitter";
         translations.label_firewall = "Firewall";
         translations.label_packetloss = "Packet Loss";
         translations.label_speed = "Speed";
         translations.testskipped = "Test Skipped";
         translations.tile_packetloss = "Packet Loss";
         translations.tile_packetssent = "Packets Sent";
         translations.tile_packetsreceived = "Packets Received";
         translations.tile_toclient = "To Client:";
         translations.tile_toserver = "To Server:";
         translations.tile_client_tcp = "Client TCP";
         translations.tile_server_tcp = "Server TCP";
         translations.tile_client_udp = "Client UDP";
         translations.tile_server_udp = "Server UDP";
         translations.meta_client = "Client:";
         translations.meta_server = "Server:";
         translations.open = "Open";
         translations.closed = "Closed";
         translations.tile_downloadspeed = "Download Speed";
         translations.tile_uploadspeed = "Upload Speed";
         translations.measuringserverusage = "Measuring Server Usage";
         translations.teststartingin = "Test starting in {SECONDS} seconds";
         translations.teststartingin1 = "Test starting in 1 second";
         translations.sharetestresult = "Share test result";
         translations.copied = "Copied!";
         translations.shareurlcopied = "Share URL Copied to Clipboard";
         translations.error = "ERROR";
         translations.documentation = "Documentation";
      }
   }
}
