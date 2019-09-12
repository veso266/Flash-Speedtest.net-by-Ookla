using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Security.Cryptography;
using System.Diagnostics;

namespace SpeedTest.net_Keygen
{
    class Program
    {
        static void Main(string[] args)
        {
            //Console.WriteLine(formatKey("V3#3877#D20171231#S1#a0346c905a489900-S1542f06532950d9-650fd90a80c8017a-16d38435844b95e5"));
            //string licena = "c1542f06532950d9-c50fd90a80c8017a-6dcef1027f806329";

            //Console.WriteLine(Key2Date("56b9bdfa561f4ef0-S14bab6ea9ced4f01-2962cf06ce4d80d7-feada1f88df9ec6f-a206c0033345cd9b"));
            //Console.WriteLine(Key2Date(licena));
            /*
            string[] ConstantPool = { "_global", "License", "prototype", "verifyKey", "configurationloadfailed", "License - Load Failed", "Logger", "error", "\"\"", "License - License Key is missing", "gallery", "License - Gallery Mode", "info", "_url", "toLowerCase", "Tools", "getHostName", ":", "indexOf", "substr", "http", "length", "/", "URL: ", "G$LL/RY", "com", "meychi", "ascrypt", "MD5", "calculate", "03855aacab57ed1311cca775f3caa3d5", "c3b855db38606921e3e82ee65e237ae5", "License - Gallery URL Valid", "-", "split", "full_license", "global_hash", "pop", "date_hash", "shift", "host_hash", "checkHost", "License - Invalid Host", "checkDate", "License - License Expired", "checkLicense", "License - Invalid License", "License - Bad Date Hash Length", "License - Bad Global Hash Length", "slice", "global_secret", "License - Corrupted License (Global)", "License - Current URL: ", "?", "getDomainName", "License - Domain: ", "License - Host: ", "charAt", "S", "H", "W", "%wildh0st$", "url_secret", "License - Adding host: ", " to wildcard list", "whiteHosts", "push", "%wildc4rd$", "License - Adding domain: ", "whiteDomains", "file", "trialTest", "***trial***", "License - !!!!!trialtest!!!!!!!!!", "trialActive", "License - Wildcard: ", "trialtest", "trial", "gotoAndPlay", "istrial", "SpeedTestController", "getController", "addPermaResult", "date_secret", "License - Corrupted License (Date)", "parseInt", "Date", "Expiration Date: ", "getMonth", "getDate", "getFullYear", "valueOf", "Math", "ceil", "License - License Expiring soon: ", "warning", "licenseExpiringSoon", "fours4me", "bling^bling", "n0v4super", "speedtest.net", "ookla.com", "Array", "ASSetPropFlags" };

            string output = "";

            string mydocpath = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);

            for (int i = 0; i < ConstantPool.Length; i++)
            {
                output += "§§constant" + i.ToString() + " = " + ConstantPool[i] + "\n"; // plus any delimiters or formating.
            }

            using (StreamWriter outputFile = new StreamWriter(mydocpath + @"\ConstantPool.txt"))
            {
                outputFile.WriteLine(output);
            }
            */
            //Console.WriteLine("\n");
            //Console.WriteLine(output);
            License License = new License();


            Console.WriteLine(License.Generate("03/19/2034 08:00:00 GMT", "http://speedtest.windows.nt/speedtest.swf", 11, "BlackHost", "speedtest", "new"));
            Console.ReadLine();
        }
    }
}
