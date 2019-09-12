using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;
using System.Diagnostics;

namespace SpeedTest.net_Keygen
{
    public static class Extensions
    {
        /// <summary>
        /// Get the string slice between the two indexes.
        /// Inclusive for start index, exclusive for end index.
        /// </summary>
        public static string slice(this string source, int start, int end)
        {
            if (end < 0) // Keep this for negative end support
            {
                end = source.Length + end;
            }
            int len = end - start;               // Calculate length
            return source.Substring(start, len); // Return Substring of length
        }
    }
    struct skrivnosti
    {
        public string global_secret;
        public string url_secret;
        public string date_secret;
        public void SpeedTestSecrets(string SpeedTestVersion)
        {
            if (SpeedTestVersion == "old")
            {
                global_secret = "fours4me";
                url_secret = "bling^bling";
                date_secret = "n0v4super";

            }
            if (SpeedTestVersion == "new")
            {
                global_secret = "aXPB2";
                url_secret = "QV67R";
                date_secret = "4tE)C4kS";
            }
        }
        public void NetGaugeSecrets(string NetGaugeVersion)

        {
            if (NetGaugeVersion == "current")
            {
                global_secret = "8zjAUM";
                url_secret = "qX^1WA!HP(";
                date_secret = "jiO4sXA";

            }
        }
    }
    class License
    {
        public string global_secret;
        public string url_secret;
        public string date_secret;
        public string vse;

        //we need some tools
        //Why did I put that in here?
        public static byte[] writeUTFBytes(string utf8String)
        {
            byte[] toBytes = Encoding.UTF8.GetBytes(utf8String);
            return toBytes;
        }
        //Why did I put that in here?


