### This is how I am using Speedtest on my server

To use this you have to open servers.xml and change
```xml
<server url="http://speedtest.windows.nt/http/upload.php" lat="46.4763" lon="15.6332" name="DXing" country="Slovenia" cc="SI" sponsor="DXing Slovenija" id="11368"  host="windows.nt:8080" />
```
to
```xml
<server url="http://<server-ip-here>/http/upload.php" lat="46.4763" lon="15.6332" name="DXing" country="Slovenia" cc="SI" sponsor="DXing Slovenija" id="11368"  host="<server-ip-here>:8080" />
```

if you want to costumize what speedtest shows you when selecting the server
you can set lat and lon (latitude, longitude) to where on the map you want your server to be located
you can also modify name, sponsor and country to change what is displayed, but be aware id has to be unique