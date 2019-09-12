WEB SERVER SPECIFIC NOTES FOR SPEEDTEST.NET MINI

Please read everything here carefully and if you still have trouble kindly visit our Knowledge Base and Support center located at http://support.ookla.com

Important Information
• Applying to become a Host on Speedtest.net? Please visit the Knowledge Base Article linked below regarding crossdomain.xml file, this most common error most new Hosts make!
https://support.ookla.com/entries/21097566-what-is-crossdomain-xml-and-why-do-i-need-it

*** A note regarding IIS6 using ASP (changes not needed for ASP.NET) ***

IIS6 won't allow POST requests larger than 200K to be performed, and ASP scripts are disabled by default. We advise disabling chunked transfer encoding.

To increase the maximum allowed POST request size and disable chunked transfer encoding:
• Open IIS Manager
• Right-click on the server name at the top of the tree and choose "Properties"
• Check the first box for "Enable Direct Metabase Edit" and click the "OK" button
• Open C:\Windows\System32\Inetsrv\metabase.xml with Notepad (NOT Wordpad)
• Find AspMaxRequestEntityAllowed and change it to 1073741824
• Find AspEnableChunkedEncoding and set it to False


To make sure ASP scripts are enabled:
• Open IIS Manager
• In the console tree pane (the pane on the left), click "Web Service Extensions"
• In the details pane (the pane on the right), click "Active Server Pages" and then click the "Allow" button

*** Apache using PHP ***
Apache on some distributions disallow POST requests over 512K. This will cause the upload portion of the test to hang on faster connections.

To correct this problem:
• Open php.conf or php.ini
• Find LimitRequestBody and remove that line
• Restart Apache (/etc/init.d/httpd restart)