        //to get MD5
        public static string md5(string input)
        {
            MD5 md5Hash = MD5.Create();
            // Convert the input string to a byte array and compute the hash.
            byte[] data = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input));

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data 
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            // Return the hexadecimal string.
            return sBuilder.ToString();
        }

        //to get Domain and hostName

        public string getDomainName(string param1)
        {
            var loc2 = getHostName(param1);
            var loc3 = loc2.Split('.');
            loc2 = loc3[loc3.Length - 2] + "." + loc3[loc3.Length - 1];
            return loc2;
        }
        public string getHostName(string param1)
        {
            string loc2 = null;
            int loc3;
            param1 = param1.ToLower();
            if (param1.IndexOf("?") > -1)
            {
                param1 = param1.Substring(0, param1.IndexOf("?"));
            }
            param1 = param1.Substring(0, param1.IndexOf("/", 8));
            loc2 = param1.Substring(param1.IndexOf(":") + 2 + 1);
            loc3 = loc2.IndexOf(":");
            if (loc3 > -1)
            {
                loc2 = loc2.Substring(0, loc3);
            }
            return loc2;
        }
        //to get Domain and hostName

        //to get Linux TimeStamp
        public long DateTime2UnixTimeStamp(DateTime datum)
        {
            var timeSpan = (datum - new DateTime(1970, 1, 1, 0, 0, 0));
            return (long)timeSpan.TotalSeconds;
        }
        //to get Linux TimeStamp

        //to get Date from Linux TimeStamp
        public static DateTime UnixTimeStamp2DateTime(double unixTimeStamp)
        {
            // Unix timestamp is seconds past epoch
            System.DateTime dtDateTime = new DateTime(1970, 1, 1, 0, 0, 0, 0, System.DateTimeKind.Utc);
            dtDateTime = dtDateTime.AddSeconds(unixTimeStamp).ToUniversalTime();
            return dtDateTime;
        }
        //to get Date from Linux TimeStamp
        //we need some tools
        public string Generate(string date, string url, int ServerCount, string LicenseMode, string product, string version)
        {
            if (product == "speedtest")
            {
                skrivnosti secrets = new skrivnosti();
                secrets.SpeedTestSecrets(version);
                global_secret = secrets.global_secret;
                url_secret = secrets.url_secret;
                date_secret = secrets.date_secret;
                //console.log("Global Secret = "+ global_secret + '\n' + "URL Secret = " + url_secret + '\n' + "Date Secret = " + date_secret);
            }
            if (product == "netgauge")
            {
                //NetGaugeSecrets(version)
                skrivnosti secrets = new skrivnosti();
                secrets.NetGaugeSecrets(version);
                global_secret = secrets.global_secret;
                url_secret = secrets.url_secret;
                date_secret = secrets.date_secret;
                //console.log("Global Secret = "+ global_secret + '\n' + "URL Secret = " + url_secret + '\n' + "Date Secret = " + date_secret);
            }
            //We store secrets here



            //We store secrets here	

            var Domain = getDomainName(url);
            var HostName = getHostName(url);

            //We first calculate date part of the licence
            //Licence Check (Date)
            var datumStamp = DateTime2UnixTimeStamp(DateTime.ParseExact(date, "MM/dd/yyyy HH:mm:ss GMT", System.Globalization.CultureInfo.InvariantCulture).ToUniversalTime());
            var date_Hash = Convert.ToString(datumStamp, 16);
            var MD5Hash = md5(date_Hash + date_secret).Substring(0, 8);
            var DatePart = MD5Hash + date_Hash;
            //Licence Check (Date)
            //We first calculate date part of the licence

            //Then we calculate Host Part
            //1. We Need to generate hash difrently for older version of speedtest
            if (product == "speedtest" && version == "old")
            {
                if (LicenseMode == "Bound2HostName")
                {
                    //Licence bound to HostName
                    string HostPart = md5("%wildh0st$" + HostName + url_secret).Substring(0, 16);
                    string Host = "H" + HostPart;
                    vse = Host;
                    //Licence bound to HostName
                }

                if (LicenseMode == "Bound2Domain")
                {
                    //Licence bound to Domain
                    string HostPart = md5("%wildc4rd$" + Domain + url_secret).Substring(0, 16);
                    string Wildcard = "W" + HostPart;
                    vse = Wildcard;
                    //Licence bound to Domain
                }
                if (LicenseMode == "Trial")
                {
                    //Trial License
                    vse = md5("***trial***" + url_secret).Substring(0, 16);
                    //Trial License
                }
            }
            else
            {
                //Current SpeedTest and Netgauge have 5 types of licenses
                if (LicenseMode == "Tag")
                {
                    //////////////////////////////// Licencse Mode Tags //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    // 1. There is Tags License which looks inside validTags array and finds speedtest-only there (the only tag that I came across), it checks if its md5hash matches and if it does it puts this tag inside activeTags array and is happy. //
                    // Pro: You can change domain or hostname without recalculating your licenses (but you have to byteEdit whiteDomains array and add your own domain in it)                                                                               //
                    // Coin: you have to ByteEddit speedtest/netgauge.swf to change validTag or stay with speedtest-only tag and hope no one steals your speedtest/netgauge.swf and a coresponding license                                                  //
                    string validTag = "speedtest-only";
                    string TagLicense = md5("%t4gs$" + validTag + this.url_secret).Substring(0, 16);
                    vse = "T" + TagLicense;
                }
                if (LicenseMode == "Server") //NOT SURE IF THIS ONE WORKS AS IT SHOULD
                {
                    //////////////////////////////// Licencse Mode Server Count //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    // 2. There is Servers License which extraxt server count from licenseKey in similar fashion as it extraxt Expernation Date , it checks if its md5hash matches and if it does it is happy.                                              //
                    // Pro: You can change domain or hostname without recalculating your licenses (but you have to byteEdit whiteDomains array and add your own domain in it)                                                                               //
                    // Coin: you can only use the number of servers you have specified in your licence. If you exceed this number your license will not work anymore.                                                                                       //
                    int Servers = ServerCount;
                    //ServersEnc = Servers.toString(16);
                    string ServerMD5 = md5("%s3rv3r$" + Servers + this.url_secret).Substring(0, 14);
                    vse = "S" + ServerMD5;
                }
                if (LicenseMode == "Bound2HostName")
                {
                    //////////////////////////////// Licencse Mode Hostname //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    // 3. There is HostName License which checks its md5hash agains hostname it is running on and if it matches it is happy.                                                                                                                //             
                    // Pro: can't find any if comparing to Wildcard License                                                                                                                                                                                 //
                    // Coin: you can only use this on hostname which is md5 hashed in license if you change hostname it will stop working.                                                                                                                  //
                    //Licence bound to HostName
                    string HostPart = md5("%wildh0st$" + HostName + url_secret).Substring(0, 16);
                    string Host = "H" + HostPart;
                    vse = Host;
                    //Licence bound to HostName
                }
                if (LicenseMode == "Bound2Domain")
                {
                    //////////////////////////////// Licencse Mode Wildcard //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    // 4. The best licence of them all is DomainName License which checks its md5hash agains a domain it is running on and if it matches it is happy.                                                                                       //             
                    // Pro: You can change hostname without recalculating your licenses (it works with *.somedomain.something (* can be anything)                                                                                                           //
                    // Coin: No Coins its the best license of them all                                                                                                                                                                                      //

                    //Licence bound to Domain
                    string HostPart = md5("%wildc4rd$" + Domain + url_secret).Substring(0, 16);
                    string Wildcard = "W" + HostPart;
                    vse = Wildcard;
                    //Licence bound to Domain
                }
                if (LicenseMode == "Trial")
                {
                    //Trial License
                    vse = md5("***trial***" + url_secret).Substring(0, 16);
                    //Trial License
                }
                if (LicenseMode == "BlackHost")
                {
                    //Nor sure why would you like to use this one but lets generate it anyway
                    string BlachHost = md5("%blackc4rd$" + Domain + this.url_secret).Substring(0, 16);
                    string BlackCard = "B" + BlachHost;
                    vse = BlackCard;
                }
            }
            //Then we calculate Host Part

            //At last we md5 validate everyhing everything and pack it in to a licence
            //We validate it
            //We Calculate the last part of the key here
            var LastKeyPart = md5(DatePart + '-' + vse + global_secret).Substring(0, 16);

            //We Calculate the last part of the key here
            //We validate it


            //We Pack it together
            var CompleteKey = DatePart + '-' + vse + '-' + LastKeyPart;
            return CompleteKey;

        //We Pack it together
        }

        static string Key2Date(string licence)
        {
            string[] _licArray_ = licence.Split('-');
            //Console.WriteLine(_licArray_[0]);
            string _loc1_ = _licArray_[0]; //Same as _licArray_.Shift in Javascript
            //Console.WriteLine(_loc1_);
            string TimeStampEnc = _loc1_.Substring(8, 8); //same as something.substr(8,8) in Javascript
            int TimeStamp = Convert.ToInt32(TimeStampEnc, 16); //same as ParseInt(something, 16) in Javascript
            Debug.WriteLine(TimeStamp);
            string datumPoteka = UnixTimeStamp2DateTime(TimeStamp).ToString(); //Convert TimeStamp to Date same as new Date (timestamp * 1000)  

            //Calculate MD5
            string licenca = "c1542f06532950d9-c50fd90a80c8017a-6dcef1027f806329";
            string[] licencaArray = licenca.Split('-');
            string ToCompare = licencaArray[2];
            // given, a password in a string
            string encoded = md5(licenca.slice(0, -16 - 1) + "fours4me").Substring(0, 16);


            //Console.WriteLine(ToCompare + "\n" + encoded);
            return datumPoteka;
        }
        //Netgauge
        //string Key = "V3#3877#D20171231#S1#a0346c905a489900-S1542f06532950d9-650fd90a80c8017a-16d38435844b95e5";
        //string[] ignore = { "V3#3877#D20171231#S1#", "650fd90a80c8017a" };

        static string formatKey(string key)
        {
            string licenseKeyTrim = key.Trim();
            int Where2Trim = licenseKeyTrim.LastIndexOf("#");
            key = licenseKeyTrim.Substring(Where2Trim + 1);

            string[] keyArray = key.Split('-');
            List<string> keyList = keyArray.ToList();
            keyList.RemoveAt(2);
            string newKey = keyList[0] + '-' + keyList[1] + '-' + keyList[2];
            return newKey;
        }

        //Netgauge

    }
}
