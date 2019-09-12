<%@ Import Namespace="System.IO" %>
<script language="vb" runat="server">
  sub Page_Load(sender as Object, e as EventArgs)
    'Open a file for reading
    Dim FILENAME as String = Server.MapPath("settings.xml")

    'Get a StreamReader class that can be used to read the file
    Dim objStreamReader as StreamReader
    objStreamReader = File.OpenText(FILENAME)

    'Now, read the entire file into a string
     Dim xml as String = objStreamReader.ReadToEnd()

    xml = xml.Replace("%CLIENT_IP%", Request.ServerVariables("REMOTE_ADDR"))

    Response.ContentType = "text/xml"
    Response.Write(xml)
						      
    objStreamReader.Close()
   end sub
</script>
