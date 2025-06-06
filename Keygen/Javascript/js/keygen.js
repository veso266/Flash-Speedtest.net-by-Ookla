//We start to write a function here

//Helper Function from here: https://coderwall.com/p/rbfl6g/how-to-get-the-correct-unix-timestamp-from-any-date-in-javascript
Date.prototype.getUnixTime = function() {
    return this.getTime() / 1000 | 0
};
if (!Date.now) Date.now = function() {
    return new Date();
}
Date.time = function() {
    return Date.now().getUnixTime();
}
//Helper Function


function GenerateKey (date, url, ServerCount, LicenseMode, product, version) 
	{
		if (product == "speedtest") 
			{
				var secrets = SpeedTestSecrets(version);
				global_secret = secrets.global_secret;
				url_secret = secrets.url_secret;
				date_secret = secrets.date_secret;
				//console.log("Global Secret = "+ global_secret + '\n' + "URL Secret = " + url_secret + '\n' + "Date Secret = " + date_secret);
			}
		if (product == "netgauge") 
			{
				//NetGaugeSecrets(version)
				var secrets = NetGaugeSecrets(version);
				global_secret = secrets.global_secret;
				url_secret = secrets.url_secret;
				date_secret = secrets.date_secret;
				//console.log("Global Secret = "+ global_secret + '\n' + "URL Secret = " + url_secret + '\n' + "Date Secret = " + date_secret);
			}
		//We store secrets here
		function SpeedTestSecrets (SpeedTestVersion) 
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
				return {global_secret: global_secret, url_secret: url_secret, date_secret: date_secret}; //return an object here as its easier to read and understand then array is
			}
		function NetGaugeSecrets (NetGaugeVersion) 
			{
				if (NetGaugeVersion == "current")
				{
					global_secret = "8zjAUM";
					url_secret = "qX^1WA!HP(";
					date_secret = "jiO4sXA";
					
				}
				return {global_secret: global_secret, url_secret: url_secret, date_secret: date_secret}; //return an object here as its easier to read and understand then array is
			}
		
		
		//We store secrets here	
		
		var Domain = getDomainName(url);
		var HostName = getHostName(url);
		
		//We first calculate date part of the licence
		//Licence Check (Date)
		var datumStamp = new Date(date).getUnixTime();
		var date_Hash = datumStamp.toString(16);
		var MD5Hash = md5(date_Hash + date_secret).substr(0,8);
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
					HostPart = md5("%wildh0st$" + HostName + url_secret).substr(0,16);
					Host = "H" + HostPart;
					vse = Host;
					//Licence bound to HostName
				}
				
				if (LicenseMode == "Bound2Domain")
				{
					//Licence bound to Domain
					HostPart = md5("%wildc4rd$" + Domain + url_secret).substr(0,16);
					Wildcard = "W" + HostPart;
					vse = Wildcard;
					//Licence bound to Domain
				}
				if (LicenseMode == "Trial")
				{
					//Trial License
					vse = md5("***trial***" + url_secret).substr(0,16);
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
					validTag = "speedtest-only";
					TagLicense = md5("%t4gs$" + validTag + this.url_secret).substr(0,16);
					vse = "T" + TagLicense;
				}
				if (LicenseMode == "Server") //NOT SURE IF THIS ONE WORKS AS IT SHOULD
				{
					//////////////////////////////// Licencse Mode Server Count //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// 2. There is Servers License which extraxt server count from licenseKey in similar fashion as it extraxt Expernation Date , it checks if its md5hash matches and if it does it is happy.                                              //
					// Pro: You can change domain or hostname without recalculating your licenses (but you have to byteEdit whiteDomains array and add your own domain in it)                                                                               //
					// Coin: you can only use the number of servers you have specified in your licence. If you exceed this number your license will not work anymore.                                                                                       //
					Servers = ServerCount
					//ServersEnc = Servers.toString(16);
					ServerMD5 = md5("%s3rv3r$" + Servers + this.url_secret).substr(0,14);
					vse = "S" + ServerMD5;
				}
				if (LicenseMode == "Bound2HostName") 
				{
					//////////////////////////////// Licencse Mode Hostname //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// 3. There is HostName License which checks its md5hash agains hostname it is running on and if it matches it is happy.                                                                                                                //             
					// Pro: can't find any if comparing to Wildcard License                                                                                                                                                                                 //
					// Coin: you can only use this on hostname which is md5 hashed in license if you change hostname it will stop working.                                                                                                                  //
					//Licence bound to HostName
					HostPart = md5("%wildh0st$" + HostName + url_secret).substr(0,16);
					Host = "H" + HostPart;
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
					HostPart = md5("%wildc4rd$" + Domain + url_secret).substr(0,16);
					Wildcard = "W" + HostPart;
					vse = Wildcard;
					//Licence bound to Domain
				}
				if (LicenseMode == "Trial")
				{
					//Trial License
					vse = md5("***trial***" + url_secret).substr(0,16);
					//Trial License
				}
				if (LicenseMode == "BlackHost") 
				{
					//Nor sure why would you like to use this one but lets generate it anyway
					BlachHost = md5("%blackc4rd$" + Domain + this.url_secret).substr(0,16);
					BlackCard = "B" + BlachHost; 
					vse = BlackCard;
				}
			}
		//Then we calculate Host Part
		
		//At last we md5 validate everyhing everything and pack it in to a licence
		//We validate it
		//We Calculate the last part of the key here
		var LastKeyPart = md5(DatePart + '-' + vse + global_secret).substr(0,16);

		//We Calculate the last part of the key here
		//We validate it
		
		
		//We Pack it together
		var CompleteKey = DatePart + '-' + vse + '-' + LastKeyPart;
		return CompleteKey
		
		//We Pack it together
		//At last we md5 validate everyhing everything and pack it in to a licence
	
	
	
	}
//console.log(GenerateKey("3/19/2034 08:00:00 GMT", "http://speedtest.windows.nt/speedtest.swf", 11, "BlackHost", "speedtest", "new"));
