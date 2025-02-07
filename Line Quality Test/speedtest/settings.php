<settings>
<licensekey>6ca01b8a51e39df0-f3c4623c710272cf-fa924d3250207392</licensekey>
<customer>tbcsolutions</customer>
<servers>
<server url="http://203.116.5.6/speedtest/speedtest/upload.php"  linequality="203.116.5.6"/>
</servers>
<!--
 maxchunkcount - maximum number of blocks of data to send (default = 10) 
 testlength - number of seconds upload test should last (default = 10) 
 ratio - assumed ratio of upload speed to download speed (default = 10) 
 threads - 1 for single upload thread or 2 for two parallel threads (default = 2) 
 maxchunksize - largest block of data so send at a time during upload test (default = 1M) 
 disabled - set this to true to completely disable the upload test (default = false) 
-->
<upload maxchunkcount="100"  testlength="10"  ratio="10"  threads="2"  maxchunksize="256K"  disabled="false" />
<!--
 autostart - true would make the test start on page load without needing to press a button (default = false) 
 repeat - the number of seconds between the test repeating indefinitely (default = 0) 
-->
<extras autostart="false"  repeat="0" />
<!--
 incrementtemplate - choose between 10M, 20M, 50M and 100M for the maximum value of the speedometer (default = 20M) 
 template - choose between kbps and mbps for showing speeds in kbps or Mbps (default = kbps) 
 clienticon - choose between person, computer, house, laptop (default = person) 
 servericon - choose between pyramid, globe, building, rack, tower and satellite (default = pyramid) 
 showborder - toggle the border around the test (default = true) 
-->
<interface incrementtemplate="100M"  template="mbps"  clienticon="customclient"  servericon="rack"  showborder="true" />
<errors linktodocs="true"  showexpirewarning="false" />
<reporting jsreporting="2" />
<!--
 testlength - number of seconds download test should last (default = 10) 
 threads - 1 for single download thread or 2 for two parallel threads (default = 2) 
 maximagesize - largest sample file that will be used for the download test (default = 40M) 
-->
<download testlength="10"  threads="4" maximagesize="40M" />
<!--
 testlength - number of samples to use for calculating http latency (default = 10) 
-->
<latency testlength="10" />
<ip enabled="1"  ip="86.61.74.227" />
<linequality enablefirewall="true"  detailedfirewallresults="true" />
</settings>
